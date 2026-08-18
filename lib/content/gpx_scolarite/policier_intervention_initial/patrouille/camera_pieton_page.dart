import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CameraPietonPage extends StatelessWidget {
  const CameraPietonPage({super.key});

  static const String routeName = '/gpx/intervention/patrouille/camera-pieton';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardUse = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardData = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProc = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Patrouille",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
              "f00002",
              "La caméra piéton",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
              "f00003",
              "Définition & finalités",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                        "f00004",
                        "Dans l’exercice des missions de prévention des atteintes à l’ordre public, de protection de la sécurité ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                        "f00005",
                        "des personnes et des biens, ainsi que dans les missions de police judiciaire, les agents de la police nationale ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                        "f00006",
                        "peuvent procéder, au moyen de caméras individuelles, à un enregistrement audiovisuel de leurs interventions (",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00007",
                    "article L. 241-1 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00008",
                  "Objectifs principaux",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00009",
                  "Prévenir les incidents au cours des interventions.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00010",
                  "Constater des infractions et collecter les preuves nécessaires à la poursuite de leurs auteurs.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00011",
                      "Les enregistrements peuvent aussi être utilisés à des fins de formation et de pédagogie (sous conditions, notamment d’anonymisation).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
              "f00012",
              "I — Base légale",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00013",
                    "Article L. 241-1 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00014",
                    " : autorise l’enregistrement audiovisuel des interventions via caméras individuelles, dans les missions prévues.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00015",
                    "Les données issues des caméras sont traitées dans un cadre réglementaire précisé notamment par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00016",
                    "les articles R. 241-2 à R. 241-5 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
              "f00017",
              "II — Modalités d’utilisation",
            ),
            cardColor: cardUse,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00018",
                  "A) Agents concernés",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00019",
                  "Dans la police nationale, peuvent porter une caméra piéton :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00020",
                  "Les personnels actifs (uniforme ou tenue civile*).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00021",
                  "Les policiers adjoints.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00022",
                  "Les réservistes.",
                ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00023",
                      "En tenue civile, l’agent doit porter des insignes extérieurs et apparents de sa qualité (ex : brassard).",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00024",
                  "B) Lieux concernés",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00025",
                      "Les personnels régulièrement équipés peuvent utiliser la caméra en tous lieux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00026",
                      "(publics ou privés, y compris domiciles et lieux assimilés).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00027",
                      "Dans un domicile, l’enregistrement doit se limiter au strict périmètre de l’intervention ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00028",
                      "et aux personnes concernées.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00029",
                  "Information des personnes filmées",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00030",
                      "Le déclenchement fait l’objet d’une information préalable des personnes filmées. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00031",
                      "Si les circonstances font obstacle à cette information préalable, elle est faite à l’issue de l’intervention ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00032",
                      "(sauf si l’obstacle persiste).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00033",
                      "Exemple d’obstacle : état d’ébriété empêchant la compréhension de l’information. Référence : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00034",
                      "Cass. crim., 2 mai 2024",
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
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00035",
                      "Le consentement des personnes filmées n’est pas requis. Une opposition ne fait pas obstacle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00036",
                      "à la poursuite de l’enregistrement. Les personnes bénéficient d’un droit d’accès pouvant être exercé via la CNIL.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00037",
                  "C) Conditions d’utilisation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00038",
                  "Seule une caméra en dotation administrative, portée de façon apparente, peut être utilisée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00039",
                  "La mise en service (mode pré-enregistrement) nécessite l’identification préalable de l’agent porteur (RIO ou carte agent selon le modèle).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00040",
                  "En cas d’incident ou de risque d’incident (circonstances / comportement), l’agent active le mode “enregistrement” puis le désactive en fin d’intervention.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00041",
                      "Les 30 secondes précédant le déclenchement sont sauvegardées (pré-enregistrement).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00042",
                  "Si la sécurité des agents (risque immédiat) ou la sécurité des biens/personnes est menacée, les images peuvent être transmises en temps réel au poste de commandement et aux personnels engagés.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
              "f00043",
              "III — Traitement des données",
            ),
            cardColor: cardData,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00044",
                  "A) Données et informations enregistrées",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00045",
                    "Les catégories de données enregistrées sont prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00046",
                    "l’article R. 241-2 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00047",
                  "Images et sons captés par la caméra.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00048",
                  "Jour et plages horaires d’enregistrement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00049",
                  "Identification de l’agent porteur de la caméra.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00050",
                  "Lieu de collecte des données.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00051",
                  "Identification de la caméra.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00052",
                  "Identification des personnels utilisateurs du logiciel d’exploitation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00053",
                  "Motif d’export du fichier vidéo, nom de l’agent et du service demandeurs, numéro de la procédure.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00054",
                  "B) Stockage & conservation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00055",
                    "Règles prévues notamment par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00056",
                    "les articles R. 241-3, R. 241-4 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00057",
                  "En fin de vacation, les données sont transférées sur un support informatique sécurisé et automatiquement effacées de la caméra.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00058",
                  "Hors procédure (judiciaire/administrative/disciplinaire), les données sont conservées pendant un mois.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
              "f00059",
              "IV — Consultation & destinataires",
            ),
            cardColor: cardProc,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00060",
                    "Les règles de consultation/accès sont prévues notamment par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                    "f00061",
                    "les articles R. 241-3, R. 241-3-1 et R. 241-5 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00062",
                  "Accès (gestionnaires)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00063",
                  "Les chefs de service et les agents qu’ils désignent peuvent accéder à tout ou partie des données.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00064",
                  "Ils peuvent extraire les données pour les besoins exclusifs d’une procédure judiciaire, administrative ou disciplinaire, ou pour une action de formation/pédagogie.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00065",
                  "Destinataires possibles (selon le cadre)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00066",
                  "Inspection générale de la police nationale (I.G.P.N.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00067",
                  "Autorité hiérarchique participant au pouvoir disciplinaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00068",
                  "Agents chargés de la formation des personnels.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00069",
                      "Les enregistrements utilisés à des fins pédagogiques et de formation sont anonymisés.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00070",
                  "Accès par l’agent après l’intervention",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00071",
                      "Dans le cadre d’une procédure judiciaire ou d’une intervention, les agents équipés peuvent accéder directement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00072",
                      "après l’intervention (après transfert sur support sécurisé) aux enregistrements auxquels ils ont procédé afin de faciliter :",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00073",
                  "La recherche d’auteurs d’infractions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00074",
                  "La prévention d’atteintes imminentes à l’ordre public.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00075",
                  "Le secours aux personnes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00076",
                  "L’établissement fidèle des faits lors des comptes rendus d’intervention.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                  "f00077",
                  "Traçabilité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00078",
                      "Toutes les opérations de collecte, modification, consultation, communication et effacement sont enregistrées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart",
                      "f00079",
                      "et conservées pendant trois ans.",
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
