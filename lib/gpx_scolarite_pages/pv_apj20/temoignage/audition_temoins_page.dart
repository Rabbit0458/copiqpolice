import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuditionTemoinsPage extends StatelessWidget {
  const AuditionTemoinsPage({super.key});

  static const String routeName = '/gpx/pv_apj20/temoignage/audition_temoins';

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
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMethod = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardOps = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardClose = isDark
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
          "Témoignage",
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
            "Canevas — Procès-verbal d’audition de témoin",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Image cliquable -> plein écran (zoom + drag)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const _FullScreenAssetImage(
                    assetPath: 'assets/images/temoignage_pv.png',
                    heroTag: 'temoignage_pv',
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'temoignage_pv',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/temoignage_pv.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (cadre juridique + "vu les articles...")
          _ConditionCard(
            title: "Cadre juridique (à faire apparaître en haut du PV)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’agent de police judiciaire doit situer son action dans un cadre juridique précis : "
                "enquête de flagrance ou enquête préliminaire.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Formule attendue (exemples)"),
              _Paragraph.rich([
                const TextSpan(text: "• « Vu les "),
                TextSpan(
                  text: "articles 53 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " » (flagrance)\n"),
                const TextSpan(text: "• « Vu les "),
                TextSpan(
                  text: "articles 75 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " » (préliminaire)"),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le cadre juridique doit être clair dès l’entête : il conditionne le vocabulaire, les mentions et l’ensemble du PV.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "1 — Lieu de rédaction",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La rédaction a lieu le plus souvent au service. Elle peut aussi être effectuée :\n"
                "• sur les lieux de l’infraction,\n"
                "• au domicile du témoin,\n"
                "• ou en tout autre lieu (ex : hôpital).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "2 — Instructions",
            cardColor: cardMethod,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Selon la nature de la procédure"),
              _BulletPoint(
                text:
                    "En flagrant délit : l’A.P.J. agit conformément aux instructions reçues de l’O.P.J.",
              ),
              _BulletPoint(
                text:
                    "En préliminaire : l’A.P.J. agit sous le contrôle de l’O.P.J.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "3 — Cadre juridique (mention procédurale)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le PV doit indiquer explicitement si l’audition s’inscrit dans :\n"
                "• une enquête de flagrance\n"
                "• ou une enquête préliminaire\n\n"
                "Puis reprendre la formule « vu les articles… » correspondante.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "À intégrer tel quel, en haut du PV : "),
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
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "4 — Assistants éventuels",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pour certaines affaires complexes ou lorsque la personnalité du témoin peut engendrer des difficultés, "
                "le rédacteur peut se faire assister d’un collègue.\n\n"
                "Il convient de le mentionner clairement (nom, grade, service).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "5 — Mode de comparution",
            cardColor: cardOps,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le témoin peut :\n"
                "• se présenter spontanément (« constatons que se présente… »),\n"
                "• ou être convoqué (« Avons mandé et constatons que se présente… »).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le choix des formules doit être cohérent avec la réalité de la comparution (spontanée / convoquée).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "6 — Identité (et protections possibles)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Objectif : identifier le témoin et pouvoir le recontacter. "
                "L’A.P.J. enregistre la petite identité.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le témoin peut se domicilier à une autre adresse que la sienne (",
                ),
                TextSpan(
                  text: "article 706-57 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") ou déposer de manière anonyme ("),
                TextSpan(
                  text: "article 706-58 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Petite identité : état civil + éléments de contact utiles.",
              ),
              const _BulletPoint(
                text:
                    "Mentionner clairement toute modalité particulière (domiciliation / anonymat).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "7 — Déclarations (structure idéale)",
            cardColor: cardOps,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Déroulé des faits (récit du témoin)"),
              _Paragraph(
                "Le témoin décrit précisément ce qu’il a vu, entendu et fait.\n"
                "Les expressions employées doivent être retranscrites telles quelles, entre guillemets.\n\n"
                "Le rédacteur doit situer le témoin dans le temps et l’espace : "
                "Date, Heure, Lieu, Motif (H.L.M.).",
              ),
              SizedBox(height: 10),
              _SubTitle("B) Déclarations spontanées puis questions"),
              _IntroBullet(
                text:
                    "1) Récit libre (spontané) pour poser le contexte et éviter l’influence.",
              ),
              _IntroBullet(
                text:
                    "2) Questions pour qualifier les faits et préciser le rôle de chacun.",
              ),
              _IntroBullet(
                text:
                    "3) Si besoin : récit guidé (toujours sans suggérer la réponse).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les questions doivent être « ouvertes » : elles ne doivent jamais suggérer la réponse.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("C) Signalement"),
              _BulletPoint(
                text:
                    "Sexe, âge apparent, taille, corpulence, type, cheveux, yeux, signes particuliers.",
              ),
              SizedBox(height: 12),
              _SubTitle("D) Reconnaissance éventuelle"),
              _BulletPoint(
                text:
                    "Sur photographies et/ou présentation derrière une glace sans tain.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "8 — Remise de documents / éléments",
            cardColor: cardMethod,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Tous éléments, indices, objets, documents découverts par le témoin sur les lieux des faits "
                "ou s’y rapportant, sont appréhendés pour être mis sous scellés ou annexés "
                "selon leur nature et leur importance.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Préciser la nature exacte de l’élément remis (document, photo, objet, etc.).",
              ),
              _BulletPoint(
                text:
                    "Tracer la prise en charge (annexe / scellé) de manière claire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "9 — Énonciation terminale (clôture)",
            cardColor: cardClose,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’A.P.J. mentionne que lecture est faite par la personne.\n"
                "Si cela est impossible (ex : non-voyant, ne sait pas lire), mentionner la lecture faite par l’A.P.J.\n\n"
                "La personne signe le procès-verbal sous l’énonciation terminale, après lecture.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Exemple : « Après lecture faite par nous-même, l’intéressé ne sachant pas lire… »",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "10 — Annexes",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les documents remis doivent être annexés au procès-verbal.\n"
                "La rubrique peut figurer en marge pour plus de clarté.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lister les annexes avec une identification simple (Annexe 1, Annexe 2…).",
              ),
              _BulletPoint(
                text:
                    "Rester cohérent entre « remis », « annexé », « placé sous scellé ».",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "11 — Avis O.P.J.",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le rédacteur mentionne l’avis donné à l’O.P.J. des diligences réalisées et du contenu utile à la procédure.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Préciser le mode d’avis (téléphone, compte-rendu, etc.) selon tes usages.",
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

class _FullScreenAssetImage extends StatelessWidget {
  const _FullScreenAssetImage({required this.assetPath, required this.heroTag});

  final String assetPath;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  constrained: false, // 🔥 OBLIGATOIRE
                  minScale: 1,
                  maxScale: 10, // 🔥 vrai zoom
                  boundaryMargin: const EdgeInsets.all(
                    300,
                  ), // 🔥 autorise le déplacement
                  panEnabled: true,
                  scaleEnabled: true,
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ),
            ),

            // Bouton fermer
            Positioned(
              top: 12,
              left: 12,
              child: Material(
                color: Colors.black.withOpacity(.45),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Fermer',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
