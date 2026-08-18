import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AbandonDeFamillePage extends StatelessWidget {
  const AbandonDeFamillePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille/abandon_de_famille';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
            "f00002",
            "Abandon de famille",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00003",
              "L’abandon de famille",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00005",
                      "Le fait, pour une personne, de ne pas exécuter une décision judiciaire ou l’un des titres ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00006",
                      "mentionnés aux 2° à 6° du I de l’article 373-2-2 du code civil lui imposant de verser au profit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00007",
                      "d’un enfant mineur, d’un descendant, d’un ascendant ou du conjoint une pension, une contribution, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00008",
                      "des subsides ou des prestations de toute nature dues en raison d’une obligation familiale, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00009",
                      "en demeurant plus de deux mois sans s’acquitter intégralement de cette obligation, constitue une infraction.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00010",
                  "Intermédiation financière",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00011",
                          "Lorsque l’intermédiation financière des pensions alimentaires est mise en œuvre, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00012",
                          "le fait pour le parent débiteur de demeurer plus de deux mois sans s’acquitter intégralement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00013",
                          "des sommes dues entre les mains de l’organisme débiteur des prestations familiales ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00014",
                          "assurant l’intermédiation constitue la même infraction.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00015",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00016",
                    "Article 227-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00017",
                    " : définit et réprime le délit d’abandon de famille.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00018",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00019",
                  "A) Un acte imposant le versement d’une somme d’argent",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00020",
                      "L’infraction suppose l’existence d’une obligation familiale portant sur une pension, une contribution, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00021",
                      "des subsides ou une prestation de toute nature (obligations prévues par le code civil) au profit :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00022",
                      "• d’un enfant mineur\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00023",
                      "• d’un descendant\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00024",
                      "• d’un ascendant\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00025",
                      "• du conjoint\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00026",
                      "Exemples : contribution aux charges du mariage, pension alimentaire, prestation compensatoire après divorce, etc.",
                    ),
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00027",
                  "B) Un acte exécutoire (décision ou titre)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                        "f00028",
                        "L’abandon de famille consiste à ne pas exécuter une décision judiciaire ou l’un des titres ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                        "f00029",
                        "mentionnés aux 2° à 6° du I de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00030",
                    "l’article 373-2-2 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00031",
                    ". L’obligation doit être exécutoire.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00032",
                      "Peuvent notamment constituer un fondement exécutoire :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00033",
                      "• une décision juridictionnelle\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00034",
                      "• une convention judiciairement homologuée\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00035",
                      "• une convention prévue à l’article 229-1 du code civil\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00036",
                      "• un acte notarié\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00037",
                      "• une convention à laquelle l’organisme débiteur des prestations familiales a donné force exécutoire\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00038",
                      "• une transaction ou un acte constatant un accord issu d’une médiation/conciliation/procédure participative\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00039",
                      "La décision doit être exécutoire et portée légalement à la connaissance du débiteur (ou exécutée volontairement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00040",
                      "ou dont il a eu légalement connaissance).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00041",
                  "Durée",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00042",
                          "L’obligation de payer se poursuit pendant toute la période prévue par l’acte exécutoire, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00043",
                          "tant qu’une décision ultérieure ne l’a pas supprimée.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00044",
                  "C) Un défaut de paiement",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00045",
                  "1) Inexécution de l’intégralité du paiement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00046",
                      "Le débiteur doit s’acquitter intégralement de l’obligation :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00047",
                      "• le délit est constitué si le non-paiement est total ou partiel\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00048",
                      "• des paiements partiels, en nature, des compensations ne permettent pas d’exonérer\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00049",
                      "• le refus de prendre en compte une indexation peut aussi caractériser l’infraction.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00050",
                      "Refus d’indexation (réévaluation) : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00051",
                      "(Cass. crim., 26 octobre 1987)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00052",
                  "2) Défaut de paiement pendant plus de deux mois",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00053",
                      "Le texte exige que le débiteur demeure plus de deux mois sans s’acquitter intégralement : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00054",
                      "le délai doit être dépassé (plus de deux mois et non deux mois seulement).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00055",
                      "Délai « plus de deux mois » : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00056",
                      "(C.A. Paris, 16 mars 1994)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00057",
                      "Point de départ du délai :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00058",
                      "• la date de signification de la décision ordonnant le versement, ou\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00059",
                      "• le jour du dernier versement intégral (en cas d’interruption des paiements).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00060",
                  "Effet du délai",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00061",
                          "Le délit est constitué dès l’expiration des deux mois : aucune situation postérieure ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00062",
                          "n’efface rétroactivement l’infraction (même si le paiement intervient tardivement, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00063",
                          "ou si la décision est ensuite modifiée/cassée).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00064",
                      "Cassation ultérieure sans effet : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00065",
                      "(Cass. crim., 26 juillet 1977)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00066",
                      "Réformation partielle sans effet : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00067",
                      "(Cass. crim., 21 mai 1980)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00068",
                      "Paiement tardif sans effet : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00069",
                      "(Cass. crim., 23 mars 1981)",
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

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00070",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00071",
                  "Volonté de ne pas exécuter l’acte imposant le versement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00072",
                      "Le délit d’abandon de famille sanctionne l’inexécution volontaire de l’acte fixant le montant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00073",
                      "de la pension/prestation, à condition que l’auteur ait eu connaissance légale de l’acte.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00074",
                      "La charge de la preuve (caractère intentionnel et connaissance de l’acte) appartient à la partie poursuivante.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00075",
                          "Le délit n’est pas constitué si le non-paiement résulte d’une situation de précarité persistante ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00076",
                          "ne dépendant pas de la volonté du débiteur : ces circonstances peuvent établir le caractère involontaire ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                          "f00077",
                          "du défaut de paiement ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                      "f00078",
                      "(C.A. Aix-en-Provence, 01 juillet 1994)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00079",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00080",
                  "Aucune circonstance aggravante prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
              "f00081",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00082",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00083",
                    "Article 227-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00084",
                  "2 ans d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00085",
                  "15 000 € d’amende.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00086",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00087",
                    "Article 227-4-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00088",
                    " : prévoit la responsabilité pénale des personnes morales.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00089",
                    "Peines encourues : amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00090",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00091",
                    ", et peines complémentaires prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00092",
                    "l’article 131-39, 2° à 9° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00093",
                    " (interdiction d’exercer, etc.).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00094",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                  "f00095",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00096",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00097",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart",
                    "f00098",
                    " (aide et assistance, provocation ou instructions).",
                  ),
                ),
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
