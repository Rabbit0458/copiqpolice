import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PvControleIdentitePage extends StatelessWidget {
  const PvControleIdentitePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/controle_identite/pv_controle_identite';

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
    final Color cardOp = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardProc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPoints = isDark
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
          "PV — Contrôle & vérification d’identité",
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
            "Canevas de procès-verbal de contrôle d’identité\nsuivi d’une vérification d’identité",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Base légale (à viser dans le PV)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Contrôle d’identité : "),
                TextSpan(
                  text: "art. 78-2 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (selon l’alinéa correspondant aux constatations) ou ",
                ),
                TextSpan(
                  text: "art. 78-2-1 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (locaux à usage professionnel)."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Vérification d’identité : "),
                TextSpan(
                  text: "art. 78-3 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (si la personne ne justifie pas ou refuse de décliner son identité).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Formule obligatoire : l’A.P.J agit « sur l’ordre et sous la responsabilité » d’un O.P.J. "
                        "Elle doit figurer au PV, sous peine de nullité.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images PV (recto/verso) avec plein écran + zoom
          _ConditionCard(
            title: "Modèles Canva (recto / verso)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Appuie sur une image pour l’ouvrir en plein écran et zoomer.",
              ),
              const SizedBox(height: 12),
              _ZoomableImageTile(
                assetPath: 'assets/images/pv_canva_ci_recto.png',
                heroTag: 'pv_ci_recto',
                label: 'Recto',
              ),
              const SizedBox(height: 10),
              _ZoomableImageTile(
                assetPath: 'assets/images/pv_canva_ci_verso.png',
                heroTag: 'pv_ci_verso',
                label: 'Verso',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Lieu de saisine / instructions / assistants / mission
          _ConditionCard(
            title: "1 → 4 — Saisine, instructions, assistants, mission",
            cardColor: cardOp,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de saisine"),
              const _IntroBullet(
                text:
                    "Mentionner l’endroit exact où se situe l’équipage (adresse, secteur, repère utile).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("2) Instructions"),
              const _IntroBullet(
                text:
                    "PV de saisine : l’équipage en patrouille agit conformément aux instructions permanentes du chef de service.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("3) Assistants"),
              const _IntroBullet(
                text:
                    "Mentionner les fonctionnaires accompagnants (nom/grade/service).",
              ),
              const _IntroBullet(
                text:
                    "Préciser la tenue : uniforme, tenue bourgeoise, port du brassard police.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("4) Mission"),
              const _IntroBullet(
                text:
                    "Indiquer le but de la mission initiale (patrouille, sécurisation, présence dissuasive, réquisition…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Constatations + cadres possibles
          _ConditionCard(
            title: "5 — Constatations (justifier le contrôle)",
            cardColor: cardProc,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Relater de manière précise les faits observés en faisant ressortir les éléments "
                "objectifs qui justifient le contrôle d’identité.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Cadres possibles à mentionner"),
              _BulletPoint(
                text:
                    "Raisons plausibles de soupçonner : infraction commise ou tentée — art. 78-2 al. 2 C.P.P.",
              ),
              _BulletPoint(
                text:
                    "Préparation d’un crime ou d’un délit — art. 78-2 al. 3 C.P.P.",
              ),
              _BulletPoint(
                text:
                    "Renseignements utiles à une enquête crime/délit — art. 78-2 al. 4 C.P.P.",
              ),
              _BulletPoint(
                text:
                    "Violation d’obligations/interdictions (CJ, ARSE, peine/mesure) — art. 78-2 al. 5 C.P.P.",
              ),
              _BulletPoint(
                text:
                    "Recherches ordonnées par une autorité judiciaire — art. 78-2 al. 6 C.P.P.",
              ),
              const SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Réquisitions du procureur (infractions, lieux, périodes) — art. 78-2 al. 7 C.P.P.",
              ),
              _BulletPoint(
                text:
                    "Prévenir une atteinte à l’ordre public (menace caractérisée) — art. 78-2 al. 8 C.P.P.",
              ),
              _BulletPoint(
                text: "Zone frontière — art. 78-2 al. 9 à 17 C.P.P.",
              ),
              _BulletPoint(
                text:
                    "Locaux professionnels (réquisitions) — art. 78-2-1 C.P.P.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Instructions / visa article
          _ConditionCard(
            title: "6 → 7 — Formule OPJ & visa de l’article",
            cardColor: cardPoints,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("6) Instructions (formule obligatoire)"),
              _Paragraph.rich([
                const TextSpan(text: "Le PV doit mentionner : "),
                TextSpan(
                  text: "« sur l’ordre et sous la responsabilité »",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0D47A1),
                  ),
                ),
                const TextSpan(text: " d’un O.P.J. (obligatoire au PV)."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("7) Visa de l’article"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Selon les constatations, viser l’alinéa adapté de ",
                ),
                TextSpan(
                  text: "l’art. 78-2 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ou "),
                TextSpan(
                  text: "l’art. 78-2-1 du C.P.P.",
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

          // Contrôle / résultat / palpation / avis OPJ
          _ConditionCard(
            title: "8 → 11 — Contrôle, résultat, palpation, avis OPJ",
            cardColor: cardOp,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("8) Contrôle"),
              const _IntroBullet(
                text: "Mentionner l’heure et le lieu du contrôle.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("9) Résultat du contrôle"),
              const _IntroBullet(
                text:
                    "Identifier la personne en style indirect : état civil et adresse (à l’exclusion des éléments de personnalité).",
              ),
              const _IntroBullet(
                text:
                    "Si l’individu ne justifie pas / refuse : mentionner clairement l’impossibilité ou le refus.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("10) Palpation de sécurité"),
              const _Paragraph(
                "Elle n’est pas systématique. Elle se justifie uniquement selon les circonstances de temps/lieu "
                "et la nécessité de vérifier l’absence d’objet dangereux (respect et discernement).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("11) Avis O.P.J."),
              const _IntroBullet(
                text:
                    "Mentionner les instructions reçues. La mise en œuvre de la vérification d’identité relève de la responsabilité exclusive de l’O.P.J.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Retour / clôture / présentation OPJ / recherches / annexe
          _ConditionCard(
            title:
                "12 → 16 — Retour, clôture, présentation OPJ, recherches, annexe",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("12) Retour au service"),
              const _IntroBullet(
                text:
                    "Préciser si la personne suit de plein gré ou sous contrainte. Tout usage de la force doit être circonstancié.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("13) Énonciation terminale (clôture)"),
              const _IntroBullet(
                text:
                    "Si déclarations au style direct : signature de la personne. Si style indirect : pas de signature.",
              ),
              const _IntroBullet(
                text: "L’indication de l’heure est facultative.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("14) Présentation à l’O.P.J."),
              const _IntroBullet(
                text:
                    "Mentionner l’heure de présentation, le compte-rendu verbal et les instructions données.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("15) Mention — recherches administratives"),
              const _IntroBullet(
                text:
                    "Préciser que les recherches ont été effectuées (F.P.R., T.A.J. le cas échéant) et qu’aucune recherche ne vise la personne (si c’est le résultat).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("16) Annexe"),
              const _IntroBullet(
                text:
                    "Annexer la copie de la réquisition du procureur justifiant le contrôle d’identité (si contrôle sur réquisitions).",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoomableImageTile extends StatelessWidget {
  const _ZoomableImageTile({
    required this.assetPath,
    required this.heroTag,
    required this.label,
  });

  final String assetPath;
  final String heroTag;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'Ouvrir l’image $label en plein écran',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _ZoomImageViewerPage(
                assetPath: assetPath,
                heroTag: heroTag,
                title: 'PV — $label',
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (isDark ? Colors.white70 : const Color(0xFF616161))
                  .withOpacity(.22),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Hero(
                tag: heroTag,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(.55),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.zoom_in_rounded, color: Colors.white),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Ouvrir en plein écran — $label",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fustat(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoomImageViewerPage extends StatelessWidget {
  const _ZoomImageViewerPage({
    required this.assetPath,
    required this.heroTag,
    required this.title,
  });

  final String assetPath;
  final String heroTag;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? Colors.black : Colors.black;
    final Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          tooltip: 'Fermer',
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 6.0,
            panEnabled: true,
            scaleEnabled: true,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
        ),
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
