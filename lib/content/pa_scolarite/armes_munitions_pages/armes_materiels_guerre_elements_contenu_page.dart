import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaArmesMaterielsGuerreElementsPage extends StatelessWidget {
  const PaArmesMaterielsGuerreElementsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements';

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
            "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
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
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
              "f00003",
              "Port sans autorisation / transport sans motif légitime (cat. A ou B)",
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
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
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
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00005",
                    "Le fait de porter ou de transporter, hors de son domicile, sans motif légitime, ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00006",
                    "et sous réserve des exceptions prévues par le Code de la sécurité intérieure, ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00007",
                    "des matériels de guerre, armes, éléments d’arme ou munitions relevant des catégories A ou B, ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00008",
                    "même en étant régulièrement détenteur, constitue un ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00009",
                    "délit",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00010",
                      "Exceptions : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
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
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
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
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00013",
                    "Article 222-54 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00014",
                    " : prévoit et réprime le port et le transport sans motif légitime des matériels de guerre, armes, éléments d’arme ou munitions des catégories A ou B.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00015",
                    "Réserves / exceptions : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00016",
                    "articles L. 315-1 et L. 315-2 du Code de la sécurité intérieure",
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
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
              "f00017",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00018",
                  "A) Port ou transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00019",
                      "L’infraction suppose que l’auteur soit trouvé en possession, hors de son domicile, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00020",
                      "d’un matériel de guerre / arme / munition / élément d’arme relevant des catégories A ou B.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00021",
                  "1) Le port",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00022",
                  "Le port, c’est l’action d’avoir l’arme sur soi (ceinture, étui, poche, etc.) et utilisable immédiatement.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00023",
                  "2) Le transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00024",
                      "Le transport, c’est déplacer une arme d’un lieu à un autre (hors domicile) en l’ayant auprès de soi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00025",
                      "mais inutilisable immédiatement (ex. valise, housse, coffre d’un véhicule, etc.).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00026",
                  "B) Armes / munitions / éléments concernés",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00027",
                  "Catégorie A : matériels de guerre et armes interdites à l’acquisition et à la détention.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00028",
                  "Catégorie B : armes soumises à autorisation.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00029",
                          "Le législateur inclut aussi les éléments d’armes (même isolés) afin d’éviter le transport d’une arme en pièces détachées ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00030",
                          "pour la remonter au lieu de destination ou d’emploi.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00031",
                  "C) Hors du domicile : notion à connaître",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00032",
                      "Le domicile vise le lieu d’habitation, mais aussi tout endroit normalement clos, non libre d’accès pour les agents, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00033",
                      "assimilé au domicile par la jurisprudence (enceinte de la maison ou proximité immédiate lorsqu’il s’agit du prolongement).",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00034",
                          "La détention d’armes ne vaut pas autorisation de port/transport : dès que l’arme franchit les limites du domicile ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00035",
                          "et que le motif de transport n’est pas légitime, l’infraction peut être constituée.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00036",
                      "Exemples fréquents : véhicule, caravane, bateau, chambre d’hôtel… ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00037",
                      "sauf si ces lieux constituent réellement le domicile de la personne et que l’arme est supposée y être entreposée.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00038",
                  "D) Dérogations à l’interdiction",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00039",
                  "1) Autorisation expresse",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00040",
                    "Le port ou le transport peut être autorisé lorsqu’un texte le prévoit, notamment : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00041",
                    "articles L. 315-1 et L. 315-2 du C.S.I.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00042",
                      "Certaines professions (militaires, policiers, sécurité privée, transport de fonds, etc.) peuvent être autorisées à s’armer. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00043",
                      "Cette autorisation n’est pas générale : elle vaut en principe pendant l’exercice des fonctions.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00044",
                  "2) Motif légitime de transport",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00045",
                  "Le transport d’une arme / élément / munition de catégorie A ou B peut être admis s’il existe un motif légitime au déplacement.",
                ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00046",
                  "Déménagement.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00047",
                  "Trajet domicile ↔ armurerie.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00048",
                  "Compétition ou entraînement.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00049",
                  "Chasse (dans le cadre prévu).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00050",
                  "Reconstitution historique.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
              "f00051",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00052",
                  "Il s’agit d’une infraction intentionnelle : l’individu a conscience qu’il ne respecte pas la loi.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00053",
                  "A) Volonté de porter / transporter hors du domicile",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00054",
                  "L’auteur décide de porter ou transporter une arme (ou munitions/éléments) en dehors du domicile.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00055",
                  "B) Conscience de l’absence de motif légitime",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00056",
                  "L’auteur sait qu’il porte ou transporte sans motif légitime (ou sans autorisation expresse applicable).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
              "f00057",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00058",
                    "Article 222-54 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00059",
                      "Si l’auteur a déjà été condamné pour une ou plusieurs infractions visées par les articles 706-73 et 706-73-1 du Code de procédure pénale, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00060",
                      "à une peine égale ou supérieure à 1 an d’emprisonnement ferme.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00061",
                    "Articles 706-73 et 706-73-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00062",
                    "Article 222-54 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00063",
                  "Si le transport est effectué par au moins deux personnes, ou si deux personnes au moins sont trouvées ensemble porteuses d’armes.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative + exemptions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
              "f00064",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00065",
                  "A) Personnes physiques — peines principales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00066",
                    "Qualification : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00067",
                    "Délit",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00068",
                    "• Simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00069",
                    "7 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00070",
                    "article 222-54 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00071",
                    "• Aggravée (condamnation antérieure) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00072",
                    "10 ans d’emprisonnement et 500 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00073",
                    "article 222-54 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00074",
                    "• Aggravée (au moins deux personnes) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00075",
                    "10 ans d’emprisonnement et 500 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00076",
                    "article 222-54 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00077",
                  "B) Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00078",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00079",
                    "l’article 222-61 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00080",
                    " (amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00081",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00082",
                    " + peines de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00083",
                    "l’article 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00084",
                  "C) Tentative",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00085",
                  "Tentative : NON.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00086",
                  "D) Exemption / réduction de peine",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00087",
                  "Exemption de peine",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00088",
                      "Article 222-67-1 alinéa 1 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00089",
                          " : la personne est exempte de peine si, ayant averti l’autorité administrative ou judiciaire, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00090",
                          "elle a permis d’éviter la réalisation de l’infraction.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00091",
                  "Réduction de peine",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                      "f00092",
                      "Article 222-67-1 alinéa 2 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00093",
                          " : la peine privative de liberté encourue par l’auteur ou le complice est réduite des deux tiers si, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00094",
                          "ayant averti l’autorité administrative ou judiciaire, il a permis de faire cesser l’infraction ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                          "f00095",
                          "ou d’identifier les autres auteurs/complices.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                  "f00096",
                  "E) Complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00097",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00098",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart",
                    "f00099",
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
