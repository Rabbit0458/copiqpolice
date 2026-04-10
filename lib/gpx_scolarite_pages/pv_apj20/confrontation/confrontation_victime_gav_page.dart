import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfrontationVictimeGavPage extends StatelessWidget {
  const ConfrontationVictimeGavPage({super.key});

  static const String routeName = '/gpx/pv_apj20/confrontation/victime_gav';

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
          tooltip: 'Retour',
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
            "PV — Confrontation victime / personne gardée à vue",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Aperçu (canevas)",
            cardColor: cardCloture,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Document unique : toutes les contradictions sur un même PV.",
              ),
              _IntroBullet(
                text: "L’enquêteur conserve la direction exclusive de l’acte.",
              ),
              _IntroBullet(
                text:
                    "Le temps de confrontation compte dans le déroulement de la garde à vue : l’heure de fin est indispensable.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Visa des articles — assistance de l’avocat (CPP)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Gardé à vue : "),
                TextSpan(
                  text: "articles 63-4-2 et 63-4-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Victime : "),
                TextSpan(
                  text: "article 63-4-5 du Code de procédure pénale",
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
                        "Ces visas doivent apparaître en tête du PV, avant le déroulement, afin de cadrer immédiatement le régime d’assistance de l’avocat.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images CANVA (recto / verso)
          _ConditionCard(
            title: "Modèle visuel (recto / verso)",
            cardColor: cardCloture,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath: 'assets/images/victime_gav_recto.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/victime_gav_verso.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre + instructions
          _ConditionCard(
            title: "1 → 3 — Lieu, instructions, cadre juridique",
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Lieu de rédaction"),
              _Paragraph(
                "Le PV indique le lieu exact de rédaction (service / commune), comme pour tout acte de procédure.",
              ),
              SizedBox(height: 12),
              _SubTitle("2) Instructions"),
              _Paragraph(
                "En flagrant délit, l’agent de police judiciaire agit conformément aux instructions reçues de l’officier de police judiciaire.\n"
                "En enquête préliminaire, il agit sous le contrôle de l’officier de police judiciaire.",
              ),
              SizedBox(height: 12),
              _SubTitle("3) Cadre juridique"),
              _Paragraph(
                "L’APJ situe l’acte : enquête de flagrance ou enquête préliminaire.\n"
                "Ce cadre doit être clair dès le début, car il conditionne le reste de la procédure.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Présents + assistants
          _ConditionCard(
            title: "5 → 6 — Assistants éventuels & personnes présentes",
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("5) Assistants éventuels"),
              _Paragraph(
                "Prévoir des effectifs d’assistance lorsque cela est nécessaire (risque d’incident, risque d’évasion, "
                "ou nombre important de personnes à confronter).",
              ),
              SizedBox(height: 12),
              _SubTitle("6) Personnes présentes"),
              _Paragraph(
                "Le PV précise l’identité des personnes mises en présence :\n"
                "• victime,\n"
                "• personne gardée à vue,\n"
                "et indique la présence ou l’absence de leurs avocats.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles
          _ConditionCard(
            title: "7 — Règles de bon déroulement",
            cardColor: cardOperation,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enquêteur conserve la direction exclusive de l’acte.\n"
                "Il peut mettre fin à la confrontation en cas de difficulté.\n"
                "Toute difficulté/incident doit être mentionné, qu’il entraîne ou non l’interruption.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Bonne pratique : annoncer les règles avant de commencer (calme, pas d’interruption, prise de parole uniquement sur invitation).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Opération + Q/R
          _ConditionCard(
            title: "8 → 9 — Opération & questions / réponses",
            cardColor: cardOperation,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("8) Opération"),
              _Paragraph(
                "Lecture des déclarations en présence de toutes les parties.\n"
                "La confrontation est une audition contradictoire : les personnes s’expriment uniquement sur les contradictions "
                "portées à leur connaissance.\n"
                "À aucun moment elles ne communiquent entre elles : elles s’adressent exclusivement à l’enquêteur.",
              ),
              SizedBox(height: 12),
              _SubTitle("9) Questions — réponses"),
              _Paragraph(
                "Deux modalités possibles (séparément ou conjointement) :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Question posée à tous : chaque personne répond à son tour.",
              ),
              _BulletPoint(
                text:
                    "Questions alternées : une question à chaque partie à tour de rôle, en présence de l’autre (seule la personne interrogée répond).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Objectif : traiter les contradictions point par point, de façon lisible et chronologique dans le PV.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Avocats
          _ConditionCard(
            title: "10 — Questions des avocats & observations écrites",
            cardColor: cardAvocats,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les avocats peuvent poser des questions à la personne gardée à vue et/ou à la victime à l’issue de la confrontation.\n"
                "L’enquêteur peut s’opposer aux questions si elles lui semblent de nature à nuire au bon déroulement de l’enquête : "
                "le refus doit être mentionné.\n"
                "Les avocats peuvent remettre des observations écrites à la fin de la confrontation.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si observations écrites : elles sont annexées et jointes au PV (voir point 12).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Clôture + annexe + avis OPJ
          _ConditionCard(
            title: "11 → 13 — Clôture, annexe, avis O.P.J.",
            cardColor: cardCloture,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("11) Énonciation terminale (clôture)"),
              _Paragraph(
                "Après lecture, l’APJ fait signer les personnes entendues.\n"
                "Il mentionne l’heure de fin de la confrontation : c’est indispensable car le temps de cette opération "
                "est pris en compte dans le déroulement de la garde à vue.",
              ),
              SizedBox(height: 12),
              _SubTitle("12) Annexe"),
              _Paragraph(
                "Le cas échéant, les observations écrites présentées par le ou les avocats sont jointes au présent PV.",
              ),
              SizedBox(height: 12),
              _SubTitle("13) Avis O.P.J."),
              _Paragraph(
                "L’O.P.J. doit être informé des déclarations faites lors de la confrontation et des éventuelles observations écrites.",
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
