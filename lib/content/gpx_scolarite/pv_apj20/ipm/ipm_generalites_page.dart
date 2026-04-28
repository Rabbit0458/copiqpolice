import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IpmGeneralitesPage extends StatelessWidget {
  const IpmGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/ipm/generalites';

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
    final Color cardScope = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardProc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNota = isDark
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
          "IPM",
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
            "L’ivresse publique et manifeste",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / cadre général
          _ConditionCard(
            title: "Définition & objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Toute personne trouvée en état d’ivresse dans les lieux publics peut, par mesure de police, "
                "être conduite à ses frais par les forces habilitées (PN, GN, PM, gardes champêtres), après "
                "un examen médical attestant que son état de santé ne s’y oppose pas, dans le service le plus proche "
                "ou en chambre de sûreté, afin d’y être retenue jusqu’à ce qu’elle ait recouvré la raison.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (comme tu veux)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 3341-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : encadre la prise en charge d’une personne en état d’ivresse dans un lieu public, "
                      "la conduite dans un service/une chambre de sûreté, et la possibilité de remise à un tiers lorsque l’audition n’est pas nécessaire immédiatement.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 3353-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit l’infraction d’ivresse publique et manifeste et la réprime par l’amende prévue pour les contraventions de 2ᵉ classe.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Champ d'application (conditions de l'IPM)
          _ConditionCard(
            title: "II — Champ d’application",
            cardColor: cardScope,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Conditions cumulatives"),
              const _BulletPoint(
                text:
                    "Ivresse manifeste : évidente, constatable par tout le monde (signes extérieurs et troubles du comportement).",
              ),
              const _BulletPoint(
                text:
                    "Ivresse publique : constatée dans un lieu public ou un lieu privé ouvert au public (place, route, gare, café, etc.).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Appréciation de l’ivresse"),
              const _Paragraph(
                "L’ivresse s’apprécie indépendamment de toute mesure d’imprégnation alcoolique : "
                "elle résulte du comportement de la personne et de la constatation de signes extérieurs "
                "mettant en évidence un état d’ivresse manifeste.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "NOTA",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les critères ne doivent pas être nécessairement réunis de manière cumulative : "
                        "un trouble du comportement anormal peut suffire à caractériser l’ivresse manifeste.",
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const _SubTitle("Exemples de signes caractéristiques"),
              const _BulletPoint(text: "Haleine sentant fortement l’alcool."),
              const _BulletPoint(text: "Défaut d’équilibre."),
              const _BulletPoint(
                text: "Élocution bégayante / trouble de l’expression.",
              ),
              const _BulletPoint(
                text: "Comportement anormal et incohérence des propos tenus.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Attention",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Cette mesure concerne les personnes majeures. Les mineurs ne doivent pas être placés en chambre de sûreté.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conduite à tenir (obligations)
          _ConditionCard(
            title: "III — Conduite à tenir",
            cardColor: cardProc,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’IPM est une mesure de police administrative : son but est de prévenir les atteintes à l’ordre public "
                "et de protéger la personne concernée (personne vulnérable).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Deux obligations fondamentales"),
              const _BulletPoint(
                text: "Devoir de protection et d’assistance aux personnes.",
              ),
              const _BulletPoint(text: "Obligation de rendre compte."),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’équipage intervenant doit rendre compte régulièrement au C.I.C. de l’évolution de l’intervention "
                "(contrôle de l’individu, placement sous responsabilité d’un tiers, prise en charge et conduite à l’hôpital, etc.). "
                "La main courante informatisée doit également être renseignée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Prise en charge (A / B)
          _ConditionCard(
            title: "IV — Prise en charge",
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Prise en charge par les fonctionnaires"),
              const _Paragraph(
                "Retirée sans brutalité de la vue du public et soumise à une palpation de sécurité, la personne "
                "peut être prise en charge selon deux modalités principales :",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Conduite à l’hôpital : délivrance d’un certificat médical de non-admission (ou admission si nécessaire).",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "L’examen médical permet de déterminer si l’intéressé peut être maintenu dans les locaux de police "
                "ou si son état de santé nécessite une admission à l’hôpital. Si l’état est compatible avec le maintien, "
                "un certificat médical de non-admission est délivré à l’issue de l’examen.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Certaines situations peuvent mimer l’ivresse (choc, prise de médicaments, malaise). "
                        "L’APJ n’est pas qualifié pour poser un diagnostic : prudence (ex. malaise hypoglycémique, symptômes proches du coma éthylique).",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _BulletPoint(
                text:
                    "Conduite au commissariat : présentation au chef de poste et mise en œuvre des mesures de sécurité.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Mesures de sécurité (chef de poste)"),
              const _BulletPoint(
                text:
                    "Fouille de sécurité : retrait des objets/accessoires dangereux (ceinture, lacets, médicaments…). "
                    "La fouille ne suppose pas un déshabillage complet ; détection électronique possible si besoin.",
              ),
              const _BulletPoint(
                text:
                    "Inventaire au registre d’écrou : objets écartés, identité, heure de prise en charge.",
              ),
              const _BulletPoint(
                text:
                    "Placement en chambre de sûreté : sous responsabilité du chef de poste, surveillance constante.",
              ),
              const _BulletPoint(
                text:
                    "Rondes régulières : intervalle maximum de 15 minutes (feuille de rondes : heures, signature, observations).",
              ),
              const _BulletPoint(
                text: "Au moindre signe d’alerte : appel à un médecin.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Fin de mesure"),
              const _Paragraph(
                "La retenue en chambre de sûreté prend fin après le complet dégrisement, c’est-à-dire lorsque les caractéristiques "
                "ayant révélé l’ivresse ont disparu. Les effets sont restitués et une décharge est faite par émargement du registre d’écrou.",
              ),
              const SizedBox(height: 14),
              const _SubTitle("B) Prise en charge par un tiers"),
              const _Paragraph(
                "Lorsque l’audition n’est pas nécessaire immédiatement après le recouvrement de la raison "
                "(ex. infraction connexe), la personne peut être placée sous la responsabilité d’un tiers qui se porte garante.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Fondement : "),
                TextSpan(
                  text:
                      "Article L. 3341-1 alinéa 2 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Si la remise à un tiers intervient avant l’examen médical, la remise d’un certificat de non-admission ne sera pas sollicitée.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Rédaction PV
          _ConditionCard(
            title: "V — Rédaction du procès-verbal",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La constatation de l’ivresse publique et manifeste (contravention de 2ᵉ classe) doit donner lieu à la rédaction d’un PV ordinaire, "
                      "faisant ressortir précisément tous les signes extérieurs caractérisant l’ivresse. — ",
                ),
                TextSpan(
                  text: "Article R. 3353-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La personne est entendue sur procès-verbal séparé : soit à l’issue de la période de dégrisement, "
                "soit ultérieurement si elle a été remise à un tiers. Il s’agit d’une audition libre.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’audition libre est précédée de la notification des droits listés à ",
                ),
                TextSpan(
                  text: "l’article 61-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ", à l’exception du droit d’être assisté d’un avocat (selon le canevas IPM fourni).",
                ),
              ]),
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
