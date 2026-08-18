import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class MaltraitanceAnimalePage extends StatelessWidget {
  const MaltraitanceAnimalePage({super.key});

  static const String routeName = '/gpx/intervention/animal/maltraitance';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
            "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Animal",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00002",
              "Lutte contre la maltraitance animale",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Définition + principes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00003",
              "Définition & principes",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00004",
                    "Les animaux sont des êtres vivants doués de sensibilité : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00005",
                    "article 515-14 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00006",
                    "Ils doivent être placés par leur propriétaire dans des conditions compatibles avec les impératifs biologiques de leur espèce : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00007",
                    "article L. 214-1 du CRPM",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                title: "Organisation",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                          "f00008",
                          "Les OPJ/APJ recherchent et constatent les infractions (Code pénal / Code rural). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                          "f00009",
                          "Un référent “maltraitance animale” est désigné dans chaque commissariat pour appui et conseil.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (infraction “support” : sévices graves / cruauté)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00010",
              "I — Élément légal (référence centrale)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00011",
                    "Sévices graves / actes de cruauté : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00012",
                    "article 521-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00013",
                    " (animal domestique, apprivoisé ou tenu en captivité).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00014",
                      "Non applicable aux courses de taureaux et combats de coqs lorsque qu’une tradition locale ininterrompue peut être invoquée/établie.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément matériel (pédagogique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00015",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00016",
                  "A) L’animal visé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00017",
                  "L’infraction concerne un animal domestique, apprivoisé ou tenu en captivité.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00018",
                  "B) Le comportement incriminé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00019",
                      "• Sévices graves : mauvais traitements d’une particulière gravité.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00020",
                      "• Actes de cruauté : agissements destinés à faire souffrir, ou violences particulièrement odieuses (caractère volontaire).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00021",
                  "C) Autres atteintes fréquentes (à qualifier selon les faits)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00022",
                      "Selon la situation, d’autres qualifications peuvent s’ajouter :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00023",
                      "• Atteinte volontaire à la vie d’un animal\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00024",
                      "• Atteinte involontaire à la vie ou à l’intégrité\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00025",
                      "• Atteintes sexuelles\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00026",
                      "• Abandon\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00027",
                      "• Expériences/recherches illicites\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00028",
                      "• Mauvais traitements (contraventions / délits selon les cas).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00029",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00030",
                      "Les sévices graves et actes de cruauté supposent un comportement volontaire : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00031",
                      "la conscience de maltraiter / faire souffrir l’animal est à caractériser par les constatations ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00032",
                      "(déclarations, contexte, traces, répétition, matériel, témoins, vidéos…).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Circonstances aggravantes (521-1)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00033",
              "IV — Circonstances aggravantes (sévices / cruauté)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00034",
                    "Aggravations prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00035",
                    "l’article 521-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00036",
                    " (selon les cas) :",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00037",
                  "Animal détenu par un agent dans l’exercice d’une mission de service public.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00038",
                  "Faits commis par le propriétaire ou le gardien.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00039",
                  "Faits commis en présence d’un mineur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00040",
                  "Faits ayant entraîné la mort de l’animal.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Tentative & complicité (spécificités utiles)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00041",
              "V — Tentative & complicité (points clés)",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00042",
                  "Complicité (images)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                          "f00043",
                          "Enregistrer sciemment des images de sévices graves / actes de cruauté ou d’atteintes sexuelles sur un animal peut constituer un acte de complicité, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                          "f00044",
                          "sauf si l’enregistrement vise un débat public d’intérêt général ou sert de preuve en justice : ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00045",
                      "article 521-1-2 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00046",
                    "Diffusion sur internet de ces images : délit prévu par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00047",
                    "l’article 521-1-2 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Panorama des infractions + références (super utile sur le terrain)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00048",
              "VI — Panorama des principales infractions",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00049",
                  "Atteintes à la vie",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00050",
                    "Atteinte volontaire à la vie : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00051",
                    "article 522-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00052",
                    "Atteinte involontaire (contravention) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00053",
                    "article R. 653-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00054",
                  "Atteintes sexuelles / sollicitations",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00055",
                    "Atteinte sexuelle sur animal : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00056",
                    "article 521-1-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00057",
                    "Proposition / sollicitation : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00058",
                    "article 521-1-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle("Abandon"),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00059",
                    "Abandon volontaire : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00060",
                    "article 521-1 alinéa 13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00061",
                    "Abandon exposant à un risque immédiat/imminent de mort : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00062",
                    "article 521-1 alinéa 15 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00063",
                  "Expériences / recherches",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00064",
                    "Expériences/recherches sans prescriptions : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00065",
                    "article 521-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00066",
                    " (renvoi CRPM).",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00067",
                  "Mauvais traitements (contraventions / délits)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00068",
                    "Mauvais traitements (contravention) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00069",
                    "article R. 654-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00070",
                    "Manquements du gardien/détenteur (nourriture, soins, habitat…) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00071",
                    "article R. 215-4 du CRPM",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00072",
                    "Mauvais traitements par un professionnel : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00073",
                    "article L. 215-11 du CRPM",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Obligations détenteurs (chiens/chats/furets)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00074",
              "VII — Obligations (chiens, chats, furets)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00075",
                      "• Depuis le 01/10/2022, l’acquéreur d’un animal de compagnie doit signer un certificat d’engagement et de connaissance.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00076",
                      "• L’identification des chiens, chats et furets et l’inscription au fichier national sont obligatoires.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00077",
                      "• En cession : remise des documents (cession, identification, certificat vétérinaire selon cas).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Mesures de protection + saisies + CPP 99-1
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00078",
              "VIII — Mesures de protection & intervention",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00079",
                  "Pouvoirs CRPM (protection animale)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00080",
                  "Accès aux locaux/installations où se trouvent des animaux (hors domiciles) entre 8h et 20h (ou si accès public/activité en cours).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00081",
                  "Ouverture et contrôle de véhicules professionnels transportant des animaux (jour/nuit) et, en cas de danger vital, ouverture de tout véhicule.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00082",
                    "Sur instructions du procureur, dans l’attente d’une mesure judiciaire prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00083",
                    "l’article 99-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00084",
                    ", possibilité de saisie/retrait et de confier l’animal à un tiers (association/fondation…).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Frais",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00085",
                      "Les frais de garde sont en principe à la charge du propriétaire/détenteur (sauf décision contraire du magistrat).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00086",
                    "En urgence, l’état de nécessité peut être invoqué : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00087",
                    "article 122-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00088",
                    " (ex. bris de vitre pour extraire un chien enfermé en plein soleil, propriétaire injoignable).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Divagation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00089",
              "IX — Divagation (points terrain)",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00090",
                      "Il est interdit de laisser divaguer les animaux domestiques et les animaux sauvages apprivoisés ou tenus en captivité.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00091",
                      "Chien divagant (hors chasse/garde/protection troupeau) : plus sous surveillance, hors portée de voix/rappel, éloigné de plus de 100 m, ou abandonné.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                      "f00092",
                      "Chat divagant : non identifié à plus de 200 m des habitations, ou à plus de 1 000 m du domicile sans surveillance, ou propriétaire inconnu saisi sur la voie publique.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00093",
                    "Divagation d’un animal dangereux (contravention) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00094",
                    "article R. 622-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00095",
                    "Amende forfaitaire possible : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                    "f00096",
                    "article R. 48-1 (7°) du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Partenaires (utile)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
              "f00097",
              "X — Partenaires utiles",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00098",
                  "DDPP : services vétérinaires (surveillance sanitaire & protection animale).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00099",
                  "SPA : enquêtes / appui (contacts selon circuits locaux).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00100",
                  "Associations de protection animale (ex. fondations/associations reconnues) pour mise en dépôt.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart",
                  "f00101",
                  "30 millions d’amis / associations locales : signalements, orientations, dépôts.",
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
