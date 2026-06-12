import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMemoTph900Page extends StatelessWidget {
  const PaMemoTph900Page({super.key});

  static const String routeName = '/pa/dps_dpg/policier_intervention/patrouille/memo-tph-900';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardPrimary = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF); // bleu très doux
    final Color cardNeutral = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
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
            "Mémo TPH 900",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte / objectif (court, pas répétitif)
          _ConditionCard(
            title: "Objectif",
            cardColor: cardNeutral,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Avoir un repère visuel immédiat pour appliquer la bonne procédure au bon moment. "
                "Ce mémo sert de support terrain : simple, rapide, opérationnel.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Image principale (le mémo)
          _ConditionCard(
            title: "Mémo (image)",
            cardColor: cardPrimary,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const _MemoTphFullscreenViewer(
                          assetPath: 'assets/images/memo_tph.png',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: isDark
                        ? Colors.white.withValues(alpha: .06)
                        : Colors.black.withValues(alpha: .04),
                    child: Image.asset(
                      'assets/images/memo_tph.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "Image introuvable : memo_tph.png\n\n"
                            "➡️ Vérifie le chemin d’assets (pubspec.yaml)\n"
                            "➡️ Et ajuste le Image.asset(...) si besoin",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fustat(
                              fontSize: 13.5,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conseils d’utilisation (pédagogique, ultra clair)
          _ConditionCard(
            title: "Utilisation terrain (rappel)",
            cardColor: cardNeutral,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Avant l’action"),
              _BulletPoint(
                text:
                    "Avoir le mémo accessible rapidement (favoris, onglet, capture).",
              ),
              _BulletPoint(
                text:
                    "S’assurer que la procédure suivie est adaptée au contexte (urgence / routine).",
              ),
              SizedBox(height: 10),
              _SubTitle("Pendant l’action"),
              _BulletPoint(
                text:
                    "Se référer au mémo uniquement pour sécuriser et standardiser (pas pour rallonger les communications).",
              ),
              _BulletPoint(
                text:
                    "Garder des messages brefs : l’essentiel opérationnel d’abord.",
              ),
              SizedBox(height: 10),
              _SubTitle("Après l’action"),
              _BulletPoint(
                text:
                    "Corriger les écarts si nécessaire (discipline radio / procédure).",
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
  final String title = 'NOTA';

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

class _MemoTphFullscreenViewer extends StatefulWidget {
  const _MemoTphFullscreenViewer({required this.assetPath});

  final String assetPath;

  @override
  State<_MemoTphFullscreenViewer> createState() =>
      _MemoTphFullscreenViewerState();
}

class _MemoTphFullscreenViewerState extends State<_MemoTphFullscreenViewer> {
  final TransformationController _controller = TransformationController();
  double _rotationQuarterTurns = 0; // 0,1,2,3 (90°)

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reset() {
    _controller.value = Matrix4.identity();
    setState(() => _rotationQuarterTurns = 0);
  }

  void _rotateRight() {
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          tooltip: 'Fermer',
        ),
        title: Text(
          "Mémo TPH 900",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.5,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _rotateRight,
            icon: const Icon(
              Icons.screen_rotation_rounded,
              color: Colors.white,
            ),
            tooltip: 'Tourner (90°)',
          ),
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt_rounded, color: Colors.white),
            tooltip: 'Réinitialiser',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1,
            maxScale: 8,
            panEnabled: true,
            scaleEnabled: true,
            child: RotatedBox(
              quarterTurns: _rotationQuarterTurns.toInt(),
              child: Image.asset(
                widget.assetPath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: .08)
                          : Colors.black.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: .15)),
                    ),
                    child: Text(
                      "Image introuvable.\nVérifie : ${widget.assetPath}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fustat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
