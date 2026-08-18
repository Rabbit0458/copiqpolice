import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ConfrontationVictimeSuspectLibreEmprisonnementPage
    extends StatelessWidget {
  const ConfrontationVictimeSuspectLibreEmprisonnementPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/confrontation/victime_suspect_libre_emprisonnement';

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
    final Color cardCadre = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardOperation = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAvocats = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardCloture = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Confrontation",
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
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00002",
              "PV — Confrontation victime / suspect (audition libre)\n(crime ou délit puni d’emprisonnement)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.18,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00003",
              "Point clé avant l’acte",
            ),
            cardColor: cardCloture,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00004",
                      "Une notification des droits (notamment le droit à l’assistance de l’avocat) doit être faite ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00005",
                      "à la personne entendue librement avant chaque audition.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00006",
                      "Cette notification fait l’objet d’un procès-verbal distinct ou peut être insérée dans le PV de confrontation.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut : visas CPP
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00007",
              "Visa des articles — assistance de l’avocat (CPP)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                    "f00008",
                    "Suspect entendu librement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                    "f00009",
                    "articles 61-1, 63-4-3 et 63-4-4 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                    "f00010",
                    "Victime : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                    "f00011",
                    "article 61-2 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00012",
                      "Ces visas doivent apparaître avant le déroulement, pour encadrer immédiatement le régime de présence et d’intervention de l’avocat.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images CANVA (recto / verso)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00013",
              "Modèle visuel (recto / verso)",
            ),
            cardColor: cardCloture,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath:
                    'assets/images/victime_suspect_libre_emprisonnement_recto.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath:
                    'assets/images/victime_suspect_libre_emprisonnement_verso.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00014",
              "1 → 3 — Lieu, instructions, cadre juridique",
            ),
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00015",
                  "1) Lieu de rédaction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00016",
                  "Le PV indique le lieu exact de rédaction (service / commune), comme tout acte de procédure.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00017",
                  "2) Instructions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00018",
                      "En flagrant délit, l’agent de police judiciaire agit conformément aux instructions reçues de l’officier de police judiciaire.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00019",
                      "En enquête préliminaire, il agit sous le contrôle de l’officier de police judiciaire.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00020",
                  "3) Cadre juridique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00021",
                      "L’APJ doit situer l’acte : enquête de flagrance ou enquête préliminaire.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00022",
                      "Le cadre doit être clair dès le début car il conditionne la procédure.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00023",
              "5 → 6 — Assistants éventuels & personnes présentes",
            ),
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00024",
                  "5) Assistants éventuels",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00025",
                      "Cette précaution devient indispensable lorsqu’il existe un risque d’incident ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00026",
                      "ou un nombre important de personnes à confronter.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00027",
                  "6) Personnes présentes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00028",
                      "Le PV précise l’identité des personnes mises en présence (victime / suspect) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00029",
                      "et indique la présence ou non de leurs avocats.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00030",
              "7 — Règles de bon déroulement",
            ),
            cardColor: cardOperation,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00031",
                      "L’enquêteur conserve la direction exclusive de l’acte.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00032",
                      "Il peut mettre fin à la confrontation en cas de difficulté.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00033",
                      "Mention doit être faite de tout incident, qu’il entraîne ou non l’interruption de l’acte.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00034",
                      "Bon réflexe : rappeler dès le départ les règles (calme, pas d’interruption, prise de parole sur invitation).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00035",
              "8 → 9 — Opération & questions / réponses",
            ),
            cardColor: cardOperation,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00036",
                  "8) Opération",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00037",
                      "Il est fait lecture des déclarations en présence de toutes les parties.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00038",
                      "La confrontation est une audition contradictoire : les personnes s’expriment sur les contradictions relevées, portées à leur connaissance.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00039",
                      "À aucun moment elles ne communiquent entre elles : elles s’adressent exclusivement à l’enquêteur.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00040",
                  "9) Questions — réponses",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00041",
                  "Deux types de questionnement (séparés ou conjoints) :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00042",
                  "Question posée à tous : chaque personne répond à son tour.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00043",
                  "Questions alternées : une question à chaque partie à tour de rôle, en présence de l’autre (seule la personne interrogée répond).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00044",
                      "Objectif : consigner les contradictions clairement, point par point, sur un même PV.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00045",
              "10 — Questions des avocats & observations écrites",
            ),
            cardColor: cardAvocats,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00046",
                      "Les avocats peuvent poser des questions au suspect et/ou à la victime à l’issue de la confrontation.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00047",
                      "L’enquêteur peut s’opposer aux questions si elles lui semblent de nature à nuire au bon déroulement de l’enquête : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00048",
                      "mention du refus devra être faite.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00049",
                      "Les avocats peuvent formuler des observations écrites à la fin de la confrontation et les remettre à l’enquêteur.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
              "f00050",
              "11 → 13 — Clôture, annexe, avis O.P.J.",
            ),
            cardColor: cardCloture,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00051",
                  "11) Énonciation terminale (clôture)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00052",
                      "Après lecture, l’agent de police judiciaire fait signer les personnes entendues ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00053",
                      "et mentionne l’heure de fin de la confrontation.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00054",
                  "12) Annexe",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00055",
                  "Le cas échéant, les observations écrites présentées par le ou les avocats sont jointes au présent PV.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00056",
                  "13) Avis O.P.J.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00057",
                      "L’O.P.J. doit être informé des déclarations faites lors de la confrontation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                      "f00058",
                      "et des éventuelles observations écrites.",
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
        "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
        "f00059",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
        "f00060",
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
                    "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                    "f00061",
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
                  "lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart",
                  "f00062",
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
