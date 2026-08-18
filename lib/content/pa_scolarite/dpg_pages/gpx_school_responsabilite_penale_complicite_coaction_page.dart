import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaGPXSchoolResponsabilitePenaleCompliciteCoactionPage
    extends StatelessWidget {
  const PaGPXSchoolResponsabilitePenaleCompliciteCoactionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/responsabilite_penale/complicite_coaction';

  // --- Helpers: mise en rouge des articles / codes ---
  TextSpan _red(String s) => TextSpan(
    text: s,
    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
  );

  TextSpan _t(String s) => TextSpan(text: s);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF0B0B0B);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF0B0B0B).withValues(alpha: .72);

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
            "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
            "f00002",
            'La complicité et la coaction',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
        children: [
          // ========================= INTRO =========================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00003",
              'La complicité et la coaction',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.05,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00004",
                  'Comprendre qui est auteur, coauteur, complice — et dans quelles conditions la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00005",
                  'participation est punissable.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= DÉFINITIONS =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00006",
              'Auteur, coauteurs, complices',
            ),
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00007",
                      "L'auteur de l'infraction est celui qui commet personnellement, dans les ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00008",
                      "conditions prévues par le texte d’incrimination, les actes prévus et réprimés ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00009",
                      "par ce texte.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00010",
                      "L'infraction peut être le fait de plusieurs personnes qui seront selon les cas ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00011",
                      "coauteurs, ou auteurs et complices.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 1 : COACTION =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00012",
              'Chapitre 1 — Les conditions de la coaction',
            ),
            cardColor: isDark
                ? const Color(0xFF20302E)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00897B),
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00013",
                  '1.1 — Le principe',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00014",
                      "Si plusieurs personnes participent à égalité à la réalisation de l’infraction, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00015",
                      "elles sont coauteurs : elles sont toutes auteur principal de l’infraction car ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00016",
                      "chacune a personnellement commis les éléments matériel et moral ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00017",
                      "pénalement sanctionnés par la loi.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00018",
                  '1.2 — Difficulté d’application',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00019",
                      "Il peut être parfois difficile de déterminer avec précision le rôle exact joué ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00020",
                      "par chaque participant, notamment dans le cas d’une infraction collective.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00021",
              'Coaction : approche jurisprudentielle',
            ),
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00022",
                        "La jurisprudence qualifie de coauteurs l’ensemble des membres du groupe ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00023",
                        "ayant participé à l’infraction. Ainsi, en matière de violences, si plusieurs ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00024",
                        "individus y ont participé, ils sont qualifiés de coauteurs (Cass. crim. 1er oct. 1984).\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00025",
                        "Il arrive que des coauteurs soient considérés comme des complices : c’est la théorie ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00026",
                        "de la complicité corespective. Ce procédé a perdu beaucoup d’intérêt car aujourd’hui ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00027",
                        "le complice est puni comme auteur.\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00028",
                        "La jurisprudence a tendance à considérer comme coauteurs ceux qui participent ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00029",
                        "à la commission de l’infraction, même s’ils n’ont pas réalisé directement ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00030",
                        "l’élément matériel.\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00031",
                        "Exemple : celui qui fait le guet pendant l’exécution d’un vol.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 2 : COMPLICITÉ =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00032",
              'Chapitre 2 — Les conditions de la complicité',
            ),
            cardColor: isDark
                ? const Color(0xFF2A1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00033",
                        "La complicité consiste en l’entente momentanée entre deux ou plusieurs personnes ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00034",
                        "dans le but d’accomplir une infraction déterminée. Le complice est celui qui aide ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00035",
                        "l’auteur dans la préparation ou l’exécution de l’infraction. Il participe ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00036",
                        "intentionnellement à la commission de l’infraction par la réalisation d’un acte matériel.\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00037",
                        "Elle est définie par ",
                      ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00038",
                    "l’article 121-7 du Code pénal",
                  ),
                ),
                _t(". "),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00039",
                    "Le Code pénal assimile le complice à l’auteur au niveau de la répression (",
                  ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00040",
                    "article 121-6 du Code pénal",
                  ),
                ),
                _t(")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ---- 2.1 Conditions relatives au fait principal ----
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00041",
              '2.1 — Conditions relatives au fait principal',
            ),
            cardColor: isDark
                ? const Color(0xFF1E2A1F)
                : const Color(0xFFE8F5E9),
            accent: const Color(0xFF2E7D32),
            titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00042",
                      "L’acte de complicité n’est pas punissable en tant que tel. Il doit se rattacher ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00043",
                      "à un fait principal punissable : c’est une criminalité d’emprunt.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00044",
              '2.1.1 — Existence d’une infraction (fait principal punissable)',
            ),
            cardColor: isDark
                ? const Color(0xFF1A2333)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF3F51B5),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00045",
                  '2.1.1.1 — Principe',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00046",
                      "La complicité suppose l’existence d’un fait prévu et réprimé par les textes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00047",
                      "Si le fait principal échappe pour une raison quelconque à la loi pénale, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00048",
                      "le complice ne pourra être puni.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                          "f00049",
                          "Le suicide n’est pas incriminé en droit français : celui qui en favorise ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                          "f00050",
                          "l’accomplissement ne sera pas poursuivi comme complice, mais éventuellement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                          "f00051",
                          "sur la base d’un délit distinct (ex. provocation au suicide).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00052",
                      "La complicité de tentative est punissable. En revanche, si l’auteur principal ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00053",
                      "n’a effectué que des actes préparatoires ou s’est désisté volontairement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00054",
                      "le complice ne peut être poursuivi : « la tentative de complicité » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00055",
                      "n’est pas punissable.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00056",
                  'Cas où la complicité ne pourra pas être retenue',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00057",
                      "Lorsque le fait principal est justifié par la légitime défense, l’ordre de la loi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00058",
                      "ou le commandement de l’autorité légitime.",
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00059",
                      "Si le fait principal n’est plus punissable suite à prescription de l’action publique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00060",
                      "ou en cas d’amnistie.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00061",
              '2.1.1.2 — La répression de l’acte principal importe peu',
            ),
            cardColor: isDark
                ? const Color(0xFF2B2B1A)
                : const Color(0xFFFFF8E1),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00062",
                      "Le complice peut être poursuivi même si l’auteur principal n’est pas puni, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00063",
                      "notamment lorsque :",
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00064",
                  "L’auteur est en fuite ou inconnu.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00065",
                  "L’auteur est décédé.",
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00066",
                      "L’auteur bénéficie d’une cause d’irresponsabilité (trouble neuro-psychique, minorité) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00067",
                      "ou d’une exemption légale de peine.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00068",
              '2.1.2 — Un fait principal qualifié crime ou délit',
            ),
            cardColor: isDark
                ? const Color(0xFF1E2D2D)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00069",
                    "l’article 121-7 du Code pénal",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00070",
                    ", tous les crimes et délits sont en principe susceptibles de complicité.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00071",
              '2.1.3 — En matière de contraventions',
            ),
            cardColor: isDark
                ? const Color(0xFF231F2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF8E24AA),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00072",
                    "La complicité par provocation ou instructions est systématiquement réprimée (",
                  ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00073",
                    "article R. 610-2 du Code pénal",
                  ),
                ),
                _t(")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00074",
                  "La complicité par aide ou assistance n’est réprimée que si un texte le prévoit expressément.",
                ),
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                          "f00075",
                          "Article R. 623-2 du Code pénal : aide/assistance aux auteurs de tapages injurieux ou nocturnes.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                          "f00076",
                          "Article R. 624-1 du Code pénal : complicité de violences légères.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---- 2.2 Participation au fait principal ----
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00077",
              '2.2 — La participation au fait principal',
            ),
            cardColor: isDark
                ? const Color(0xFF1B263B)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF303F9F),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00078",
                  '2.2.1 — Participation matérielle',
                ),
              ),
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00079",
                    "Les actes de participation sont énumérés par ",
                  ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00080",
                    "l’article 121-7 du Code pénal",
                  ),
                ),
                _t("."),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00081",
                      "Les actes doivent être positifs : l’abstention ne peut pas constituer un acte de complicité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00082",
                      "(le simple spectateur n’est pas complice).",
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00083",
                      "Les actes doivent être antérieurs ou concomitants : il n’existe pas de complicité postérieure ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00084",
                      "à l’infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00085",
              '2.2.1.2 — Les actes de complicité (Article 121-7 du Code pénal)',
            ),
            cardColor: isDark
                ? const Color(0xFF2A1E12)
                : const Color(0xFFFFF3E0),
            accent: const Color(0xFFEF6C00),
            titleColor: isDark ? Colors.white : const Color(0xFFE65100),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00086",
                  'A) La provocation',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00087",
                      "La provocation doit être accompagnée de don, promesse, ordre, menace, abus d’autorité ou de pouvoir. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00088",
                      "Le simple conseil ne suffit pas.",
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00089",
                  "Elle doit être individuelle (adressée à une personne déterminée).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00090",
                  "Elle doit être suivie d’effets : l’infraction doit être réalisée ou au moins tentée.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00091",
                      "Provocation aux délits de trafic ou d’usage de stupéfiants : Article L. 3421-4 du Code de la santé publique.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00092",
                  'B) La fourniture d’instructions',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00093",
                      "Il s’agit d’indications précises, données en connaissance de cause, de nature à faciliter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00094",
                      "l’exécution d’une infraction.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00095",
                      "Indiquer, en vue d’un cambriolage, les heures où une personne est absente de chez elle.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00096",
                  'C) L’aide ou l’assistance',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00097",
                      "L’acte doit avoir facilité la préparation ou la consommation de l’infraction. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00098",
                      "Cela peut être la fourniture de moyens matériels ou un concours apporté à l’auteur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00099",
                      "au moment de la préparation ou de la réalisation.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00100",
              '2.2.2 — L’intention de participer à l’infraction',
            ),
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00ACC1),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00101",
                  "L’intention criminelle du complice doit réunir deux conditions :",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00102",
                  "Connaissance du caractère délictueux des actes envisagés ou réalisés par l’auteur.",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00103",
                      "Volonté de s’associer à l’acte délictueux : auteur et complice ont agi « ensemble et de concert » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00104",
                      "en vue d’obtenir le résultat délictueux.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00105",
              '2.2.3 — Cas particulier : le “happy slapping”',
            ),
            cardColor: isDark
                ? const Color(0xFF2E1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFB71C1C),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: [
              _Paragraph.rich([
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00106",
                    "L’article 222-33-3, alinéa 1, du Code pénal",
                  ),
                ),
                _t(
                  ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00107",
                        " prévoit qu’est constitutif d’un acte de complicité des atteintes volontaires ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00108",
                        "à l’intégrité de la personne le fait d’enregistrer sciemment, par quelque moyen ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                        "f00109",
                        "que ce soit, des images relatives à la commission de ces infractions.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00110",
                    "Sont visées notamment les atteintes prévues par ",
                  ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00111",
                    "les articles 222-1 à 222-14-1 et 222-23 à 222-31 et 222-33 du Code pénal",
                  ),
                ),
                _t("."),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00112",
                  'Idée clé',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00113",
                      "Le législateur assimile l’enregistrement à un cas de complicité : l’enregistrement doit être réalisé sciemment.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 3 : RÉPRESSION =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00114",
              'Chapitre 3 — La répression de la complicité',
            ),
            cardColor: isDark
                ? const Color(0xFF1A1F2A)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF3949AB),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00115",
                    "l’article 121-6 du Code pénal",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00116",
                    ", le complice est puni comme auteur.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00117",
                  '3.1 — Sens de la règle',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00118",
                      "Les peines encourues par l’auteur et le complice sont identiques, mais le juge ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00119",
                      "n’a pas l’obligation de prononcer des peines identiques.",
                    ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00120",
                  '3.2 — Application de la règle',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00121",
                      "Le complice peut être puni plus sévèrement que l’auteur principal si des circonstances ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00122",
                      "aggravantes lui sont personnelles, ou si l’auteur bénéficie de circonstances atténuantes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00123",
                      "Inversement, la peine du complice peut aussi être inférieure selon les circonstances.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00124",
              '3.2.1 — Circonstances personnelles à l’auteur',
            ),
            cardColor: isDark
                ? const Color(0xFF1E2D2D)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00125",
                      "Qu’elles aggravent ou atténuent la culpabilité de l’auteur, ces circonstances ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00126",
                      "ne s’appliquent pas au complice.",
                    ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00127",
                      "Démence ou contrainte ; qualité de récidiviste de l’auteur principal.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00128",
              '3.2.2 — Circonstances réelles (liées à l’acte)',
            ),
            cardColor: isDark
                ? const Color(0xFF2A1E12)
                : const Color(0xFFFFF3E0),
            accent: const Color(0xFFEF6C00),
            titleColor: isDark ? Colors.white : const Color(0xFFE65100),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00129",
                      "Ce sont des circonstances de fait qui modifient la nature de l’infraction : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00130",
                      "elles aggravent ou atténuent la peine applicable au complice.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00131",
                      "Elles peuvent aggraver l’infraction (ex. réunion pour le vol). L’aggravation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00132",
                      "s’étend au complice même s’il ignorait l’existence de la circonstance.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00133",
              '3.2.3 — Circonstances mixtes',
            ),
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00134",
                      "Les circonstances mixtes concernent à la fois la personne et l’acte : elles procèdent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00135",
                      "de l’auteur et se répercutent sur l’acte en modifiant la nature de l’infraction ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                      "f00136",
                      "(ex. fonctions, lien familial, préméditation).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00137",
                    "La question de leur applicabilité au complice a été tranchée par la Cour de cassation : ",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00138",
                    "dans un arrêt n° 04-84.235 du 7 septembre 2005, elle a admis que ",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00139",
                    "« sont applicables au complice des circonstances aggravantes liées à la qualité de l’auteur principal ».\n\n",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00140",
                    "La formulation de ",
                  ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00141",
                    "l’article 121-6 du Code pénal",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00142",
                    " semblait pourtant privilégier le caractère personnel de la circonstance.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= TABLEAU (en format lisible) =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
              "f00143",
              'Tableau — La complicité (synthèse)',
            ),
            cardColor: isDark
                ? const Color(0xFF172027)
                : const Color(0xFFE1F5FE),
            accent: const Color(0xFF0277BD),
            titleColor: isDark ? Colors.white : const Color(0xFF01579B),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00144",
                  '1) Un fait principal punissable',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00145",
                  'Existence d’une infraction commise par l’auteur principal.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00146",
                  'Crime ou délit (en principe).',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00147",
                  'Contravention : complicité par provocation/instructions ; et certaines contraventions prévues par des textes spéciaux.',
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00148",
                  '2) Une participation à l’infraction',
                ),
              ),
              _Paragraph.rich([
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00149",
                    "Actes positifs, antérieurs ou concomitants. ",
                  ),
                ),
                _t(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00150",
                    "Référence : ",
                  ),
                ),
                _red(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                    "f00151",
                    "Article 121-7 du Code pénal",
                  ),
                ),
                _t("."),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00152",
                  'Provocation (don, promesse, menace, ordre, abus…).',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00153",
                  'Fourniture d’instructions.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00154",
                  'Aide ou assistance (moyens, concours).',
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00155",
                  '3) Une intention criminelle',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00156",
                  'Connaissance du caractère délictueux du fait principal.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart",
                  "f00157",
                  'Volonté de s’associer à l’acte délictueux (ensemble et de concert).',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
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
