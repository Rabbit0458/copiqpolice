import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AvocatGeneralitesPage extends StatelessWidget {
  const AvocatGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/gav_suspect_libre/avocat_generalites';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDesign = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardProc = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRights = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardOps = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
            "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
            "f00002",
            "Avocat – Généralités",
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
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00003",
              "L’intervention de l’avocat dans l’enquête de police",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00004",
              "Fondement (principe directeur)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00005",
                    "Principe : ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00006",
                    "article préliminaire du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                        "f00007",
                        " — en matière criminelle et correctionnelle, aucune condamnation ne peut être prononcée ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                        "f00008",
                        "sur le seul fondement de déclarations faites sans avoir pu s’entretenir avec un avocat et être assistée par lui.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                          "f00009",
                          "Jurisprudence : les enquêteurs ne peuvent recueillir des déclarations spontanées sur les faits sans audition régulière ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                          "f00010",
                          "respectant le droit au silence et à l’assistance de l’avocat — ",
                        ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00011",
                      "Cass. crim., 25 avril 2017",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00012",
              "I — Désignation de l’avocat",
            ),
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00013",
                      "Le suspect, qu’il soit entendu en audition libre (crime/délit puni d’emprisonnement) ou placé en garde à vue, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00014",
                      "est informé de son droit à l’assistance d’un avocat.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00015",
                  "A) Conditions de désignation",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00016",
                  "1) Par le mis en cause",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00017",
                    "La personne peut désigner un avocat de son choix ou demander qu’il lui en soit commis un d’office — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00018",
                    "articles 63-3-1 et 61-1 (5°) du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00019",
                  "À tout moment, la personne peut revenir sur un refus initial et solliciter l’assistance d’un avocat.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00020",
                  "2) Par des tiers",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00021",
                  "• En garde à vue",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00022",
                    "L’avocat peut être désigné par certaines personnes avisées de la mesure — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00023",
                    "article 63-2 du C.P.P.",
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00024",
                  "Personne vivant habituellement avec le gardé à vue, parent en ligne directe, frère/sœur, autre personne désignée, employeur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00025",
                  "Autorités consulaires si la personne est étrangère.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00026",
                    "En cas de mesure de protection juridique, l’avocat peut être désigné par le tuteur/curateur/mandataire — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00027",
                    "article 706-112-1 du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00028",
                      "La personne gardée à vue doit être informée de la désignation afin de pouvoir la confirmer ou l’infirmer.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00029",
                  "• Garde à vue d’un mineur",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00030",
                  "Le mineur est assisté d’un avocat.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00031",
                  "À défaut de désignation, le procureur / juge / O.P.J. informe sans délai le bâtonnier pour une commission d’office.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00032",
                  "• Audition libre",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00033",
                  "Si la personne est sous protection juridique : le tuteur/curateur avisé peut désigner un avocat ou demander une commission d’office.",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00034",
                  "• Audition libre d’un mineur",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00035",
                  "Assistance obligatoire : à défaut, information immédiate du bâtonnier pour une commission d’office.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00036",
                  "Conflit d’intérêts / pluralité d’avocats",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00037",
                  "En cas de conflit d’intérêts, un autre défenseur peut être demandé ; en cas de désaccord, le bâtonnier tranche.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00038",
                  "En cas d’auditions simultanées de plusieurs gardés à vue, le procureur peut solliciter le bâtonnier pour désigner plusieurs avocats.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00039",
              "B) Information de l’avocat",
            ),
            cardColor: cardDesign,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00040",
                  "L’O.P.J., ou sous son contrôle l’A.P.J. / assistant d’enquête, informe sans délai et par tous moyens l’avocat choisi ou commis d’office.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00041",
                  "Un message laissé sur répondeur suffit à remplir l’obligation d’information.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00042",
                  "L’avocat est informé de la qualification juridique et de la date présumée des faits.",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00043",
                      "Pour garantir l’effectivité de l’information, privilégier un contact téléphonique direct.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00044",
              "II — Intervention de l’avocat",
            ),
            cardColor: cardRights,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00045",
                  "À l’arrivée de l’avocat, l’enquêteur vérifie la carte professionnelle afin de s’assurer de son identité et de sa qualité.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00046",
              "A) L’entretien (confidentiel)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00047",
                    "La personne soupçonnée peut s’entretenir avec son avocat dans des conditions garantissant la confidentialité — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00048",
                    "article 63-4 du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00049",
                  "• En garde à vue",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00050",
                  "Applicable dès le début de la mesure.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00051",
                  "Durée maximale : 30 minutes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00052",
                  "En cas de prolongation : un nouvel entretien peut être demandé (1 entretien par tranche de 24h).",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00053",
                  "• En audition libre",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00054",
                  "Un temps suffisant est accordé à la personne souhaitant s’entretenir avec son avocat.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00055",
              "B) Consultation de certaines pièces",
            ),
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00056",
                      "L’avocat ne peut pas consulter toute la procédure : seules certaines pièces sont accessibles. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00057",
                      "Il ne peut ni demander ni réaliser de copie, mais peut prendre des notes. Après consultation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00058",
                      "les documents sont remis à l’enquêteur.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00059",
                  "• En garde à vue",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00060",
                  "PV de notification de placement en GAV et des droits + réponses du gardé à vue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00061",
                  "Certificat médical établi suite au placement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00062",
                  "PV d’audition et de confrontation du gardé à vue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00063",
                  "Le cas échéant, PV antérieurs concernant les mêmes faits (avant la GAV en cours).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00064",
                  "• En audition libre",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00065",
                  "PV d’audition / confrontation antérieurs, réalisés avec ou sans avocat.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00066",
              "C) Assistance de l’avocat",
            ),
            cardColor: cardRights,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00067",
                  "1) Présence de l’avocat",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00068",
                  "En garde à vue, si la personne demande l’assistance, elle ne peut être entendue sur les faits sans l’avocat (sauf renonciation expresse mentionnée au PV).",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00069",
                  "• Délai en garde à vue",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00070",
                  "L’avocat dispose de 2 heures à compter de l’avis pour se présenter.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00071",
                  "Pendant ce délai : pas d’audition sur les faits, uniquement identité (et actes de signalisation possibles).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00072",
                  "Ce délai s’applique à la première audition. Il peut se réappliquer en cas de demande en cours de mesure ou changement d’avocat (conflit d’intérêts).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00073",
                  "Si l’avocat ne vient pas : saisine du bâtonnier pour un avocat commis d’office (nouveau délai de 2h), sauf renonciation expresse.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00074",
                  "• Audition libre",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00075",
                  "Pas de délai légal de carence : si l’avocat ne se présente pas dans un délai raisonnable, la personne peut refuser d’être entendue et être convoquée ultérieurement, ou renoncer expressément à ce droit.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00076",
              "2) Modalités d’intervention",
            ),
            cardColor: cardOps,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00077",
                  "L’avocat peut assister aux auditions et confrontations, reconstitutions, séances d’identification.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00078",
                  "L’audition est dirigée exclusivement par l’enquêteur : l’avocat prend des notes, ne conseille pas son client pendant l’audition.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00079",
                  "À l’issue, l’avocat peut poser des questions si l’enquêteur l’y invite ; questions/réponses sont consignées au PV.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00080",
                  "L’enquêteur peut refuser des questions si elles nuisent au bon déroulement de l’enquête ; le refus est mentionné au PV.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00081",
                  "L’avocat peut rédiger des observations écrites annexées à la procédure.",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00082",
                      "En cas de difficultés, l’A.P.J. informe immédiatement l’O.P.J. (possibilité d’interrompre l’acte et d’aviser le procureur).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00083",
              "3) Transport du gardé à vue",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00084",
                    "Si la personne gardée à vue est transportée sur un autre lieu, l’avocat en est informé sans délai — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00085",
                    "article 63-4-3-1 du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00086",
                    "Elle ne peut être auditionnée dans un autre lieu que le service enquêteur si l’avocat n’a pas été avisé — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00087",
                    "article D15-5-6 du C.P.P.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00088",
                  "Cette information concerne les transports nécessaires : audition, reconstitution, identification de suspects.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00089",
              "4) Signalisation sans consentement",
            ),
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00090",
                      "Lorsque la signalisation est réalisée sans consentement et que la personne a demandé l’assistance d’un avocat : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00091",
                      "l’avocat doit être avisé et peut y assister. L’acte ne peut être fait en son absence qu’après un délai de 2 heures ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                      "f00092",
                      "à compter de l’avis.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
              "f00093",
              "Pour aller plus loin",
            ),
            cardColor: cardDesign,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00094",
                  "Consultez le guide de la garde à vue et de l’audition libre (onglet « outils professionnels ») via l’intranet.",
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

// Les class suivantes doivent être utilisées dans ta page si je dois affiché une image de caneva : (UNIQUMENT POUR AFFICHER UNE IMAGE CANVA)

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.heroTag,
    this.borderRadius = 16,
    this.backgroundColor,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.enableHero = true,
  });

  final String assetPath;

  /// Si tu veux un Hero stable : passe un tag unique.
  /// Sinon, par défaut on utilise assetPath.
  final Object? heroTag;

  final double borderRadius;
  final Color? backgroundColor;

  final double minScale;
  final double maxScale;

  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg =
        backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF));

    final Color border = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.black.withValues(alpha: .08);

    final Color shadow = Colors.black.withValues(alpha: isDark ? .28 : .12);

    final tag = heroTag ?? assetPath;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );

    if (enableHero) {
      image = Hero(tag: tag, child: image);
    }

    return Semantics(
      label: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
        "f00095",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
        "f00096",
        "Touchez pour ouvrir, pincez pour zoomer, glissez pour déplacer",
      ),
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _openViewer(context, tag),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(child: image),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _Badge(
                    isDark: isDark,
                    text: "Zoom",
                    icon: Icons.zoom_in_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context, Object tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => _ZoomableImageViewer(
          assetPath: assetPath,
          heroTag: enableHero ? tag : null,
          minScale: minScale,
          maxScale: maxScale,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({
    required this.assetPath,
    required this.heroTag,
    required this.minScale,
    required this.maxScale,
  });

  final String assetPath;
  final Object? heroTag;

  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color scrim = isDark
        ? Colors.black.withValues(alpha: .92)
        : Colors.black.withValues(alpha: .86);

    Widget image = Image.asset(
      assetPath,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fond sombre
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              color: scrim,
            ),

            // Image zoom/pan
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  _TopBar(
                    onClose: () => Navigator.of(context).maybePop(),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: minScale,
                        maxScale: maxScale,
                        clipBehavior: Clip.none,
                        child: image,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HintBar(isDark: isDark),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose, required this.isDark});

  final VoidCallback onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .95);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _Pill(
            bg: bg,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 18, color: fg),
                const SizedBox(width: 8),
                Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                    "f00097",
                    "Aperçu",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: fg,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 18, color: fg),
                    const SizedBox(width: 6),
                    Text(
                      "Fermer",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: fg,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintBar extends StatelessWidget {
  const _HintBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .92);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _Pill(
        bg: bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pinch_rounded, size: 18, color: fg),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart",
                  "f00098",
                  "Pincez pour zoomer • Glissez pour déplacer • Tapez pour fermer",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.isDark, required this.text, required this.icon});

  final bool isDark;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .12)
        : Colors.black.withValues(alpha: .06);
    final Color fg = isDark
        ? Colors.white
        : Colors.black.withValues(alpha: .78);

    return _Pill(
      bg: bg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: .12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
