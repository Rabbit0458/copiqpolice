import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AtteinteIntimiteViePriveePage extends StatelessWidget {
  const AtteinteIntimiteViePriveePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
            "f00002",
            "Atteinte à la personnalité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00003",
              "L’atteinte à l’intimité de la vie privée",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / faits visés
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00004",
              "Définition — faits visés",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00005",
                  "Constituent des infractions :",
                ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00006",
                  "la captation, l’enregistrement ou la transmission, sans son consentement, des paroles d’une personne prononcées à titre privé ou confidentiel.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00007",
                  "la fixation, l’enregistrement ou la transmission, sans son consentement, de l’image d’une personne se trouvant dans un lieu privé.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00008",
                  "la captation, l’enregistrement ou la transmission de la localisation (en temps réel ou en différé) d’une personne, sans son consentement.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00009",
                  "La conservation, l’utilisation ou la divulgation d’un document ou d’un enregistrement issu de ces agissements constitue également une infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (comme demandé)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00010",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00011",
                    "Article 226-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00012",
                    " : définit et réprime les atteintes à l’intimité de la vie privée d’une personne.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00013",
                    "Article 226-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00014",
                    " : définit et réprime la conservation, la diffusion ou l’utilisation de tout document ou enregistrement obtenu à l’aide d’une atteinte à l’intimité de la vie privée.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00015",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00016",
                  "A) Au moyen d’un procédé quelconque",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00017",
                      "Sont visés toutes les méthodes permettant de parvenir au résultat recherché : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00018",
                      "dispositifs techniques (appareils, logiciels, balises…) mais aussi procédés ne faisant pas appel à un appareil.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00019",
                  "B) Captation / enregistrement / transmission des paroles privées ou confidentielles",
                ),
              ),

              SizedBox(height: 6),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00020",
                  "• La captation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00021",
                      "Le Code pénal vise notamment l’audition par un ou des tiers, grâce à des moyens techniques appropriés, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00022",
                      "de conversations (par ex. téléphoniques). Sont également concernés les propos tenus de vive voix alors ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00023",
                      "que le locuteur est éloigné de toute oreille indiscrète, mais rendus audibles par des moyens clandestins ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00024",
                      "de captation ou d’amplification.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00025",
                  "• L’enregistrement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00026",
                      "C’est le fait d’enregistrer, au moyen d’un appareil quelconque, des paroles prononcées à titre privé. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00027",
                      "L’infraction est constituée quels que soient les résultats techniques : elle peut l’être même si les propos ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00028",
                      "enregistrés sont inaudibles.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00029",
                  "• La transmission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00030",
                      "Elle vise tout moyen permettant la mise à disposition, à un ou plusieurs destinataires avertis, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00031",
                      "de la parole indûment captée. L’expédition d’un enregistrement matériel ou dématérialisé peut constituer cette transmission.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00032",
                  "• Paroles « privées ou confidentielles »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00033",
                      "Le délit est constitué dès lors que les paroles captées ou enregistrées ont été prononcées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00034",
                      "dans un lieu privé ou public : l’important est qu’elles n’avaient pas vocation à être rendues publiques ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00035",
                      "(intimité ou volonté d’entourer les propos d’une part de secret).",
                    ),
              ),

              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00036",
                          "Jurisprudence : l’enregistrement de la parole ou de l’image d’une personne placée en garde à vue ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00037",
                          "n’échappe pas ipso facto au champ d’application de l’atteinte à l’intimité de la vie privée ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00038",
                      "(Cass. crim., 21 avril 2020)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00039",
                  "• Sans le consentement de la personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00040",
                      "L’auteur des paroles n’a pas donné son accord pour qu’elles soient captées, enregistrées ou transmises. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00041",
                      "À l’inverse, le consentement est présumé lorsque l’atteinte est accomplie au vu et au su de cette personne ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00042",
                      "sans qu’elle s’y soit opposée, alors même qu’elle pouvait le faire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00043",
                          "Jurisprudence : l’infraction n’est pas caractérisée si l’acte est réalisé au vu et au su ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00044",
                          "de la personne sans établir qu’elle s’y opposait ; la charge de la preuve ne pèse pas sur le prévenu ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00045",
                          "mais sur le ministère public ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00046",
                      "(Cass. crim., 28 mars 2023)",
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
                title: "Mineur",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00047",
                          "Dans le cas d’un mineur, le consentement doit émaner des titulaires de l’autorité parentale ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00048",
                          "dans le respect de ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00049",
                      "l’article 372-1 du Code civil",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00050",
                  "C) Fixation / enregistrement / transmission de l’image d’une personne en un lieu privé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00051",
                      "Toute personne a le droit d’interdire la reproduction, sans autorisation, de son image : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00052",
                      "elle constitue le prolongement de sa personnalité. Ce droit vaut que la personne soit anonyme ou publique.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00053",
                  "• La fixation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00054",
                  "Cela inclut le recours aux appareils photos ou caméras vidéo.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00055",
                  "• L’enregistrement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00056",
                  "L’image fixe ou animée est sauvegardée sur tout type de support (numérique ou technologies plus anciennes).",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00057",
                  "• La transmission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00058",
                  "Tout transfert du support de l’image illicite vers un ou des tiers avertis tombe sous le coup de cette incrimination.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00059",
                  "• De l’image d’une personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00060",
                      "Est exclue la photographie du lieu de vie d’une personne ou de biens, même prise sans consentement : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00061",
                      "c’est bien l’image de la personne qui est visée.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00062",
                  "• En un lieu privé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00063",
                      "Le champ de l’infraction est restreint : le lieu privé n’est pas ouvert à tous, sauf autorisation de celui ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00064",
                      "qui l’occupe de manière permanente ou temporaire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00065",
                      "Jurisprudence : le lieu privé est un endroit non ouvert à tous sauf autorisation ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00066",
                      "(Cass. crim., 28 novembre 2006)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00067",
                  "La notion de lieu privé s’apprécie au cas par cas (exemples admis) :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00068",
                  "Une chambre d’hôpital.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00069",
                  "Une prison.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00070",
                  "Un commissariat.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00071",
                  "• Sans le consentement de la personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00072",
                  "On retrouve les mêmes principes que pour les paroles, y compris lorsqu’il s’agit d’un mineur.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00073",
                      "Ne tombent pas sous le coup de cet article :\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00074",
                      "• procédé photo police/gendarmerie pour matérialité d’un excès de vitesse ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00075",
                      "(Cass. 2e civ., 29 juin 1988)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00076",
                      "• prise de photos dans le cadre de la signalisation anthropométrique à l’occasion d’une enquête judiciaire ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00077",
                      "(Cass. crim., 18 décembre 2003)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00078",
                  "D) Captation / enregistrement / transmission de la localisation (temps réel ou différé) sans consentement",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00079",
                  "• La captation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00080",
                      "Tout dispositif technique est envisageable : placement clandestin d’une balise sur une personne ou un véhicule, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00081",
                      "installation d’un logiciel espion sur un moyen de communication mobile, etc.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00082",
                  "• L’enregistrement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00083",
                  "Les données de localisation (positionnement, éventuellement horodatage) sont stockées sur tout support.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00084",
                  "• La transmission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00085",
                      "Les données sont mises à disposition d’un ou de plusieurs tiers avertis. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00086",
                      "Peu importe que cela s’opère en temps réel, en différé ou en un seul bloc.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00087",
                  "• Localisation temps réel ou différé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00088",
                  "Le niveau de précision importe peu : relais de communication ou GPS précis.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00089",
                  "• Sans le consentement de la personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00090",
                      "La personne n’a pas donné son accord à la localisation. La présomption de consentement prévue pour ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00091",
                      "les paroles et l’image ne s’applique pas à la localisation, car elle est très facilement clandestine.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Mineur",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00092",
                          "Le consentement doit émaner des titulaires de l’autorité parentale. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00093",
                          "Il suffit de l’opposition de l’un d’eux pour rendre la localisation illicite, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00094",
                          "dans le respect de ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00095",
                      "l’article 372-1 du Code civil",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00096",
                  "E) Conservation / divulgation / utilisation d’un document ou enregistrement obtenu par atteinte à la vie privée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00097",
                      "Il s’agit d’une infraction de conséquence : le « produit » des atteintes prévues par l’incrimination principale. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00098",
                      "Le terme « document » inclut tous supports, y compris ceux liés au suivi géographique.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00099",
                  "• La conservation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00100",
                      "Indépendamment de toute divulgation ou utilisation, le simple fait de garder à disposition le produit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00101",
                      "de l’atteinte est réprimé (prévention de publication, chantage ultérieur, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00102",
                  "• L’utilisation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00103",
                  "Elle peut avoir lieu en public ou non : par exemple l’usage d’enregistrements illicites dans une procédure de divorce.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00104",
                  "• La diffusion",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00105",
                      "Est punissable la divulgation au sens large : presse, radio, télévision (objectif grand public) ou simple ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00106",
                      "communication à un tiers jusqu’alors ignorant la nature de ce qui est dévoilé.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Presse",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00107",
                          "Quand l’infraction est commise par voie de presse écrite ou audiovisuelle, des règles particulières ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                          "f00108",
                          "s’appliquent pour la détermination des responsables, avec notamment une hiérarchie prévue par ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00109",
                      "l’article 42 de la loi du 29 juillet 1881",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00110",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00111",
                  "A) Conscience de se livrer à un acte illicite",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00112",
                      "L’auteur sait que les paroles ont vocation à demeurer dans un cercle restreint (voire à rester secrètes). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00113",
                      "Pour les images, il a connaissance de la nature privée du lieu où il procède à l’atteinte.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00114",
                  "B) Volonté de porter atteinte à la vie privée d’autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00115",
                      "L’auteur décide de ne pas respecter la vie privée de la victime, quelle que soit sa motivation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                      "f00116",
                      "(enrichissement, règlement de compte, volonté de nuire, etc.).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00117",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00118",
                    "Article 226-1 alinéa 7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00119",
                  "Lorsque les faits sont commis par le conjoint, le concubin, ou le partenaire lié par un PACS.",
                ),
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00120",
                    "Article 226-1 alinéa 8 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00121",
                  "Lorsque les faits sont commis au préjudice d’une personne dépositaire de l’autorité publique, chargée d’une mission de service public, titulaire d’un mandat électif public, candidate à un tel mandat ou d’un membre de sa famille.",
                ),
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00122",
                    "Article 226-2-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00123",
                  "Lorsque les faits portent sur des paroles ou des images présentant un caractère sexuel prises dans un lieu public ou privé.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
              "f00124",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00125",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00126",
                    "Atteinte simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00127",
                    "1 an d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00128",
                    "article 226-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00129",
                    "Conservation / diffusion / utilisation : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00130",
                    "1 an d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00131",
                    "article 226-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00132",
                    "Formes aggravées : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00133",
                    "2 ans d’emprisonnement et 60 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00134",
                    "article 226-1 al. 7 et al. 8 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00135",
                    " ; et ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00136",
                    "article 226-2-1 al. 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00137",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00138",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00139",
                    "l’article 226-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00140",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00141",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00142",
                    "article 226-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00143",
                    "Complicité : OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00144",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                    "f00145",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart",
                  "f00146",
                  "Elle suppose un fait constitutif de complicité prévu par la loi : aide et assistance, provocation ou instructions données.",
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
