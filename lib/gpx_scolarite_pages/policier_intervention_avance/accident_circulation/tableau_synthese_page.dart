import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class TableauSynthesePage extends StatelessWidget {
  const TableauSynthesePage({super.key});

  static const String routeName =
      '/gpx/intervention/accident-circulation/tableau-synthese';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color cardDocs = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

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
          "Accident circulation",
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
            "Tableau de synthèse",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Utilisation",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ces tableaux servent de support rapide pour structurer le constat et vérifier "
                "que les points essentiels ont bien été relevés.\n\n"
                "Astuce : ouvre l’image en plein écran pour zoomer sur les cases et faire pivoter "
                "si besoin (boutons ↺ ↻).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Tableaux",
            cardColor: cardDocs,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Clique sur une image pour l’ouvrir en plein écran :\n"
                "• Zoom / déplacement\n"
                "• Rotation (↺ ↻)\n"
                "• Reset",
              ),
              SizedBox(height: 12),
              _ZoomRotateImageTile(
                title: "Tableau 1",
                assetPath: "assets/images/talbeau-1.png",
              ),
              SizedBox(height: 12),
              _ZoomRotateImageTile(
                title: "Tableau 2",
                assetPath: "assets/images/talbeau-2.png",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoomRotateImageTile extends StatelessWidget {
  const _ZoomRotateImageTile({required this.title, required this.assetPath});

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color border = isDark
        ? Colors.white.withOpacity(.12)
        : Colors.black.withOpacity(.08);

    final Color labelBg = isDark
        ? Colors.black.withOpacity(.35)
        : Colors.white.withOpacity(.72);

    final Color labelColor = isDark ? Colors.white : const Color(0xFF111111);

    return Semantics(
      button: true,
      label: "Ouvrir $title",
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openViewer(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: labelBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(.14)
                          : Colors.black.withOpacity(.08),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.zoom_in_rounded,
                        size: 18,
                        color: labelColor.withOpacity(.9),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: labelBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(.14)
                          : Colors.black.withOpacity(.08),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Appuyer pour ouvrir",
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                      color: labelColor.withOpacity(.92),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        double angle = 0.0;
        final TransformationController controller = TransformationController();

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF121212)
                      : const Color(0xFFFDFDFD),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(.12)
                        : Colors.black.withOpacity(.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.35),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        transformationController: controller,
                        minScale: 1,
                        maxScale: 6,
                        panEnabled: true,
                        scaleEnabled: true,
                        child: Center(
                          child: Transform.rotate(
                            angle: angle,
                            child: Image.asset(
                              assetPath,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Barre d’actions (haut)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white)
                              .withOpacity(.55),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              tooltip: "Fermer",
                              icon: const Icon(Icons.close_rounded),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.fustat(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  angle -= math.pi / 2;
                                });
                              },
                              tooltip: "Tourner à gauche",
                              icon: const Icon(Icons.rotate_left_rounded),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  angle += math.pi / 2;
                                });
                              },
                              tooltip: "Tourner à droite",
                              icon: const Icon(Icons.rotate_right_rounded),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  angle = 0.0;
                                  controller.value = Matrix4.identity();
                                });
                              },
                              tooltip: "Reset",
                              icon: const Icon(Icons.restart_alt_rounded),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Aide (bas)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white)
                              .withOpacity(.55),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(.12)
                                : Colors.black.withOpacity(.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.pinch_rounded,
                              size: 18,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Pince pour zoomer • Glisse pour déplacer • Utilise ↺ ↻ pour tourner",
                                style: GoogleFonts.fustat(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
