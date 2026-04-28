import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationGavDroitsApjPage extends StatelessWidget {
  const NotificationGavDroitsApjPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/gav_suspect_libre/notification_gav_droits_apj';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRights = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProtected = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardClosure = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    // Accents
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
          "Procès-verbal G.A.V.",
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
            "Canevas de PV : notification du placement en garde à vue\net des droits par un A.P.J.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro
          _ConditionCard(
            title: "Objectif de la page",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette page te donne un canevas clair et opérationnel pour rédiger un procès-verbal de notification "
                "du placement en garde à vue et des droits, lorsqu’il est réalisé par un A.P.J. sous le contrôle d’un O.P.J.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: "I — Élément légal (visa des textes)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Visa obligatoire des articles "),
                TextSpan(
                  text: "62-2 à 63-4-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " relatifs à la décision de placement en garde à vue et aux droits de la personne.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le PV doit rappeler expressément que la mesure a été décidée par un O.P.J. (même si l’A.P.J. notifie).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Steps (structure PV)
          _ConditionCard(
            title: "II — Structure du procès-verbal (canevas)",
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Voici les rubriques attendues dans un PV de notification du placement en garde à vue et des droits.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Lieu de rédaction"),
              const _Paragraph(
                "Indiquer précisément le lieu où le procès-verbal est établi.",
              ),

              const SizedBox(height: 10),

              const _SubTitle("2) Cadre juridique"),
              const _Paragraph(
                "Situer l’action dans un cadre juridique clair : enquête de flagrance ou enquête préliminaire.",
              ),

              const SizedBox(height: 10),

              const _SubTitle(
                "3) Visa des articles du C.P.P. relatifs à la G.A.V.",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: "Viser les textes applicables, notamment ",
                ),
                TextSpan(
                  text: "62-2 à 63-4-3 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 10),

              const _SubTitle("4) Instructions"),
              const _Paragraph(
                "Rappeler clairement que la garde à vue a été décidée par un O.P.J. (instructions reçues / décision).",
              ),

              const SizedBox(height: 10),

              const _SubTitle("5) Identité (petite identité)"),
              const _Paragraph(
                "Mentionner les éléments d’identité utiles de la personne faisant l’objet de la mesure.",
              ),

              const SizedBox(height: 10),

              const _SubTitle("6) Visa du ou des objectifs"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La mesure doit être l’unique moyen de parvenir à au moins un objectif de l’",
                ),
                TextSpan(
                  text: "article 62-2 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Permettre l’exécution des investigations impliquant la présence/participation de la personne.",
              ),
              const _BulletPoint(
                text:
                    "Garantir la présentation devant le procureur de la République (suite à l’enquête).",
              ),
              const _BulletPoint(
                text: "Empêcher la modification des preuves/indices matériels.",
              ),
              const _BulletPoint(
                text:
                    "Empêcher des pressions sur témoins/victimes ainsi que leurs familles/proches.",
              ),
              const _BulletPoint(
                text: "Empêcher la concertation avec coauteurs/complices.",
              ),
              const _BulletPoint(
                text:
                    "Garantir la mise en œuvre de mesures destinées à faire cesser l’infraction.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("7) Information (dans une langue comprise)"),
              _Paragraph.rich([
                const TextSpan(text: "Conformément à "),
                TextSpan(
                  text: "l’article 63-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", informer la personne :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "De la qualification juridique des faits, de la date et du lieu présumés.",
              ),
              const _BulletPoint(
                text:
                    "De son placement en garde à vue, sur décision de l’O.P.J.",
              ),
              const _BulletPoint(
                text:
                    "De la durée de la mesure et des éventuelles prolongations.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si l’infraction est punie d’une peine d’emprisonnement inférieure à un an, la mention relative à la prolongation ne doit pas apparaître.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Rights
          _ConditionCard(
            title: "III — Notification des droits",
            cardColor: cardRights,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "Informer la personne des droits visés aux articles ",
                ),
                TextSpan(
                  text: "63-1 à 63-4-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", et le cas échéant : "),
                TextSpan(
                  text: "706-112-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (mesure de protection juridique)."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("Droits à notifier (liste pédagogique)"),
              const _BulletPoint(
                text:
                    "Lors des auditions : faire des déclarations, répondre aux questions, ou se taire (droit au silence).",
              ),
              const _BulletPoint(text: "Être assisté par un interprète."),
              const _BulletPoint(
                text:
                    "Consulter certaines pièces de procédure (PV de notification, certificat médical, PV d’audition(s)).",
              ),
              const _BulletPoint(
                text:
                    "Présenter des observations au magistrat (en cas de prolongation) ou via PV d’audition communiqué avant décision.",
              ),
              const _BulletPoint(
                text: "Se faire remettre un document énonçant ses droits.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Protected adult specifics
          _ConditionCard(
            title: "IV — Majeur protégé",
            cardColor: cardProtected,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Si la personne fait l’objet d’une mesure de protection juridique (tutelle, curatelle, sauvegarde de justice), "
                "elle doit être informée des conséquences pratiques liées à cette situation.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article 706-112-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("À notifier en plus"),
              const _BulletPoint(
                text:
                    "Le tuteur/curateur/mandataire spécial sera également avisé de la mesure.",
              ),
              const _BulletPoint(
                text:
                    "Il pourra désigner un avocat (choisi ou commis d’office) si la personne ne l’a pas demandé.",
              ),
              const _BulletPoint(
                text:
                    "Il pourra solliciter un examen médical si la personne ne l’a pas demandé.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Requests collection
          _ConditionCard(
            title: "V — Recueil des demandes",
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Acter clairement les demandes formulées par la personne gardée à vue.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Avis à la famille / à une personne désignée / à l’employeur / aux autorités consulaires.",
              ),
              const _BulletPoint(
                text:
                    "Droit de communiquer avec un tiers (famille, personne désignée, employeur, autorités consulaires, tuteur/curateur/mandataire).",
              ),
              const _BulletPoint(text: "Droit d’être examiné par un médecin."),
              const _BulletPoint(text: "Droit d’être assisté par un avocat."),
            ],
          ),

          const SizedBox(height: 14),

          // Closing / mentions
          _ConditionCard(
            title: "VI — Clôture & mentions indispensables",
            cardColor: cardClosure,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Énonciation terminale (clôture)"),
              const _Paragraph(
                "Terminer le PV par une clôture claire : date/heure, lecture faite, signatures (ou refus de signer mentionné).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Mention"),
              const _Paragraph(
                "La décision de placement en garde à vue figure, en procédure, avant le PV de notification. "
                "Le procureur de la République a été informé de cette mesure par l’O.P.J.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Avis O.P.J."),
              const _Paragraph(
                "Faire apparaître l’avis à l’O.P.J. et la décision de placement en garde à vue dans la procédure (PV ou mention dans le PV d’interpellation).",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Canva images
          _ConditionCard(
            title: "Supports (CANVA)",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Affichages des supports visuels du canevas (zoomables).",
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/canva_gardeavue.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/canva_gardeavue_page2.png',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/canva_gardeavue_page3.png',
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

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.heroTag,
    this.borderRadius = 16,
    this.initialScale = 1.0,
    this.maxScale = 5.0,
    this.backgroundColor,
  });

  final String assetPath;

  /// Si tu veux un Hero personnalisé. Sinon, on utilise assetPath.
  final Object? heroTag;

  final double borderRadius;
  final double initialScale;
  final double maxScale;

  /// Couleur de fond dans le viewer plein écran (sinon auto selon thème)
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg = isDark
        ? const Color(0xFF1F1F1F)
        : const Color(0xFFFFFFFF);
    final Color border = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.black.withOpacity(.06);

    final tag = heroTag ?? assetPath;

    return GestureDetector(
      onTap: () => _openViewer(context, tag),
      child: Semantics(
        button: true,
        label: 'Ouvrir l’image en plein écran',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? .35 : .10),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Hero(
              tag: tag,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: maxScale,
                panEnabled: false,
                scaleEnabled: false,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => _errorBox(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorBox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3F3F3),
      child: Row(
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Image introuvable :\n$assetPath",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openViewer(BuildContext context, Object tag) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = backgroundColor ?? (isDark ? Colors.black : Colors.white);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(.55),
        pageBuilder: (_, __, ___) => _ZoomViewerPage(
          assetPath: assetPath,
          heroTag: tag,
          background: bg,
          initialScale: initialScale,
          maxScale: maxScale,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(opacity: curve, child: child);
        },
      ),
    );
  }
}

class _ZoomViewerPage extends StatelessWidget {
  const _ZoomViewerPage({
    required this.assetPath,
    required this.heroTag,
    required this.background,
    required this.initialScale,
    required this.maxScale,
  });

  final String assetPath;
  final Object heroTag;
  final Color background;
  final double initialScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: background.withOpacity(.98),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Center(
                  child: Hero(
                    tag: heroTag,
                    child: InteractiveViewer(
                      minScale: 0.9,
                      maxScale: maxScale,
                      panEnabled: true,
                      scaleEnabled: true,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _fullscreenError(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bouton fermer (top-right)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Icons.close_rounded, color: iconColor),
                tooltip: "Fermer",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fullscreenError(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Impossible de charger : $assetPath",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
