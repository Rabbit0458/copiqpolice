import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CeintureRetenueEnfantPage extends StatelessWidget {
  const CeintureRetenueEnfantPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/ceinture_retenue_enfant';

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
            "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
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
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
              "f00003",
              "Ceinture de sécurité & retenue enfant",
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
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00004",
                      "Assurer la sécurité des occupants : port obligatoire de la ceinture homologuée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00005",
                      "règles de transport des mineurs, et usage d’un système de retenue enfant adapté.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
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
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00007",
                    "R. 412-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: " — "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00008",
                    "R. 412-1-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: " — "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00009",
                    "R. 412-2 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00010",
                  "Repères NATINF",
                ),
                bodySpans: [
                  _boldSpan("12929"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00011",
                      " (conducteur sans ceinture) • ",
                    ),
                  ),
                  _boldSpan("12930"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00012",
                      " (passager sans ceinture) • ",
                    ),
                  ),
                  _boldSpan("26813"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00013",
                      " (plusieurs personnes sur un siège) • ",
                    ),
                  ),
                  _boldSpan("32933"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00014",
                      " (passagers en surnombre) • ",
                    ),
                  ),
                  _boldSpan("11065"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00015",
                      " (mineur non retenu) • ",
                    ),
                  ),
                  _boldSpan("27193"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00016",
                      " (enfant < 3 ans sans ceinture) • ",
                    ),
                  ),
                  _boldSpan("237"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00017",
                      " (enfant < 10 ans à l’avant).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
              "f00018",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00019",
                  "A) Port de la ceinture (conducteur + passagers)",
                ),
              ),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00020",
                    "R. 412-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                        "f00021",
                        " : tout conducteur ou passager d’un véhicule à moteur doit porter une ceinture de sécurité homologuée ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                        "f00022",
                        "(sauf dérogations ou véhicule réceptionné sans être équipé).",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00023",
                  "Obligation valable pour le conducteur ET les passagers (si véhicule réceptionné avec ceinture).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00024",
                  "Un siège équipé d’une ceinture ne peut être occupé que par une seule personne.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00025",
                    "Références : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00026",
                    "R. 412-1-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00027",
                    " (occupation d’un siège) • NATINF ",
                  ),
                ),
                _boldSpan("26813"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00028",
                  "B) Nombre de passagers (places assises)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00029",
                      "Le nombre de personnes transportées dans le véhicule est limité au nombre de places assises ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00030",
                      "indiqué sur le certificat d’immatriculation.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00031",
                    "Repère : NATINF ",
                  ),
                ),
                _boldSpan("32933"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00032",
                  "C) Mineurs : ceinture / système de retenue enfant",
                ),
              ),
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00033",
                    "R. 412-2 du Code de la route",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                        "f00034",
                        " : le conducteur d’un véhicule (≤ 9 places assises, conducteur inclus) doit s’assurer que tout passager mineur ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                        "f00035",
                        "est maintenu par une ceinture de sécurité, ou par un système homologué de retenue pour enfant lorsque l’enfant ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                        "f00036",
                        "a moins de 10 ans.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00037",
                  "Mineurs < 10 ans",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00038",
                      "Système homologué de retenue adapté à la taille et au poids (sauf exceptions prévues).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00039",
                  "Mineurs 10 à 18 ans",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00040",
                      "Système homologué de retenue ou ceinture de sécurité.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00041",
                  "D) Enfant < 3 ans & sièges sans ceinture",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00042",
                    "Si un siège n’est ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00043",
                    "pas équipé",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00044",
                    " de ceinture de sécurité, il est interdit d’y transporter un enfant de moins de trois ans.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00045",
                    "Repère : NATINF ",
                  ),
                ),
                _boldSpan("27193"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00046",
                  "E) Transport d’un enfant < 10 ans à l’avant",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00047",
                  "Les enfants de moins de 10 ans ne peuvent être transportés sur un siège avant, sauf exceptions.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00048",
                  "Exceptions (avant autorisé)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00049",
                      "• Enfant transporté ",
                    ),
                  ),
                  _boldSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00050",
                      "dos à la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00051",
                      " dans un siège homologué et airbag frontal désactivé.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00052",
                      "• Véhicule sans siège arrière ou siège arrière sans ceinture.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00053",
                      "• Siège arrière momentanément inutilisable ou déjà occupé par des enfants < 10 ans en retenue.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00054",
                    "Repère : NATINF ",
                  ),
                ),
                _boldSpan("237"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00055",
                    " — base ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00056",
                    "R. 412-2 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00057",
                  "F) Dérogations (ceinture / retenue enfant)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00058",
                      "Le port de la ceinture ou l’usage d’un système de retenue peut ne pas être obligatoire dans certains cas ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00059",
                      "(dérogations prévues par les textes).",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00060",
                  "Ceinture non obligatoire (exemples)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00061",
                          "• Morphologie manifestement inadaptée.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00062",
                          "• Contre-indication médicale avec certificat (durée de validité + symbole d’exemption).\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00063",
                          "• Occupants de véhicules d’intérêt général prioritaire en intervention urgente (police, gendarmerie, douanes, pompiers, etc.).\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00064",
                          "• Conducteurs de taxis en service.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00065",
                          "• Services publics avec arrêts fréquents en agglomération.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00066",
                          "• Livraisons de porte à porte en agglomération.",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00067",
                  "Retenue enfant non obligatoire (dérogations)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00068",
                          "• Enfant dont la taille est adaptée au port de la ceinture.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00069",
                          "• Certificat médical d’exemption (durée + symbole).\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                          "f00070",
                          "• Enfant transporté dans un taxi ou un véhicule de transport en commun.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
              "f00071",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00072",
                      "Ces infractions sont généralement constatées par l’absence de port de la ceinture / l’absence de dispositif ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00073",
                      "de retenue ou le non-respect des règles de transport. La matérialité du manquement suffit en pratique.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
              "f00074",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00075",
                      "Aucune circonstance aggravante spécifique n’est mentionnée dans l’extrait du mémento. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00076",
                      "En revanche, plusieurs manquements peuvent se cumuler (ex. mineur non retenu + enfant à l’avant + surnombre).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
              "f00077",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00078",
                  "Récapitulatif NATINF (infractions)",
                ),
              ),
              _Paragraph.rich([
                _boldSpan("12929"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00079",
                    " — Conducteur sans ceinture. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00080",
                    "R. 412-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00081",
                    " (4e classe, retrait 3 points).",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("12930"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00082",
                    " — Passager sans ceinture. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00083",
                    "R. 412-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00084",
                    " (4e classe).",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("26813"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00085",
                    " — Plusieurs personnes sur un siège. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00086",
                    "R. 412-1-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("32933"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00087",
                    " — Surnombre de passagers (places assises).",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("11065"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00088",
                    " — Mineur transporté sans ceinture / sans retenue homologuée. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00089",
                    "R. 412-2 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("27193"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00090",
                    " — Enfant < 3 ans transporté sur un siège sans ceinture. (4e classe).",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("237"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00091",
                    " — Enfant < 10 ans transporté à l’avant (interdit). Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                    "f00092",
                    "R. 412-2 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00093",
                  "Mesures & mentions",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                      "f00094",
                      "Le mémento mentionne des contrôles DIA / dépistage stupéfiants facultatifs sur plusieurs NATINF de cette rubrique.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
              "f00095",
              "VI — Tentative & complicité",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00096",
                  "Tentative : NON (contraventions liées à un non-respect constaté).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart",
                  "f00097",
                  "Complicité : NON (verbalisation centrée sur l’obligation du conducteur / occupant).",
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
