import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVVictimeViolencesConjugalesPage extends StatelessWidget {
  const PVVictimeViolencesConjugalesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/violences_conjugales/pv_victime';

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
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
            "Canevas & PV de plainte d’une victime de violences conjugales",
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
            title: "Objectif",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette page regroupe un canevas opérationnel et des modèles de procès-verbaux utiles "
                "pour la prise de plainte d’une victime de violences conjugales. "
                "Le but : une procédure claire, chronologique, exploitable, et une prise en charge adaptée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (articles en rouge)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Obligation de recevoir les plaintes — "),
                TextSpan(
                  text: "article 15-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Récépissé / copie sur demande — "),
                TextSpan(
                  text: "article 15-3 alinéa 2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Selon la situation, préciser le cadre juridique : enquête de flagrance "
                        "(articles 53 et suivants) ou enquête préliminaire (articles 75 et suivants).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Canevas (pratique)
          _ConditionCard(
            title: "II — Canevas (prise de plainte)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Accueil & confidentialité"),
              _BulletPoint(
                text:
                    "Installer la victime dans un lieu calme, confidentiel et sécurisant, dans la mesure du possible.",
              ),
              _BulletPoint(
                text:
                    "Autoriser qu’elle soit accompagnée (si elle le souhaite), tout en veillant à la liberté de parole.",
              ),
              SizedBox(height: 12),

              _SubTitle("2) Recueil du récit"),
              _BulletPoint(
                text:
                    "Commencer par un récit libre, puis questions ouvertes (ne jamais suggérer).",
              ),
              _BulletPoint(
                text:
                    "Faire ressortir : chronologie, fréquence, contexte, menaces, témoins, preuves, blessures, retentissement psychologique.",
              ),
              SizedBox(height: 12),

              _SubTitle("3) Points essentiels à qualifier"),
              _BulletPoint(
                text:
                    "Lien victime/auteur : conjoint, ex-conjoint, concubin, ex-concubin, partenaire PACS, ex-partenaire…",
              ),
              _BulletPoint(
                text:
                    "Caractéristiques : violences physiques / sexuelles / psychologiques / verbales / économiques, contrôle, harcèlement.",
              ),
              _BulletPoint(
                text:
                    "Présence d’enfants, grossesse, isolement, dépendance financière, armes, addictions, antécédents.",
              ),
              SizedBox(height: 12),

              _SubTitle("4) Diligences"),
              _BulletPoint(
                text:
                    "Selon le contexte : avis OPJ / parquet, réquisition médicale, clichés, consultation fichiers (TAJ, FPR, etc.).",
              ),
              _BulletPoint(
                text:
                    "Proposer / organiser la mise en sécurité (proche, foyer, 115, dispositifs locaux).",
              ),
              SizedBox(height: 12),

              _SubTitle("5) Clôture"),
              _BulletPoint(
                text:
                    "Lecture + signature. Mentionner tout refus (ITT, mise en sécurité, etc.) en procédure.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Élément moral (pédagogique, sans inventer l’infraction précise)
          _ConditionCard(
            title: "III — Élément moral (rappel)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pour la plupart des infractions, l’élément moral correspond à la volonté de commettre les faits "
                "(intention), ou à la conscience de l’acte et de ses conséquences. "
                "En matière de violences au sein du couple, l’analyse s’appuie sur les déclarations, le contexte, "
                "la répétition, les menaces, le contrôle, et tout élément objectif (messages, témoins, certificats…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Circonstances aggravantes (générique + visuel)
          _ConditionCard(
            title: "IV — Circonstances aggravantes (à rechercher)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Lien conjugal / ex-conjugal / concubinage / PACS (cadre violences conjugales).",
              ),
              _BulletPoint(
                text:
                    "Présence de mineurs, violences en leur présence, menaces envers eux.",
              ),
              _BulletPoint(
                text:
                    "Usage ou détention d’arme, alcool/drogues, escalade de fréquence ou de gravité.",
              ),
              _BulletPoint(
                text:
                    "Vulnérabilité particulière de la victime (grossesse, handicap, isolement, dépendance).",
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Ces éléments orientent la qualification et les mesures de protection (TGD, ordonnance de protection, etc.) "
                        "selon les consignes locales et l’autorité judiciaire.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V — Tentative & complicité (générique, sans copyWith)
          _ConditionCard(
            title: "V — Tentative & complicité (rappel)",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Tentative"),
              const _Paragraph(
                "La tentative est punissable lorsqu’un commencement d’exécution a eu lieu et que l’infraction "
                "n’a pas été consommée en raison de circonstances indépendantes de la volonté de l’auteur "
                "(selon la qualification retenue).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Complicité"),
              _Paragraph.rich([
                const TextSpan(text: "La complicité est réprimée par "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (aide/assistance, provocation, instructions…).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Modèles (images)
          _ConditionCard(
            title: "VI — Modèles & canevas (images)",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Appuie sur l’image pour l’ouvrir en plein écran. Tu peux zoomer et tourner.",
              ),
              SizedBox(height: 10),

              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif1.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif2.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif3.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif4.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif5.png'),
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
