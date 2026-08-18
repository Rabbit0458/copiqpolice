import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaFauxCertificatsOuAttestationsPage extends StatelessWidget {
  const PaFauxCertificatsOuAttestationsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations';

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
            "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
            "f00002",
            "Faux & usage de faux",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00003",
              "Les faux certificats ou attestations",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00005",
                      "L’infraction est constituée par le fait d’établir une attestation ou un certificat faisant état de faits matériellement inexacts ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00006",
                      "de falsifier une attestation ou un certificat originairement sincère ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00007",
                      "ou de faire usage d’une attestation ou d’un certificat inexact ou falsifié.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00009",
                    "Article 441-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00010",
                    " : définit et réprime l’établissement et l’usage de faux certificats ou attestations.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00012",
                  "A) Un certificat ou une attestation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00013",
                  "La jurisprudence vise toute déclaration écrite, quelle que soit sa forme, faite en faveur d’autrui dans un but probatoire.",
                ),
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00014",
                  "Repères utiles",
                ),
                cardColor: isDark
                    ? const Color(0xFF1E232A)
                    : const Color(0xFFF3F4F6),
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00015",
                      "Le certificat concerne en général une personne : qualité, état de santé, situation professionnelle, familiale, sociale, etc.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00016",
                      "L’attestation porte sur des faits, événements ou circonstances quelconques.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00017",
                  "B) Seul l’écrit est pris en compte",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00018",
                    "La seule fourniture de renseignements oraux, même inexacts, ne constitue pas l’établissement d’attestations ou de certificats inexacts ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00019",
                    "(Cass. crim., 21 février 1985)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00020",
                      "Exemples admis : une simple lettre / déclaration écrite sur les circonstances d’un accident ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00021",
                      "(Cass. crim., 30 janvier 1962)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00022",
                      " ; un certificat d’immatriculation provisoire délivré par un garagiste ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00023",
                      "(Cass. crim., 14 février 1973)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00024",
                  "C) Conditions dégagées par la jurisprudence",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00025",
                  "Le document doit comporter la signature authentique de son auteur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00026",
                  "Il doit être établi au profit d’un tiers (pas une attestation sur l’honneur rédigée pour soi-même).",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00027",
                    "Signature authentique exigée ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00028",
                    "(Cass. crim., 15 mars 2000)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00029",
                  "D) Les comportements incriminés",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00030",
                    "L’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00031",
                    "article 441-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00032",
                    " incrimine plusieurs comportements :",
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00033",
                  "1) Établir un écrit matériellement inexact",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00034",
                      "L’établissement correspond à la rédaction du document et à sa signature. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00035",
                      "L’infraction est constituée par le simple établissement, indépendamment de l’usage ultérieur.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00036",
                  "Les « faits matériellement inexacts » renvoient à des éléments objectifs, susceptibles de vérification, de constatation ou de preuve contraire.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00037",
                  "2) Falsifier un écrit sincère à l’origine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00038",
                  "Le délit est consommé par une altération de la vérité dans le document initialement sincère.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00039",
                      "Jurisprudence : surcharge de la date de validité provisoire du certificat d’immatriculation ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00040",
                      "(Cass. crim., 14 février 1973)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00041",
                      "Jurisprudence : modification du résultat d’une analyse de sang sur un certificat délivré ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00042",
                      "(C.A. Rouen, 22 septembre 1999)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00043",
                  "3) Faire usage d’un écrit inexact ou falsifié",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00044",
                  "L’usage suppose au préalable l’existence d’un faux : soit un établissement matériellement inexact, soit une falsification d’un document sincère.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00045",
                      "Jurisprudence : attestation produite dans une procédure de divorce relatant faussement des violences ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00046",
                      "(Cass. crim., 31 janvier 2007)",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00047",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00048",
                  "A) Connaissance de l’inexactitude",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00049",
                      "L’auteur doit avoir connaissance de l’inexactitude des faits certifiés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00050",
                      "Peu importe qu’il n’ait pas prévu l’usage qu’un tiers ferait de l’attestation mensongère.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00051",
                  "B) En cas d’usage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00052",
                  "Dans le cadre de l’usage, l’infraction suppose la volonté d’user du document.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00053",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00054",
                    "Article 441-7 alinéa 5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00055",
                    " : lorsque l’infraction est commise :",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00056",
                  "Soit en vue de porter préjudice au Trésor public ou au patrimoine d’autrui.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00057",
                  "Soit en vue d’obtenir un titre de séjour ou le bénéfice d’une protection contre l’éloignement.",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00058",
                      "Jurisprudence : employeur faisant établir par des salariés de fausses attestations produites en procédure prud’homale ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00059",
                      "(Cass. crim., 26 septembre 2001)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                      "f00060",
                      " — la circonstance aggravante n’était pas retenue au stade de l’établissement, mais applicable à l’usage.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
              "f00061",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00062",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00063",
                    "Simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00064",
                    "1 an d’emprisonnement et 15 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00065",
                    "article 441-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00066",
                    "Aggravée (alinéa 5) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00067",
                    "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00068",
                    "article 441-7 alinéa 5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00069",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00070",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00071",
                    "l’article 441-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00072",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00073",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00074",
                    "article 441-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                    "f00075",
                    " (prévoit expressément la tentative des délits, dont ceux visés à l’article 441-7).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart",
                  "f00076",
                  "Complicité : OUI (règles générales de la complicité).",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
