import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ConduitePosteCeeaPositifOuRefusPage extends StatelessWidget {
  const ConduitePosteCeeaPositifOuRefusPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardProc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNota = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Alcool",
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
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00002",
              "PV — Conduite au poste (C.E.E.A. positif, refus, ou sans dépistage)",
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
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00003",
              "Objectif du canevas",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00004",
                      "Ce canevas t’aide à rédiger un procès-verbal clair et complet lorsque tu conduis au poste ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00005",
                      "un conducteur suite à un dépistage de l’imprégnation alcoolique positif (C.E.E.A.), un refus de dépistage, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00006",
                      "ou lorsque tu procèdes directement aux vérifications sans dépistage préalable.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00007",
                  "Rédaction pédagogique, chronologique et précise.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00008",
                  "Style indirect pour l’état civil (hors éléments de personnalité).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00009",
                  "Mentionner les infos utiles + les garanties procédurales.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (articles en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00010",
              "Base légale — à rappeler dès le début",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                    "f00011",
                    "Rétention du conducteur : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                    "f00012",
                    "article L. 234-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                    "f00013",
                    " — le conducteur peut être retenu le temps strictement nécessaire au dépistage et aux vérifications.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00014",
                  "Point important",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                          "f00015",
                          "Le refus de subir le dépistage n’est pas, en lui-même, une infraction pénale ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                          "f00016",
                          "il entraîne l’obligation de se soumettre aux vérifications. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                          "f00017",
                          "Si la personne refuse ensuite les vérifications, elle commet un délit de refus de se soumettre ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00018",
                      "(Cass. crim., 07/03/2007)",
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
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                          "f00019",
                          "Le dépistage n’est pas obligatoire lorsque l’infraction est punie par le Code de la route ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                          "f00020",
                          "d’une peine complémentaire de suspension du permis : on peut procéder directement aux vérifications ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                          "f00021",
                          "sans dépistage préalable — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00022",
                      "article L. 234-3 alinéa 1 du Code de la route",
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

          // Images CANVA (recto/verso)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00023",
              "Canevas (visuels)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath:
                    'assets/images/conduite_poste_ceea_positif_ou_refus_recto.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath:
                    'assets/images/conduite_poste_ceea_positif_ou_refus_verso.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Les 3 éléments (adapté en mode PV pédagogique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00024",
              "Structure de rédaction — les 3 piliers",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00025",
                  "1) Contexte (avant contrôle)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00026",
                  "Lieu de saisine : indiquer l’endroit exact où se situe l’équipage.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00027",
                  "Instructions : préciser le cadre (patrouille / instructions permanentes du chef de service).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00028",
                  "Assistants : nommer les fonctionnaires accompagnants + préciser la tenue (uniforme / tenue bourgeoise / brassard).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00029",
                  "Mission : but initial de la mission.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00030",
                  "2) Faits générateurs (interception + contrôle)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00031",
                  "Interception : expliquer le motif (infraction au Code de la route observée / contrôle sans infraction / contrôle préventif alcool).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00032",
                  "Contrôle : pièces de conduite + circulation + assurance (FVA si véhicule à moteur immatriculé) + identification de la personne (état civil + adresse uniquement).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00033",
                  "3) Procédure alcool (dépistage → information → suite)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00034",
                  "Dépistage : relater précisément le déroulé (positif / refus / ou pas de dépistage préalable).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00035",
                  "Information : rappeler que le conducteur peut être retenu le temps strictement nécessaire et qu’il peut consentir ou refuser les vérifications.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00036",
                  "Si refus des vérifications : mentionner clairement que cela constitue un délit de refus de se soumettre (jurisprudence).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00037",
              "Étapes détaillées (PV chronologique)",
            ),
            cardColor: cardProc,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00038",
                  "1 — Lieu de saisine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00039",
                  "Mentionner l’endroit exact où se situe l’équipage (adresse, repère, sens de circulation, point kilométrique si utile).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00040",
                  "2 — Instructions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00041",
                  "Lorsque tu rédiges le PV de saisine en patrouille, indiquer que tu agis conformément aux instructions permanentes du chef de service (ou toute instruction spécifique reçue).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00042",
                  "3 — Assistants",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00043",
                  "Citer les fonctionnaires qui t’accompagnent pour la mission et préciser la tenue (uniforme, tenue bourgeoise, brassard police).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00044",
                  "4 — Mission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00045",
                  "Indiquer le but initial : patrouille générale, contrôle routier, prévention alcool, recherche ciblée, etc.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00046",
                  "5 — Interception du véhicule",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00047",
                      "Relater pourquoi le véhicule est intercepté :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00048",
                      "• suite à une infraction constatée (décrire les faits observés)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00049",
                      "• ou contrôle sans infraction préalable\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00050",
                      "• ou contrôle préventif alcool\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00051",
                      "• à l’initiative de l’agent ou sur instructions du procureur de la République.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00052",
                  "6 — Contrôle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00053",
                      "Décrire le contrôle des pièces (conduite/circulation/assurance) et l’identification en style indirect : état civil et adresse, sans ajouter d’élément de personnalité (situation familiale, profession…).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00054",
                      "Si le contrôle est motivé par des faits observés, relater les faits qui justifient le dépistage.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00055",
                  "7 — Dépistage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00056",
                      "Mentionner le dépistage d’imprégnation alcoolique :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00057",
                      "• résultat positif (C.E.E.A.)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00058",
                      "• ou refus de subir le dépistage\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00059",
                      "• ou absence de dépistage préalable (si vérifications directes).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00060",
                  "8 — Information du conducteur",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                    "f00061",
                    "Rappeler que le conducteur peut être retenu le temps strictement nécessaire à l’exécution du dépistage et des vérifications destinées à établir la preuve de l’état alcoolique — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                    "f00062",
                    "article L. 234-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00063",
                      "Si le dépistage est positif ou refusé, préciser qu’il est informé qu’il peut :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00064",
                      "• consentir aux vérifications\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00065",
                      "• ou les refuser (ce qui caractérise alors un délit de refus de se soumettre).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00066",
                      "La jurisprudence retient le délit lorsque la personne refuse de se soumettre aux vérifications : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00067",
                      "Cass. crim., 07/03/2007",
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

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00068",
              "Mesures de sécurité & clôture",
            ),
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00069",
                  "9 — Palpation de sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00070",
                      "Elle ne doit pas être systématique. Agir avec respect et discernement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00071",
                      "Elle est justifiée uniquement selon les circonstances de temps/lieu si nécessaire pour vérifier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00072",
                      "que la personne ne transporte aucun objet dangereux pour elle-même ou pour autrui.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00073",
                  "10 — Retour au service",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00074",
                      "Mentionner que la personne accepte d’accompagner de son plein gré les fonctionnaires de police. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00075",
                      "Effectuer un compte-rendu radio au centre d’information et de commandement (CIC) et l’indiquer.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00076",
                  "11 — Énonciation terminale (clôture)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00077",
                      "Si les déclarations sont prises au style direct : la personne doit signer le PV. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00078",
                      "Si elles sont notées au style indirect : elle ne doit pas signer. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00079",
                      "L’indication de l’heure est facultative.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
              "f00080",
              "Mentions indispensables (à ne pas oublier)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00081",
                  "12 — Recherches administratives",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00082",
                      "Préciser les recherches au F.P.R. et au S.N.P.C. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00083",
                      "Cette mention confirme que les vérifications ont bien été effectuées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00084",
                      "et que l’intéressé ne fait l’objet d’aucune recherche ou suspension du permis.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00085",
                  "13 — Immobilisation du véhicule",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00086",
                      "Indiquer que l’immobilisation est levée dès qu’un conducteur qualifié ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00087",
                      "proposé par le conducteur (ou accompagnateur de l’élève conducteur) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00088",
                      "ou éventuellement par le propriétaire du véhicule peut en assurer la conduite. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                      "f00089",
                      "Préciser qu’un exemplaire de la fiche d’immobilisation est remis au conducteur.",
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

// Les class suivantes doivent être utilisées dans ta page si je dois affiché une image de caneva : (UNIQUMENT POUR AFFICHER UNE IMAGE CANVA)

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.heroTag,
    this.borderRadius = 16,
    this.backgroundColor,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.enableHero = true,
  });

  final String assetPath;

  /// Si tu veux un Hero stable : passe un tag unique.
  /// Sinon, par défaut on utilise assetPath.
  final Object? heroTag;

  final double borderRadius;
  final Color? backgroundColor;

  final double minScale;
  final double maxScale;

  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg =
        backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF));

    final Color border = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.black.withValues(alpha: .08);

    final Color shadow = Colors.black.withValues(alpha: isDark ? .28 : .12);

    final tag = heroTag ?? assetPath;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );

    if (enableHero) {
      image = Hero(tag: tag, child: image);
    }

    return Semantics(
      label: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
        "f00091",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
        "f00092",
        "Touchez pour ouvrir, pincez pour zoomer, glissez pour déplacer",
      ),
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _openViewer(context, tag),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(child: image),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _Badge(
                    isDark: isDark,
                    text: "Zoom",
                    icon: Icons.zoom_in_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context, Object tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => _ZoomableImageViewer(
          assetPath: assetPath,
          heroTag: enableHero ? tag : null,
          minScale: minScale,
          maxScale: maxScale,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({
    required this.assetPath,
    required this.heroTag,
    required this.minScale,
    required this.maxScale,
  });

  final String assetPath;
  final Object? heroTag;

  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color scrim = isDark
        ? Colors.black.withValues(alpha: .92)
        : Colors.black.withValues(alpha: .86);

    Widget image = Image.asset(
      assetPath,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fond sombre
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              color: scrim,
            ),

            // Image zoom/pan
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  _TopBar(
                    onClose: () => Navigator.of(context).maybePop(),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: minScale,
                        maxScale: maxScale,
                        clipBehavior: Clip.none,
                        child: image,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HintBar(isDark: isDark),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose, required this.isDark});

  final VoidCallback onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .95);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _Pill(
            bg: bg,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 18, color: fg),
                const SizedBox(width: 8),
                Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                    "f00093",
                    "Aperçu",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: fg,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 18, color: fg),
                    const SizedBox(width: 6),
                    Text(
                      "Fermer",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: fg,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintBar extends StatelessWidget {
  const _HintBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .92);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _Pill(
        bg: bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pinch_rounded, size: 18, color: fg),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart",
                  "f00094",
                  "Pincez pour zoomer • Glissez pour déplacer • Tapez pour fermer",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.isDark, required this.text, required this.icon});

  final bool isDark;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .12)
        : Colors.black.withValues(alpha: .06);
    final Color fg = isDark
        ? Colors.white
        : Colors.black.withValues(alpha: .78);

    return _Pill(
      bg: bg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: .12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
