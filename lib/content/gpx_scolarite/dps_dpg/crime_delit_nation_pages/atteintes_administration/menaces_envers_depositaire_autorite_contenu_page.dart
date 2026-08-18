import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class MenacesEnversDepositaireAutoritePage extends StatelessWidget {
  const MenacesEnversDepositaireAutoritePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
            "f00002",
            "Atteintes à l’administration",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
              "f00003",
              "Les menaces de crime ou délit envers une personne dépositaire de l’autorité publique, chargée d’une mission de service public, ou assimilée",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (pédagogique + synthétique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00005",
                      "L’infraction consiste à proférer la menace de commettre un crime ou un délit contre les personnes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00006",
                      "ou les biens, à l’encontre d’une victime spécialement protégée (D.A.P., agent de service public, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00007",
                      "professionnel de santé, enseignant, agent de transport, agent de sécurité privée, etc.), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00008",
                      "dans les conditions prévues par la loi (qualité apparente ou connue, lien avec les fonctions).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00010",
                    "Article 433-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00011",
                    " : définit et réprime les menaces visant certaines personnes en raison de leurs fonctions.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                          "f00012",
                          "À noter : des menaces adressées à certaines personnes dans le but d’entraver l’action de la justice ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                          "f00013",
                          "peuvent relever d’incriminations spécifiques (",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00014",
                      "articles 434-5, 434-8 et 434-15 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
              "f00015",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00016",
                  "A) Une menace de commettre un crime ou un délit",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00017",
                      "La menace doit annoncer la commission prochaine d’un crime ou d’un délit contre les personnes ou les biens. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00018",
                      "Si la menace vise un bien, elle peut consister en l’annonce d’un mal susceptible d’être qualifié de destruction, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00019",
                      "dégradation ou détérioration.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00020",
                  "La menace est punissable même si elle n’a pas été réitérée ni matérialisée.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00021",
                  "B) Un destinataire déterminé par la loi",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00022",
                  "La loi énumère limitativement les victimes protégées. On peut les regrouper en 4 grands blocs :",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00023",
                  "1) Mandat électif / dépositaire de l’autorité publique / assimilés",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00024",
                      "Sont notamment visés : personnes investies d’un mandat électif public, magistrats, jurés, avocats, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00025",
                      "officiers publics ou ministériels, militaires de la gendarmerie nationale, fonctionnaires de la police nationale, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00026",
                      "douanes, inspection du travail, administration pénitentiaire, ainsi que toute autre personne dépositaire de l’autorité publique.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00027",
                    "Article 433-3 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00028",
                    " : liste des personnes concernées (alinéa principal).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00029",
                  "2) Mission de service public (enseignants, santé, transport…)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00030",
                      "Sont concernés notamment : agent d’un exploitant de réseau de transport public de voyageurs, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00031",
                      "enseignant et personnels des établissements scolaires, ainsi que les professionnels de santé, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00032",
                      "lorsque la qualité est apparente ou connue.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00033",
                    "Article 433-3 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00034",
                    " : extension à certaines professions de service public/santé.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00035",
                  "3) Activités privées de sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00036",
                      "Sont visées les personnes exerçant une activité privée de sécurité (surveillance/gardiennage, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00037",
                      "protection de l’intégrité physique, transport de fonds/objets de valeur, sécurité dans les transports, etc.).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00038",
                    "Articles L.611-1 et L.621-1 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00039",
                    " : domaines concernés (renvoi légal).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00040",
                    "Article 433-3 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00041",
                    " : protection pénale pour ces activités.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00042",
                  "4) Proches de la victime protégée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00043",
                      "Sont également protégés : le conjoint, les ascendants, les descendants en ligne directe, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00044",
                      "ou toute personne vivant habituellement au domicile, lorsque les menaces sont proférées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00045",
                      "en raison des fonctions exercées par la personne protégée.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00046",
                    "Article 433-3 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00047",
                    " : extension aux proches en raison des fonctions.",
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00048",
                  "C) Une menace motivée par les fonctions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00049",
                      "Le lien avec les fonctions est indispensable :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00050",
                      "• pour les personnes de l’alinéa 1 : menace dans l’exercice ou du fait de l’exercice des fonctions ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00051",
                      "• pour les personnes des alinéas 2 et 3 : menace dans l’exercice des fonctions ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00052",
                      "• pour les proches (alinéa 4) : menace en raison des fonctions exercées par la personne protégée.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00053",
                  "D) Qualité de la victime apparente ou connue",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00054",
                  "La qualité de la victime doit être apparente ou connue de l’auteur, qui agit en raison de cette qualité.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
              "f00055",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00056",
                      "L’auteur doit vouloir porter atteinte (ou intimider) la victime — ou ses proches — en raison des fonctions protégées. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00057",
                      "Il a conscience du trouble créé par les menaces dans l’esprit de la victime.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00058",
                  "Peu importe que l’auteur ait eu l’intention de mettre sa menace à exécution ou qu’il en ait eu les moyens.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
              "f00059",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00060",
                    "Article 433-3 alinéa 5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00061",
                    " : lorsque la menace est une menace de mort ou une menace d’atteinte aux biens dangereuse pour les personnes.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00062",
                    "Article 433-3 alinéa 6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                        "f00063",
                        " : lorsqu’il est fait usage de menaces/violences/actes d’intimidation pour obtenir que la personne accomplisse ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                        "f00064",
                        "ou s’abstienne d’accomplir un acte de sa fonction/mission/mandat (ou facilité par celle-ci), ou pour la faire abuser ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                        "f00065",
                        "de son autorité (vraie ou supposée) afin d’obtenir d’une autorité/administration des distinctions, emplois, marchés ou ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                        "f00066",
                        "toute décision favorable.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00067",
                      "Ces dispositions ne s’appliquent pas aux menaces/violences/actes d’intimidation prévus par ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                      "f00068",
                      "l’article 433-3-1 du Code pénal",
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

          // Répression
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
              "f00069",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00070",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00071",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00072",
                    "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00073",
                    "article 433-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00074",
                    "Aggravée (mort / biens dangereux) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00075",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00076",
                    "article 433-3 alinéa 5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00077",
                    "Aggravée (intimidation pour obtenir un acte) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00078",
                    "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00079",
                    "article 433-3 alinéa 6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00080",
                  "Personnes morales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00081",
                  "Les personnes morales peuvent être reconnues pénalement responsables (conditions du droit commun).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00082",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                  "f00083",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00084",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00085",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00086",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart",
                    "f00087",
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
