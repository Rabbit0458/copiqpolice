import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAbusDeConfiancePage extends StatelessWidget {
  const PaAbusDeConfiancePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/voisines_du_vol/abus_de_confiance';

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
            "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
            "f00002",
            "Infractions voisines du vol",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
              "f00003",
              "L’abus de confiance",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00005",
                      "L’abus de confiance est le fait, par une personne, de détourner, au préjudice d’autrui, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00006",
                      "des fonds, des valeurs ou un bien quelconque qui lui ont été remis et qu’elle a acceptés ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00007",
                      "à charge de les rendre, de les représenter ou d’en faire un usage déterminé.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00009",
                    "Article 314-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00010",
                    " : définit et réprime l’abus de confiance.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00012",
                      "L’abus de confiance est une appropriation frauduleuse de la propriété d’autrui, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00013",
                      "caractérisée par un détournement. L’auteur a légitimement la chose entre les mains ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00014",
                      "à titre précaire, après une remise librement consentie en vertu d’un accord.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00015",
                  "A) Une remise préalable de la chose",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00016",
                      "La remise est une condition préalable : elle intervient avant le détournement, dans un cadre précis. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00017",
                      "Elle ne confère qu’une détention précaire à celui qui reçoit.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00018",
                  "1) Cadre juridique de la remise",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00019",
                  "La remise peut s’opérer dans différents cadres :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00020",
                  "Un cadre contractuel : tout contrat impliquant une remise à titre précaire (louage, crédit-bail, dépôt, gage, nantissement, société, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00021",
                  "Des dispositions légales ou réglementaires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00022",
                  "Une décision de justice.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00023",
                  "Une simple situation de fait : accord non contractuel (relations amicales), sans engagement juridique formel.",
                ),
              ),

              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00024",
                      "L’abus de confiance ne suppose pas nécessairement une remise en vertu d’un contrat. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00025",
                      "(Cass. crim., 18 octobre 2000)",
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

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00026",
                  "2) Contenu de la remise",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00027",
                  "La remise peut porter sur :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00028",
                  "Des fonds : sommes d’argent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00029",
                  "Des valeurs : titres négociables (actions, obligations…) ou objets de valeur (bijoux, lingots, tableaux, pièces…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00030",
                  "Un bien quelconque : tout bien susceptible d’appropriation, mobilier ou immobilier, avec ou sans valeur économique.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00031",
                      "Le bien peut être incorporel s’il est exploitable matériellement (ex. fichier clientèle, scénario, numéro de carte bancaire, connexion internet, temps de travail…). ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00032",
                      "(Cass. crim., 13 mars 2024, n° 22-83.689)",
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

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00033",
                  "3) Affectation de la remise",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00034",
                      "La remise poursuit un but déterminé : le bénéficiaire accepte :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00035",
                      "• de rendre (restituer) la chose ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00036",
                      "• de la représenter (la montrer) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00037",
                      "• ou d’en faire un usage déterminé (utilisation convenue).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00038",
                      "Il n’a donc pas la libre disposition : la détention est bien précaire.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00039",
                  "B) Un acte matériel de détournement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00040",
                      "Le détournement est caractérisé par la non-restitution de la chose remise à titre précaire.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00041",
                      "Il peut résulter :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00042",
                      "• d’une transgression de l’affectation ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00043",
                      "• d’une aliénation ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00044",
                      "• ou d’une disparition.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00045",
                      "Le délit est caractérisé par le seul détournement, sans qu’une mise en demeure de restituer soit nécessaire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00046",
                      "Aucune mise en demeure nécessaire. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00047",
                      "(Cass. crim., 24 mars 1969)",
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

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00048",
                  "Repères pédagogiques (formes fréquentes)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00049",
                  "Usage abusif : en principe seulement civil, sauf abus manifeste directement contraire aux prévisions acceptées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00050",
                  "Retard de restitution : en principe inexécution contractuelle, sauf retard injustifié devenant frauduleux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00051",
                  "Refus de restituer : caractérise en principe le détournement, sauf droit de rétention/compensation légitime.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00052",
                  "Impossibilité de restituer : si volontaire (hors force majeure/cas fortuit), manifeste la volonté de ne pas respecter la finalité.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00053",
                  "C) Au préjudice d’autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00054",
                      "Le préjudice est un élément essentiel : il suffit que l’acte soit susceptible de priver ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00055",
                      "le propriétaire/possesseur de ses droits. Il n’est pas nécessaire que l’auteur ait tiré profit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00056",
                      "ou que le bien soit entré dans son patrimoine.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00057",
                      "Le préjudice peut être réel ou éventuel ; il peut découler de la seule constatation du détournement. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00058",
                      "(Cass. crim., 3 décembre 2003)",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
              "f00059",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00060",
                      "L’abus de confiance est un délit intentionnel : aucune condamnation ne peut intervenir ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00061",
                      "sans constater le caractère frauduleux des faits.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00062",
                    "Le caractère frauduleux découle de la conscience : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00063",
                    "1) de la précarité de la détention, et 2) de l’obligation de restitution / représentation / usage déterminé, ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00064",
                    "et de la volonté d’y contrevenir.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00065",
                      "L’intention frauduleuse peut se déduire des circonstances (présomptions de fraude). ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                      "f00066",
                      "(Cass. crim., 30 juin 2010)",
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
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
              "f00067",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00068",
                    "Article 314-1-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00069",
                    " : abus de confiance commis en bande organisée.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00070",
                    "Article 314-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                        "f00071",
                        " : circonstances aggravantes liées notamment à l’appel au public pour obtenir la remise, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                        "f00072",
                        "à l’exercice habituel d’opérations portant sur les biens des tiers, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                        "f00073",
                        "au préjudice d’une association faisant appel au public, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                        "f00074",
                        "ou au préjudice d’une personne vulnérable (âge, maladie, infirmité, déficience, grossesse).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00075",
                    "Article 314-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                        "f00076",
                        " : aggravation lorsque l’auteur est mandataire de justice ou officier public/ministériel, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                        "f00077",
                        "dans l’exercice, à l’occasion, ou en raison de ses fonctions/qualité.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + immunité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
              "f00078",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00079",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00080",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00081",
                    "5 ans d’emprisonnement et 375 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00082",
                    "article 314-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00083",
                    "Bande organisée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00084",
                    "7 ans d’emprisonnement et 750 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00085",
                    "article 314-1-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00086",
                    "Aggravations spécifiques : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00087",
                    "7 ans d’emprisonnement et 750 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00088",
                    "article 314-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00089",
                    "Officier public / mandataire de justice : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00090",
                    "10 ans d’emprisonnement et 1 500 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00091",
                    "article 314-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00092",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00093",
                    "Responsabilité pénale selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00094",
                    "l’article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00095",
                    ", pour les infractions des ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00096",
                    "articles 314-1 et 314-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00097",
                    ", et peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00098",
                    "l’article 314-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00099",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00100",
                    "Tentative : OUI — prévue expressément par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00101",
                    "l’article 314-1-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00102",
                    " (toujours punissable).",
                  ),
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00103",
                  "Complicité : OUI (punissable pour l’infraction consommée ou tentée, personne physique ou morale).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                  "f00104",
                  "Immunité familiale",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00105",
                    "Immunité familiale : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00106",
                    "article 314-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00107",
                    " renvoyant aux dispositions de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart",
                    "f00108",
                    "l’article 311-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
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
