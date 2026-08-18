import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AtteintesSecretCorrespondancesPage extends StatelessWidget {
  const AtteintesSecretCorrespondancesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite_particuliers/atteintes_secret_correspondances';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
            "f00002",
            "Abus d’autorité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00003",
              "Les atteintes au secret des correspondances",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00005",
                      "L’atteinte au secret des correspondances consiste, pour une personne dépositaire de l’autorité publique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00006",
                      "ou chargée d’une mission de service public, agissant dans l’exercice ou à l’occasion de l’exercice de ses ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00007",
                      "fonctions ou de sa mission, à ordonner, commettre ou faciliter, hors les cas prévus par la loi : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00008",
                      "le détournement, la suppression ou l’ouverture de correspondances, ou la révélation du contenu de correspondances.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00009",
                      "Elle vise aussi le fait, par ces personnes ou par un agent d’un exploitant de réseaux ouverts au public de ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00010",
                      "communications électroniques / d’un fournisseur de services de télécommunications, agissant dans l’exercice ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00011",
                      "de ses fonctions, d’ordonner, commettre ou faciliter, hors les cas prévus par la loi : l’interception ou le ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00012",
                      "détournement des correspondances émises, transmises ou reçues par télécommunications, l’utilisation ou la ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00013",
                      "divulgation de leur contenu.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00014",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00015",
                    "Article 432-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00016",
                    " : l’infraction est prévue et réprimée par ce texte.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00017",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00018",
                  "A) Un auteur déterminé",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00019",
                  "1) Dépositaire de l’autorité publique ou chargé d’une mission de service public",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00020",
                      "Est dépositaire de l’autorité publique celui qui dispose d’un pouvoir de décision fondé sur une parcelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00021",
                      "d’autorité publique conférée par ses fonctions (fonctionnaire, militaire, magistrat, officier public ou ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00022",
                      "ministériel, etc.). Sont notamment concernés : policiers, gendarmes, douaniers, huissiers de justice, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00023",
                      "commissaires-priseurs, fonctionnaires des eaux et forêts. Certains exécutifs locaux et élus peuvent aussi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00024",
                      "avoir cette qualité selon leurs attributions.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00025",
                      "Est chargé d’une mission de service public celui qui accomplit, à titre temporaire ou permanent, volontairement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00026",
                      "ou sur réquisition, un service public quelconque, en participant à une mission d’intérêt général sans pouvoir ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00027",
                      "de décision/commandement. Les élus sans prérogatives de puissance publique par délégation peuvent relever ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00028",
                      "de cette catégorie.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00029",
                  "2) Agissant dans l’exercice ou à l’occasion des fonctions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00030",
                      "L’acte accompli dans l’exercice des fonctions suppose que, dans le cadre de ses attributions professionnelles, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00031",
                      "le dépositaire/chargé de mission abuse de son autorité ou détourne le pouvoir qui lui est conféré.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00032",
                      "On parle d’acte commis à l’occasion de l’exercice des fonctions lorsque l’auteur agit en dehors de sa compétence ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00033",
                      "d’attribution. En revanche, n’entre pas dans le champ de l’infraction le fonctionnaire qui agit en dehors de sa ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00034",
                      "mission ou de ses fonctions.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00035",
                  "3) Agents des opérateurs de communications électroniques / télécoms",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                        "f00036",
                        "Un réseau ouvert au public est tout réseau établi ou utilisé pour la fourniture au public de services de communications électroniques ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                        "f00037",
                        "ou de communication au public par voie électronique, au sens de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00038",
                    "l’article L. 32 (4°) du Code des postes et des communications électroniques",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00039",
                      "Les communications électroniques sont les émissions, transmissions ou réceptions de signes, signaux, écrits, images ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00040",
                      "ou sons par câble, voie hertzienne, moyen optique ou autres moyens électromagnétiques.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00041",
                      "Peut être auteur toute personne travaillant pour un exploitant (personne physique ou morale) d’un réseau ouvert au public, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00042",
                      "salariée ou non, relevant de son autorité. Idem pour un agent d’un fournisseur de services de télécommunications, quel que soit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00043",
                      "son statut et sa place dans l’entreprise.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00044",
                  "B) Des correspondances",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00045",
                  "1) Correspondances matérielles",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00046",
                      "Sont visées toutes les correspondances protégées : plis clos ou ouverts, imprimés, journaux, paquets, etc. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00047",
                      "Le contenu importe peu : correspondance professionnelle ou privée.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00048",
                  "2) Correspondances par télécommunications",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00049",
                      "Il s’agit de correspondances dématérialisées (téléphone, courrier informatique). Elles doivent être en cours de transmission ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00050",
                      "ou parvenues à destination mais non encore appréhendées par le destinataire.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00051",
                  "C) Un acte matériel d’atteinte",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00052",
                  "1) Les modalités : ordonner / commettre / faciliter",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00053",
                  "Ordonner : l’ordre émane d’une personne dépositaire de l’autorité publique (abus de pouvoir).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00054",
                  "Commettre : l’auteur réalise lui-même l’acte répréhensible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00055",
                  "Faciliter : l’auteur aide, donne des indications ou des instructions permettant la commission.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00056",
                  "2) Le contenu de l’atteinte (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00057",
                  "Atteinte à l’acheminement : détournement d’une correspondance, modification du cours de transmission.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00058",
                  "Atteinte à l’inviolabilité du support : ouverture d’une correspondance.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00059",
                  "Suppression : tout acte empêchant la correspondance de parvenir à destination.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00060",
                  "Révélation du contenu : divulgation à un tiers sans qualité.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00061",
                  "Jurisprudences (illustrations)",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00062",
                      "Un préposé des P.T.T. ouvre une lettre adressée à son épouse alors qu’il est en instance de divorce : atteinte constituée. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00063",
                      "(C.A. Limoges, 20 décembre 1995)",
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
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00064",
                      "Soustraction de lettres par des employés d’un centre de tri postal pour en dérober le contenu : suppression au sens du texte. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00065",
                      "(C.A. Paris, 16 septembre 2005)",
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
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00066",
                      "Surveillance visant à connaître le contenu des mails d’un étudiant avec lecture et divulgation : violation du secret par divulgation. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00067",
                      "(C.A. Paris, 17 décembre 2001)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00068",
                  "3) Spécificités télécom : interception / détournement / usage / divulgation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00069",
                      "Pour les correspondances émises, transmises ou reçues par voie de télécommunications, l’atteinte peut notamment consister en : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00070",
                      "un détournement (manipulation informatique), une interception (captation pendant la transmission), une divulgation (révéler à un tiers), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00071",
                      "ou une utilisation (se servir du contenu comme si l’agent en était destinataire).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00072",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00073",
                  "Volonté d’attenter au secret des correspondances",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00074",
                      "L’auteur a conscience d’agir sans droit : il sait que la correspondance ne lui est pas destinée et qu’il n’a aucun droit sur elle. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00075",
                      "L’intention de nuire n’est pas exigée, mais l’intention de porter atteinte au contenu des correspondances doit être caractérisée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                          "f00076",
                          "En matière d’atteinte au secret des correspondances par un fonctionnaire public, l’élément intentionnel nécessite que le fonctionnaire ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                          "f00077",
                          "ait eu l’intention de porter atteinte au contenu des correspondances litigieuses. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00078",
                      "(Cass. crim., 27 février 2018)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00079",
                  "Erreur de fait (effet)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00080",
                      "L’erreur de fait peut faire disparaître l’intention : ouvrir par méprise une correspondance non destinée (ex. pour rechercher l’adresse du destinataire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00081",
                      "afin de la réexpédier) peut exclure la punissabilité. Pour les correspondances dématérialisées, l’erreur n’a vocation à s’appliquer que lorsqu’il est ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00082",
                      "possible de recevoir sans prendre connaissance du contenu (ex. e-mail consulté plus tard).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00083",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00084",
                  "Aucune circonstance aggravante n’est prévue par le texte.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + faits justificatifs
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
              "f00085",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00086",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00087",
                    "Délit — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00088",
                    "3 ans d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00089",
                    "article 432-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00090",
                    " (alinéas 1 et 2).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00091",
                  "Personnes morales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00092",
                  "Les personnes morales peuvent être reconnues responsables pénalement (selon les règles générales).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00093",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00094",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00095",
                    "Complicité : OUI, selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00096",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                        "f00097",
                        " : aide/assistance, provocation (ex. ordonner d’ouvrir une lettre destinée à un tiers), ou instructions ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                        "f00098",
                        "(ex. expliquer comment récupérer le courrier électronique d’un tiers).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00099",
                  "Un particulier peut être complice d’un dépositaire de l’autorité publique en fournissant, par exemple, les moyens matériels.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00100",
                  "Faits justificatifs (cas prévus par la loi)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00101",
                    "Article 432-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                    "f00102",
                    " : l’infraction est exclue lorsque l’atteinte est réalisée dans les cas prévus par la loi (notamment procédures judiciaires).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00103",
                  "Procédures judiciaires (exemples)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                          "f00104",
                          "L’interception, l’enregistrement et la transcription de correspondances émises par communications électroniques peuvent être autorisés ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                          "f00105",
                          "par le juge d’instruction en matière criminelle et pour les délits punis d’au moins 3 ans d’emprisonnement, selon les ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00106",
                      "articles 100 à 100-8 du Code de procédure pénale",
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
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                          "f00107",
                          "En enquête de flagrance ou préliminaire (infractions relevant des régimes spéciaux), l’autorisation peut relever du juge des libertés et de la détention ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                          "f00108",
                          "sur requête du procureur, selon ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00109",
                      "l’article 706-95 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                      "f00110",
                      " et les textes de renvoi.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart",
                  "f00111",
                  "D’autres exemptions existent en matière administrative, notamment pour certaines réquisitions liées à la lutte contre le terrorisme (données techniques de connexion et de trafic).",
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
