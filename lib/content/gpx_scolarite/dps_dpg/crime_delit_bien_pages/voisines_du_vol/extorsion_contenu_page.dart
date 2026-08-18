import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ExtorsionPage extends StatelessWidget {
  const ExtorsionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/extorsion';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
              "f00003",
              "L’extorsion",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00005",
                      "L’extorsion est le fait d’obtenir, par violence, menace de violences ou contrainte, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00006",
                      "soit une signature, un engagement ou une renonciation, soit la révélation d’un secret, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00007",
                      "soit la remise de fonds, de valeurs ou d’un bien quelconque.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00009",
                    "Article 312-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00010",
                    " : définit et réprime l’extorsion.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00012",
                  "A) Des moyens mis en œuvre (violence, menace ou contrainte)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00013",
                      "Il n’y a extorsion que si le comportement de la victime a été obtenu par violence, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00014",
                      "menace de violences ou contrainte. Si la remise résulte seulement de promesses fallacieuses, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00015",
                      "l’infraction n’est pas constituée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00016",
                      "Jurisprudence : remise d’un véhicule de location et d’une carte bancaire après promesse de travail (pas d’extorsion). ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00017",
                      "(C.A. Paris, 27 juin 1997)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00018",
                  "1) Des violences",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00019",
                      "Sont visés tous procédés de contrainte physique privant la victime de sa liberté d’action ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00020",
                      "et l’amenant à se dépouiller : coups et blessures, séquestration, brimades physiques, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00021",
                      "privation de soins ou de nourriture, etc.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00022",
                      "Jurisprudence : victime maintenue dans un état quasi grabataire et de dénuement. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00023",
                      "(Cass. crim., 19 janvier 2000)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00024",
                  "2) Des menaces de violences",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00025",
                      "Il s’agit de toute menace de violences, quelle qu’en soit la forme, dès lors qu’elle a ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00026",
                      "permis la remise. Les menaces n’ont pas à être exécutées : leur formulation peut suffire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00027",
                      "Exemples jurisprudentiels : ",
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                          "f00028",
                          "menaces d’égorger (C.A. Paris, 04 mai 1987) ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                          "f00029",
                          "pression sur un gérant pour reversement d’un pourcentage (Cass. crim., 4 novembre 1997) ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                          "f00030",
                          "menace avec matraque pour obtenir une somme supérieure à la dette (C.A. Grenoble, 24 mai 1996)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00031",
                  "3) Une contrainte morale",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00032",
                      "La contrainte est une force d’origine externe qui domine la volonté de la victime, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00033",
                      "ou suffisamment puissante pour lui enlever sa liberté d’esprit. Elle permet notamment de ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00034",
                      "sanctionner les extorsions par menaces visant la situation matérielle de la victime ou d’un tiers.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00035",
                    "Les juges apprécient souverainement la contrainte (force de l’expression, crainte inspirée, vulnérabilité…). ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00036",
                    "(Cass. crim., 03 octobre 1991)",
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
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00037",
                      "Exemples : menace faite à une mineure de mettre le feu au restaurant de ses parents ; intimidation par un acolyte impressionnant. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00038",
                      "(C.A. Paris, 25 mai 1988 ; Cass. crim., 11 avril 1988)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00039",
                  "B) Une remise par la victime",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00040",
                      "La remise est involontaire mais consciente : la victime joue un rôle actif en remettant la chose, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00041",
                      "même si elle y est contrainte. Sa collaboration résulte de la pression exercée.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00042",
                  "Victime personne physique : pour l’extorsion de signature, la victime est le titulaire de la signature.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00043",
                  "Victime personne morale : une personne morale peut être victime d’extorsion ; elle peut aussi engager sa responsabilité pénale.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00044",
                    "Responsabilité pénale des personnes morales : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00045",
                    "article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00046",
                    ". Peines applicables : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00047",
                    "article 312-15 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00048",
                  "C) L’objet de la remise",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00049",
                      "L’extorsion peut porter sur : une signature, un engagement ou une renonciation, la révélation d’un secret, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00050",
                      "ou la remise de fonds/valeurs/bien quelconque.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00051",
                  "1) Une signature",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00052",
                  "L’infraction est constituée par le seul fait de contraindre une personne à signer (même une feuille blanche).",
                ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00053",
                      "Jurisprudence : pressions d’un supérieur hiérarchique pour obtenir la signature d’une subordonnée. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00054",
                      "(Cass. crim., 16 octobre 2002)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00055",
                  "2) Un engagement ou une renonciation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00056",
                      "Sont visés les actes écrits (contrats, quittances, reçus, démissions, mainlevées…) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00057",
                      "ou des engagements non écrits, y compris non patrimoniaux.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                          "f00058",
                          "Jurisprudences : séquestrer un inspecteur du travail pour obtenir l’engagement écrit de ne pas dresser PV ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                          "f00059",
                          "renoncer à dénoncer des surfacturations illicites. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00060",
                      "(Cass. crim., 09 janvier 1991 ; Cass. crim., 28 novembre 2001)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00061",
                  "3) La révélation d’un secret",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00062",
                      "Le secret s’entend largement : secrets de la vie privée, secrets professionnels, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00063",
                      "secrets de correspondance ou secrets des affaires. Il peut s’agir du secret personnel ou d’autrui.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00064",
                  "4) Fonds, valeurs ou bien quelconque",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00065",
                      "Les « fonds et valeurs » comprennent valeurs mobilières, effets de commerce et instruments de paiement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00066",
                      "(billets, chèques, carte bancaire ou code, mandats…). Le « bien quelconque » vise tout bien susceptible ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00067",
                      "d’appropriation (mobilier/immobilier), avec ou sans valeur économique, y compris des biens incorporels exploitables.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00068",
                      "Jurisprudence : remise sous la violence d’une carte de crédit avec le code. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00069",
                      "(C.A. Bordeaux, 18 octobre 1989)",
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
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00070",
                      "L’objet doit être suffisamment déterminé : exiger un « dédommagement » trop imprécis ne suffit pas. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00071",
                      "(C.A. Paris, 16 avril 1993)",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
              "f00072",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00073",
                      "L’extorsion est une infraction intentionnelle : l’auteur doit vouloir obtenir ce qui ne peut ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00074",
                      "être librement consenti en usant de procédés contraignants.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00075",
                    "Définition jurisprudentielle : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00076",
                    "« conscience d’obtenir par la force, la violence ou la contrainte ce qui n’aurait pu être obtenu par un accord librement consenti »",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900, color: _lawRed),
                ),
                TextSpan(text: " "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00077",
                    "(Cass. crim., 09 janvier 1991)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00078",
                    "Les mobiles sont indifférents (même pour obtenir ce qui serait dû). ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00079",
                    "(Cass. crim., 23 mars 2016)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
              "f00080",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00081",
                  "A) Extorsion aggravée délictuelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00082",
                    "Article 312-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00083",
                  "Violences sur autrui (précédée, accompagnée ou suivie) ayant entraîné une I.T.T. ≤ 8 jours.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00084",
                  "Au préjudice d’une personne vulnérable (âge, maladie, infirmité, déficience physique/psychique, grossesse), vulnérabilité apparente ou connue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00085",
                  "Auteur dissimulant volontairement tout ou partie du visage pour ne pas être identifié.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00086",
                  "Dans un établissement d’enseignement/éducation ou aux abords immédiats lors des entrées/sorties des élèves.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00087",
                  "B) Extorsion aggravée criminelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00088",
                    "Article 312-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00089",
                    " : violences avec I.T.T. > 8 jours.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00090",
                    "Article 312-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00091",
                    " : violences avec mutilation ou infirmité permanente.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00092",
                    "Article 312-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00093",
                    " : usage ou menace d’une arme, ou auteur porteur d’une arme soumise à autorisation / port prohibé.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00094",
                    "Article 312-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00095",
                    " : bande organisée (et variantes avec violences graves / arme).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00096",
                    "Article 312-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00097",
                    " : violences ayant entraîné la mort ou tortures/actes de barbarie.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00098",
                      "Si les violences sont commises pour favoriser la fuite ou assurer l’impunité : extorsion suivie de violences. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00099",
                      "(article 312-8 du Code pénal)",
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

          // Répression + tentative/complicité + immunité + exemption/réduction
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
              "f00100",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00101",
                  "Peines encourues — aperçu",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00102",
                    "Extorsion simple (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00103",
                    "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00104",
                    "article 312-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00105",
                    "Extorsion aggravée délictuelle : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00106",
                    "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00107",
                    "article 312-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00108",
                    "Extorsion aggravée criminelle : peines de réclusion (15 ans, 20 ans, 30 ans, perpétuité) selon la circonstance. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00109",
                    "articles 312-3 à 312-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00110",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00111",
                    "Peines applicables aux personnes morales : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00112",
                    "article 312-15 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00113",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00114",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00115",
                    "article 312-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00116",
                    " (commencement d’exécution + absence de consommation pour circonstances indépendantes).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00117",
                      "Jurisprudence : la fixation d’un rendez-vous peut constituer un début d’exécution. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00118",
                      "(Cass. crim., 17 février 1998)",
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
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00119",
                    "Complicité : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00120",
                    "article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00121",
                    " (aide/assistance, provocation, instructions).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00122",
                  "Immunité familiale",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00123",
                    "Immunité familiale : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00124",
                    "article 312-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00125",
                    " renvoie à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00126",
                    "l’article 311-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00127",
                    " (ascendants/descendants ; conjoint sauf séparation).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exception",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                      "f00128",
                      "L’immunité n’est pas retenue si l’extorsion porte sur des objets/documents indispensables à la vie quotidienne (documents d’identité, titre de séjour, moyens de paiement, télécommunication) ou si l’auteur est tuteur/curateur/mandataire de protection. ",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                  "f00129",
                  "Exemption & réduction de peine (bande organisée)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00130",
                    "Article 312-6-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00131",
                    " : exemption de peine si l’auteur avertit l’autorité et permet d’éviter la réalisation de l’infraction.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00132",
                    "Article 312-6-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/extorsion_contenu_page.dart",
                    "f00133",
                    " : réduction des deux tiers si l’avertissement permet de faire cesser l’infraction/éviter mort ou infirmité/permettre d’identifier les autres auteurs ou complices (perpétuité ramenée à 20 ans).",
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
