import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ArmesPortTransportCDPage extends StatelessWidget {
  const ArmesPortTransportCDPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd';

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
            "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
            "f00002",
            "Armes & munitions",
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
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00003",
              "Port sans autorisation / transport sans motif légitime (cat. C ou D)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00005",
                    "Hors du domicile (et sauf exceptions), le fait d’être trouvé porteur ou d’effectuer sans motif légitime le transport ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00006",
                    "d’armes de catégories C ou D (liste fixée par arrêté), de munitions ou de leurs éléments ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00007",
                    "constitue un ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00008",
                    "délit",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00009",
                    ", même si l’on en est régulièrement détenteur.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00010",
                      "Exceptions : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00011",
                      "articles L. 315-1 et L. 315-2 du C.S.I.",
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

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00012",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00013",
                    "Article L. 317-8 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                        "f00014",
                        " : prévoit et réprime le port et le transport sans motif légitime des armes, munitions ou éléments des catégories C ou D ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                        "f00015",
                        "(à l’exception de ceux présentant une faible dangerosité et figurant sur une liste fixée par arrêté).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00016",
                    "Réserves / exceptions : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00017",
                    "articles L. 315-1 et L. 315-2 du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00018",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00019",
                  "A) Port ou transport hors du domicile",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00020",
                      "L’infraction vise des faits commis hors du domicile, selon les mêmes logiques que pour les catégories A ou B : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00021",
                      "l’interdiction est le principe, les dérogations sont encadrées.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00022",
                  "1) Le port",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00023",
                  "Le port, c’est le fait d’avoir l’arme sur soi (ceinture, étui, poche, etc.) et utilisable immédiatement.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00024",
                  "2) Le transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00025",
                      "Le transport, c’est déplacer une arme d’un lieu à un autre (hors domicile) en l’ayant auprès de soi, mais inutilisable immédiatement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00026",
                      "(ex. dans une valise, une housse, le coffre d’un véhicule, etc.).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00027",
                  "B) Armes / munitions / éléments concernés",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00028",
                  "Catégorie C : armes soumises à déclaration.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00029",
                  "Catégorie D : uniquement celles figurant sur une liste fixée par arrêté (hors faible dangerosité).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                          "f00030",
                          "Le législateur inclut aussi les éléments d’armes (même isolés) pour éviter le transport d’une arme en pièces détachées ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                          "f00031",
                          "afin de la remonter au lieu de destination ou d’emploi.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00032",
                  "C) Dérogations : le motif légitime de transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00033",
                      "Le transport d’une arme, de munitions ou d’éléments d’arme de catégorie C ou D (sauf cas où il est libre) est admis ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                      "f00034",
                      "s’il existe un motif légitime lié au déplacement.",
                    ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00035",
                  "Déménagement.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00036",
                  "Trajet domicile ↔ armurerie.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00037",
                  "Compétition ou entraînement.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00038",
                  "Chasse (dans le cadre prévu).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00039",
                  "Reconstitution historique.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00040",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00041",
                  "Il s’agit d’une infraction intentionnelle : l’auteur a conscience de ne pas respecter la loi.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00042",
                  "A) Volonté de porter / transporter hors du domicile",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00043",
                  "L’individu décide de porter ou transporter l’arme (ou munitions/éléments) en dehors de son domicile.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00044",
                  "B) Conscience de l’absence de motif légitime",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00045",
                  "L’individu sait qu’il porte ou transporte sans motif légitime au sens de la réglementation.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00046",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00047",
                    "Article L. 317-9 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00048",
                  "Si le transport d’armes est effectué par au moins deux personnes, ou si deux personnes au moins sont trouvées porteuses d’armes.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
              "f00049",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00050",
                  "A) Personnes physiques — peines principales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00051",
                    "Qualification : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00052",
                    "Délit",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00053",
                  "Catégorie C",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00054",
                    "• Simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00055",
                    "2 ans d’emprisonnement et 30 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00056",
                    "article L. 317-8 2° du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00057",
                    "• Aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00058",
                    "5 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00059",
                    "article L. 317-9 2° du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00060",
                  "Catégorie D",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00061",
                    "• Simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00062",
                    "1 an d’emprisonnement et 15 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00063",
                    "article L. 317-8 3° du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00064",
                    "• Aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00065",
                    "2 ans d’emprisonnement et 30 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00066",
                    "article L. 317-9 3° du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00067",
                  "B) Personnes morales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00068",
                  "NON (non prévu ici).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00069",
                  "C) Amende forfaitaire délictuelle (AFD)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00070",
                    "Le dernier alinéa de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00071",
                    "l’article L. 317-8 du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00072",
                    " permet de recourir à la procédure d’amende forfaitaire pour le délit (catégorie D), sauf s’il s’agit d’armes à feu.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00073",
                    "Procédure prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00074",
                    "les articles 495-17 à 495-25 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                  "f00075",
                  "D) Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00076",
                    "Tentative : ",
                  ),
                ),
                TextSpan(
                  text: "NON",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00077",
                    " (en l’absence de texte spécial : la tentative n’est punissable que si la loi le prévoit).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00078",
                    "Complicité : ",
                  ),
                ),
                TextSpan(
                  text: "OUI",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00079",
                    ", conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00080",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart",
                    "f00081",
                    "l’article 121-7 du Code pénal",
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
