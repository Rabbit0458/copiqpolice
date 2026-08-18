import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RequisitionsGeneralitesPage extends StatelessWidget {
  const RequisitionsGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/requisitions/generalites';

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
    final Color cardPQ = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardGen = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardNum = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInter = isDark
        ? const Color(0xFF1E2330)
        : const Color(0xFFF3F6FF);
    final Color cardMan = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color cardBlood = isDark
        ? const Color(0xFF2D1F1F)
        : const Color(0xFFFFF3F3);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentIndigo = isDark
        ? const Color(0xFF9FA8DA)
        : const Color(0xFF283593);
    final Color accentRed = isDark
        ? const Color(0xFFEF9A9A)
        : const Color(0xFFC62828);

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
            "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
            "f00002",
            "Réquisitions judiciaires",
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
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00003",
              "Les réquisitions judiciaires — généralités",
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
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                      "f00005",
                      "La réquisition est un acte permettant à une autorité judiciaire d’exiger d’une personne ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                      "f00006",
                      "l’accomplissement d’une prestation ou la remise d’informations utiles à l’enquête.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (bases principales)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00007",
              "Élément légal — textes de référence",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00008",
                    "Articles 60 et 77-1 du Code de procédure pénale (CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00009",
                    " : réquisitions à personne qualifiée.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00010",
                    "Articles 60-1 et 77-1-1 du Code de procédure pénale (CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00011",
                    " : réquisitions générales (remise d’informations/documents).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00012",
                    "Articles 57-1, 60-2, 60-3, 77-1-2, 97-1, 99-4 et 99-5 du Code de procédure pénale (CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00013",
                    " : réquisitions informatiques et téléphoniques.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00014",
                    "Article 100-3 du Code de procédure pénale (CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00015",
                    " : interceptions de correspondances (commission rogatoire).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00016",
                    "Article R. 642-1 du Code pénal (CP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00017",
                    " : réquisition à manœuvrier.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00018",
                    "Article L. 3354-1 du Code de la santé publique (CSP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00019",
                    " : réquisition à des fins de prélèvement sanguin.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I — Personne qualifiée
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00020",
              "I — Réquisition à personne qualifiée",
            ),
            cardColor: cardPQ,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00021",
                    "Articles 60 et 77-1 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00022",
                        " : l’OPJ (ou sous son contrôle l’APJ / assistant d’enquête) peut recourir à toute personne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00023",
                        "susceptible de réaliser des constatations ou examens techniques/scientifiques utiles à l’enquête.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00024",
                  "En enquête préliminaire : autorisation préalable du procureur de la République requise.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                          "f00025",
                          "Les personnes requises prêtent serment par écrit (« en leur honneur et conscience »). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                          "f00026",
                          "Le serment figure en tête du rapport ou sur déclaration séparée, sauf si la personne est inscrite sur une liste d’experts.",
                        ),
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                      "f00027",
                      "(référence : article 157 du CPP)",
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
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00028",
                  "Peut ouvrir des scellés, replacer sous scellés et placer sous scellés les objets issus de l’examen (ex : prélèvements).",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00029",
                  "Sur instructions du procureur : communication des résultats aux personnes mises en cause (indices) et aux victimes.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Générales
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00030",
              "II — Réquisition générale",
            ),
            cardColor: cardGen,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00031",
                    "Articles 60-1 et 77-1-1 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00032",
                        " : l’OPJ (ou sous son contrôle l’APJ) peut requérir toute personne, établissement, organisme privé/public ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00033",
                        "ou administration susceptible de détenir des informations intéressant l’enquête, y compris issues de systèmes informatiques.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00034",
                  "Remise possible sous forme numérique ; le secret professionnel ne peut être opposé sans motif légitime.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00035",
                    "En enquête préliminaire : réquisition sur autorisation préalable du procureur de la République. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00036",
                    "(article 77-1-1 du CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                          "f00037",
                          "Le procureur peut aussi autoriser par « instructions générales » certaines réquisitions nécessaires à la vérité. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                          "f00038",
                          "Durée maximale : 6 mois (renouvelables / modifiables / interrompues). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                          "f00039",
                          "Le procureur doit être immédiatement avisé des réquisitions délivrées en application de ses instructions.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00040",
                  "Sanction (non-réponse)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00041",
                  "Le fait de s’abstenir de répondre dans les meilleurs délais est puni d’une amende de 3 750 €.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Informatiques & téléphoniques
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00042",
              "III — Réquisitions informatiques & téléphoniques",
            ),
            cardColor: cardNum,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00043",
                    "Articles 57-1, 60-2, 60-3, 77-1-2, 97-1, 99-4 et 99-5 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00044",
                    " : principales hypothèses.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00045",
                  "A) Accès / protection des données",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00046",
                    "Article 57-1 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00047",
                    " : requérir toute personne ayant connaissance des mesures de protection ou permettant l’accès aux données (perquisition).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00048",
                  "B) Remise d’informations par organismes",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00049",
                    "Article 60-2 alinéa 1 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00050",
                    " : requérir des organismes publics / personnes morales de droit privé détenant des informations utiles (sauf secret prévu par la loi).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00051",
                    "En enquête préliminaire : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00052",
                    "article 77-1-2 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00053",
                    " → autorisation préalable du procureur.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00054",
                  "C) Préservation de données (opérateurs)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00055",
                    "Article 60-2 alinéa 2 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00056",
                    " : sur réquisition du procureur après autorisation du JLD, imposer aux opérateurs de préserver certaines données (max. 1 an).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00057",
                  "D) Ouverture de scellés / copies",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00058",
                    "Article 60-3 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00059",
                    " : requérir une personne qualifiée pour ouvrir des scellés supports de données, copier/exploiter sans altérer l’intégrité.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00060",
                  "Sanction (refus non légitime)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00061",
                  "Le refus de répondre sans motif légitime à ces réquisitions est puni d’une amende de 3 750 €.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Interceptions (CR)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00062",
              "IV — Interceptions de correspondances (commission rogatoire)",
            ),
            cardColor: cardInter,
            accent: accentIndigo,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00063",
                    "Article 100-3 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00064",
                        " : en commission rogatoire, l’OPJ (ou sous son contrôle l’APJ) peut requérir un agent qualifié ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00065",
                        "pour installer un dispositif d’interception (service sous tutelle ou exploitant/fournisseur autorisé).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                      "f00066",
                      "Cette réquisition est liée à un cadre judiciaire spécifique (commission rogatoire) : rigueur maximale sur la trace et l’autorisation.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V — Manœuvrier
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00067",
              "V — Réquisition à manœuvrier",
            ),
            cardColor: cardMan,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00068",
                    "Article R. 642-1 du Code pénal (CP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00069",
                        " : l’APJ, dans l’exercice de ses fonctions, peut requérir toute personne susceptible de fournir ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00070",
                        "une prestation utile (ex : serrurier) en cas d’atteinte à l’ordre public, sinistre, ou danger.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00071",
                  "La personne requise ne concourt pas directement à la manifestation de la vérité et ne réalise pas d’examen technique/scientifique.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00072",
                  "Pas d’obligation de prêter serment.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00073",
                  "Le refus ou la négligence sans motif légitime est puni de l’amende des contraventions de 2ᵉ classe.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Prélèvement sanguin
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
              "f00074",
              "VI — Réquisition pour prélèvement sanguin",
            ),
            cardColor: cardBlood,
            accent: accentRed,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00075",
                    "Article L. 3354-1 du CSP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00076",
                        " : en cas de crime/délit/accident de circulation, les OPJ/APJ doivent faire procéder aux vérifications ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                        "f00077",
                        "pour déterminer la présence d’alcool (obligatoires si mort).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00078",
                    "Vérifications prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                    "f00079",
                    "l’article L. 234-4 du Code de la route (CR)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00080",
                  "Peuvent être effectuées sur l’auteur présumé et, si utile, sur la victime.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                  "f00081",
                  "Moyens : analyses/examens médicaux, cliniques, biologiques, ou éthylomètre (air expiré).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                      "f00082",
                      "À cette fin, l’OPJ/APJ peut requérir : médecin, interne, étudiant autorisé remplaçant, ou infirmier pour la prise de sang.",
                    ),
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart",
                      "f00083",
                      "(article L. 234-4 du Code de la route)",
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
