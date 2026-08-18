import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PresentationGrilleDangerPage extends StatelessWidget {
  const PresentationGrilleDangerPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/violences_conjugales/presentation_grille_danger';

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
    final Color cardUse = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardReco = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCriteria = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDocs = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
            "f00002",
            "Violences conjugales",
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
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00003",
              "Présentation de la grille d’évaluation du danger",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / objectif (sans répétitions)
          _ConditionCard(
            title: "Objectif",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00004",
                      "La grille d’évaluation du danger vise à apprécier le niveau de danger encouru par une victime ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00005",
                      "de violences conjugales. Combinée à d’autres éléments de contexte, elle peut conduire à la mise ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00006",
                      "en œuvre de mesures d’accompagnement et de protection. Elle aide aussi la victime à prendre conscience ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00007",
                      "du danger encouru.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (articles en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
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
                    "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                    "f00009",
                    "Information des droits des victimes (dans le cadre d’une plainte) — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                    "f00010",
                    "article 10-2 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                          "f00011",
                          "La grille est transmise à l’autorité judiciaire lorsqu’elle est renseignée, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                          "f00012",
                          "en l’annexant à l’audition ou à la main courante informatisée (MCI).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Présentation / contenu du questionnaire
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00013",
              "II — Présentation",
            ),
            cardColor: cardUse,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00014",
                      "La grille se présente sous la forme de 23 questions fermées. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00015",
                      "Parmi elles, 5 questions signalées en rouge définissent un degré de danger particulier.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00016",
                  "Permet une évaluation structurée et rapide de la situation de danger.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00017",
                  "Sert d’appui pour décider et déclencher des mesures adaptées (protection, accompagnement, partenariats).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00018",
                  "Doit être remplie par le policier à partir des déclarations de la victime.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Où trouver la grille (LRPPN) + cas refus de plainte
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00019",
              "III — Renseignement & transmission",
            ),
            cardColor: cardReco,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00020",
                  "Disponibilité (LRPPN)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00021",
                      "Disponible dans le logiciel de rédaction des procédures (LRPPN) : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00022",
                      "« RÉDACTION PJ » → fonction « création/suite de dossier – Violences conjugales ».",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00023",
                  "Quand la victime refuse la plainte",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00024",
                      "Si la victime privilégie une main courante informatisée (MCI), il convient d’imprimer la grille ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00025",
                      "et de la remplir manuellement.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle("Transmission"),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00026",
                  "La grille doit être transmise à l’autorité judiciaire, annexée à l’audition ou à la MCI.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Préconisations (pédagogie + confidentialité etc.)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00027",
              "IV — Préconisations",
            ),
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00028",
                  "Recevoir la victime dans un lieu sécurisant et respectant la confidentialité (dans la mesure du possible).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00029",
                  "Informer la victime : ce questionnaire sert à mieux évaluer la situation pour mieux l’accompagner.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00030",
                  "Laisser un temps de parole, puis compléter la grille avec la victime (ne pas lui remettre pour qu’elle la remplisse seule).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00031",
                  "Adopter une posture bienveillante et pédagogique pour rassurer et déculpabiliser.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Critères danger (2 hypothèses non cumulatives)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00032",
              "V — Critères de danger (non cumulatif)",
            ),
            cardColor: cardCriteria,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00033",
                  "Le danger est susceptible d’être caractérisé dans deux hypothèses non cumulatives :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00034",
                  "Réponse positive à au moins 2 questions signalées en rouge dans le formulaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00035",
                  "Réponse positive à 12 questions (qu’elles soient en rouge ou non).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                          "f00036",
                          "La conduite à tenir est adaptée au résultat (danger identifié ou non), avec mobilisation des partenaires ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                          "f00037",
                          "engagés dans la lutte contre les violences conjugales.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // “Rappel / conduite à tenir” (résumé opérationnel)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00038",
              "VI — Rappel opérationnel (conduites à tenir)",
            ),
            cardColor: cardUse,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00039",
                  "Diligences essentielles",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00040",
                  "Accueillir la victime : confidentialité, sécurité, possibilité d’être accompagnée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00041",
                  "Écouter et prendre les déclarations (plainte ou MCI), avis OPJ si nécessaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00042",
                  "Renseigner systématiquement la grille d’évaluation du danger.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00043",
                  "Remise à la victime : information droits victimes, récépissés, coordonnées utiles (ISC / associations / etc.).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00044",
                      "Tout refus de la victime (ITT, mise en sécurité, etc.) doit être mentionné en procédure.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Documents/images (zoom + rotation)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
              "f00045",
              "VII — Documents (zoom / rotation)",
            ),
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                  "f00046",
                  "Appuie sur l’image pour l’ouvrir en plein écran. Tu peux zoomer et tourner.",
                ),
              ),
              SizedBox(height: 10),
              _ZoomRotateImage(assetPath: 'assets/images/protocole.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/presentation.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/evaluation.png'),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///  Image : plein écran + zoom + rotation (sans dépendances, sans copyWith)
///////////////////////////////////////////////////////////////////////////////

class _ZoomRotateImage extends StatefulWidget {
  const _ZoomRotateImage({required this.assetPath});

  final String assetPath;

  @override
  State<_ZoomRotateImage> createState() => _ZoomRotateImageState();
}

class _ZoomRotateImageState extends State<_ZoomRotateImage> {
  int _quarterTurns = 0;

  void _rotateLeft() => setState(() => _quarterTurns = (_quarterTurns - 1) % 4);
  void _rotateRight() =>
      setState(() => _quarterTurns = (_quarterTurns + 1) % 4);
  void _reset() => setState(() => _quarterTurns = 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color border = isDark
        ? Colors.white.withValues(alpha: .18)
        : Colors.black.withValues(alpha: .10);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: .18)
                  : Colors.black12,
              border: Border(bottom: BorderSide(color: border, width: 1)),
            ),

            // ✅ FIX OVERFLOW: la barre devient scrollable horizontalement
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _rotateLeft,
                    tooltip: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00047",
                      'Tourner à gauche',
                    ),
                    icon: const Icon(Icons.rotate_left_rounded),
                  ),
                  IconButton(
                    onPressed: _rotateRight,
                    tooltip: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                      "f00048",
                      'Tourner à droite',
                    ),
                    icon: const Icon(Icons.rotate_right_rounded),
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                        "f00049",
                        "Réinitialiser",
                      ),
                      style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    onPressed: () => _openFullscreen(context),
                    icon: const Icon(Icons.fullscreen_rounded),
                    label: Text(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                        "f00050",
                        "Plein écran",
                      ),
                      style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 6,
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(80),
              child: Center(
                child: RotatedBox(
                  quarterTurns: _quarterTurns,
                  child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    int turns = _quarterTurns;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .92),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(12),
              backgroundColor: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    // ✅ FIX OVERFLOW aussi en plein écran
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                setLocalState(() => turns = (turns - 1) % 4),
                            tooltip: ScolariteText.value(
                              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                              "f00051",
                              'Tourner à gauche',
                            ),
                            icon: const Icon(
                              Icons.rotate_left_rounded,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setLocalState(() => turns = (turns + 1) % 4),
                            tooltip: ScolariteText.value(
                              "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                              "f00052",
                              'Tourner à droite',
                            ),
                            icon: const Icon(
                              Icons.rotate_right_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          TextButton.icon(
                            onPressed: () => setLocalState(() => turns = 0),
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart",
                                "f00053",
                                "Réinitialiser",
                              ),
                              style: GoogleFonts.fustat(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            tooltip: 'Fermer',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 10,
                      panEnabled: true,
                      boundaryMargin: const EdgeInsets.all(200),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: turns,
                          child: Image.asset(
                            widget.assetPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() => _quarterTurns = turns);
    });
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
