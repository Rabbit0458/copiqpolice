import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PrincipesGenerauxCirculationPage extends StatelessWidget {
  const PrincipesGenerauxCirculationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/natinf';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _b(String text) => TextSpan(
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
            "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
            "f00002",
            "Règles d’usage des voies",
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
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00003",
              "Principes généraux de circulation",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro / source
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00004",
              "Repère",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00005",
                      "Page “Natinf” classique : règles générales applicables à tout conducteur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00006",
                      "avec focus sur la prudence, la position de conduite, les interdictions courantes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00007",
                      "(téléphone, oreillette, écran), et quelques obligations de circulation.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00009",
                    "R. 412-6 à R. 412-16 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00010",
                    " : principes généraux de prudence, de maîtrise et de comportement du conducteur.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (les “faits” / obligations-interdictions)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00012",
                  "A) Comportement prudent",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00013",
                      "Le conducteur de tout véhicule doit, à tout moment, adopter un comportement prudent et respectueux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00014",
                      "envers les autres usagers, avec une prudence accrue à l’égard des usagers les plus vulnérables.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00015",
                  "B) Être en état et en position de manœuvrer",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00016",
                      "Le conducteur doit se tenir constamment en état et en position d’exécuter commodément et sans délai ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00017",
                      "toutes les manœuvres qui lui incombent (champ de vision et possibilités de mouvement non réduits par : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00018",
                      "passagers, objets transportés, objets non transparents sur les vitres…).",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6090"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00019",
                      "R. 412-6 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00020",
                      " (gêne / conditions ne permettant pas de manœuvrer aisément).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00021",
                  "C) Interdictions en circulation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00022",
                  "Usage d’un téléphone tenu en main.",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("23800"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00023",
                      "R. 412-6-1 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00024",
                      " (AF min. 4e classe, retrait de 3 points ; contrôle alcoolémie obligatoire).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00025",
                  "Port à l’oreille d’un dispositif susceptible d’émettre du son (sauf appareils correcteurs de surdité).",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("31063"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00026",
                      "R. 412-6-1 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00027",
                  "Placer dans le champ de vision un appareil en fonctionnement doté d’un écran (hors aide à la conduite/navigation).",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("26963"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00028",
                      "R. 412-6-2 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00029",
                      " (AF min. 5e classe, retrait de 3 points, saisie possible de l’appareil).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00030",
                  "Adopter une position ou effectuer une manœuvre acrobatique / non conforme aux conditions normales d’utilisation (conduite imprudente caractérisée).",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("35564"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00031",
                      "R. 412-6-4 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00032",
                      " (AF min. 3e classe, retrait de 2 points ; contrôle alcoolémie obligatoire).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00033",
                  "D) Obligations de circulation sur la chaussée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00034",
                      "Obligation de circuler sur la chaussée (sauf nécessité absolue, accès carrossables, aménagement particulier). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00035",
                      "En marche normale, les véhicules circulent près du bord droit (sauf trajectoire matérialisée pour cycles/EDPM/cyclomobiles légers, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00036",
                      "ou giratoire à plusieurs voies).",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("24088"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00037",
                      "R. 412-7 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00038",
                      " (circulation en dehors de la chaussée).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6092"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00039",
                      "R. 412-9 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00040",
                      " (éloigné du bord droit).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6093"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00041",
                      "R. 412-9 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00042",
                      " (marche normale sur la partie gauche d’une chaussée à double sens).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00043",
                  "E) Voies réservées / voies vertes / aires piétonnes / BAU",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00044",
                  "Voies réservées : interdiction de circuler pour les véhicules non autorisés (transport en commun, véhicules d’intérêt général, piste/bande cyclable…).",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00045",
                  "NATINF (exemples)",
                ),
                bodySpans: [
                  _bold("24090"),
                  const TextSpan(text: ", "),
                  _bold("24091"),
                  const TextSpan(text: ", "),
                  _bold("32512"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00046",
                      "R. 412-7 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00047",
                  "Voies vertes / aires piétonnes : interdiction de circuler en véhicule motorisé (sauf exceptions fixées par arrêté).",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("24089"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00048",
                      "R. 412-7 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00049",
                  "Bande d’arrêt d’urgence : circulation interdite.",
                ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6292"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00050",
                      "R. 412-8 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00051",
                  "F) Distances de sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00052",
                      "Le conducteur doit conserver une distance de sécurité suffisante pour éviter une collision en cas de ralentissement brusque ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00053",
                      "ou d’arrêt subit du véhicule qui le précède : distance correspondant à au moins 2 secondes.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00054",
                  "Repères",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00055",
                      "50 km/h ≈ 28 m • 90 km/h ≈ 50 m • 110 km/h ≈ 62 m • 130 km/h ≈ 73 m.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6096"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00056",
                      "R. 412-12 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00057",
                  "Ouvrages à risques",
                ),
                bodySpans: [
                  _bold("23082"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00058",
                      "R. 412-12 du Code de la route",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00059",
                      " (distance imposée : tunnel/pont…).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00060",
                  "G) Avertissement préalable (clignotants)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00061",
                      "Tout conducteur qui s’apprête à changer de direction ou à ralentir doit avertir de son intention les autres usagers ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00062",
                      "(se porter à gauche, traverser, reprendre sa place après arrêt/stationnement…).",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("217"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00063",
                      "R. 412-10 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00064",
                  "H) Facilités de passage (transport en commun)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00065",
                      "En agglomération, le conducteur doit ralentir si nécessaire et au besoin s’arrêter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00066",
                      "pour laisser les véhicules de transport en commun quitter les arrêts signalés.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("11084"),
                  const TextSpan(text: " — "),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00067",
                      "R. 412-11 du Code de la route",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral (logique “NATINF”)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00068",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00069",
                      "En pratique, ces infractions reposent sur la violation d’une obligation de prudence/maîtrise ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00070",
                      "ou d’une interdiction explicite (téléphone, oreillette, écran, manœuvre acrobatique, etc.).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00071",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00072",
                      "Pas de circonstance aggravante spécifique indiquée ici : se référer à la NATINF concernée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00073",
                      "et aux dispositions particulières (ex. alcoolémie obligatoire, retraits de points, saisie…).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression (résumé clean, pédagogique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00074",
              "V — Répression (repères NATINF)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00075",
                  "Obligations / interdictions majeures",
                ),
              ),
              _Paragraph.rich([
                _b("6090"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00076",
                    " — gêne du conducteur — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00077",
                    "R. 412-6 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("23800"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00078",
                    " — téléphone tenu en main — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00079",
                    "R. 412-6-1 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("31063"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00080",
                    " — dispositif à l’oreille — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00081",
                    "R. 412-6-1 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("26963"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00082",
                    " — écran dans le champ de vision — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00083",
                    "R. 412-6-2 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("35564"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00084",
                    " — manœuvre/position acrobatique — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00085",
                    "R. 412-6-4 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _b("24088"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00086",
                    " — hors chaussée — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00087",
                    "R. 412-7 C.R.",
                  ),
                ),
                const TextSpan(text: " • "),
                _b("6092"),
                const TextSpan(text: " / "),
                _b("6093"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00088",
                    " — bord droit — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00089",
                    "R. 412-9 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("6292"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00090",
                    " — bande d’arrêt d’urgence — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00091",
                    "R. 412-8 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("6096"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00092",
                    " — distance de sécurité — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00093",
                    "R. 412-12 C.R.",
                  ),
                ),
                const TextSpan(text: " • "),
                _b("23082"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00094",
                    " — ouvrage à risques.",
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("217"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00095",
                    " — changement de direction sans avertissement — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00096",
                    "R. 412-10 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("11084"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00097",
                    " — passage bus quittant arrêt — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                    "f00098",
                    "R. 412-11 C.R.",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Note",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                      "f00099",
                      "Selon la NATINF : contrôle alcoolémie peut être obligatoire, retraits de points variables, saisie/immobilisation possibles.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
              "f00100",
              "VI — Tentative & complicité",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00101",
                  "Tentative : NON (contraventions liées à un comportement constaté).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart",
                  "f00102",
                  "Complicité : en pratique NON pour ces obligations personnelles (appréciation au cas par cas selon l’infraction).",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextSpan _bold(String text) => TextSpan(
    text: text,
    style: const TextStyle(fontWeight: FontWeight.w900),
  );
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
