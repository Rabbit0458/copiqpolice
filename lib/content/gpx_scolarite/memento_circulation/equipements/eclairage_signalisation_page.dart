import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EclairageSignalisationPage extends StatelessWidget {
  const EclairageSignalisationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/eclairage_signalisation';

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
    final Color cardOblig = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRem = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardUsage = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfra = isDark
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
            "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
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
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00003",
              "Éclairage & signalisation",
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
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00004",
                      "Tout véhicule à moteur ou remorque ne peut être équipé que de dispositifs d’éclairage et de signalisation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00005",
                      "autorisés, installés conformément au Code de la route, et maintenus en état de fonctionnement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00006",
                      "Les infractions varient selon l’équipement concerné (dispositif absent, non conforme, ou usage irrégulier).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00008",
                    "R. 313-1 à R. 313-23 du Code de la route",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00009",
                    "R. 416-4 à R. 416-20 du Code de la route",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00010",
                    "R. 412-10 du Code de la route",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00011",
                    "R. 414-4 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00012",
                    "Référence conformité dispositifs : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00013",
                    "NATINF 22830",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Dispositifs obligatoires véhicules à moteur
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00014",
              "II — Dispositifs obligatoires (véhicules à moteur)",
            ),
            cardColor: cardOblig,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00015",
                  "A) Obligatoires pour tout véhicule à moteur",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00016",
                  "Feux de croisement (lumière jaune ou blanche) — NATINF 22833.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00017",
                  "Feux de position arrière (lumière rouge non éblouissante) — NATINF 22835.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00018",
                  "Catadioptres arrière (rouges, non triangulaires) — NATINF 22844.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00019",
                  "Feux stop (rouges non éblouissants) — NATINF 22837.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00020",
                  "Éclairage de la plaque d’immatriculation arrière — NATINF 22840.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00021",
                  "B) Obligatoires pour certains véhicules à moteur",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00022",
                  "Feux de route (jaune/blanc) — NATINF 22832 (tous sauf cyclomoteurs et quadricycles légers à moteur).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00023",
                  "Feux de position avant (jaune/orange/blanc) — NATINF 22834 (tous sauf cyclomoteurs à 2 roues).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00024",
                  "Indicateurs de direction (orangés non éblouissants) — NATINF 22842 (tous sauf cyclomoteurs).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00025",
                  "Signal de détresse — NATINF 22843 (tous sauf motocyclettes, cyclomoteurs, quadricycles légers à moteur).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00026",
                  "Feu de brouillard arrière — NATINF 22838 (1re MEC à compter du 01/10/1990, sauf moto/tricycles/quad/cyclo).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00027",
                  "Catadioptres latéraux — NATINF 22846 (véhicules > 6 m, cyclomoteurs, quadricycles à moteur).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00028",
                  "Triangle de présignalisation — NATINF 26986 (tous sauf moto/cyclo/tricycles/quad non carrossés).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Remorques
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00029",
              "III — Dispositifs obligatoires (remorques)",
            ),
            cardColor: cardRem,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00030",
                  "A) Équipements arrière principaux",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00031",
                  "Catadioptres arrière rouges triangulaires — NATINF 22844 (non triangulaire possible si groupés avec dispositifs arrière).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00032",
                  "Feux de position arrière rouges — NATINF 22835.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00033",
                  "Éclairage de la plaque d’immatriculation — NATINF 22840.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00034",
                  "B) Obligatoires selon PTAC / masquage des feux",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00035",
                  "Feu de brouillard arrière — NATINF 22838 (1re MEC à compter du 01/10/1990).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00036",
                  "Indicateurs de direction — NATINF 22842.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00037",
                  "Signal de détresse — NATINF 22843.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00038",
                  "Feux stop — NATINF 22837.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                          "f00039",
                          "Ces dispositifs concernent notamment : toute remorque de PTAC > 500 kg, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                          "f00040",
                          "et les remorques de PTAC ≤ 500 kg lorsque la remorque ou son chargement masque les feux du véhicule tracteur.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions (dispositifs)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00041",
              "IV — Infractions (dispositifs)",
            ),
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00042",
                    "NATINF 22830",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00043",
                    " — Dispositif d’éclairage/signalisation non réglementaire (véhicule à moteur). Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00044",
                    "R. 313-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00045",
                    "Principales absences/non-conformités (AF min. 3e classe) : ",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00046",
                  "Feux de route — NATINF 22832 (base : R. 313-2).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00047",
                  "Feux de croisement — NATINF 22833 (base : R. 313-3).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00048",
                  "Feux de position avant — NATINF 22834 (base : R. 313-4).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00049",
                  "Feux de position arrière — NATINF 22835 (base : R. 313-5).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00050",
                  "Feux stop — NATINF 22837 (base : R. 313-7).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00051",
                  "Feu de brouillard arrière — NATINF 22838 (base : R. 313-9).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00052",
                  "Éclairage plaque arrière — NATINF 22840 (base : R. 313-12).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00053",
                  "Indicateurs de direction — NATINF 22842 (base : R. 313-14).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00054",
                  "Signal de détresse — NATINF 22843 (base : R. 313-17).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00055",
                  "Catadioptres arrière — NATINF 22844 (base : R. 313-18).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00056",
                  "Catadioptres latéraux — NATINF 22846 (base : R. 313-19).",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00057",
                    "NATINF 26986",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00058",
                    " — Absence de triangle conforme. Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00059",
                    "R. 416-19 du Code de la route",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00060",
                    "R. 233-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00061",
                    " (AF 1re classe).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                          "f00062",
                          "Immobilisation : possible pour NATINF 22830. Pour les autres NATINF, immobilisation possible la nuit, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                          "f00063",
                          "ou de jour si la visibilité est insuffisante.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles d’utilisation (usage des feux)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00064",
              "V — Règles d’utilisation (éclairage & signalisation)",
            ),
            cardColor: cardUsage,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00065",
                  "A) Usage obligatoire de jour (2 roues motorisés)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00066",
                  "Motocyclettes (1re MEC après le 01/01/1965), motocyclettes légères (1re MEC à compter du 01/01/1988), cyclomoteurs (1re MEC à compter du 01/07/2004) : feux de croisement ou feux diurnes allumés.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00067",
                    "NATINF : ",
                  ),
                ),
                _boldSpan("238"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00068",
                    " (moto) et ",
                  ),
                ),
                _boldSpan("26165"),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00069",
                    " (cyclomoteur).",
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00070",
                  "B) Nuit / visibilité insuffisante",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00071",
                  "Feux rouges arrière allumés — NATINF 22892.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00072",
                  "Éclairage de plaque arrière allumé — NATINF 22893.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00073",
                  "Feux de position des remorques allumés — NATINF 22895.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00074",
                  "Cyclomoteurs et quadricycles légers à moteur : feux de croisement — NATINF 22887.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                          "f00075",
                          "Autres véhicules : usage des feux de croisement notamment en cas d’éblouissement, en agglomération éclairée, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                          "f00076",
                          "hors agglomération sur route éclairée en continu, ou si la visibilité est réduite (NATINF 22888 / 22889).",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00077",
                    "Interdiction : circuler sans éclairage/signalisation en lieu dépourvu d’éclairage public — ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00078",
                    "NATINF 11052",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00079",
                  "C) Feux de brouillard",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00080",
                  "Feux avant : peuvent remplacer/compléter les feux de croisement en cas de brouillard, neige ou forte pluie.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00081",
                  "Feux arrière : uniquement en cas de brouillard ou chute de neige.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00082",
                    "Usage injustifié : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00083",
                    "NATINF 22890",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00084",
                  "D) Indicateurs de direction",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00085",
                  "Changement de direction / ralentissement : obligation d’avertir — NATINF 217 (base : R. 412-10).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00086",
                  "Dépassement : avertissement préalable — NATINF 11054 (base : R. 414-4).",
                ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00087",
                  "E) Signal de détresse",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00088",
                  "À utiliser pour avertir les autres usagers d’un risque de surprise (allure très réduite, dernier d’une file lente).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00089",
                    "NATINF : ",
                  ),
                ),
                _boldSpan("6290"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Présignalisation immobilisation / chargement
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00090",
              "VI — Présignalisation (véhicule/chargement immobilisé)",
            ),
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00091",
                      "Lorsqu’un véhicule immobilisé sur la chaussée constitue un danger (intersections, virages, sommets de côtes, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00092",
                      "passages à niveau, visibilité insuffisante), ou lorsqu’un chargement tombe sur la chaussée, le conducteur doit :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00093",
                      "• utiliser les feux de détresse ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00094",
                      "• mettre un triangle de présignalisation (sauf si cela met manifestement sa vie en danger) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00095",
                      "• porter un gilet haute visibilité (rubrique EPI rétroréfléchissant).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00096",
                    "Absence de présignalisation conforme : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00097",
                    "NATINF 22799",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00098",
                    " (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00099",
                    "R. 416-19 du Code de la route",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00100",
                    "Autoroute (nécessité absolue) : feux de détresse obligatoires — ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00101",
                    "NATINF 7574",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00102",
                    " (base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00103",
                    "R. 421-7 du Code de la route",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Cycles
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00104",
              "VII — Cycles (rappel)",
            ),
            cardColor: cardOblig,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00105",
                    "Dispositifs obligatoires cycles et règles d’utilisation : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00106",
                    "R. 313-1, R. 313-4, R. 313-5, R. 313-18 à R. 313-20, R. 416-10, R. 431-1-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00107",
                  "A) Catadioptres (toujours)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00108",
                  "Arrière rouge — NATINF 22858.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00109",
                  "Avant blanc — NATINF 22861.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00110",
                  "Latéraux orange (min. 1 roue AV + 1 roue AR) — NATINF 22859.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00111",
                  "Pédales orange — NATINF 22860.",
                ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00112",
                  "B) Nuit / visibilité insuffisante",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00113",
                  "Feu de position avant jaune/blanc — NATINF 22856.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00114",
                  "Feu de position arrière visible — NATINF 22857.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00115",
                  "Feux allumés (et remorque le cas échéant) — NATINF 22796.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00116",
                      "Port du gilet haute visibilité : obligatoire pour le conducteur et le passager (voir rubrique dédiée).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00117",
                    "Dispositif non réglementaire : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00118",
                    "NATINF 22855",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // EDPM
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
              "f00119",
              "VIII — E.D.P.M. (rappel)",
            ),
            cardColor: cardRem,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00120",
                    "Dispositifs obligatoires E.D.P.M. : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00121",
                    "R. 313-1, R. 313-4, R. 313-5, R. 313-18 à R. 313-20 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00122",
                  "A) Catadioptres",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00123",
                  "Arrière rouge — NATINF 33354.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00124",
                  "Avant blanc — NATINF 33356.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00125",
                  "Latéraux orange — NATINF 33355.",
                ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00126",
                  "B) Nuit / visibilité insuffisante",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00127",
                  "Feu de position avant — NATINF 33352.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                  "f00128",
                  "Feu de position arrière — NATINF 33353.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                      "f00129",
                      "Port du gilet haute visibilité : obligatoire pour le conducteur (voir rubrique dédiée).",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00130",
                    "Dispositif non réglementaire : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart",
                    "f00131",
                    "NATINF 33348",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
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
