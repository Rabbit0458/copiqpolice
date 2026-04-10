import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MandatsPage extends StatelessWidget {
  const MandatsPage({super.key});

  static const String routeName = '/gpx/pv_apj20/interpellation/mandats';

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
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardFocus = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
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
          tooltip: 'Retour',
        ),
        title: Text(
          "PV APJ 20",
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
            "Les mandats (schémas + points clés)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "À retenir",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Un mandat = acte d’autorité (souvent magistrat) visant une personne déterminée.",
              ),
              _IntroBullet(
                text:
                    "Certains mandats permettent la coercition (contrainte), d’autres non.",
              ),
              _IntroBullet(
                text:
                    "Quand il est exécuté : notification / exhibition du mandat / remise d’une copie (selon le mandat).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Schémas (zoomables)
          _ConditionCard(
            title: "Schémas (zoom)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final double gap = 12;
                  final double itemWidth = (constraints.maxWidth - gap) / 2;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: const [
                      SizedBox(
                        width: 220,
                        child: _ZoomableAssetImage(
                          assetPath: 'assets/images/mandant_recherche.png',
                          label: 'Mandat de recherche',
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _ZoomableAssetImage(
                          assetPath: 'assets/images/mandat_comparution.png',
                          label: 'Mandat de comparution',
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _ZoomableAssetImage(
                          assetPath: 'assets/images/mandat-damener.png',
                          label: 'Mandat d’amener',
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _ZoomableAssetImage(
                          assetPath: 'assets/images/madant_darret.png',
                          label: 'Mandat d’arrêt',
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: _ZoomableAssetImage(
                          assetPath: 'assets/images/mandat_darret_europeen.png',
                          label: 'Mandat d’arrêt européen',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // 1) Mandat de recherche
          // =========================
          _ConditionCard(
            title: "1 — Mandat de recherche",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 122 alinéa 2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : ordre donné à la force publique (par un magistrat).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Objet"),
              const _BulletPoint(
                text: "Rechercher la personne visée par le mandat.",
              ),
              const _BulletPoint(
                text: "La placer en garde à vue après découverte (par O.P.J.).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Coercition"),
              const _BulletPoint(text: "Coercition possible."),
              const _BulletPoint(
                text:
                    "Introduction au domicile possible pendant les heures légales.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Exécution / formalités : notification et exécution par ",
                  ),
                  const TextSpan(
                    text: "O.P.J., A.P.J. ou agent de la force publique",
                  ),
                  const TextSpan(
                    text: ", exhibition du mandat et remise d’une copie.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // 2) Mandat de comparution
          // =========================
          _ConditionCard(
            title: "2 — Mandat de comparution",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 122 alinéa 4 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : simple assignation à comparaître."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Objet"),
              const _BulletPoint(
                text:
                    "Mettre en demeure la personne de se présenter à la date et l’heure indiquées.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Coercition"),
              const _BulletPoint(text: "Pas de coercition."),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Signification / notification : "),
                  const TextSpan(text: "par huissier"),
                  const TextSpan(text: " ou notifié par "),
                  const TextSpan(
                    text: "O.P.J., A.P.J. ou agent de la force publique",
                  ),
                  const TextSpan(text: ", avec remise d’une copie."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // 3) Mandat d’amener
          // =========================
          _ConditionCard(
            title: "3 — Mandat d’amener",
            cardColor: cardFocus,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 122 alinéa 5 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : ordre donné à la force publique (par un magistrat).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Objet"),
              const _BulletPoint(
                text: "Conduire immédiatement la personne devant le magistrat.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Coercition"),
              const _BulletPoint(text: "Coercition possible."),
              const _BulletPoint(
                text:
                    "Introduction au domicile possible pendant les heures légales.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Délais / distance"),
              const _BulletPoint(
                text:
                    "Exécution à 200 km au plus : présentation immédiate au magistrat mandant OU rétention 24 h maximum.",
              ),
              const _BulletPoint(
                text:
                    "Exécution à plus de 200 km : présentation dans les 24 h au magistrat mandant OU au J.L.D. du lieu d’arrestation si conduite impossible dans les 24 h.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text: "Formalités : notification/exécution par ",
                  ),
                  const TextSpan(
                    text: "O.P.J., A.P.J. ou agent de la force publique",
                  ),
                  const TextSpan(
                    text: ", exhibition du mandat + remise d’une copie.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // 4) Mandat d’arrêt
          // =========================
          _ConditionCard(
            title: "4 — Mandat d’arrêt",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 122 alinéa 6 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : ordre donné à la force publique (par un magistrat).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Objet"),
              const _BulletPoint(
                text:
                    "Rechercher la personne (notamment en fuite / pouvant résider hors du territoire).",
              ),
              const _BulletPoint(
                text:
                    "La conduire devant le magistrat (avec possible conduite préalable à la maison d’arrêt indiquée).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Coercition"),
              const _BulletPoint(text: "Coercition possible."),
              const _BulletPoint(
                text:
                    "Introduction au domicile possible pendant les heures légales.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Délais / distance"),
              const _BulletPoint(
                text:
                    "Exécution à 200 km au plus : présentation dans les 24 h au JI mandant OU président du tribunal judiciaire / juge désigné.",
              ),
              const _BulletPoint(
                text:
                    "Exécution à plus de 200 km : présentation dans les 24 h au magistrat mandant OU au J.L.D. du lieu d’arrestation si conduite impossible dans les 24 h.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text: "Formalités : notification/exécution par ",
                  ),
                  const TextSpan(
                    text: "O.P.J., A.P.J. ou agent de la force publique",
                  ),
                  const TextSpan(
                    text: ", exhibition du mandat + remise d’une copie.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // 5) Mandat d’arrêt européen
          // =========================
          _ConditionCard(
            title: "5 — Mandat d’arrêt européen",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 695-11 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : MAE (mandat d’arrêt européen)."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Point de départ"),
              const _BulletPoint(
                text: "Mandat d’arrêt OU décision de condamnation.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Deux situations"),
              const _BulletPoint(
                text:
                    "Personne localisée : acceptation de l’État → mandat adressé à l’autorité judiciaire d’exécution.",
              ),
              const _BulletPoint(
                text:
                    "Personne non localisée : signalement diffusé (SIS-Schengen) et via Interpol.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "But",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Permet la recherche et l’arrestation dans un cadre européen, avec un circuit d’exécution judiciaire.",
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

class _ZoomableAssetImage extends StatelessWidget {
  const _ZoomableAssetImage({required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color border = isDark ? Colors.white24 : Colors.black12;
    final Color chipBg = isDark
        ? Colors.black54
        : Colors.white.withOpacity(.92);
    final Color chipText = isDark ? Colors.white : const Color(0xFF050505);

    return Semantics(
      button: true,
      label: 'Ouvrir $label en plein écran',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFullScreen(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(assetPath, fit: BoxFit.cover),
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
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in_rounded, size: 16, color: chipText),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: chipText,
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
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_full_rounded,
                        size: 16,
                        color: chipText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Plein écran",
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: chipText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fermer',
      barrierColor: Colors.black.withOpacity(.92),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 6.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.asset(assetPath),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: 'Fermer',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
