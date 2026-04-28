import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RefusVerificationsGPXPage extends StatelessWidget {
  const RefusVerificationsGPXPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/refus_verifications';

  static const Color _lawRed = Color(0xFFE53935);

  // ⚠️ IMPORTANT : pas de copyWith sur TextSpan (sinon erreur).
  // Donc on crée nos TextSpan "loi" directement :
  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProc = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF202632)
        : const Color(0xFFF2F2FF);

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
    final Color accentIndigo = isDark
        ? const Color(0xFF9FA8DA)
        : const Color(0xFF303F9F);
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
          "Alcool & stupéfiants",
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
            "PV — Refus de se soumettre aux vérifications",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro (objectif)
          _ConditionCard(
            title: "Objectif du canevas",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas sert à structurer le procès-verbal de conduite au poste d’un individu ayant refusé "
                "de se soumettre aux vérifications tendant à établir l’état alcoolique et/ou l’usage de stupéfiants. "
                "Il aide à rédiger de manière complète, pédagogique et juridiquement sécurisée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images (CANVA)
          _ConditionCard(
            title: "Canevas (visuels)",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath: 'assets/images/refus_verifications_recto.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/refus_verifications_verso.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le refus de se soumettre aux vérifications constitue un délit dès lors qu’une injonction régulière a été faite au conducteur : ",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Alcool — "),
                  _lawSpan("Article L. 234-8 du Code de la route"),
                  const TextSpan(
                    text:
                        " : refus de se soumettre aux vérifications tendant à établir l’état alcoolique.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Stupéfiants — "),
                  _lawSpan("Article L. 235-3 du Code de la route"),
                  const TextSpan(
                    text:
                        " : refus de se soumettre aux analyses ou examens en vue d’établir l’usage de stupéfiants.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Important : le refus de dépistage (souffle/salivaire) n’est pas, à lui seul, une infraction pénale ; il déclenche l’obligation de se soumettre aux vérifications : ",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawSpan("Article L. 234-4 du Code de la route"),
                const TextSpan(text: " (alcool) et "),
                _lawSpan("Article L. 235-2 du Code de la route"),
                const TextSpan(text: " (stupéfiants)."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (3 éléments)
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Une injonction régulière de se soumettre"),
              _Paragraph(
                "Le délit suppose que le conducteur ait été informé de l’obligation de se soumettre aux vérifications "
                "et qu’une injonction claire lui ait été faite (vérifications alcool et/ou stupéfiants).",
              ),
              SizedBox(height: 10),
              _SubTitle("B) Un refus caractérisé et réitéré"),
              _Paragraph(
                "Le refus doit être persistant et déterminé, de manière à faire apparaître la volonté délibérée "
                "du conducteur de refuser les vérifications. La réitération de l’injonction et la réitération du refus "
                "doivent être décrites précisément dans le PV.",
              ),
              SizedBox(height: 10),
              _SubTitle("C) Constatations utiles à consigner"),
              _Paragraph(
                "Consigner : les propos exacts (style direct si possible), l’attitude, les circonstances de temps et de lieu, "
                "l’information donnée au conducteur, et toute mention utile permettant d’établir la réalité et la constance du refus.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ces délits sont intentionnels : il faut caractériser la volonté de refuser. "
                "Le PV doit faire ressortir que le conducteur a compris la demande, a été informé des conséquences, "
                "et a néanmoins maintenu son refus.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Bon réflexe rédactionnel : noter la réitération de l’injonction + la réitération du refus pour matérialiser l’intention.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Procédure / canevas détaillé
          _ConditionCard(
            title: "IV — Canevas de rédaction (plan complet)",
            cardColor: cardProc,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de saisine"),
              const _Paragraph(
                "Mentionner l’endroit exact où se situe l’équipage (commune, voie, point de repère).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2) Instructions"),
              const _Paragraph(
                "Indiquer que l’équipage, en patrouille, agit conformément aux instructions permanentes du chef de service "
                "(ou selon les instructions reçues).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("3) Assistants"),
              const _Paragraph(
                "Citer les fonctionnaires accompagnants et préciser la tenue (uniforme, tenue civile, port du brassard POLICE).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("4) Mission"),
              const _Paragraph("Indiquer le but de la mission initiale."),
              const SizedBox(height: 10),

              const _SubTitle("5) Interception du véhicule"),
              const _Paragraph(
                "Préciser le cadre :\n"
                "• suite à la constatation d’une infraction au code de la route (relater les faits observés), ou\n"
                "• suite à un contrôle routier sans infraction préalable, ou\n"
                "• suite à un contrôle préventif (initiative de l’agent / réquisition du procureur de la République).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("6) Contrôle"),
              const _Paragraph(
                "Mentionner le contrôle : pièces afférentes à la conduite et à la circulation, obligation d’assurance "
                "(consultation du fichier des véhicules assurés), et identification en style indirect (état civil + adresse), "
                "à l’exclusion de tout autre élément de personnalité (familial/professionnel).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("7) Dépistages (alcool et stupéfiants)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Rappeler que le refus de dépistage n’est pas une infraction pénale, mais entraîne l’obligation de se soumettre aux vérifications (",
                ),
                TextSpan(
                  text: "Article L. 234-4 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "Article L. 235-2 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("8) Information"),
              const _Paragraph(
                "En cas de refus du dépistage, préciser que le conducteur est informé que ce refus entraîne l’obligation "
                "de procéder aux vérifications destinées à :\n"
                "• établir un état alcoolique,\n"
                "• rechercher et confirmer la présence d’un ou plusieurs produits stupéfiants.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("9) Déclarations"),
              const _Paragraph(
                "Consigner les déclarations du contrevenant sur son premier refus de se soumettre aux vérifications "
                "(style direct si possible).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("10) Réitération de l’injonction"),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Refus alcool — "),
                  TextSpan(
                    text: "Article L. 234-8 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " : puni de 2 ans d’emprisonnement et de 4 500 € d’amende.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Refus stupéfiants — "),
                  TextSpan(
                    text: "Article L. 235-3 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " : puni de 2 ans d’emprisonnement et de 4 500 € d’amende.",
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _SubTitle("11) Réitération du refus"),
              const _Paragraph(
                "Le refus doit être persistant et déterminé : il doit faire apparaître la volonté délibérée du conducteur "
                "de refuser les vérifications. Détailler précisément.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("12) Cadre juridique"),
              const _Paragraph(
                "Dès que les délits sont caractérisés, l’action de l’agent de police judiciaire se situe dans le cadre "
                "du flagrant délit (à qualifier selon la situation).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("13) Retour au service"),
              const _Paragraph(
                "Mentionner que la personne appréhendée accepte d’accompagner de son plein gré les fonctionnaires de police.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("14) Palpation de sécurité"),
              const _Paragraph(
                "Uniquement si nécessaire (temps/lieu/risque). Si découverte d’objets : situer, décrire, présenter à la personne "
                "qui peut faire une brève déclaration sur l’appartenance (style direct) sans que cela constitue une audition. "
                "Objets appréhendés aux fins de remise à l’OPJ (D.R.D.A).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("15) Compte-rendu OPJ"),
              const _Paragraph(
                "Compte-rendu verbal à l’OPJ. Mentionner les instructions éventuellement données.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("16) Énonciation terminale (clôture)"),
              const _Paragraph(
                "Signature : si déclarations au style direct, la personne doit signer. "
                "Si déclarations au style indirect, pas de signature. L’heure est facultative.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("17) Présentation à l’OPJ"),
              const _Paragraph(
                "Présentation de l’individu en précisant l’heure. Compte-rendu verbal et éventuelle remise d’objets appréhendés. "
                "Mentionner les instructions reçues.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("18) Mention — fichiers"),
              const _Paragraph(
                "Recherches administratives (FPR, SNPC). Préciser que les recherches ont été effectuées et que la personne ne fait l’objet d’aucune recherche.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("19) Mention — immobilisation"),
              const _Paragraph(
                "Il peut être procédé d’office à l’immobilisation du véhicule pendant la durée de rétention du permis de conduire. "
                "Elle est levée dès qu’un conducteur qualifié (proposé par le conducteur / l’accompagnateur de l’élève conducteur / "
                "ou le propriétaire) peut assurer la conduite. Remettre un exemplaire de la fiche d’immobilisation.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("20) Mention — avis de rétention"),
              const _Paragraph(
                "Remettre un exemplaire de l’avis de rétention du permis de conduire au conducteur.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative / complicité
          _ConditionCard(
            title: "V — Répression, tentative & complicité",
            cardColor: cardRep,
            accent: accentIndigo,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines principales (rappel)"),
              _Paragraph.rich([
                const TextSpan(text: "Refus alcool : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 4 500 € d’amende — ",
                ),
                TextSpan(
                  text: "Article L. 234-8 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Refus stupéfiants : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 4 500 € d’amende — ",
                ),
                TextSpan(
                  text: "Article L. 235-3 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text:
                    "Tentative : en pratique, le refus se consomme instantanément ; la tentative est rarement pertinente à caractériser.",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Complicité : possible en théorie, mais à apprécier au cas par cas selon l’aide ou l’assistance apportée au refus.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Conseil rédactionnel : rester factuel (paroles, injonctions, refus) et bien chronologiser. "
                        "C’est ce qui rend le PV “béton” et pédagogique.",
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
