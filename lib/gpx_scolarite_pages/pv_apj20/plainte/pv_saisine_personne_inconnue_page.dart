import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class PVPvSaisinePersonneInconnuePage extends StatefulWidget {
  const PVPvSaisinePersonneInconnuePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/pv_saisine_personne_inconnue';

  @override
  State<PVPvSaisinePersonneInconnuePage> createState() =>
      _PVPvSaisinePersonneInconnuePageState();
}

class _PVPvSaisinePersonneInconnuePageState
    extends State<PVPvSaisinePersonneInconnuePage> {
  static const Color _lawRed = Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    // ✅ Plein écran
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // ✅ Restaure l'affichage normal
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDecl = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDocs = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
      body: SafeArea(
        top: true,
        bottom: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // ✅ Header custom (sans AppBar)
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
                  tooltip: 'Retour',
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
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
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "PV de saisine — personne inconnue",
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                height: 1.15,
                color: textMain,
              ),
            ),
            const SizedBox(height: 10),

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
                        "Les officiers et agents de police judiciaire sont tenus de recevoir les plaintes, y compris si le service est territorialement incompétent (transmission si besoin). — ",
                  ),
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
                  const TextSpan(
                    text:
                        "Le plaignant est informé des droits des victimes lors du dépôt de plainte. — ",
                  ),
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
                  const TextSpan(
                    text:
                        "Le dépôt de plainte donne lieu à un procès-verbal, à la délivrance immédiate d’un récépissé, et, si la victime le demande, à une copie du PV. — ",
                  ),
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
                          "Cadre juridique à annoncer : enquête de flagrance ou enquête préliminaire. "
                          "On vise « articles 53 et suivants » ou « articles 75 et suivants » du CPP selon le cas.",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _Paragraph.rich([
                  const TextSpan(text: "Dommages-intérêts (si demande) : "),
                  TextSpan(
                    text: "article 420-1 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " (se conformer aux consignes du parquet local le cas échéant).",
                  ),
                ]),
              ],
            ),

            const SizedBox(height: 14),

            // Définition
            _ConditionCard(
              title: "Définition",
              cardColor: cardDef,
              accent: accentGrey,
              titleColor: textMain,
              children: const [
                _Paragraph(
                  "La plainte « contre auteur inconnu » est utilisée lorsque la victime ne peut pas identifier l’auteur. "
                  "Le PV doit être structuré et exploitable : il organise le récit, précise les éléments utiles (H.L.M.), "
                  "et oriente immédiatement les premières diligences.",
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Canevas structure PV (contre inconnu)
            _ConditionCard(
              title: "II — Canevas (PV de saisine — auteur inconnu)",
              cardColor: cardSteps,
              accent: accentGreen,
              titleColor: textMain,
              children: [
                const _SubTitle("1) Lieu de rédaction"),
                const _BulletPoint(
                  text:
                      "Service, domicile, hôpital… L’APJ peut recevoir la plainte ailleurs qu’au service.",
                ),

                const SizedBox(height: 10),

                const _SubTitle("2) Instructions"),
                const _BulletPoint(
                  text:
                      "En PV de saisine : agir sur « instructions permanentes du chef de service ».",
                ),

                const SizedBox(height: 10),

                const _SubTitle("3) Réception du déclarant"),
                const _BulletPoint(
                  text:
                      "Si la victime vient avec un interprète : mentionner ses coordonnées.",
                ),
                const _BulletPoint(
                  text:
                      "Selon gravité / qualité victime-auteur : aviser immédiatement l’OPJ (avant toute rédaction si nécessaire).",
                ),
                const _BulletPoint(
                  text:
                      "Faire une description succincte des circonstances pour annoncer la rubrique suivante.",
                ),

                const SizedBox(height: 10),

                const _SubTitle("4) Cadre juridique"),
                const _BulletPoint(
                  text:
                      "Situer l’enquête : flagrance (articles 53 et s.) ou préliminaire (articles 75 et s.) du CPP.",
                ),

                const SizedBox(height: 10),

                const _SubTitle("5) Droits des victimes"),
                _Paragraph.rich([
                  const TextSpan(text: "Informer le plaignant — "),
                  TextSpan(
                    text: "article 10-2 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ]),
                const SizedBox(height: 8),
                _NotaBox(
                  bodySpans: [
                    const TextSpan(
                      text:
                          "Si demande de dommages-intérêts : appliquer les consignes du parquet local.",
                    ),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: "(article 420-1 du Code de procédure pénale)",
                      style: const TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),

                const SizedBox(height: 10),

                const _SubTitle("6) Identité"),
                const _BulletPoint(
                  text:
                      "Petite identité relevée lors de la création du CRI ; le rappel NOM + Prénom suffit dans le PV.",
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Déclarations / Signalement / Reconnaissance
            _ConditionCard(
              title: "III — Déclarations & exploitabilité",
              cardColor: cardDecl,
              accent: accentPink,
              titleColor: textMain,
              children: [
                const _SubTitle("Déroulé des faits (H.L.M.)"),
                const _BulletPoint(
                  text:
                      "Heure – Lieu – Motif : description précise, en première personne (« je… »).",
                ),
                const _BulletPoint(
                  text:
                      "Récit libre d’abord (déclarations spontanées), puis questions ouvertes (sans suggérer).",
                ),
                const SizedBox(height: 12),
                const _SubTitle("Signalement (auteur inconnu)"),
                const _BulletPoint(
                  text:
                      "Sexe, âge apparent, taille, corpulence, cheveux, yeux, signes distinctifs, tenue vestimentaire…",
                ),
                const _BulletPoint(
                  text:
                      "Tous renseignements utiles doivent apparaître clairement (mode opératoire, direction de fuite, véhicule, etc.).",
                ),
                const SizedBox(height: 12),
                const _SubTitle("Reconnaissance"),
                const _BulletPoint(
                  text:
                      "Reconnaissance possible : sur photographies et/ou présentation derrière une glace sans tain, selon procédure.",
                ),
                const SizedBox(height: 12),
                _NotaBox(
                  title: "Important",
                  bodySpans: [
                    const TextSpan(
                      text:
                          "Certaines infractions sont conditionnées par un dépôt de plainte (ex. diffamation). "
                          "Toujours vérifier si la qualification nécessite la plainte pour déclencher les suites.",
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Documents / Demande de copie / Clôture / Annexes / Remises / Avis OPJ + Images
            _ConditionCard(
              title: "IV — Finalisation, annexes & canevas (images)",
              cardColor: cardDocs,
              accent: accentAmber,
              titleColor: textMain,
              children: [
                const _SubTitle("Documents remis"),
                const _BulletPoint(
                  text:
                      "Certificats médicaux, chèques, factures, messages, captures… tout ce qui se rapporte à l’affaire.",
                ),
                const _BulletPoint(
                  text:
                      "Tout document remis doit être annexé au PV (numérotation conseillée).",
                ),
                const SizedBox(height: 10),

                const _SubTitle("Demande de copie"),
                _Paragraph.rich([
                  const TextSpan(
                    text: "Copie du PV si la victime le demande — ",
                  ),
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

                const _SubTitle("Énonciation terminale (clôture)"),
                const _BulletPoint(
                  text:
                      "Mentionner la lecture faite par la personne ; si impossible : lecture faite par l’APJ (ex : ne sait pas lire).",
                ),
                const _BulletPoint(
                  text:
                      "Signature sous l’énonciation terminale. Si interprète : lecture par son truchement + signature interprète.",
                ),
                const _BulletPoint(
                  text: "Heure de fin d’audition : facultative.",
                ),
                const SizedBox(height: 10),

                const _SubTitle("Remises & avis OPJ"),
                const _BulletPoint(
                  text:
                      "Remettre : formulaire droits des victimes + récépissé + copie du PV si demandée.",
                ),
                const _BulletPoint(
                  text:
                      "Avis OPJ : l’APJ avise l’OPJ des faits contenus dans la plainte.",
                ),

                const SizedBox(height: 14),

                const _SubTitle("Canevas visuel — auteur inconnu (anonyme)"),
                const _Paragraph(
                  "Tap sur l’image pour ouvrir en plein écran (zoom + rotation).",
                ),
                const SizedBox(height: 10),
                const _ZoomRotateImage(
                  assetPath: 'assets/images/pv_canva_plainte_recto_anonyme.png',
                ),
                const SizedBox(height: 12),
                const _ZoomRotateImage(
                  assetPath: 'assets/images/pv_canva_plainte_verso_anonyme.png',
                ),

                const SizedBox(height: 14),
              ],
            ),
          ],
        ),
      ),
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

  void _openFullScreenViewer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) {
          return _FullScreenImageViewer(assetPath: widget.assetPath);
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

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
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openFullScreenViewer(context),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 6,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: _quarterTurns,
                    child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  const _FullScreenImageViewer({required this.assetPath});

  final String assetPath;

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  int _quarterTurns = 0;

  void _rotateLeft() => setState(() => _quarterTurns = (_quarterTurns - 1) % 4);
  void _rotateRight() =>
      setState(() => _quarterTurns = (_quarterTurns + 1) % 4);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.92),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 10,
                panEnabled: true,
                child: RotatedBox(
                  quarterTurns: _quarterTurns,
                  child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: "Fermer",
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _rotateLeft,
                    icon: const Icon(
                      Icons.rotate_left_rounded,
                      color: Colors.white,
                    ),
                    tooltip: "Tourner à gauche",
                  ),
                  IconButton(
                    onPressed: _rotateRight,
                    icon: const Icon(
                      Icons.rotate_right_rounded,
                      color: Colors.white,
                    ),
                    tooltip: "Tourner à droite",
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: Text(
                "Pince pour zoomer • Glisse pour déplacer • Boutons pour tourner",
                textAlign: TextAlign.center,
                style: GoogleFonts.fustat(
                  color: isDark ? Colors.white70 : Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
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
