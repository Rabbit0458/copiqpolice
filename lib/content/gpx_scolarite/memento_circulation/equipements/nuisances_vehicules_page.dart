import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class NuisancesVehiculesPage extends StatelessWidget {
  const NuisancesVehiculesPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/nuisances';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _boldSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(fontWeight: FontWeight.w900),
  );

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
            "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
            "f00002",
            "Équipements",
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
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00003",
              "Les nuisances causées par les véhicules",
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
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00004",
                      "Encadrer et sanctionner les nuisances causées par les véhicules (pollution, bruits, usage abusif du klaxon) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00005",
                      "lorsqu’elles compromettent la santé, la sécurité publiques ou gênent les usagers et riverains.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00006",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00007",
                    "R. 318-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00008",
                    " (fumées / gaz) — ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00009",
                    "R. 318-3 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00010",
                    " (bruits) — ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00011",
                    "R. 416-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: " & "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00012",
                    "R. 416-2 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00013",
                    " (avertisseur sonore).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00014",
                  "Repères NATINF",
                ),
                bodySpans: [
                  _boldSpan("9920"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00015",
                      " (émissions polluantes) • ",
                    ),
                  ),
                  _boldSpan("22656"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00016",
                      " (échappement libre) • ",
                    ),
                  ),
                  _boldSpan("22657"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00017",
                      " (échappement interrompable) • ",
                    ),
                  ),
                  _boldSpan("22658"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00018",
                      " (échappement modifié / mauvais état) • ",
                    ),
                  ),
                  _boldSpan("6126"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00019",
                      " (bruits gênants) • ",
                    ),
                  ),
                  _boldSpan("22882"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00020",
                      " (klaxon abusif jour) • ",
                    ),
                  ),
                  _boldSpan("22883"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00021",
                      " (klaxon nuit).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00022",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00023",
                  "A) Émissions de fumées / gaz toxiques",
                ),
              ),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00024",
                    "R. 318-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00025",
                        " : les véhicules automobiles (sauf 2 roues motorisés, tricycles et quadricycles à moteur) ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00026",
                        "ne doivent pas émettre de fumées, gaz toxiques, corrosifs ou odorants dans des conditions susceptibles ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00027",
                        "d’incommoder la population ou de compromettre la santé et la sécurité publiques.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00028",
                  "Diesel : fumées non odorantes, non teintées, non opaques (tolérance au démarrage à froid et lors des changements de régime).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00029",
                  "Constat possible « de visu » si fumées nettement teintées/opaques en régime continu (contestation possible).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00030",
                  "Essence (cas particulier)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                          "f00031",
                          "Si le propriétaire a fait régler le moteur depuis moins d’un an, le véhicule ne peut pas être verbalisé ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                          "f00032",
                          "si le conducteur présente un justificatif (ex. PV de visite technique) et qu’un nouveau réglage antipollution ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                          "f00033",
                          "est effectué dans les 30 jours.",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00034",
                  "B) Présentation à un service de contrôle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00035",
                      "Lorsqu’une infraction est constatée, l’agent verbalisateur peut soit autoriser la conduite vers un établissement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00036",
                      "de réparation (avec immobilisation possible + fiche de circulation provisoire), soit prescrire une présentation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00037",
                      "à la brigade de contrôle technique selon des délais fixés (diesel / essence).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00038",
                    "Référence : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00039",
                    "NATINF 6210",
                  ),
                ),
                const TextSpan(text: ", "),
                _boldSpan("21937"),
                const TextSpan(text: ", "),
                _boldSpan("21938"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00040",
                    " (refus de présenter le véhicule).",
                  ),
                ),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00041",
                  "C) Émissions de bruits gênants",
                ),
              ),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00042",
                    "R. 318-3 du Code de la route",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00043",
                        " : les véhicules automobiles ne doivent pas émettre de bruits susceptibles de causer une gêne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00044",
                        "aux usagers de la route ou aux riverains.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00045",
                      "Deux situations pratiques sont distinguées :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00046",
                      "• Origine du bruit déterminable : infraction relevée + immobilisation possible avec circulation vers réparation.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00047",
                      "• Origine non décelable : pas de verbalisation immédiate, mais présentation à la BCT pour contrôle au sonomètre.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00048",
                  "Origines typiques",
                ),
                bodySpans: [
                  _boldSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00049",
                      "Échappement libre",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00050",
                      " (dispositif absent) — ",
                    ),
                  ),
                  _boldSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00051",
                      "mauvais état / modification",
                    ),
                  ),
                  const TextSpan(text: " — "),
                  _boldSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00052",
                      "dispositif interrompable",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00053",
                    "Repères NATINF : ",
                  ),
                ),
                _boldSpan("22656"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00054",
                    " (échappement libre), ",
                  ),
                ),
                _boldSpan("22658"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00055",
                    " (mauvais état/modifié), ",
                  ),
                ),
                _boldSpan("22657"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00056",
                    " (interrompable), ",
                  ),
                ),
                _boldSpan("6126"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00057",
                    " (bruits gênants).",
                  ),
                ),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00058",
                  "D) Usage intempestif de l’avertisseur sonore",
                ),
              ),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00059",
                    "R. 416-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00060",
                        " : l’avertisseur sonore ne peut être utilisé (de jour) que pour donner les avertissements nécessaires (hors agglomération) ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                        "f00061",
                        "ou en cas de danger immédiat (en agglomération).",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00062",
                    "R. 416-2 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00063",
                    " : de nuit, l’avertisseur sonore ne peut être utilisé qu’en cas d’absolue nécessité.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00064",
                    "Repères NATINF : ",
                  ),
                ),
                _boldSpan("22882"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00065",
                    " (jour) • ",
                  ),
                ),
                _boldSpan("22883"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00066",
                    " (nuit).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00067",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00068",
                      "Ces infractions relèvent en pratique de la constatation de comportements/états du véhicule ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00069",
                      "(pollution visible/odorante, bruit gênant, usage injustifié du klaxon). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00070",
                      "La matérialité du fait suffit généralement à caractériser l’infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00071",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00072",
                      "Aucune circonstance aggravante spécifique n’est mentionnée dans l’extrait du mémento pour ces nuisances. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                      "f00073",
                      "En revanche, des mesures de procédure (immobilisation, présentation BCT, PVO) peuvent s’appliquer selon les cas.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00074",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00075",
                  "Tableau récapitulatif (NATINF)",
                ),
              ),
              _Paragraph.rich([
                _boldSpan("9920"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00076",
                    " — Émission de fumées / gaz toxiques. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00077",
                    "R. 318-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22656"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00078",
                    " — Échappement libre. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00079",
                    "R. 318-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22657"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00080",
                    " — Dispositif d’échappement interrompable. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00081",
                    "R. 318-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22658"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00082",
                    " — Dispositif d’échappement modifié / non entretenu. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00083",
                    "R. 318-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("6126"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00084",
                    " — Bruits gênants. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00085",
                    "R. 318-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _boldSpan("6210"),
                const TextSpan(text: ", "),
                _boldSpan("21937"),
                const TextSpan(text: ", "),
                _boldSpan("21938"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00086",
                    " — Refus de présenter le véhicule à un service de contrôle (niveau sonore / émissions). Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00087",
                    "R. 325-8 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _boldSpan("22882"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00088",
                    " — Usage abusif (jour) de l’avertisseur sonore. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00089",
                    "R. 416-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22883"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00090",
                    " — Usage (nuit) de l’avertisseur sonore. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                    "f00091",
                    "R. 416-2 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00092",
                  "Mesures & mentions (selon mémento)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00093",
                  "Plusieurs NATINF indiquent : D.I.A. / dépistage stupéfiants facultatifs.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00094",
                  "Immobilisation : mentionnée pour certaines contraventions (pollution/bruit).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00095",
                  "P.V.O. : mentionné pour le refus de présentation (5e classe).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00096",
                  "Usage abusif du klaxon : contravention (minimum 2e classe).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
              "f00097",
              "VI — Tentative & complicité",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00098",
                  "Tentative : NON (non applicable pour ces contraventions liées à un état/usage constaté).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart",
                  "f00099",
                  "Complicité : NON (pas pertinente ici, verbalisation centrée sur le conducteur / le véhicule).",
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
