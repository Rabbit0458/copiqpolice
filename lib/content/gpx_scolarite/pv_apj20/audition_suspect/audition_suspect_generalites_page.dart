import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuditionSuspectGeneralitesPage extends StatelessWidget {
  const AuditionSuspectGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/audition_suspect/generalites';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardPrep = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardConduite = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardEnreg = isDark
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
          tooltip: 'Retour',
        ),
        title: Text(
          "Audition du suspect",
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
            "Généralités & bonnes pratiques d’audition",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro courte (évite la répétition de titres)
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Recueillir des déclarations (et parfois des aveux) est un objectif fréquent, mais ils doivent être "
                "précis, circonstanciés et exploitables. La conduite d’une audition impose des règles : préparation, "
                "neutralité, sécurité, et traçabilité dans le procès-verbal.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ “Élément légal” en haut (ici : fondements juridiques cités dans tes notes)
          _ConditionCard(
            title: "Fondements juridiques (à citer au besoin)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law("Article L. 311-1 du CJPM"),
                const TextSpan(
                  text:
                      " : accompagnement possible du mineur par les représentants légaux ou un adulte approprié (si intérêt supérieur de l’enfant et sans préjudice à la procédure).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article L. 413-12 du CJPM"),
                const TextSpan(
                  text:
                      " : enregistrement audiovisuel obligatoire des interrogatoires des mineurs en garde à vue ou en retenue (systématique).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article 64-1 du Code de procédure pénale"),
                const TextSpan(
                  text:
                      " : enregistrement audiovisuel obligatoire des interrogatoires des majeurs en garde à vue en matière criminelle (avec exceptions encadrées).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I. Avant l'audition
          _ConditionCard(
            title: "I — Avant l’audition",
            cardColor: cardPrep,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Connaissance de l’affaire et de la personne"),
              _BulletPoint(
                text:
                    "Maîtriser le dossier : lecture préalable et attentive de toutes les pièces de procédure.",
              ),
              _BulletPoint(
                text:
                    "Préparer les questions : déterminer celles à poser et celles à éviter.",
              ),
              _BulletPoint(
                text:
                    "Recueillir des renseignements sur la personnalité du suspect (milieu, situation, relations…).",
              ),
              _BulletPoint(
                text:
                    "Conserver une approche objective : distinguer ce qui est avéré de ce qui reste incertain.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Conditions matérielles"),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "B — Conditions matérielles de l’audition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Le lieu"),
              _Paragraph(
                "Sauf rares exceptions, ne pas entendre une personne suspecte à son domicile ou sur son lieu de travail. "
                "Le lieu privilégié reste le bureau de l’enquêteur : calme, confidentialité, disponibilité, sans interventions parasites.",
              ),
              SizedBox(height: 12),
              _SubTitle("2) Nombre de participants"),
              _Paragraph(
                "En principe, l’audition est menée par un seul enquêteur. Un assistant peut être utile, mais n’intervient que si l’enquêteur l’y invite.",
              ),
              SizedBox(height: 12),
              _SubTitle("3) Règles de sécurité"),
              _BulletPoint(
                text:
                    "Prévenir toute évasion : surveillance des issues (portes, fenêtres…).",
              ),
              _BulletPoint(
                text:
                    "Retirer tout objet utilisable comme arme (ciseaux, presse-livres, etc.).",
              ),
              _BulletPoint(
                text:
                    "Armes de service : hors de la vue et hors d’atteinte du suspect.",
              ),
              _BulletPoint(
                text:
                    "Individu dangereux : menottage et/ou surveillance rapprochée par un fonctionnaire prêt à intervenir.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. Pendant l'audition
          _ConditionCard(
            title: "II — Pendant l’audition",
            cardColor: cardConduite,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Généralités"),
              _BulletPoint(
                text:
                    "Rester neutre et objectif : maintenir un climat de confiance, orienté vers la manifestation de la vérité.",
              ),
              _BulletPoint(text: "Ne rien révéler des éléments de l’enquête."),
              _BulletPoint(
                text:
                    "Mettre en évidence les contradictions qui apparaissent pendant l’entretien.",
              ),
              _BulletPoint(text: "Éviter les questions suggestives."),
              SizedBox(height: 12),
              _SubTitle("Le PV d’audition doit faire ressortir"),
              _BulletPoint(
                text:
                    "Les actes matériels correspondant aux éléments constitutifs de l’infraction et aux circonstances aggravantes éventuelles.",
              ),
              _BulletPoint(text: "L’intention coupable (élément moral)."),
              _BulletPoint(text: "Le mobile."),
              _BulletPoint(
                text:
                    "Les circonstances susceptibles d’excuser ou de justifier l’acte.",
              ),
              _BulletPoint(
                text:
                    "Le rôle de la personne interrogée et celui des éventuels coauteurs/complices.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les déclarations doivent être très circonstanciées et être corroborées par le travail d’enquête (avant ou après audition).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mineur suspecté
          _ConditionCard(
            title: "B — Le mineur suspecté",
            cardColor: cardPrep,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le mineur suspecté (retenu, gardé à vue ou entendu librement) peut être accompagné par ses représentants légaux ou par un adulte approprié ",
                ),
                _law("(article L. 311-1 du CJPM)"),
                const TextSpan(
                  text:
                      ", si l’enquêteur estime que c’est conforme à l’intérêt supérieur de l’enfant et que cela ne porte pas préjudice à la procédure.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "L’audition peut débuter sans ces personnes après un délai de 2 heures à compter du moment où elles ont été invitées.",
              ),
              const _BulletPoint(
                text:
                    "Leur présence (ou absence) doit être mentionnée au procès-verbal.",
              ),
              const _BulletPoint(
                text:
                    "Elles ne posent pas de questions et ne formulent pas d’observations.",
              ),
              const _BulletPoint(
                text:
                    "Si elles gênent, mettre fin à l’accompagnement en le mentionnant dans le PV.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. Enregistrement audiovisuel
          _ConditionCard(
            title: "III — Enregistrement audiovisuel des interrogatoires",
            cardColor: cardEnreg,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Mineurs en garde à vue / retenue"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les interrogatoires des mineurs placés en garde à vue ou en retenue font obligatoirement l’objet d’un enregistrement audiovisuel ",
                ),
                _law("(article L. 413-12 du CJPM)"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Enregistrement systématique, quel que soit le cadre d’enquête.",
              ),
              const _BulletPoint(
                text:
                    "Le mineur (ou son représentant légal) n’a pas à être informé et aucun accord n’est requis.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si impossibilité technique : aviser immédiatement le procureur de la République ou le juge d’instruction, et préciser la nature de l’impossibilité dans le PV.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Majeurs en garde à vue – matière criminelle"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les interrogatoires des personnes placées en garde à vue pour crime font obligatoirement l’objet d’un enregistrement audiovisuel ",
                ),
                _law("(article 64-1 du Code de procédure pénale)"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Dérogation possible si le nombre de GAV simultanées empêche l’enregistrement : l’OPJ saisit sans délai le procureur, qui désigne par décision écrite versée au dossier les auditions non enregistrées.",
              ),
              const _BulletPoint(
                text:
                    "Dérogation possible en cas d’impossibilité technique : procureur immédiatement avisé + PV précisant la nature de l’impossibilité.",
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
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.08);

    final Color shadow = Colors.black.withOpacity(isDark ? .28 : .12);

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
      label: "Image zoomable",
      hint: "Touchez pour ouvrir, pincez pour zoomer, glissez pour déplacer",
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
        ? Colors.black.withOpacity(.92)
        : Colors.black.withOpacity(.86);

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
    final Color fg = Colors.white.withOpacity(.95);
    final Color bg = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.white.withOpacity(.12);

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
                  "Aperçu",
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
    final Color fg = Colors.white.withOpacity(.92);
    final Color bg = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.white.withOpacity(.12);

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
                "Pincez pour zoomer • Glissez pour déplacer • Tapez pour fermer",
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
        ? Colors.white.withOpacity(.12)
        : Colors.black.withOpacity(.06);
    final Color fg = isDark ? Colors.white : Colors.black.withOpacity(.78);

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
        border: Border.all(color: Colors.white.withOpacity(.12), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
