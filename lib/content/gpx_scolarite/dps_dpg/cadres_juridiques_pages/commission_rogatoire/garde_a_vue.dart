import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class GardeAVuePage extends StatelessWidget {
  const GardeAVuePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/commission_rogatoire/garde_a_vue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const Color cardBlueAccent = Color(0xFF1565C0);

    // Couleur utilisée pour tous les articles de loi
    const Color lawColor = Color(0xFFD32F2F);

    TextSpan lawSpan(String text) => TextSpan(
      text: text,
      style: const TextStyle(color: lawColor, fontWeight: FontWeight.w700),
    );

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
            "f00002",
            'Garde à vue',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
              "f00003",
              '3.7 — La garde à vue',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00004",
                  "Garde à vue dans le cadre de l’exécution d’une commission rogatoire, ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00005",
                  "régie par les dispositions du Code de procédure pénale et soumise à ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00006",
                  "des règles de fond et de forme proches de celles de l’enquête de ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00007",
                  "flagrance ou de l’enquête préliminaire.",
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 10),

          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00008",
                  "La garde à vue sur commission rogatoire reste une mesure privative ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00009",
                  "de liberté exceptionnelle, strictement encadrée et réservée aux ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00010",
                  "personnes soupçonnées d’avoir commis un crime ou un délit puni ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00011",
                  "d’une peine d’emprisonnement.",
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00012",
                  "Le juge d’instruction contrôle directement la mesure et ses ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00013",
                  "prolongations, tout en partageant certains pouvoirs avec le ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00014",
                  "procureur de la République et le juge des libertés et de la ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00015",
                  "détention.",
                ),
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.7 — LA GARDE À VUE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
              "f00016",
              '3.7 — La garde à vue',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00017",
                        "La garde à vue dans le cadre de l’exécution d’une commission ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00018",
                        "rogatoire est prévue par ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00019",
                    "l’article 154 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00020",
                      "Même lors de l’exécution d’une commission rogatoire, ne peuvent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00021",
                      "être placées en garde à vue que les personnes à l’encontre desquelles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00022",
                      "il existe une ou plusieurs raisons de soupçonner qu’elles ont commis ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00023",
                      "ou tenté de commettre un crime ou un délit puni d’une peine ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00024",
                      "d’emprisonnement.",
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00025",
                        "En vertu de l’article 153 alinéa 1, les personnes à l’encontre ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00026",
                        "desquelles il n’existe aucune raison plausible de soupçonner ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00027",
                        "qu’elles ont commis ou tenté de commettre une infraction ne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00028",
                        "peuvent pas être placées en garde à vue : elles ne peuvent être ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00029",
                        "retenues que le temps strictement nécessaire à leur audition, ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00030",
                    "conformément à l’article 153 alinéa 1 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00031",
                      "Lors de l’exécution d’une commission rogatoire, la garde à vue est ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00032",
                      "soumise, en principe, aux mêmes règles de fond et de forme qu’au ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00033",
                      "cours d’une enquête de flagrance ou d’une enquête préliminaire, à ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00034",
                      "l’exception des particularités suivantes :",
                    ),
              ),
              const SizedBox(height: 14),

              // ------------------------------------------------------------
              // Particularité : contrôle par le juge d’instruction
              // ------------------------------------------------------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00035",
                  "Contrôle de la garde à vue par le juge d’instruction",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00036",
                        "✓ La garde à vue est directement contrôlée par le juge ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00037",
                        "d’instruction (",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00038",
                    "article 154 alinéa 2 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00039",
                        "Ce magistrat doit être avisé dès le début de la mesure. L’officier ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00040",
                        "de police judiciaire doit l’informer du ou des motifs figurant à ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00041",
                    "l’article 62-2 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00042",
                    " justifiant le placement en garde à vue.",
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00043",
                        "Le juge d’instruction exerce les pouvoirs conférés au procureur de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00044",
                        "la République en matière d’avis aux personnes à prévenir (",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00045",
                    "article 63-2 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00046",
                    "), d’examen médical du gardé à vue (",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00047",
                    "article 63-3 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00048",
                    ") et d’enregistrement des interrogatoires en ",
                  ),
                ),
                lawSpan(
                  ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00049",
                        "matière criminelle au sens de l’article 64-1 du Code ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00050",
                        "de procédure pénale",
                      ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00051",
                        "Le contrôle du juge d’instruction n’est pas exclusif du pouvoir ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00052",
                        "général de contrôle exercé par le procureur de la République en ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00053",
                        "vertu de ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00054",
                    "l’article 41 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),

              // ------------------------------------------------------------
              // Prolongation de la garde à vue
              // ------------------------------------------------------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00055",
                  "Prolongation de la garde à vue",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00056",
                        "✓ L’autorisation de prolongation de la garde à vue relève du juge ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00057",
                        "d’instruction. La prolongation ne peut être décidée que si elle ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00058",
                        "constitue l’unique moyen de parvenir à l’un des six objectifs ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00059",
                        "visés par ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00060",
                    "l’article 62-2 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00061",
                        " ou de permettre, lorsque le tribunal ne dispose pas de locaux ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00062",
                        "adaptés, ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00063",
                    "au sens de l’article 803-3 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00064",
                    ", la présentation de la personne devant l’autorité judiciaire.",
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00065",
                      "Le juge d’instruction peut subordonner son autorisation à la ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00066",
                      "présentation de la personne devant lui, y compris par l’utilisation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00067",
                      "d’un moyen de télécommunication audiovisuelle.",
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00068",
                      "S’il accorde la prolongation, le juge d’instruction doit préciser, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00069",
                      "dans une décision écrite, le ou les motifs retenus et, le cas ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00070",
                      "échéant, les éléments de l’espèce justifiant la mesure.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00071",
                    "L’article 152 alinéa 3 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00072",
                        " autorise le juge d’instruction à se transporter, sans son ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00073",
                        "greffier, pour diriger et contrôler l’exécution de la ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00074",
                        "commission rogatoire. À l’occasion de ce transport, il peut ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00075",
                        "ordonner la prolongation des gardes à vue prononcées dans le ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00076",
                        "cadre de la commission rogatoire.",
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00077",
                      "Le juge d’instruction mandant est compétent en principe pour ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00078",
                      "ordonner la prolongation de la garde à vue, car il est le mieux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00079",
                      "placé pour apprécier la nécessité de la mesure.",
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00080",
                      "Une compétence concurrente est toutefois reconnue au juge ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00081",
                      "d’instruction du lieu d’exécution de la mesure lorsque la garde à ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00082",
                      "vue se déroule dans un ressort différent de celui du siège du juge ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00083",
                      "d’instruction mandant.",
                    ),
              ),
              const SizedBox(height: 14),

              // ------------------------------------------------------------
              // Droits de la défense et avocat
              // ------------------------------------------------------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                  "f00084",
                  "Assistance de l’avocat",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00085",
                        "✓ L’avocat assistant la personne lors de sa garde à vue doit être ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00086",
                        "informé, en plus des mentions prévues dans les autres cadres ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00087",
                        "juridiques d’enquête, que la mesure intervient dans le cadre de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00088",
                        "l’exécution d’une commission rogatoire (",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00089",
                    "article 154 alinéa 2 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00090",
                      "Les règles relatives au report de l’assistance de l’avocat sont ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00091",
                      "également applicables en matière d’information judiciaire.",
                    ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00092",
                      "Le report jusqu’à la douzième heure de garde à vue relève de la ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00093",
                      "compétence du juge d’instruction.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00094",
                      "Lorsque l’officier de police judiciaire sollicite le report jusqu’à la ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00095",
                      "vingt-quatrième heure de garde à vue, le juge d’instruction saisit le ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00096",
                      "juge des libertés et de la détention, qui décide d’accorder ou non la ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                      "f00097",
                      "prolongation du report.",
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00098",
                        "Lorsque l’infraction ayant justifié le placement en garde à vue ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00099",
                        "relève de la criminalité organisée, seul le juge d’instruction ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00100",
                        "est compétent pour autoriser le report de l’intervention de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                        "f00101",
                        "l’avocat, conformément aux dispositions de ",
                      ),
                ),
                lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart",
                    "f00102",
                    "l’article 706-88 du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),
          const SizedBox(height: 26),
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
