import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DiffusionEnregistrementCaractereSexuelSansAccordPage
    extends StatelessWidget {
  const DiffusionEnregistrementCaractereSexuelSansAccordPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
            "f00002",
            "Atteintes à la personnalité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
              "f00003",
              "La diffusion, sans l’accord de la personne concernée, d’un enregistrement ou document à caractère sexuel",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00005",
                      "La diffusion, sans l'accord de la personne concernée, d'un enregistrement ou document portant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00006",
                      "sur des paroles ou images à caractère sexuel, préalablement obtenu avec son consentement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00007",
                      "ou fourni par elle-même, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00009",
                    "Article 226-2-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                        "f00010",
                        " : définit et réprime la diffusion, sans l’accord de la personne concernée, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                        "f00011",
                        "d’un enregistrement ou document portant sur des paroles ou images à caractère sexuel.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00013",
                      "Ces agissements ont été popularisés sous l’appellation « revenge porn » ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00014",
                      "on parle aussi aujourd’hui de « pornodivulgation ».",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00015",
                  "A) Un enregistrement ou document obtenu avec consentement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00016",
                      "La pornodivulgation consiste à obtenir (avec l’accord du partenaire/ex-partenaire) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00017",
                      "des vidéos, photos, enregistrements, ou échanges de messages (« sexting ») à caractère intime, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00018",
                      "puis à les diffuser sans le consentement de la personne concernée.",
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                        "f00019",
                        "À la différence de l’atteinte à la vie privée, la personne est consentante à être filmée, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                        "f00020",
                        "photographiée ou enregistrée : ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00021",
                    "article 226-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00022",
                      "Le support peut être :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00023",
                      "• visuel (photo)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00024",
                      "• audio (bande son)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00025",
                      "• audiovisuel (vidéo)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00026",
                      "• écrit (échange de messages)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00027",
                      "Peu importe qu’il soit matériel ou totalement numérisé.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00028",
                  "B) Un caractère sexuel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00029",
                      "Le caractère sexuel des paroles/images s’apprécie au cas par cas. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00030",
                      "Le Conseil constitutionnel a jugé la notion suffisamment claire et précise, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00031",
                      "et a rappelé qu’il appartient aux juridictions d’en apprécier la réalité.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00032",
                      "Décision ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00033",
                      "n° 2021-933 QPC du 30 septembre 2021",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00034",
                  "C) Une diffusion sans accord",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00035",
                      "L’enregistrement/document est porté à la connaissance du public ou d’un tiers ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00036",
                      "sans l’accord de la victime : soit parce qu’elle s’y oppose, soit parce qu’elle n’a pas été consultée.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00037",
                      "L’accord à être filmé(e) ou photographié(e) ne vaut pas accord à la diffusion. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00038",
                      "Il appartient à l’auteur de prouver qu’il avait reçu un accord en vue de diffuser.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                          "f00039",
                          "Si l’auteur exige des faveurs sexuelles en menaçant de diffuser le contenu intime, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                          "f00040",
                          "le harcèlement sexuel est constitué — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00041",
                      "article 222-33 II du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                          "f00042",
                          "S’il obtient une signature, un engagement, une renonciation, une révélation de secret, ou la remise de fonds/biens ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                          "f00043",
                          "par cette menace, le chantage est constitué — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00044",
                      "article 312-10 du Code pénal",
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
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                          "f00045",
                          "Dans la pratique, la preuve de l’absence d’accord repose souvent sur la déclaration de la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                          "f00046",
                          "C’est la raison pour laquelle le dépôt de plainte est requis — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00047",
                      "article 226-6 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "IMPORTANT",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
              "f00048",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00049",
                      "Il faut la conscience de diffuser, sans l’accord de la personne, un enregistrement ou document ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                      "f00050",
                      "portant sur des paroles ou images à caractère sexuel.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
              "f00051",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00052",
                  "Aucune circonstance aggravante prévue par le texte.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
              "f00053",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00054",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00055",
                    "Délit : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00056",
                    "2 ans d’emprisonnement et 60 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00057",
                    "article 226-2-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00058",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00059",
                    "Responsabilité prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00060",
                    "l’article 226-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                  "f00061",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00062",
                    "Tentative : OUI, prévue expressément par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00063",
                    "l’article 226-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00064",
                    " (tentative du délit prévu à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00065",
                    "l’article 226-2-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00066",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00067",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00068",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart",
                    "f00069",
                    " (aide et assistance, provocation ou instructions données).",
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
