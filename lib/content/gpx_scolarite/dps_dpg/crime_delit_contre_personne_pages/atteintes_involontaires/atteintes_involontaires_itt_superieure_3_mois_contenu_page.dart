import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AtteintesInvolontairesIttSuperieure3MoisPage extends StatelessWidget {
  const AtteintesInvolontairesIttSuperieure3MoisPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
            "f00002",
            "Atteintes involontaires",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
              "f00003",
              "Atteintes involontaires à l’intégrité de la personne\n(I.T.T. > 3 mois)",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00005",
                      "Le fait de causer à autrui, dans les conditions et selon les distinctions prévues à l’article 121-3, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00006",
                      "par maladresse, imprudence, inattention, négligence ou manquement à une obligation de sécurité ou de prudence ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00007",
                      "imposée par la loi ou le règlement, une incapacité totale de travail pendant plus de trois mois, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00009",
                    "Texte d’incrimination : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00010",
                    "article 222-19 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00011",
                    " (blessures involontaires avec I.T.T. > 3 mois).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00012",
                    "Renvoi essentiel : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00013",
                    "article 121-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00014",
                    " (distinction faute simple / causalité indirecte : faute délibérée ou caractérisée).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
              "f00015",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00016",
                  "A) Un acte involontaire : la faute",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00017",
                    "L’article 222-19 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                        "f00018",
                        ", en référence à l’article 121-3, énumère cinq comportements fautifs (liste limitative). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                        "f00019",
                        "Les juges doivent caractériser l’un de ces comportements.",
                      ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00020",
                  "1) La faute simple",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00021",
                  "Maladresse, imprudence, inattention, négligence.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00022",
                      "L’imprudence, la maladresse ou l’inattention consistent à agir sans précautions. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00023",
                      "La négligence correspond au fait de ne pas se soucier des conséquences de son abstention.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00024",
                      "Ces fautes sont appréciées par rapport au comportement attendu d’une personne « normalement » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00025",
                      "adroite, attentive, prudente et diligente. Le cas échéant, l’appréciation se fait au regard du ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00026",
                      "professionnel moyen (ou diligent) placé dans la même situation.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00027",
                  "Manquement à une obligation de sécurité ou de prudence imposée par la loi ou le règlement.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00028",
                      "Le terme « règlement » vise les actes des autorités administratives à caractère général et impersonnel. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00029",
                      "L’inobservation d’une obligation textuelle se suffit en elle-même : il n’est pas nécessaire de se référer ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00030",
                      "aux devoirs généraux de prudence et de diligence.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00031",
                      "Les magistrats doivent pouvoir préciser la source et la nature exacte de l’obligation violée. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00032",
                      "(Cass. crim., 18 juin 2002)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00033",
                  "2) La faute caractérisée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00034",
                      "Si la faute est en lien direct avec le dommage, la faute simple peut suffire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00035",
                      "En cas de causalité indirecte, il faut démontrer une faute délibérée ou caractérisée.",
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00036",
                      "La faute caractérisée est une faute lourde exposant autrui à un danger d’une particulière gravité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00037",
                      "et dont l’auteur ne peut ignorer les risques. Elle révèle une gravité supplémentaire (circonstances de l’acte, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00038",
                      "fonctions exercées), et apparaît grossière et inacceptable.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00039",
                      "Faute caractérisée : remise volontaire des clés d’un véhicule à une personne sans permis et sous alcool. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00040",
                      "(Cass. crim., 14 décembre 2010)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00041",
                      "Médecin du SAMU n’ayant pas posé les bonnes questions. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00042",
                      "(Cass. crim., 2 décembre 2003)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00043",
                  "B) Un lien de causalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00044",
                      "La faute doit avoir concouru au dommage. La causalité n’a pas à être immédiate : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00045",
                      "le dommage peut s’aggraver et s’apprécie dans son dernier état.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00046",
                  "1) Causalité indirecte",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00047",
                    "Article 121-3 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                        "f00048",
                        " : auteurs indirects = personnes qui ont créé ou contribué à créer la situation ayant permis le dommage, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                        "f00049",
                        "ou qui n’ont pas pris les mesures permettant de l’éviter.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00050",
                      "Professionnel de location confiant un scooter des mers à une personne sans permis de navigation (perte de maîtrise : mort et blessures). ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00051",
                      "(Cass. crim., 5 octobre 2004)",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00052",
                    "En matière d’accidents du travail, la causalité indirecte peut être retenue contre le chef d’entreprise / directeur d’établissement. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00053",
                    "(Cass. crim., 28 mars 2006)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00054",
                  "Exemples (maire)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00055",
                      "Aire de jeux : buse non fixée écrasant un enfant. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00056",
                      "(Cass. crim., 20 mars 2001)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00057",
                      "Pouvoirs de police administrative : absence de réglementation des déplacements de dameuses sur piste de luge. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00058",
                      "(Cass. crim., 18 mars 2003)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00059",
                  "2) Causalité directe",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00060",
                      "La circulaire d’application du 11 octobre 2000 évoque une « causalité immédiate » : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00061",
                      "frapper/heurter la victime, ou initier/contrôler le mouvement d’un objet ayant heurté la victime.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00062",
                    "La Cour de cassation adopte une approche plus large : peut relever de la causalité directe celui dont le comportement a été un paramètre déterminant du dommage. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00063",
                    "(Cass. crim., 25 septembre 2001)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00064",
                  "C) Sur la personne d’autrui",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00065",
                  "Une personne humaine.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00066",
                  "Une personne vivante.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00067",
                  "D) Un dommage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00068",
                      "Le dommage peut être physique ou psychique : un choc émotionnel peut constituer le résultat. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00069",
                      "La victime doit avoir subi une incapacité totale de travail de plus de trois mois.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
              "f00070",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00071",
                  "L’élément moral n’est pas requis pour les infractions non intentionnelles.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00072",
                  "Exception : violation manifestement délibérée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00073",
                      "En présence d’une violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00074",
                      "il faut établir que l’individu a adopté un comportement risqué en toute connaissance de cause : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00075",
                      "conscience des dangers, sans volonté que le dommage se réalise.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
              "f00076",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00077",
                    "Article 222-19 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00078",
                    " : aggravation en cas de violation manifestement délibérée d’une obligation particulière imposée par la loi ou le règlement.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00079",
                  "La violation délibérée d’une circulaire ou du règlement intérieur d’une entreprise ne peut pas constituer la circonstance aggravante.",
                ),
              ),
              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00080",
                    "Article 222-19-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00081",
                    " : trois degrés d’aggravation (conducteur de VTM).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00082",
                  "1) Premier degré",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00083",
                  "Lorsque l’atteinte est commise par le conducteur d’un véhicule terrestre à moteur.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00084",
                  "2) Deuxième degré",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00085",
                      "Lorsque le conducteur est auteur d’une violation manifestement délibérée d’une obligation particulière de prudence ou de sécurité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00086",
                      "ou lorsque les blessures involontaires s’accompagnent d’une infraction routière :",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00087",
                  "Conduite en état d’ivresse manifeste / état alcoolique ≥ seuil légal.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00088",
                  "Refus de se soumettre aux vérifications alcool.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00089",
                  "Conduite après usage de stupéfiants.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00090",
                  "Refus de se soumettre aux vérifications stupéfiants.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00091",
                  "Conduite sans permis / permis annulé, invalidé, suspendu ou retenu.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00092",
                  "Excès de vitesse ≥ 50 km/h.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00093",
                  "Délit de fuite.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00094",
                  "3) Troisième degré",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00095",
                  "Lorsque deux ou plusieurs circonstances ci-dessus sont réunies.",
                ),
              ),

              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00096",
                    "Article 222-19-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00097",
                    " : trois degrés d’aggravation (agression par un chien).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00098",
                  "NOTA (présomption)",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                          "f00099",
                          "L’absence de faute est présumée lorsque l’animal est, au moment des faits, en action de protection d’un troupeau ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                          "f00100",
                          "et identifié conformément au code rural et de la pêche maritime. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00101",
                      "(art. 222-19-2 II du Code pénal)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00102",
                  "1) Premier degré",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00103",
                  "Lorsque l’infraction résulte de l’agression commise par un chien, à l’encontre du propriétaire/détenteur.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00104",
                  "2) Deuxième degré",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00105",
                  "Lorsque l’infraction est commise dans l’une des situations suivantes :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00106",
                  "Propriété ou détention du chien illicite.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00107",
                  "Propriétaire/détenteur en état d’ivresse manifeste ou sous stupéfiants.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00108",
                  "Non-exécution des mesures prescrites par le maire pour prévenir le danger.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00109",
                  "Absence de permis de détention.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00110",
                  "Absence de justification de vaccination antirabique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00111",
                  "Chien de 1ère/2ème catégorie non muselé ou non tenu en laisse par un majeur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00112",
                  "Chien ayant fait l’objet de mauvais traitements.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00113",
                  "3) Troisième degré",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00114",
                  "Lorsque deux ou plusieurs circonstances ci-dessus sont réunies.",
                ),
              ),

              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00115",
                    "Article 434-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00116",
                    " : aggravation lorsque les blessures sont suivies d’un délit de fuite (hors cas déjà prévus à l’article 222-19-1).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
              "f00117",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00118",
                  "Peines encourues — personnes physiques",
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00119",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00120",
                    "2 ans d’emprisonnement et 30 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00121",
                    "article 222-19 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00122",
                    "Aggravée (violation manifestement délibérée) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00123",
                    "3 ans d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00124",
                    "article 222-19 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00125",
                    "Aggravée (conducteur — 1er degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00126",
                    "3 ans d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00127",
                    "article 222-19-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00128",
                    "Aggravée (conducteur — 2e degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00129",
                    "5 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00130",
                    "article 222-19-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00131",
                    "Aggravée (conducteur — 3e degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00132",
                    "7 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00133",
                    "article 222-19-1 alinéa 9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00134",
                    "Aggravée (chien — 1er degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00135",
                    "3 ans d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00136",
                    "article 222-19-2 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00137",
                    "Aggravée (chien — 2e degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00138",
                    "5 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00139",
                    "article 222-19-2 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00140",
                    "Aggravée (chien — 3e degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00141",
                    "7 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00142",
                    "article 222-19-2 alinéa 10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00143",
                    "Aggravée (délit de fuite, hors 222-19-1) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00144",
                    "doublement des peines — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00145",
                    "article 434-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00146",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00147",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00148",
                    "l’article 222-21 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                    "f00149",
                    " (les personnes morales peuvent être responsables même si la causalité est indirecte, en cas de faute simple).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                          "f00150",
                          "La chambre criminelle retient la responsabilité des personnes morales pour toute faute non intentionnelle ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                          "f00151",
                          "de leurs organes ou représentants, même si (à défaut de faute délibérée/caractérisée) la responsabilité ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                          "f00152",
                          "pénale des personnes physiques ne pourrait être recherchée. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                      "f00153",
                      "(Cass. crim., 24 octobre 2000)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00154",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00155",
                  "Tentative : NON (le résultat n’est pas souhaité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart",
                  "f00156",
                  "Complicité : NON (jurisprudence exclut la complicité en matière non intentionnelle).",
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
