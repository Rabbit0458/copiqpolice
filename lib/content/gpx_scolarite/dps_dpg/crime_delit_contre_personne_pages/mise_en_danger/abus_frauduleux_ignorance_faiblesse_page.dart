import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AbusFrauduleuxIgnoranceFaiblessePage extends StatelessWidget {
  const AbusFrauduleuxIgnoranceFaiblessePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
            "f00002",
            "Mise en danger",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00003",
              "L’abus frauduleux de l’état d’ignorance ou de faiblesse",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00005",
                      "L’abus frauduleux de l’état d’ignorance ou de la situation de faiblesse, soit d’un mineur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00006",
                      "soit d’une personne dont la particulière vulnérabilité (âge, maladie, infirmité, déficience ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00007",
                      "physique ou psychique, grossesse) est apparente ou connue de l’auteur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00008",
                      "pour conduire cette personne à un acte ou une abstention gravement préjudiciables, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00010",
                    "Article 223-15-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00011",
                    " : prévoit et réprime l’abus frauduleux de l’état d’ignorance ou de la situation de faiblesse.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00013",
                  "A) Un acte d’abus frauduleux",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00014",
                      "L’abus n’est pas défini par la loi. Il peut consister en des manœuvres grossières, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00015",
                      "un simple mensonge, voire des pressions suscitant la crainte de la victime.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00016",
                      "Jurisprudence : obtenir d’une personne « fragile » un prêt immobilier impossible à rembourser ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00017",
                      "(Cass. crim., 05 octobre 2004)",
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

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00018",
                      "L’abus frauduleux correspond à l’exploitation excessive de l’état de la victime pour l’amener ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00019",
                      "à un acte ou une abstention qu’elle n’aurait pas acceptés si elle avait été éclairée ou en état de résister.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00020",
                    "Le texte exige que l’abus « conduise » la personne à un acte/une abstention : cela ne signifie pas contraindre. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00021",
                    "(Cass. crim., 16 octobre 2007)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00022",
                  "B) Basé sur l’état d’ignorance ou de faiblesse",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00023",
                      "L’acte d’abus doit être fondé sur l’état d’ignorance ou de faiblesse de la victime.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00024",
                      "• L’ignorance : manque de connaissances adéquates (ex. tromper une personne sans compétence technique).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00025",
                      "• La faiblesse : vulnérabilité empêchant une résistance normale aux sollicitations.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00026",
                    "Cass. crim., 26 mai 2009",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00027",
                    " : l’abus de faiblesse s’apprécie au regard de la vulnérabilité au moment de l’acte gravement préjudiciable.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00028",
                      "Le consentement doit être libre et éclairé au moment où l’acte est passé. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00029",
                      "Peu importe un consentement ancien : si la vulnérabilité apparaît ensuite, il faut vérifier le consentement effectif au moment de l’acte.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00030",
                  "C) Une victime particulière",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00031",
                    "Sans faire disparaître tout libre arbitre, la particulière vulnérabilité empêche la personne d’agir de son plein gré. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00032",
                    "(Cass. crim., 16 octobre 2007)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00033",
                      "La protection pénale vise une liste limitative :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00034",
                      "• Les mineurs\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00035",
                      "• Les personnes d’une particulière vulnérabilité (âge, maladie, infirmité, déficience physique/psychique, grossesse), apparente ou connue.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00036",
                      "Jurisprudence : personne de 89 ans, surdité importante, ayant souscrit un nouveau contrat en l’absence de l’aidant habituel ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00037",
                      "(Cass. crim., 17 janvier 2001)",
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
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00038",
                      "Jurisprudence : un voyant recevant une forte somme d’argent d’une personne dépressive ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00039",
                      "(C.A. Nîmes, 15 novembre 2002)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00040",
                  "D) Un préjudice gravement préjudiciable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00041",
                      "La victime doit avoir été poussée à un acte ou une abstention gravement préjudiciables. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00042",
                      "Le préjudice peut concerner le patrimoine, la santé, l’activité professionnelle, mais aussi la vie familiale et affective.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00043",
                      "Jurisprudence : des prélèvements successifs vident le patrimoine de la victime ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00044",
                      "(Cass. crim., 27 mai 2004)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00045",
                  "La jurisprudence n’exige pas que l’acte préjudiciable soit déjà réalisé : il peut être seulement potentiel.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00046",
                      "Jurisprudence : femme de 83 ans, Alzheimer, placée sous sauvegarde de justice, disposant de ses biens par testament au profit de l’auteur ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00047",
                      "(Cass. crim., 21 octobre 2008)",
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
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00048",
                      "Jurisprudence : vente en viager de deux immeubles à un prix anormalement bas (isolement + affaiblissement intellectuel) ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00049",
                      "(Cass. crim., 13 janvier 2016)",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00050",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00051",
                  "A) Connaissance de la minorité / vulnérabilité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00052",
                      "L’auteur doit connaître la minorité de la victime. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00053",
                      "La particulière vulnérabilité doit être « apparente ou connue ». ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00054",
                      "La Cour de cassation exige que cette connaissance soit démontrée.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00055",
                    "Cass. crim., 27 mai 2004",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00056",
                    " : la connaissance doit être caractérisée.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00057",
                  "B) Conscience de pousser à un acte/abstention gravement préjudiciable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00058",
                      "L’auteur doit savoir que l’intérêt de la victime est de refuser la proposition, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                      "f00059",
                      "et qu’il la conduit pourtant à accepter un acte ou une abstention gravement préjudiciables.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00060",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00061",
                    "Article 223-15-2 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00062",
                  "Lorsque l’infraction est commise par l’utilisation d’un service de communication au public en ligne ou via un support numérique/électronique.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00063",
                    "Article 223-15-2 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00064",
                  "Lorsque l’infraction est commise en bande organisée.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
              "f00065",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00066",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00067",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00068",
                    "3 ans d’emprisonnement et 375 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00069",
                    "article 223-15-2 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00070",
                    "Aggravée (en ligne/numérique) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00071",
                    "5 ans d’emprisonnement et 750 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00072",
                    "article 223-15-2 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00073",
                    "Aggravée (bande organisée) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00074",
                    "7 ans d’emprisonnement et 1 000 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00075",
                    "article 223-15-2 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00076",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00077",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00078",
                    "l’article 223-15-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00079",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                  "f00080",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00081",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00082",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart",
                    "f00083",
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
