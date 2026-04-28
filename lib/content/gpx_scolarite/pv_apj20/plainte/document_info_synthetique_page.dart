import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentInfoSynthetiquePage extends StatelessWidget {
  const DocumentInfoSynthetiquePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/violences_conjugales/document_info_synthetique';

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
    final Color cardDocs = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          tooltip: 'Retour',
        ),
        title: Text(
          "Violences conjugales",
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
            "Document d’information synthétique",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (courte, pédagogique)
          _ConditionCard(
            title: "Objectif",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce document permet de remettre à la victime une information claire et immédiatement exploitable "
                "sur les démarches, les droits et les ressources utiles. Il peut être annexé à la procédure selon les consignes du service.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (si tu veux compléter d’autres articles, mets-les ici)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Information des droits des victimes — "),
                TextSpan(
                  text: "article 10-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Utilisation
          _ConditionCard(
            title: "II — Utilisation",
            cardColor: cardUse,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Remettre à la victime au moment opportun (plainte / audition / MCI selon le cadre).",
              ),
              _BulletPoint(
                text:
                    "Expliquer brièvement le contenu : droits, contacts, démarches, accompagnement.",
              ),
              _BulletPoint(
                text:
                    "Mentionner en procédure la remise du document si requis par les consignes locales.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Documents (zoom + rotation)
          _ConditionCard(
            title: "III — Documents (zoom / rotation)",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Appuie sur l’image pour l’ouvrir en plein écran. Tu peux zoomer et tourner.",
              ),
              SizedBox(height: 10),

              // ✅ Tes 2 docs demandés
              _ZoomRotateImage(assetPath: 'assets/images/document_vif1.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/document_vif2.png'),

              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///  Image : zoom + rotation + plein écran + anti-overflow (Row scrollable)
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

            // ✅ FIX : plus jamais d’overflow
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _rotateLeft,
                    tooltip: 'Tourner à gauche',
                    icon: const Icon(Icons.rotate_left_rounded),
                  ),
                  IconButton(
                    onPressed: _rotateRight,
                    tooltip: 'Tourner à droite',
                    icon: const Icon(Icons.rotate_right_rounded),
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      "Réinitialiser",
                      style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 6),
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

                    // ✅ FIX : overflow aussi ici
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                setLocalState(() => turns = (turns - 1) % 4),
                            tooltip: 'Tourner à gauche',
                            icon: const Icon(
                              Icons.rotate_left_rounded,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setLocalState(() => turns = (turns + 1) % 4),
                            tooltip: 'Tourner à droite',
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
                              "Réinitialiser",
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
