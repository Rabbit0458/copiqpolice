import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaViolationCorrespondancesVoieElectroniquePage extends StatelessWidget {
  const PaViolationCorrespondancesVoieElectroniquePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/violation_correspondances_voie_electronique';

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
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
              "f00003",
              "La violation des correspondances émises par la voie électronique",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00005",
                      "Le fait, commis de mauvaise foi, d’intercepter, de détourner, d’utiliser ou de divulguer des correspondances ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00006",
                      "émises, transmises ou reçues par la voie électronique, ou de procéder à l’installation d’appareils de nature ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00007",
                      "à permettre la réalisation de telles interceptions, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00009",
                    "Article 226-15 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00010",
                    " : définit la violation des correspondances émises par la voie électronique (commise par un particulier).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00011",
                    "Article 226-15 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00012",
                    " : prévoit la répression de cette infraction.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00014",
                  "A) Des correspondances émises, transmises ou reçues par la voie électronique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00015",
                      "Le texte protège les correspondances « dématérialisées » (sans support tangible), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00016",
                      "par exemple : appels téléphoniques, courrier électronique, messages électroniques.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00017",
                      "Il vise les correspondances en cours de transmission ou parvenues à destination mais non encore appréhendées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00018",
                      "par leur destinataire. Une fois la correspondance ouverte/prise de connaissance, elle perd ce régime spécifique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00019",
                      "et peut relever d’autres qualifications (ex. vol de données copiées, accès/maintien frauduleux dans un STAD).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00020",
                  "DÉFINITION LÉGALE",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00021",
                          "Le courrier électronique est défini comme « tout message, sous forme de texte, de voix, de son ou d’image, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00022",
                          "envoyé par un réseau public de communications, stocké sur un serveur du réseau ou dans l’équipement terminal ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00023",
                          "du destinataire, jusqu’à ce que ce dernier le récupère ». — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00024",
                      "article 1er de la loi n° 2004-575 du 21 juin 2004 (LCEN)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00025",
                  "B) Un acte matériel d’atteinte",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00026",
                      "L’infraction est constituée par l’un des actes suivants : intercepter, détourner, utiliser, divulguer ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00027",
                      "ou installer des appareils permettant ces atteintes.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00028",
                  "1) Intercepter",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00029",
                      "Intercepter consiste à « prendre au passage » ce qui est destiné à autrui, pendant le cours de la transmission, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00030",
                      "au moyen d’un matériel quelconque. Il n’est pas nécessaire que l’auteur prenne connaissance du contenu pour que ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00031",
                      "l’interception soit réprimée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "JURISPRUDENCE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00032",
                      "L’interception suppose la captation pendant la transmission (",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00033",
                      "Cass. crim., 14 avril 1999",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "EXEMPLE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00034",
                      "Interception d’échanges radio entre différentes patrouilles de police (",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00035",
                      "C.A. Paris, 15 septembre 2005",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00036",
                  "2) Détourner",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00037",
                      "Détourner consiste à modifier le cours de la transmission, notamment par l’installation d’un dispositif permettant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00038",
                      "une dérivation de la correspondance vers un point choisi par l’auteur. Le détournement peut viser des messages en attente ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00039",
                      "d’être lus par le destinataire (ils ne sont plus « en cours de transmission », mais pas encore appréhendés).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "JURISPRUDENCE",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00040",
                          "Détournement retenu à l’encontre d’un employeur accédant aux courriers électroniques d’un salarié ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00041",
                          "avant que celui-ci en ait eu connaissance (",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00042",
                      "C.A. Pau, 24 novembre 2005",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00043",
                  "3) Utiliser",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00044",
                      "Utiliser consiste à se servir de la correspondance comme si l’on en était le destinataire (ex. effacer un courriel ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00045",
                      "dont on n’est pas destinataire, ou le transférer à un tiers, sans qualité pour en connaître).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00046",
                  "4) Divulguer",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00047",
                      "Divulguer consiste à révéler à un tiers le contenu d’une correspondance qui ne vous est pas destinée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00048",
                      "La divulgation peut faire suite à une interception (ex. faire écouter une conversation enregistrée, transmettre un courriel intercepté).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00049",
                  "5) Installer un dispositif permettant l’interception",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00050",
                      "L’installation consiste à mettre en œuvre un dispositif (matériel ou logiciel) permettant d’intercepter, détourner, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00051",
                      "utiliser ou divulguer des correspondances émises par la voie électronique.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00052",
                      "Même sans précision légale, la personne réalisant l’installation peut être considérée comme auteur de la violation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                      "f00053",
                      "du secret des correspondances, y compris si elle agit pour le compte d’un tiers qui recueille les informations interceptées.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
              "f00054",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00055",
                  "L’infraction suppose la mauvaise foi : l’auteur agit en toute connaissance de cause en violant le secret des correspondances.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00056",
                    "La Cour de cassation définit la « mauvaise foi » comme la connaissance que les correspondances ne lui étaient pas destinées (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00057",
                    "Cass. crim., 15 mai 1990",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00058",
                          "La méprise ou l’erreur ne permet pas de caractériser l’infraction faute d’intention coupable. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                          "f00059",
                          "L’intention de nuire n’est pas exigée : le mobile importe peu.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00061",
                    "Article 226-15 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00062",
                  "Lorsque les faits sont commis par le conjoint, le concubin ou le partenaire lié à la victime par un pacte civil de solidarité (PACS).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
              "f00063",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00064",
                  "Peines encourues — personnes physiques",
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00065",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00066",
                    "1 an d’emprisonnement et 45 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00067",
                    "article 226-15 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00068",
                    "Qualification aggravée (conjoint/concubin/PACS) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00069",
                    "2 ans d’emprisonnement et 60 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00070",
                    "article 226-15 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00071",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00072",
                    "Responsabilité pénale possible via ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00073",
                    "l’article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00074",
                    " (responsabilité généralisée depuis le 31 décembre 2005, notamment suite à l’article 54 de la loi n° 2004-204 du 9 mars 2004).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00075",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                  "f00076",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00077",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00078",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00079",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart",
                    "f00080",
                    " (aide et assistance, provocation, instructions données).",
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
