import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CanevasPVConstatationsPage extends StatelessWidget {
  const CanevasPVConstatationsPage({super.key});

  static const String routeName = '/gpx/pv_apj20/constatations/canevas_pv';

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
    final Color cardMain = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDocs = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);

    final List<String> pages = List.generate(
      13,
      (i) => 'assets/images/pv_canva_constatation${i + 1}.png',
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          "Constatations",
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
            "Canevas de procès-verbal de constatations",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Base juridique en haut
          _ConditionCard(
            title: "Base juridique (à mentionner en procédure)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En flagrant délit : l’agent de police judiciaire, sur instruction d’un officier de police judiciaire, "
                      "peut placer sous scellés les objets, traces et indices utiles à la manifestation de la vérité, "
                      "aux fins d’examens techniques et scientifiques — ",
                ),
                TextSpan(
                  text: "art. D. 15-5-1-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En enquête préliminaire : l’agent de police judiciaire peut saisir et placer sous scellés tout prélèvement effectué — ",
                ),
                TextSpan(
                  text: "art. 76 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Victime : le code de procédure pénale n’impose pas de réaliser les constatations "
                        "dans un domicile (ou lieu clos) en présence du chef de maison ou de deux témoins. "
                        "Il s’agit d’une règle traditionnelle de prudence à observer.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Objectif des constatations",
            cardColor: cardMain,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les constatations ont pour but de fixer l’état des lieux, d’établir la réalité de l’infraction "
                "et de rechercher les objets, traces et indices susceptibles d’orienter l’enquête.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Plan du canevas (rédaction)",
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("1. Lieu de saisine"),
              _Paragraph("Mentionner l’endroit exact où se situe l’équipage."),
              SizedBox(height: 10),

              _SubTitle("2. Instructions"),
              _Paragraph(
                "• Procès-verbal de saisine : l’équipage en patrouille agit conformément aux instructions permanentes du chef de service.\n"
                "• Constatations sur demande OPJ (après une plainte, par exemple) :\n"
                "  ➤ en flagrant délit : conformément aux instructions reçues de l’OPJ.\n"
                "  ➤ en préliminaire : sous le contrôle de l’OPJ.",
              ),
              SizedBox(height: 10),

              _SubTitle("3. Assistants éventuels"),
              _Paragraph(
                "Mentionner les fonctionnaires qui accompagnent le rédacteur pour l’accomplissement de la mission.",
              ),
              SizedBox(height: 10),

              _SubTitle("4. Mission"),
              _Paragraph("Indiquer le but de la mission initiale."),
              SizedBox(height: 10),

              _SubTitle("5. Saisine"),
              _Paragraph(
                "Indiquer le mode de saisine de l’équipage intervenant : réquisition d’une victime, avis téléphonique du chef de poste, "
                "appel radio du C.I.C., etc. Mentionner les mesures conservatoires prises ou sollicitées.",
              ),
              SizedBox(height: 10),

              _SubTitle("6. Cadre juridique"),
              _Paragraph(
                "En fonction des constatations et déclarations (victime notamment), indiquer le cadre juridique de l’intervention.\n"
                "Les constatations peuvent être réalisées :\n"
                "• peu de temps après l’infraction : enquête de flagrance ;\n"
                "• à un moment plus éloigné (ex. cambriolage constaté plusieurs jours après) : enquête préliminaire.",
              ),
              SizedBox(height: 10),

              _SubTitle("7. Transport"),
              _Paragraph(
                "Préciser : ville, rue, numéro, immeuble, étage, porte. Indiquer l’heure d’arrivée, la prise de contact "
                "avec le requérant ou la victime (petite identité) et la vérification de la matérialité des faits.",
              ),
              SizedBox(height: 10),

              _SubTitle("8. Assistance P.T.S."),
              _Paragraph(
                "Selon le protocole de répartition des compétences, faire appel au S.D.P.T.S., à la B.P.T.S. ou au S.R.P.T.S.\n"
                "Mentionner la présence du fonctionnaire P.T.S. ou son heure d’arrivée. Une réquisition peut être exigée.\n"
                "L’APJ doit préserver les lieux en l’état et ne commencer ses constatations qu’en présence du P.T.S. (sauf nécessité absolue).",
              ),
              SizedBox(height: 10),

              _SubTitle("9. Constatations"),
              _Paragraph(
                "En matière criminelle : l’APJ assure uniquement la protection des lieux, seul l’OPJ procède aux constatations techniques.\n"
                "Pour tout autre fait (petite/moyenne délinquance) : l’APJ peut procéder aux constatations sur les lieux.\n\n"
                "Étapes :\n"
                "➤ Description générale : situation géographique, environnement, voies d’accès.\n"
                "➤ Description précise : mode opératoire (effraction, escalade), découverte d’objets, traces/indices.\n\n"
                "Noter chaque M.A.S. :\n"
                "• MODIFICATION : déplacé/endommagé (porte ouverte, dégradations, effractions…)\n"
                "• APPORT : éléments absents avant l’infraction (traces, empreintes, objets abandonnés…)\n"
                "• SUPPRESSION : éléments disparus (objets volés).",
              ),
              SizedBox(height: 10),

              _SubTitle("S.D.I.S.S. / S.D.I.A."),
              _Paragraph(
                "Pour tout objet découvert ou trace relevée :\n"
                "➤ SITUATION\n"
                "➤ DESCRIPTION\n"
                "➤ INTERPELLATION (ou interrogation de la victime)\n"
                "➤ SAISIE et SCELLÉS ou APPRÉHENSION",
              ),
              SizedBox(height: 10),

              _SubTitle("10. Diligences"),
              _Paragraph(
                "Inviter la victime à se présenter au service pour déposer plainte, munie si possible d’une liste précise "
                "des objets dérobés et de leurs références (marque, type, n° de série…) et du chiffrage du préjudice global subi.",
              ),
              SizedBox(height: 10),

              _SubTitle("11. Énonciation terminale (clôture)"),
              _Paragraph(
                "La signature du procès-verbal par la personne présente lors des constatations est recommandée notamment :\n"
                "• lors de la découverte d’objets abandonnés ;\n"
                "• lors de déclarations recueillies au style direct.",
              ),
              SizedBox(height: 10),

              _SubTitle("12. Annexes"),
              _Paragraph(
                "Documents éventuellement remis par le plaignant. Copie de la réquisition éventuellement remise au service P.T.S. intervenant.",
              ),
              SizedBox(height: 10),

              _SubTitle("13. Avis O.P.J."),
              _Paragraph(
                "L’agent de police judiciaire avise l’officier de police judiciaire des constatations effectuées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Affichage des pages images
          _ConditionCard(
            title: "Documents (pages du canevas)",
            cardColor: cardDocs,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Chaque page ci-dessous est une image consultable avec zoom, déplacement, rotation et mode plein écran.",
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < pages.length; i++) ...[
                _SubTitle("Page ${i + 1}"),
                _ZoomRotateImage(assetPath: pages[i]),
                const SizedBox(height: 12),
              ],
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
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
                    : const Color(0xFF1F1F1F).withOpacity(.92),
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
        color: bgColor.withOpacity(isDark ? .7 : .95),
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
                : const Color(0xFF3E2723).withOpacity(.95),
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

///////////////////////////////////////////////////////////////////////////////
///                       ZOOM + ROTATION IMAGE                            ///
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
        ? Colors.white.withOpacity(.18)
        : Colors.black.withOpacity(.10);

    final double w = MediaQuery.of(context).size.width;
    final bool compact = w < 380; // ✅ évite l’overflow sur petits écrans

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
              color: isDark ? Colors.black.withOpacity(.18) : Colors.black12,
              border: Border(bottom: BorderSide(color: border, width: 1)),
            ),
            // ✅ Wrap au lieu de Row => plus d’overflow
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  onPressed: _rotateLeft,
                  tooltip: 'Tourner à gauche',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.rotate_left_rounded),
                ),
                IconButton(
                  onPressed: _rotateRight,
                  tooltip: 'Tourner à droite',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.rotate_right_rounded),
                ),
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    compact ? "Reset" : "Réinitialiser",
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openFullscreen(context),
                  icon: const Icon(Icons.fullscreen_rounded),
                  label: Text(
                    "Plein écran",
                    style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
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
                  child: Image.asset(
                    widget.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            'Asset introuvable :\n${widget.assetPath}\n\nVérifie le nom exact du fichier + pubspec.yaml',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fustat(
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
      barrierColor: Colors.black.withOpacity(.92),
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
                      color: Colors.black.withOpacity(.35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () =>
                              setLocalState(() => turns = (turns - 1) % 4),
                          tooltip: 'Tourner à gauche',
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.rotate_left_rounded,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setLocalState(() => turns = (turns + 1) % 4),
                          tooltip: 'Tourner à droite',
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.rotate_right_rounded,
                            color: Colors.white,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => setLocalState(() => turns = 0),
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Réinitialiser",
                            style: GoogleFonts.fustat(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          tooltip: 'Fermer',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
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
                            errorBuilder: (context, error, stack) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    'Asset introuvable :\n${widget.assetPath}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.fustat(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              );
                            },
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
