import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVPvSaisinePersonneDenommeePage extends StatelessWidget {
  const PVPvSaisinePersonneDenommeePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/pv_saisine_personne_denommee';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible) — comme ta template
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

          // ✅ Élément légal en haut (comme demandé)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Obligation de recevoir les plaintes (même en cas d’incompétence territoriale, avec transmission si nécessaire). — ",
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
                      "Information du plaignant sur les droits des victimes au moment du dépôt de plainte. — ",
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
                      "Dépôt de plainte : PV + récépissé immédiat + copie si demandée. — ",
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
                        "Cadre juridique à annoncer dans le PV : enquête de flagrance ou enquête préliminaire. "
                        "On vise « articles 53 et suivants » ou « articles 75 et suivants » selon le cas.",
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

          // ✅ Canevas (structure PV de saisine) — issu de ta capture
          _ConditionCard(
            title: "II — Canevas du PV (procès-verbal de saisine)",
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de rédaction"),
              const _Paragraph(
                "L’agent de police judiciaire peut être amené à recevoir la plainte ailleurs qu’au service "
                "(domicile, hôpital, etc.).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2) Instructions"),
              const _Paragraph(
                "Lorsqu’il s’agit d’un procès-verbal de saisine, l’agent de police judiciaire agit sur "
                "« instructions permanentes du chef de service ».",
              ),
              const SizedBox(height: 10),

              const _SubTitle("3) Réception du déclarant"),
              const _BulletPoint(
                text:
                    "Si la victime se présente avec un interprète, l’A.P.J. mentionne les coordonnées de ce dernier.",
              ),
              const _BulletPoint(
                text:
                    "Selon la gravité des faits, la qualité de la victime et/ou de l’auteur, l’O.P.J. doit être informé immédiatement (avant toute rédaction).",
              ),
              const _BulletPoint(
                text:
                    "Une description succincte des circonstances de la commission de l’infraction permet d’annoncer la rubrique suivante.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("4) Cadre juridique"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Situer l’action dans un cadre juridique précis (enquête de flagrance ou enquête préliminaire) et viser : ",
                ),
                TextSpan(
                  text: "articles 53 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ou "),
                TextSpan(
                  text: "articles 75 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("5) Droits des victimes"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Informer le plaignant des dispositions — ",
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
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text: "En cas de demande de dommages-intérêts : ",
                  ),
                  TextSpan(
                    text: "article 420-1 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: " (se conformer aux consignes du Parquet local).",
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _SubTitle("6) Identité"),
              const _Paragraph(
                "Il s’agit d’identifier la victime et de pouvoir la recontacter. "
                "L’A.P.J. enregistre la petite identité de cette personne. "
                "Le rappel du NOM et du Prénom suffit si déjà relevés au C.R.I.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("7) Déclarations"),
              const _BulletPoint(
                text:
                    "Déroulé des faits : description précise (Heure, Lieu, Motif : H.L.M.) en utilisant la première personne (« je… »).",
              ),
              const _BulletPoint(
                text:
                    "Récit libre d’abord (déclarations spontanées), puis questions pour qualifier et déterminer le rôle de chacun.",
              ),
              const _BulletPoint(
                text:
                    "Questions « ouvertes », sans suggérer la réponse. Le récit peut ensuite être guidé.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Auteur : faire préciser les liens éventuels victime/auteur et mentionner les renseignements utiles (nom, prénom, adresse, profession, etc.).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("8) Dépôt de plainte"),
              const _Paragraph(
                "Certaines infractions sont conditionnées par le dépôt de plainte (ex. diffamation).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("9) Remise de documents"),
              const _Paragraph(
                "Certificats médicaux, chèques, factures, messages, captures… tout document utile est remis et annexé.",
              ),
              const SizedBox(height: 10),

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
              const SizedBox(height: 10),

              const _SubTitle("11) Énonciation terminale (clôture)"),
              const _BulletPoint(
                text:
                    "Mentionner que la lecture est faite par la personne (ou par l’A.P.J. si impossibilité : non voyant / ne sait pas lire).",
              ),
              const _BulletPoint(
                text:
                    "Signature de la personne sous l’énonciation terminale après lecture.",
              ),
              const _BulletPoint(
                text:
                    "Si interprète : lecture par son truchement et signature de l’interprète.",
              ),
              const _BulletPoint(
                text: "L’heure de fin d’audition de plainte est facultative.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("12) Annexes"),
              const _Paragraph(
                "Les documents remis doivent être annexés au PV. La rubrique peut figurer en marge pour plus de clarté.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("13) Mention"),
              const _Paragraph(
                "Remise de documents à la victime : formulaire d’information des droits des victimes, récépissé de plainte et éventuellement copie du PV.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("14) Avis O.P.J."),
              const _Paragraph(
                "L’agent de police judiciaire avise l’officier de police judiciaire des faits contenus dans la plainte.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Visuels / documents
          _ConditionCard(
            title: "III — Documents & supports (visuels)",
            cardColor: cardDocs,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("PV (recto / verso)"),
              _Paragraph("Ces visuels servent de repère pendant la rédaction."),
              SizedBox(height: 10),
              _ZoomRotateImage(
                assetPath: 'assets/images/pv_plainte_personne_denommee.png',
              ),
              SizedBox(height: 12),
              _ZoomRotateImage(
                assetPath: 'assets/images/plainte_verso_denommée.png',
              ),
              SizedBox(height: 12),
              _SubTitle("Canevas — zoom & rotation"),
              _Paragraph("Tu peux ouvrir en plein écran, zoomer et tourner."),
              SizedBox(height: 10),
              _ZoomRotateImage(
                assetPath: 'assets/images/pv_canva_plainte_recto.png',
              ),
              SizedBox(height: 12),
              _ZoomRotateImage(
                assetPath: 'assets/images/pv_canva_plainte_verso.png',
              ),
              SizedBox(height: 12),
              _SubTitle("Canevas (version anonyme)"),
              _Paragraph(
                "Même canevas, version auteur inconnu/anonyme pour comparaison.",
              ),
              SizedBox(height: 10),
              _ZoomRotateImage(
                assetPath: 'assets/images/pv_canva_plainte_recto_anonyme.png',
              ),
              SizedBox(height: 12),
              _ZoomRotateImage(
                assetPath: 'assets/images/pv_canva_plainte_verso_anonyme.png',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Mémo pratique
          _ConditionCard(
            title: "IV — Mémo rapide (qualité rédactionnelle)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Règles d’or"),
              _BulletPoint(
                text:
                    "Rester factuel, chronologique, sans jugement ni interprétation gratuite.",
              ),
              _BulletPoint(
                text:
                    "Déclarations en « je » pour le récit, puis questions ouvertes pour qualifier.",
              ),
              _BulletPoint(
                text:
                    "Faire ressortir : preuves, témoins, messages, blessures, menaces, contexte, antécédents du conflit.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ✅ Image zoom/rotation + vrai plein écran (tap ou bouton)
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

  void _openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(
          assetPath: widget.assetPath,
          initialQuarterTurns: _quarterTurns,
        ),
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
                const SizedBox(width: 6),
                IconButton(
                  onPressed: _openFullScreen,
                  tooltip: 'Plein écran',
                  icon: const Icon(Icons.open_in_full_rounded),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _openFullScreen,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 6,
                panEnabled: true,
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
  const _FullScreenImageViewer({
    required this.assetPath,
    required this.initialQuarterTurns,
  });

  final String assetPath;
  final int initialQuarterTurns;

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late int _quarterTurns;

  @override
  void initState() {
    super.initState();
    _quarterTurns = widget.initialQuarterTurns % 4;
  }

  void _rotateLeft() => setState(() => _quarterTurns = (_quarterTurns - 1) % 4);
  void _rotateRight() =>
      setState(() => _quarterTurns = (_quarterTurns + 1) % 4);
  void _reset() => setState(() => _quarterTurns = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Aperçu",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        actions: [
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
          IconButton(
            onPressed: _reset,
            tooltip: 'Réinitialiser',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 8,
        panEnabled: true,
        child: Center(
          child: RotatedBox(
            quarterTurns: _quarterTurns,
            child: Image.asset(widget.assetPath, fit: BoxFit.contain),
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
