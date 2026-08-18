import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AgressionArmeeCrapuleuxPage extends StatelessWidget {
  const AgressionArmeeCrapuleuxPage({super.key});

  static const String routeName =
      '/gpx/intervention/autres/agression-armee-crapuleux';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMro = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDont = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDo = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardPost = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
            "f00002",
            "Pratiques pro en intervention",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00003",
              "Intervention face à une agression armée\nà caractère crapuleux",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00004",
              "Réf. vS.01-2016",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : const Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut (le texte fourni ne donne pas d’article précis)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00005",
              "Cadre légal (à compléter)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                          "f00006",
                          "Ton document décrit une doctrine/méthode d’intervention mais ne mentionne pas d’articles précis (CP/CPP/CSI). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                          "f00007",
                          "Ajoute ici les articles/références internes que tu veux afficher : je les formaterai en rouge (ex. ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00008",
                      "Article 123 du Code de procédure pénale",
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

          // Introduction
          _ConditionCard(
            title: "Introduction",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00009",
                      "L’intervention des forces de police dans le contexte particulièrement dangereux d’une agression armée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00010",
                      "sur réquisition ou de manière inopinée, exige la mise en œuvre de précautions particulières.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00011",
                      "Comme pour toute intervention, le policier prépare et réalise son action selon la méthode de raisonnement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00012",
                      "opérationnel (MRO).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MRO
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00013",
              "Méthode de raisonnement opérationnel (MRO)",
            ),
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00014",
                  "Les 3 phases chronologiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00015",
                  "Analyse de la situation : « Que se passe-t-il ? »",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00016",
                  "Cadre juridique : « Quel est le cadre légal de l’intervention ? »",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00017",
                  "Tactique d’action : « Comment intervenir ? »",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectifs suite à levée de doute confirmée
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00018",
              "Objectifs après confirmation (levée de doute)",
            ),
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00019",
                      "La levée de doute ayant permis de confirmer une agression armée à caractère crapuleux en cours, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00020",
                      "les mesures prises visent à favoriser la prise de renseignements et à prendre les premières mesures de sécurité.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00021",
                  "Les renseignements servent principalement à :",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00022",
                  "Évaluer en temps réel, le plus précisément possible, la dangerosité du (des) auteur(s) et les risques pour les tiers.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00023",
                  "Favoriser une interpellation ultérieure du (des) mis en cause dans des conditions optimales de sécurité.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00024",
                  "Faciliter l’enquête judiciaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Ce qu'il ne faut pas faire
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00025",
              "Ce qu’il ne faut pas faire",
            ),
            cardColor: cardDont,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00026",
                  "Tenter de pénétrer dans l’établissement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00027",
                  "Chercher à bloquer le(s) agresseur(s) à l’intérieur, au risque de provoquer une prise d’otages ou un affrontement armé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00028",
                  "Provoquer l’interpellation du ou des auteur(s) à leur sortie afin d’éviter un affrontement armé sur la voie publique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00029",
                  "Faire obstacle au départ d’un véhicule dans lequel les auteurs prendraient place pour s’enfuir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00030",
                  "Faire usage des armes à feu sur un véhicule pour faire cesser la fuite, sauf cas de légitime défense.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Ce qu'il est préconisé de faire
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00031",
              "Ce qu’il est préconisé de faire",
            ),
            cardColor: cardDo,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00032",
                  "Solliciter du renfort.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00033",
                  "Solliciter la présence sur les lieux de l’OPJ territorialement compétent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00034",
                  "Dans la mesure du possible, interdire toute approche ou passage devant l’établissement depuis le poste d’observation.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00035",
                  "Alerte CIC immédiate en cas de fuite / sortie",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00036",
                  "Aviser instantanément le CIC afin de communiquer les premières informations relatives à :",
                ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00037",
                  "Leur nombre.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00038",
                  "Leur description physique.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00039",
                  "Leur tenue vestimentaire.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00040",
                  "La présence d’arme(s) (nombre, description générique : arme de poing, arme d’épaule, fusil, grenade, etc.).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00041",
                  "La présence supposée ou avérée d’otage(s).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00042",
                  "La direction de fuite.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00043",
                  "Le moyen de locomotion utilisé.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00044",
                  "Le cas échéant, changer ou multiplier les postes d’observation pour se soustraire à un risque ou favoriser la prise de renseignements.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Différer interpellation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00045",
              "Principe tactique — différer l’interpellation",
            ),
            cardColor: cardMro,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00046",
                      "Différer l’interpellation permet aux services d’investigation, assistés de groupes spécialisés, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00047",
                      "d’appréhender les auteurs dans de meilleures conditions de lieu et de temps, avec des risques évalués et contrôlés.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                          "f00048",
                          "Objectif : privilégier le renseignement, éviter l’affrontement immédiat et préparer une interpellation ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                          "f00049",
                          "dans un cadre maîtrisé.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention dans l’établissement (exceptionnel)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00050",
              "Intervention dans l’établissement (exceptionnel)",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00051",
                  "L’intervention des policiers dans l’établissement peut exceptionnellement être envisagée, notamment lorsque :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00052",
                  "Les circonstances liées à la protection des personnes l’exigent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00053",
                  "Les renseignements disponibles, l’équipement des policiers et leur nombre le permettent.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00054",
                      "Dans certaines circonstances et sur instructions de l’autorité désignée, des brigades spécialisées, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00055",
                      "entraînées et connaissant l’affaire en cours peuvent également intervenir.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Confrontation inopinée
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00056",
              "La confrontation inopinée",
            ),
            cardColor: cardDont,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00057",
                      "Les policiers peuvent être confrontés de manière inopinée à un ou plusieurs auteurs d’une agression armée en cours, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                      "f00058",
                      "ne permettant pas la mise en œuvre préalable de tous les principes de la levée de doute.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00059",
                  "Priorité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00060",
                  "Se soustraire à une possible confrontation armée.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00061",
                  "Dès que possible, les policiers chercheront à se poster afin d’appliquer le protocole d’intervention propre à ce type d’évènement.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dispositions post-événementielles
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
              "f00062",
              "Dispositions post-événementielles",
            ),
            cardColor: cardPost,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00063",
                  "Après le départ des auteurs, se rendre sur place et prendre les mesures suivantes :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00064",
                  "Sécuriser les lieux (s’assurer de l’absence d’autre(s) auteur(s) sur les lieux).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00065",
                  "Porter secours aux victimes et, le cas échéant, aviser les sapeurs-pompiers.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00066",
                  "Relever les identités des victimes et des témoins et les maintenir sur les lieux jusqu’à l’arrivée de l’OPJ.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00067",
                  "Préserver les traces et indices, notamment d’origine papillaire et/ou biologique (mouchoir, mégot, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart",
                  "f00068",
                  "Prendre les renseignements sur la commission des faits (coups de feu, nombre d’auteurs, mode opératoire précis, etc.).",
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
