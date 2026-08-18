import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PriseServiceGardeAVuePage extends StatelessWidget {
  const PriseServiceGardeAVuePage({super.key});

  static const String routeName = '/gpx/intervention/prise-service/garde-a-vue';

  // Couleur des articles de loi (CPP / CP / CSI / etc.)
  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
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
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
            "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
            "f00002",
            "Prise de service",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00003",
              "Gestion humaine et matérielle de la garde à vue",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (références présentes dans ton texte)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00004",
              "Références (élément légal)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00005",
                    "Devoir de protection et de dignité — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00006",
                    "article R. 434-17 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00007",
                    " : le policier doit préserver la vie, la santé et la dignité de la personne appréhendée.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00008",
                    "Objets nécessaires pendant l’audition — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00009",
                    "article 63-6 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00010",
                    " : possibilité pour le gardé à vue de disposer d’effets indispensables au respect de sa dignité (lunettes, appareil auditif, etc.), avec retrait à l’issue de chaque acte.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00011",
                    "Vidéosurveillance des locaux de GAV — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00012",
                    "articles L. 256-1 à L. 256-5 du Code de la sécurité intérieure",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00013",
                    " : encadrement du dispositif (motivation, durée, notification, droits, conservation).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "RAPPEL",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00014",
                      "La garde à vue doit s’exécuter dans des conditions assurant le respect de la dignité de la personne.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Contexte",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00015",
                      "Les gardiens de la paix, assistés des policiers adjoints, ont la charge :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00016",
                      "• de la surveillance et de la sûreté des personnes gardées à vue ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00017",
                      "• de l’alimentation, du repos et de l’hygiène.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00018",
                      "L’objectif permanent est double : sécurité + dignité.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00019",
              "I — Responsables du déroulement de la mesure",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00020",
                      "La surveillance de la garde à vue répond au principe d’une double responsabilité :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00021",
                      "• l’O.P.J. (responsabilité juridique) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00022",
                      "• l’officier ou le gradé de garde à vue (suivi administratif et conditions matérielles).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00023",
                  "A) L’O.P.J. (décideur de la mesure)",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00024",
                  "Responsable de l’accomplissement juridique de la mesure.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00025",
                  "Renseigne le registre spécial de garde à vue prévu par le CPP.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00026",
                  "Rédige un billet/ordre à l’attention du gradé ou de l’officier de GAV : identité, motif, cadre d’enquête, consignes particulières (agressivité, risque suicidaire, intentions d’évasion…).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00027",
                  "B) Officier / gradé de garde à vue",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00028",
                  "Assure le suivi administratif de l’ensemble des gardés à vue, en liaison avec les O.P.J.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00029",
                  "Contrôle au quotidien les conditions matérielles : sécurité et dignité.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00030",
              "II — Prise en charge des personnes gardées à vue",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00031",
                    "Le policier chargé de la garde doit être attentif à l’état physique et psychologique de la personne et prendre toutes mesures possibles pour préserver sa vie, sa santé et sa dignité — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00032",
                    "art. R. 434-17 CSI",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00033",
                  "A) Règles administratives",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00034",
                  "1) Le billet d’ordre",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00035",
                      "Document remis par l’O.P.J. Il doit être conservé et rester à disposition des policiers ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00036",
                      "chargés de la surveillance.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00037",
                  "2) Registre des personnes gardées à vue",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00038",
                      "Le registre doit être renseigné avec rigueur. Il mentionne notamment :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00039",
                      "• les informations figurant sur l’ordre de GAV ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00040",
                      "• l’éventuelle fouille de sécurité (avec déshabillage non intégral) et ses raisons ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00041",
                      "• les objets provisoirement soustraits ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00042",
                      "• l’ensemble des événements survenus et leurs horaires (extraction ou non) : visite avocat/médecin, sortie audition/perquisition, repas, etc.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00043",
              "B — Conditions matérielles",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00044",
                  "1) Alimentation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00045",
                      "Sauf exceptions circonstancielles, les gardés à vue doivent recevoir des repas chauds aux heures habituelles. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00046",
                      "Les menus sont définis selon les principes religieux dont ils font état.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00047",
                  "2) Hygiène & repos",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00048",
                      "Les cellules doivent être maintenues dans un bon état de propreté et disposer des éléments d’hygiène nécessaires. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00049",
                      "Les services doivent veiller à la disponibilité de locaux permettant le repos auquel les personnes gardées à vue peuvent prétendre.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00050",
                  "3) Effets personnels durant l’audition",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00051",
                    "Le gardé à vue peut disposer, au cours de son audition, d’objets nécessaires au respect de sa dignité — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00052",
                    "art. 63-6 CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00053",
                      "Objectif : s’assurer que l’intéressé entend, comprend et signe en parfaite connaissance de cause les PV.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00054",
                      "À l’issue de chaque acte, ces objets (lunettes, appareil auditif, etc.) sont retirés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00055",
                      "Une vigilance particulière est nécessaire lors des retraits/restitutions successifs.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00056",
              "C — Mesures de sécurité",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00057",
                      "Les mesures de sécurité visent à s’assurer qu’une personne gardée à vue ne détient aucun objet dangereux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00058",
                      "pour elle-même ou pour autrui.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "INTERDIT",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00059",
                      "En aucun cas, ces mesures ne peuvent consister en une fouille intégrale.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00060",
                  "Mesures possibles (strictement nécessaires)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00061",
                  "Palpation de sécurité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00062",
                  "Retrait d’objets/effets pouvant constituer un danger (ex : lacets, ceinture, écharpe).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00063",
                  "Fouille de sécurité.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00064",
              "D — Surveillance",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00065",
                  "Les policiers doivent veiller à empêcher toute évasion. Les risques sont particulièrement présents :",
                ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00066",
                  "Lors des entrées/sorties (cellule, chambre de sûreté, toilettes…).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00067",
                  "Lors de la pose ou du retrait des menottes (vérifier le menottage).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00068",
                  "Lors des déplacements (issues, portes, cour, cage d’escalier, hall).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00069",
                  "À chaque prise en charge.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00070",
                  "1) Surveillance dans les cellules — généralités",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00071",
                      "Les locaux de GAV permettent une surveillance directe. Une vigilance accrue est nécessaire pour les personnes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00072",
                      "en mauvaise santé ou très émotives : tout signe inquiétant doit être signalé.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00073",
                      "En cas de malaise/crise d’épilepsie : appel immédiat aux sapeurs-pompiers ou au SAMU.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00074",
                      "Aucune initiative ne doit être prise seul : la simulation peut viser une évasion.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00075",
                      "Mineurs : détention dans un local différent de celui des adultes. Tout incident doit être signalé (chef de poste, gradé/officier de GAV, O.P.J. ordonnateur).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00076",
                  "Dégradations / dangers",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00077",
                      "Les dégradations dangereuses doivent être signalées afin de mettre en œuvre les mesures nécessaires ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00078",
                      "(travaux, condamnation temporaire de cellule, etc.).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00079",
              "Placement sous vidéosurveillance",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00080",
                    "La vidéosurveillance des locaux de GAV complète la surveillance humaine, sans s’y substituer — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                    "f00081",
                    "art. L. 256-1 à L. 256-5 CSI",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00082",
                  "Principes techniques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00083",
                  "Contrôle en temps réel + enregistrement des séquences vidéo (sans le son).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00084",
                  "Le simple renvoi d’images sans enregistrement est proscrit.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00085",
                  "Dispositif limité aux gardes à vue et retenues douanières.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00086",
                  "Décision & motif",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00087",
                      "Décidé par le chef de service responsable de la sécurité des lieux (ou son représentant), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00088",
                      "en lien avec l’O.P.J. en charge de la procédure, et motivé par des raisons sérieuses ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00089",
                      "de penser que la personne pourrait :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00090",
                      "• attenter à sa vie ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00091",
                      "• agresser autrui ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00092",
                      "• s’évader.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00093",
                  "Durée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00094",
                      "Limitée au temps strictement nécessaire au regard du comportement. Elle cesse dès que les conditions ne sont plus réunies.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00095",
                      "Durée maximale : 24 heures, renouvelable par périodes de 24 heures jusqu’à la fin de la garde à vue.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00096",
                  "Notification & information",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00097",
                      "La décision doit être notifiée à la personne concernée (chef de service ou représentant). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00098",
                      "À défaut, notification par l’O.P.J., l’A.P.J. ou, sous leur contrôle, par l’assistant d’enquête.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00099",
                  "Droit de demander à tout moment à l’autorité judiciaire compétente qu’il soit mis fin à la mesure.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00100",
                  "Droit de demander la conservation des enregistrements + information sur la durée de conservation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00101",
                  "Droits « informatique et libertés » : accès, rectification, effacement, limitation (sauf droit d’opposition).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00102",
                  "Avis & diligences",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00103",
                      "L’autorité judiciaire est informée sans délai. Les représentants légaux du mineur, tuteur/curateur du majeur protégé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00104",
                      "et l’avocat sont informés sans délai (sauf report autorisé par magistrat).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "ADMINISTRATIF",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                          "f00105",
                          "Le placement sous vidéosurveillance est une mesure administrative décorrélée de la procédure judiciaire : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                          "f00106",
                          "pas de PV à intégrer à la procédure. Les diligences sont consignées dans un formulaire administratif spécifique.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00107",
              "Surveillance pendant les déplacements",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00108",
                      "Les gardiens de la paix, assistés des policiers adjoints, peuvent être chargés de la conduite sous surveillance ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00109",
                      "des gardés à vue dans le service. Une palpation de sécurité est préconisée entre chaque mouvement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                      "f00110",
                      "(audition, entretien, examen médical, etc.).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00111",
                  "Précautions essentielles",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00112",
                  "Si menottage nécessaire : menotter dans le dos (maintien de la chaînette côté main gauche pour un droitier, ou inversement).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00113",
                  "Faire marcher l’interpellé du côté opposé aux fenêtres.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00114",
                  "Éviter les points hauts dominant un vide.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00115",
                  "Dans les escaliers : progresser côté mur, pas côté rampe.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00116",
                  "Éviter, si possible, les couloirs avec témoins/complices/famille/public.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00117",
                  "Ne pas laisser l’interpellé près d’objets/meubles utilisables contre lui-même/autrui.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00118",
                  "Ne jamais baisser la vigilance face à une attitude paisible ou des propos rassurants.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00119",
              "Surveillance dans les bureaux",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00120",
                  "Positionner l’interpellé loin des ouvertures (portes/fenêtres) et veiller à ce qu’elles restent fermées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00121",
                  "Lors des auditions : ne jamais garder l’arme administrative à la ceinture, ni la placer ostensiblement dans un tiroir/placard non fermé à clé. La ranger non approvisionnée dans un lieu sûr, fermé à clé, hors de la vue de l’interpellé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00122",
                  "Écarter tout objet pouvant être projeté, utilisé comme arme ou avalé (presse-papiers, cadres, bouteilles, coupe-papier, ciseaux, épingles, trombones…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00123",
                  "Neutraliser un individu dangereux (menottes) ou assurer une surveillance rapprochée avec un fonctionnaire prêt à intervenir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00124",
                  "Ne jamais laisser un interpellé seul dans un bureau, même brièvement : se faire remplacer avant de sortir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00125",
                  "Toilettes : accompagnement par un policier du même sexe. La porte des W-C reste entrouverte et surveillée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00126",
                  "Éviter tout contact, même visuel, avec témoins/coauteurs/complices (y compris dans la répartition en cellules en cas de GAV multiples).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
              "f00127",
              "III — Visites des locaux de garde à vue",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00128",
                  "Certaines autorités/personnalités peuvent visiter les locaux de garde à vue :",
                ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00129",
                  "Procureur de la République : obligation d’une visite annuelle + visites possibles à tout moment.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00130",
                  "Parlementaires : visites inopinées, de jour comme de nuit (sans contact avec les gardés à vue).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00131",
                  "Comité européen de prévention de la torture (CPT) : visites + possibilité d’entretiens avec les gardés à vue.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00132",
                  "Contrôleur général des lieux de privation de liberté : visites à tout moment.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart",
                  "f00133",
                  "Bâtonniers (ou délégué désigné) : autorisés à visiter à tout moment les locaux de garde à vue.",
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
