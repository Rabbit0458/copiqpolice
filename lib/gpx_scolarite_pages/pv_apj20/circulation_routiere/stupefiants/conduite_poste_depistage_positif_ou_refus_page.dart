import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConduitePosteDepistagePositifOuRefusPage extends StatelessWidget {
  const ConduitePosteDepistagePositifOuRefusPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus';

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
    final Color cardGuide = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardVigilance = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardAnnexes = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Stupéfiants",
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
            "Conduite au poste — dépistage positif ou refus",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Objet",
            cardColor: cardAnnexes,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Canevas de rédaction d’un procès-verbal relatif à la conduite au poste d’un individu "
                "à la suite d’un dépistage de l’usage de stupéfiants positif, ou en cas de refus de subir le dépistage. "
                "Objectif : structurer une procédure claire, complète et pédagogiquement irréprochable.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre juridique en haut (article(s) en rouge)
          _ConditionCard(
            title: "I — Cadre juridique (rappels utiles)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les vérifications et prélèvements peuvent être réalisés par un professionnel habilité. ",
                ),
                TextSpan(
                  text: "Article R. 235-3 du Code de la route",
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
                      "Selon les cas, le prélèvement sanguin et/ou l’organisation des actes peuvent relever d’autres habilitations prévues par les textes. ",
                ),
                TextSpan(
                  text: "Article R. 235-6 du Code de la route",
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
                      "Un étudiant en médecine peut intervenir dans certains cadres spécifiques. ",
                ),
                TextSpan(
                  text: "Article L. 4131-2 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le refus de dépistage n’est pas, à lui seul, une infraction pénale : ",
                  ),
                  const TextSpan(
                    text:
                        "il entraîne l’obligation de se soumettre aux vérifications prévues par les textes.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Canevas du procès-verbal (structure conseillée)",
            cardColor: cardGuide,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Lieu de saisine"),
              _BulletPoint(
                text:
                    "Mentionner l’endroit exact où se situe l’équipage (adresse/secteur, contexte immédiat).",
              ),
              SizedBox(height: 10),

              _SubTitle("2) Instructions"),
              _BulletPoint(
                text:
                    "Si PV de saisine en patrouille : agir conformément aux instructions permanentes du chef de service.",
              ),
              SizedBox(height: 10),

              _SubTitle("3) Assistants"),
              _BulletPoint(
                text:
                    "Lister les fonctionnaires accompagnants (noms/qualités) et préciser la tenue (uniforme, tenue civile, port du brassard POLICE).",
              ),
              SizedBox(height: 10),

              _SubTitle("4) Mission"),
              _BulletPoint(
                text:
                    "Indiquer clairement le but de la mission initiale (patrouille, sécurisation, prévention, contrôle ciblé, etc.).",
              ),
              SizedBox(height: 10),

              _SubTitle("5) Interception du véhicule"),
              _Paragraph(
                "Préciser le motif exact de l’interception, en choisissant la branche pertinente :",
              ),
              _BulletPoint(
                text:
                    "Suite à la constatation d’une infraction au Code de la route (relater les faits observés constitutifs).",
              ),
              _BulletPoint(
                text:
                    "Suite à un contrôle routier sans infraction préalable (contrôle général).",
              ),
              _BulletPoint(
                text:
                    "Suite à un contrôle préventif de l’usage de stupéfiants : à l’initiative de l’agent ou sur réquisition du procureur de la République.",
              ),
              SizedBox(height: 10),

              _SubTitle("6) Contrôle"),
              _BulletPoint(
                text:
                    "Contrôler les pièces afférentes à la conduite et à la circulation du véhicule.",
              ),
              _BulletPoint(
                text:
                    "Vérifier l’obligation d’assurance (consultation du Fichier des Véhicules Assurés pour véhicules immatriculés).",
              ),
              _BulletPoint(
                text:
                    "Identifier la personne contrôlée en style indirect : état civil et adresse uniquement (exclure situation familiale/professionnelle).",
              ),
              _Paragraph(
                "Si contrôle motivé par une infraction : relater les faits justifiant le dépistage.",
              ),
              SizedBox(height: 10),

              _SubTitle("7) Dépistage"),
              _BulletPoint(
                text:
                    "Si résultat positif : préciser la/les famille(s) concernée(s) (cannabiniques, amphétaminiques, cocaïniques, opiacés).",
              ),
              _BulletPoint(
                text:
                    "Si refus : rappeler que le refus entraîne l’obligation de se soumettre aux vérifications.",
              ),
              SizedBox(height: 10),

              _SubTitle("8) Information"),
              _BulletPoint(
                text:
                    "Le conducteur peut être retenu le temps strictement nécessaire à l’exécution du dépistage et des vérifications.",
              ),
              _BulletPoint(
                text:
                    "Si dépistage positif ou refus : informer le conducteur que son refus implique de procéder aux vérifications.",
              ),
              SizedBox(height: 10),

              _SubTitle("9) Palpation de sécurité"),
              _BulletPoint(
                text:
                    "Ne pas pratiquer de manière systématique : agir avec respect et discernement.",
              ),
              _BulletPoint(
                text:
                    "La réaliser seulement si les circonstances de temps/lieu le justifient, pour vérifier l’absence d’objet dangereux (pour lui-même ou autrui).",
              ),
              SizedBox(height: 10),

              _SubTitle("10) Retour au service"),
              _BulletPoint(
                text:
                    "Mentionner que la personne accepte d’accompagner de son plein gré les fonctionnaires de police.",
              ),
              _BulletPoint(
                text:
                    "Effectuer un compte-rendu radio au centre d’information et de commandement.",
              ),
              SizedBox(height: 10),

              _SubTitle("11) Énonciation terminale (clôture)"),
              _BulletPoint(text: "L’indication de l’heure est facultative."),
              SizedBox(height: 10),

              _SubTitle("12) Mentions — recherches administratives"),
              _BulletPoint(
                text:
                    "Indiquer les recherches (F.P.R., S.N.P.C.) et préciser que la personne ne fait l’objet d’aucune recherche, le cas échéant.",
              ),
              SizedBox(height: 10),

              _SubTitle("13) Mentions — immobilisation du véhicule"),
              _BulletPoint(
                text:
                    "Lever l’immobilisation dès qu’un conducteur qualifié (proposé par le conducteur, l’accompagnateur d’élève conducteur, ou le propriétaire) peut assurer la conduite.",
              ),
              _BulletPoint(
                text:
                    "Remettre un exemplaire de la fiche d’immobilisation au conducteur.",
              ),
              SizedBox(height: 10),

              _SubTitle("14) Mentions — rétention du permis de conduire"),
              _BulletPoint(
                text:
                    "Remettre un exemplaire de l’avis de rétention du permis de conduire au conducteur.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Points de vigilance (qualité rédactionnelle)",
            cardColor: cardVigilance,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _BulletPoint(
                text:
                    "Rester factuel : décrire ce qui est constaté/observé, sans jugement de valeur.",
              ),
              const _BulletPoint(
                text:
                    "Respecter le style indirect pour l’identité (état civil + adresse uniquement).",
              ),
              const _BulletPoint(
                text:
                    "Structurer : un paragraphe = une idée (ça rend le PV lisible et “solide”).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Astuce : lorsque tu évoques un fondement juridique, écris-le toujours sous la forme complète (ex. ",
                  ),
                  TextSpan(
                    text: "Article R. 235-3 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ") et garde cette référence cohérente dans tout le PV.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Annexes (visuels)",
            cardColor: cardAnnexes,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Tu peux zoomer sur les canevas pour relire et vérifier les formulations.",
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath:
                    'assets/images/conduite_poste_depistage_positif_ou_refus_recto.png',
                heroTag: 'conduite_poste_recto',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath:
                    'assets/images/conduite_poste_depistage_positif_ou_refus_verso.png',
                heroTag: 'conduite_poste_verso',
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
