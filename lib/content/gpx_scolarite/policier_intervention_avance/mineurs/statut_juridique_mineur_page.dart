import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class StatutJuridiqueMineurPage extends StatelessWidget {
  const StatutJuridiqueMineurPage({super.key});

  static const String routeName = '/gpx/intervention/mineurs/statut-juridique';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRights = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDuties = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Mineurs",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
              "f00002",
              "Le statut juridique du mineur",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
              "f00003",
              "Contexte opérationnel",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00004",
                      "Le policier est confronté à des mineurs délinquants mais aussi à des mineurs victimes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00005",
                      "Dans toutes les missions, il ne faut jamais oublier qu’un mineur bénéficie de droits assortis ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00006",
                      "d’une protection particulière, mais également de devoirs à respecter.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00007",
                  "Toujours adopter une posture protectrice et adaptée à l’âge, sans oublier le cadre légal.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00008",
                  "Penser systématiquement à l’autorité parentale (droits/devoirs des parents + intérêt de l’enfant).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
              "f00009",
              "Références essentielles (cadre légal)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00010",
                    "L’autorité parentale est un ensemble de droits et devoirs exercés dans l’intérêt de l’enfant. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00011",
                    "Article 371-1 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00012",
                    " : protection (sécurité, santé, vie privée, moralité), éducation, développement, respect de la personne.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00013",
                      "L’autorité parentale s’exerce ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00014",
                      "sans violences physiques ou psychologiques",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00015",
                      " et les parents associent l’enfant aux décisions selon son âge/maturité (",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00016",
                      "article 371-1 du Code civil",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Droits
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
              "f00017",
              "I — Les droits des mineurs",
            ),
            cardColor: cardRights,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00018",
                  "A) Droit à l’hébergement",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00019",
                    "Le mineur trouve d’abord sa sécurité en étant hébergé chez ses parents où il est normalement domicilié. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00020",
                    "Article 108-2 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00021",
                      "Atteintes sévèrement punies :\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00022",
                      "• Abandon / non-représentation d’enfant : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00023",
                      "articles 227-3 et 227-5 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00024",
                      "• Enlèvement / détournement de mineur : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00025",
                      "article 224-5, articles 227-7 et 227-8 du Code pénal",
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
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00026",
                  "B) Droit à l’entretien",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00027",
                    "Les parents doivent satisfaire aux besoins de l’enfant (nourriture, logement, santé, éducation). ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00028",
                    "Article 203 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00029",
                    " : les dépenses sont supportées selon les ressources et la situation sociale.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00030",
                  "En cas de séparation (divorce) : l’obligation d’entretien prend souvent la forme d’une pension alimentaire.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00031",
                  "C) Droit à l’éducation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00032",
                      "Les parents ont le droit et le devoir d’assurer l’éducation : instruction, formation professionnelle, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00033",
                      "mais aussi formation civique, morale et religieuse. Le choix des méthodes d’éducation leur appartient, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00034",
                      "mais le juge peut intervenir si elles entraînent des violences ou sont contraires aux bonnes mœurs (assistance éducative).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00035",
                    "Article R. 624-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00036",
                    " : amende (750 €) si un parent ne fait pas fréquenter assidûment l’école à un enfant soumis à l’obligation scolaire, sans motif légitime/excuse valable.",
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00037",
                  "D) Droit à la santé",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00038",
                    "Les parents doivent assurer et veiller à la santé de leurs enfants. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00039",
                    "Article 371-1 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00040",
                  "Exemples d’atteintes / infractions citées",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00041",
                      "• Exemples (défaut de soins, inconduite notoire, etc.) : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00042",
                      "article 378-1 du Code civil",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00043",
                      "• Violences sur mineur : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00044",
                      "articles 222-8, 222-10 (1°), 222-12 (1°), 222-13 (1°), 222-14 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00045",
                      "• Atteintes à la santé/sécurité/moralité/éducation : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00046",
                      "article 227-17 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00047",
                      "• Privation volontaire d’aliments ou de soins : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00048",
                      "articles 227-15 et 227-16 du Code pénal",
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
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                          "f00049",
                          "Constitue notamment une privation de soins : maintenir un enfant de moins de 6 ans sur la voie publique ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                          "f00050",
                          "ou dans un espace de transport collectif, dans le but de solliciter la générosité des passants.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00051",
                    "Obligation scolaire : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00052",
                    "article L. 131-1 du Code de l’éducation",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00053",
                    "article 227-17-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00054",
                  "E) Droit à l’image & respect de la vie privée",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                        "f00055",
                        "Les parents protègent le droit à l’image du mineur dans le respect de sa vie privée, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                        "f00056",
                        "et associent l’enfant à ce droit selon son âge et sa maturité. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00057",
                    "Article 372-1 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00058",
                  "F) Droit au recours à la justice & défense des intérêts",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00059",
                    "Article 388-1 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                        "f00060",
                        " : le mineur capable de discernement peut être entendu, dans toute procédure le concernant, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                        "f00061",
                        "par le juge (ou la personne désignée). La demande ne peut être écartée que par décision spécialement motivée.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00062",
                  "Le mineur peut être entendu seul, avec un avocat, ou avec une personne de son choix (si conforme à son intérêt).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00063",
                  "G) Droit à l’aide juridictionnelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00064",
                    "Attribuée de droit au mineur : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00065",
                    "article 9-1 de la loi n° 91-647 du 10 juillet 1991",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // II — Devoirs
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
              "f00066",
              "II — Les devoirs des mineurs",
            ),
            cardColor: cardDuties,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00067",
                  "En contrepartie de la protection dont il bénéficie, le mineur doit respecter un certain nombre de devoirs.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00068",
                  "A) Respect des parents",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00069",
                    "Article 371 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00070",
                    " : l’enfant, à tout âge, doit honneur et respect à ses père et mère.",
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00071",
                  "B) Devoir d’obéissance",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00072",
                    "Article 371-1 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00073",
                    " : l’enfant doit respecter l’autorité des parents jusqu’à sa majorité ou son émancipation.",
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00074",
                  "C) Devoir de domiciliation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00075",
                    "Le mineur non émancipé est domicilié chez ses parents : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00076",
                    "article 108-2 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00077",
                      "Si les parents ont des domiciles distincts : domiciliation chez celui avec lequel il réside, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                      "f00078",
                      "ou alternativement selon décision de justice.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                        "f00079",
                        "L’enfant ne peut quitter la maison familiale sans permission des parents et ne peut en être retiré ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                        "f00080",
                        "que dans les cas prévus par la loi : ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00081",
                    "article 371-3 du Code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00082",
                  "D) Obligation de scolarisation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                  "f00083",
                  "L’instruction est obligatoire pour les enfants (français et étrangers), entre 3 ans et 16 ans.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00084",
                    "Article L. 131-1 du Code de l’éducation",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart",
                    "f00085",
                    " : cadre général de l’obligation d’instruction.",
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
