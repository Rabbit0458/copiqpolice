import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CooperationUEPage extends StatelessWidget {
  const CooperationUEPage({super.key});

  static const String routeName = '/gpx/intervention/etrangers/cooperation-ue';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardPolice = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardServices = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardJud = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfo = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
            "f00002",
            "Étrangers",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
              "f00003",
              "Coopération policière et judiciaire au sein de l’Union européenne",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
              "f00004",
              "Pourquoi c’est essentiel ?",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00005",
                      "La création de l’espace Schengen (libre circulation) a nécessité un renforcement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00006",
                      "de la coopération policière et judiciaire entre États membres, afin de préserver la sécurité.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00007",
                  "Objectif : échanger rapidement des informations, coordonner les actions, et soutenir les enquêtes transfrontalières.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00008",
                  "Principe : coopération organisée et encadrée, avec des canaux dédiés et des conditions strictes.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre en haut (sans inventer d’articles)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
              "f00009",
              "Cadre (à retenir)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00010",
                      "La coopération repose sur des mécanismes transfrontaliers encadrés, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00011",
                      "notamment dans l’espace Schengen et au sein de l’UE, pour permettre :",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00012",
                  "l’observation transfrontalière (filature au-delà de la frontière, sans interpellation).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00013",
                  "la poursuite transfrontalière (continuer une poursuite dans un État voisin, sous conditions strictes).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00014",
                  "l’échange d’informations via des services dédiés (SCCOPOL, PCC, UCAP/Prüm, N-SIS II…).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00015",
                      "Ici, on retient surtout les définitions, les conditions et les canaux (qui contacter / comment faire).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — COOP POLICIÈRE
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
              "f00016",
              "I — Coopération policière",
            ),
            cardColor: cardPolice,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00017",
                  "A) Droit d’observation transfrontalière",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00018",
                      "Il permet à un enquêteur de continuer, sous certaines conditions, une filature sur le territoire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00019",
                      "d’un État voisin membre de l’espace Schengen, sans interpellation possible.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00020",
                  "1) Observation dite « ordinaire »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00021",
                      "Elle intervient dans le cadre d’une enquête judiciaire. La personne observée doit être présumée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00022",
                      "avoir participé (ou être susceptible de commettre) un fait puni d’une peine. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00023",
                      "Peuvent aussi être observées des personnes susceptibles de conduire à l’identification de l’intéressé.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00024",
                  "Condition clé : autorisation préalable de l’État requis.",
                ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00025",
                      "Pour les agents français : demande transmise via la ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00026",
                      "S.C.C.O.P.O.L.",
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
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00027",
                  "2) Observation « en urgence »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00028",
                      "Lorsque l’autorisation préalable ne peut pas être demandée pour des raisons particulièrement urgentes, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00029",
                      "l’agent peut continuer l’observation au-delà de la frontière pour certaines infractions graves ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00030",
                      "(liste limitative : meurtre, viol, trafic de stupéfiants, vol aggravé, etc.).",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00031",
                  "Obligation : franchissement immédiatement porté à la connaissance de l’autorité centrale du pays concerné.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00032",
                  "Puis : autorisation donnée a posteriori par cette autorité centrale.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00033",
                  "B) Droit de poursuite transfrontalière",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00034",
                      "Il permet à des policiers (O.P.J. ou A.P.J.) poursuivant une personne prise en flagrant délit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00035",
                      "d’une infraction grave (liste limitative), ou se trouvant en état d’arrestation provisoire / purgeant une peine, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00036",
                      "de continuer la poursuite sur le territoire d’un État voisin membre de l’espace Schengen.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00037",
                  "Pas d’autorisation préalable en principe, mais conditions très strictes et modalités précises.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00038",
                  "Dès le franchissement : alerter sans délai les autorités compétentes de l’État concerné.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00039",
                      "À retenir : c’est proche du droit d’observation, mais dans un contexte de poursuite immédiate.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Services de coopération
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
              "f00040",
              "C) Services de coopération policière (France)",
            ),
            cardColor: cardServices,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00041",
                      "Au sein de la D.N.P.J., la direction des relations internationales coordonne la coopération policière opérationnelle. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00042",
                      "Elle s’appuie sur plusieurs structures.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00043",
                  "1) S.C.C.O.P.O.L.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00044",
                      "La Section Centrale de Coopération Opérationnelle de Police administre des organes de coopération internationale, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00045",
                      "dont notamment :",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00046",
                  "Le B.C.N. France d’Interpol : coopération policière internationale (organisation mondiale).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00047",
                  "L’unité nationale Europol : lutte contre la criminalité organisée et le terrorisme, analyse et regroupements.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00048",
                  "2) P.C.C. — Point de Contact Central",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00049",
                      "Il centralise les demandes nationales de coopération au sein de la SCCOPOL. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00050",
                      "Il vérifie la légalité, effectue les premiers recoupements et choisit le canal le plus adapté.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00051",
                      "Astuce terrain : le PCC = la « tour de contrôle » qui oriente la demande sur le bon circuit.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00052",
                  "3) U.C.A.P. (Prüm)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00053",
                      "L’unité de coordination et d’assistance Prüm traite les échanges d’informations consécutifs à un « hit » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00054",
                      "lors des comparaisons automatisées d’ADN ou d’empreintes digitales entre pays de l’UE.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00055",
                  "4) Office N-SIS II",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00056",
                  "Il assure le bon fonctionnement et la sécurité du système N-SIS II (interface nationale du SIS).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — COOP JUDICIAIRE
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
              "f00057",
              "II — Coopération judiciaire",
            ),
            cardColor: cardJud,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00058",
                  "A) Entraide judiciaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00059",
                      "Une demande d’entraide judiciaire est adressée à une autorité étrangère pour exécuter un ou plusieurs actes judiciaires, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00060",
                      "dans le but de réprimer une infraction existante.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00061",
                  "B) Équipes communes d’enquête (ECE)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00062",
                      "Des équipes communes d’enquête, regroupant plusieurs États membres, peuvent être créées en France ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00063",
                      "dans le cadre d’une procédure judiciaire existante, notamment pour une enquête pénale complexe.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00064",
                  "C) C.C.P.D. — Centres de Coopération Policière et Douanière",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00065",
                      "Les CCPD rassemblent dans une même structure des agents de sécurité de la zone frontalière des États partenaires. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00066",
                      "Pour la France : Police nationale, Gendarmerie nationale et Douane y sont représentées.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00067",
                  "Rôle : échange d’informations.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00068",
                  "Limite : aucun pouvoir opérationnel.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                  "f00069",
                  "D) Commissariats européens",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00070",
                      "Ils consistent en un renfort d’agents des États membres au profit des services de sécurité publique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00071",
                      "dans des lieux particulièrement fréquentés par des ressortissants européens, lors d’évènements ponctuels ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00072",
                      "ou pendant les périodes touristiques.",
                    ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart",
                      "f00073",
                      "Des policiers français peuvent aussi être désignés pour renforcer les forces de police ou de gendarmerie d’autres États.",
                    ),
                  ),
                ],
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
