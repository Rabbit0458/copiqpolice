import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVPvSaisinePersonneDenommeeSuitePage extends StatelessWidget {
  const PVPvSaisinePersonneDenommeeSuitePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/pv_saisine_personne_denommee_suite';

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
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDecl = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDocs = isDark
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
          "Plainte",
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
            "PV de plainte — personne dénommée",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (simple, non répétitive)
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le procès-verbal de saisine est rédigé dès lors qu’un service reçoit une plainte. "
                "Le PV doit être clair, chronologique et exploitable : il organise le récit, fait ressortir les éléments utiles, "
                "et prépare les actes d’enquête.",
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
                const TextSpan(text: "PV + récépissé + copie sur demande — "),
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
                        "Cadre juridique à annoncer dans le PV : enquête de flagrance ou enquête préliminaire. "
                        "On vise « articles 53 et suivants » ou « articles 75 et suivants » selon le cas.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Dommages-intérêts (si demande) — "),
                TextSpan(
                  text: "article 420-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (se conformer aux consignes du parquet local).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Canevas (structure)
          _ConditionCard(
            title: "II — Canevas (PV de saisine)",
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de rédaction"),
              const _Paragraph(
                "L’agent de police judiciaire peut recevoir la plainte ailleurs qu’au service "
                "(domicile, hôpital, etc.).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2) Instructions"),
              const _Paragraph(
                "Lorsqu’il s’agit d’un procès-verbal de saisine, l’agent agit sur "
                "« instructions permanentes du chef de service ».",
              ),
              const SizedBox(height: 10),

              const _SubTitle("3) Réception du déclarant"),
              const _BulletPoint(
                text:
                    "Si la victime se présente avec un interprète, mentionner les coordonnées de ce dernier.",
              ),
              const _BulletPoint(
                text:
                    "Selon la gravité des faits, la qualité de la victime et/ou de l’auteur, informer immédiatement l’OPJ (avant toute rédaction si nécessaire).",
              ),
              const _BulletPoint(
                text:
                    "Une description succincte des circonstances permet d’annoncer la rubrique suivante.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("4) Cadre juridique"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Situer l’action : enquête de flagrance ou préliminaire. Citer « vu les articles 53 et suivants » ou « vu les articles 75 et suivants » — ",
                ),
                TextSpan(
                  text: "Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("5) Droits des victimes"),
              _Paragraph.rich([
                const TextSpan(text: "Informer la victime — "),
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
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Si demande de dommages-intérêts — "),
                  TextSpan(
                    text: "article 420-1 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: " : se conformer aux consignes du parquet local.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("6) Identité"),
              const _Paragraph(
                "Identifier la victime pour pouvoir la recontacter. La petite identité est en pratique déjà relevée au CRI. "
                "Le rappel du NOM et du Prénom suffit dans le corps du PV.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("7) Déclarations"),
              const _BulletPoint(
                text:
                    "Déroulé des faits : description précise (Heure, Lieu, Motif : H.L.M.) en utilisant la première personne (« je… »).",
              ),
              const _BulletPoint(
                text:
                    "Récit libre d’abord (déclarations spontanées), puis questions ouvertes pour qualifier les faits et déterminer le rôle de chacun.",
              ),
              const _BulletPoint(
                text:
                    "Auteur : préciser les liens éventuels victime/auteur et les renseignements utiles (nom, prénom, adresse, profession…).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("8) Dépôt de plainte"),
              const _Paragraph(
                "Certaines infractions sont conditionnées par le dépôt de plainte (ex. diffamation).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("9) Remise de documents"),
              const _Paragraph(
                "Certificats médicaux, chèques, factures, captures, documents utiles… (à annexer et mentionner).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("10) Demande de copie"),
              _Paragraph.rich([
                const TextSpan(text: "Copie du PV si demandée — "),
                TextSpan(
                  text: "article 15-3 alinéa 2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("11) Énonciation terminale (clôture)"),
              const _BulletPoint(
                text:
                    "Mentionner la lecture + signature. Si impossibilité de lecture : indiquer que la lecture est faite par l’APJ.",
              ),
              const _BulletPoint(
                text:
                    "Si interprète : préciser que la lecture est faite par son truchement et faire signer l’interprète.",
              ),
              const _Paragraph(
                "L’heure de fin d’audition de plainte est facultative.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("12) Annexes"),
              const _Paragraph(
                "Les documents remis doivent être annexés au procès-verbal. La rubrique peut figurer en marge pour plus de clarté.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("13) Mention"),
              const _Paragraph(
                "Remise à la victime : formulaire d’information des droits, récépissé de plainte, éventuellement copie du PV.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("14) Avis O.P.J."),
              const _Paragraph(
                "L’agent de police judiciaire avise l’officier de police judiciaire des faits contenus dans la plainte.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Docs + images demandées (recto/verso + zoom)
          _ConditionCard(
            title: "III — Documents & modèles (images)",
            cardColor: cardDocs,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Modèle PV (recto / verso)"),
              _Paragraph(
                "Appuie sur l’image pour l’ouvrir en plein écran et zoomer.",
              ),
              SizedBox(height: 10),
              _ZoomableImage(
                assetPath: 'assets/images/pv_plainte_personne_denommee.png',
              ),
              SizedBox(height: 12),
              _ZoomableImage(
                assetPath: 'assets/images/plainte_verso_denommée.png',
              ),
              SizedBox(height: 14),
            ],
          ),

          const SizedBox(height: 14),

          // Bonnes pratiques (rendu pédagogique)
          _ConditionCard(
            title: "IV — Bonnes pratiques (rendu exploitable)",
            cardColor: cardDecl,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Qualité rédactionnelle"),
              _BulletPoint(
                text:
                    "Factuel, chronologique, sans jugement ni interprétation gratuite.",
              ),
              _BulletPoint(
                text:
                    "D’abord récit libre, puis questions ouvertes (ne jamais suggérer la réponse).",
              ),
              _BulletPoint(
                text:
                    "Toujours faire ressortir : preuves, témoins, messages, blessures, menaces, antécédents du conflit, etc.",
              ),
              SizedBox(height: 12),
              _SubTitle("Signalement / éléments utiles"),
              _BulletPoint(
                text:
                    "Signalement si pertinent : sexe, âge apparent, taille, corpulence, signes distinctifs, tenue…",
              ),
              _BulletPoint(
                text:
                    "Liens victime/auteur : relation, contexte, fréquence, éventuelles démarches déjà faites.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///  Widgets “images” (pour ton souci : plein écran + zoom/rotation)
///////////////////////////////////////////////////////////////////////////////

class _ZoomableImage extends StatelessWidget {
  const _ZoomableImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color border = isDark
        ? Colors.white.withOpacity(.18)
        : Colors.black.withOpacity(.10);

    return InkWell(
      onTap: () => _openFullscreen(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.92),
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 1,
                maxScale: 8,
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(120),
                child: Center(
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  tooltip: 'Fermer',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
            child: Row(
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
                const Spacer(),
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
              child: Stack(
                children: [
                  Column(
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
                        child: Row(
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
                            const Spacer(),
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
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // on garde la rotation actuelle de la carte (pas obligatoire, mais logique)
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
