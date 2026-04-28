import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConduiteAuPostePage extends StatelessWidget {
  const ConduiteAuPostePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/interpellation/conduite_au_poste';

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
    final Color cardProc = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardActes = isDark
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
          "Interpellation",
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
            "PV de conduite au poste — canevas de rédaction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas t’aide à rédiger un procès-verbal de « conduite au poste » : "
                "mentions obligatoires, ordre logique, points de vigilance (heure, identité en style indirect, "
                "palpation, DRDA, avis OPJ, retour au service…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre juridique placé en haut (même si le canevas ne cite pas d’article précis)
          _ConditionCard(
            title: "I — Cadre juridique (à poser clairement)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En fonction des constatations, le rédacteur doit indiquer le cadre juridique de l’intervention "
                "(ce qui fonde les pouvoirs et les droits attachés à la situation).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’heure exacte de la conduite au poste est un point clé : elle peut aussi être celle du début "
                        "d’une éventuelle mesure de garde à vue selon les circonstances.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Trame chronologique (mentions à rédiger)",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Lieu de saisine"),
              _BulletPoint(
                text: "Mentionner l’endroit exact où se situe l’équipage.",
              ),

              SizedBox(height: 10),
              _SubTitle("2) Instructions (uniquement si PV de saisine)"),
              _BulletPoint(
                text:
                    "Indiquer les instructions permanentes du chef de service (si applicable).",
              ),

              SizedBox(height: 10),
              _SubTitle("3) Assistants éventuels"),
              _BulletPoint(
                text:
                    "Citer les fonctionnaires accompagnants + préciser la tenue (uniforme, tenue bourgeoise, port du brassard police).",
              ),

              SizedBox(height: 10),
              _SubTitle("4) Mission"),
              _BulletPoint(text: "Indiquer le but de la mission initiale."),

              SizedBox(height: 10),
              _SubTitle("5) Constatations"),
              _BulletPoint(
                text:
                    "Relater précisément les faits constitutifs de l’infraction (et si besoin l’heure de constatation / arrivée sur les lieux).",
              ),

              SizedBox(height: 10),
              _SubTitle("6) Cadre juridique"),
              _BulletPoint(
                text:
                    "Expliquer clairement le cadre juridique retenu, en cohérence avec les constatations.",
              ),

              SizedBox(height: 10),
              _SubTitle("7) Identité (style indirect)"),
              _BulletPoint(
                text:
                    "Prise de contact + identification : état civil et adresse uniquement (exclure situation familiale/professionnelle).",
              ),
              _BulletPoint(
                text:
                    "Préciser l’heure exacte et le lieu (si différent du lieu de saisine).",
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: "Ordre possible",
                bodySpans: [
                  TextSpan(
                    text:
                        "Selon la situation (comportement/attitude), la palpation de sécurité peut être réalisée "
                        "avant l’identité.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Palpation, DRDA, suites et clôture",
            cardColor: cardActes,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("8) Palpation de sécurité"),
              _BulletPoint(
                text:
                    "Si découverte d’objets : les situer et les décrire précisément (où, quoi).",
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: "Procédure",
                bodySpans: [
                  TextSpan(
                    text:
                        "D.R.D.A. : Décrire — Représenter — (brève) Déclaration — Appréhender. "
                        "La déclaration doit être limitée à l’appartenance de l’objet : ce n’est pas une audition.",
                  ),
                ],
              ),

              SizedBox(height: 12),
              _SubTitle("9) Constatations & appréhensions éventuelles"),
              _BulletPoint(
                text:
                    "Constatations postérieures à l’appréhension : effractions, bris de serrure/vitre, objets abandonnés, etc.",
              ),
              _BulletPoint(
                text:
                    "Objets pièces à conviction : représenter à la personne + brève déclaration éventuelle + appréhender pour remise OPJ.",
              ),

              SizedBox(height: 12),
              _SubTitle("10) Avis O.P.J."),
              _BulletPoint(
                text:
                    "Mentionner les instructions reçues de l’OPJ + les divers avis (invitation victime/témoin, avis radio…).",
              ),

              SizedBox(height: 10),
              _SubTitle("11) Retour au service de police"),
              _BulletPoint(
                text:
                    "Indiquer que la personne accepte d’accompagner de son plein gré les fonctionnaires de police.",
              ),

              SizedBox(height: 10),
              _SubTitle("12) Énonciation terminale (clôture)"),
              _BulletPoint(
                text:
                    "Signature seulement si déclarations au style direct. Si tout est au style indirect : pas de signature.",
              ),

              SizedBox(height: 10),
              _SubTitle("13) Présentation O.P.J."),
              _BulletPoint(
                text:
                    "Présenter l’individu en précisant l’heure, faire un compte-rendu verbal, remettre les objets appréhendés le cas échéant.",
              ),

              SizedBox(height: 10),
              _SubTitle("14) Mention"),
              _BulletPoint(
                text:
                    "Recherches administratives : FPR, TAJ (le cas échéant). Préciser qu’elles ont été effectuées et le résultat.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Canevas (images) — zoom & plein écran",
            cardColor: cardDocs,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Appuie sur une image pour l’ouvrir en plein écran. Tu peux zoomer (pincement) et déplacer.",
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_cap_recto.png',
                label: 'Recto — canevas CAP',
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_cap_verso.png',
                label: 'Verso — suite',
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Petit rappel "article en rouge" : ici le canevas fourni ne cite pas d’article,
          // mais on garde le style prêt au besoin.
          _ConditionCard(
            title: "Rappel (mise en forme)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Dès qu’un article est cité, il doit être en rouge : ex. ",
                ),
                const TextSpan(
                  text: "Article 803 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoomableAssetImage extends StatelessWidget {
  const _ZoomableAssetImage({required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color border = isDark ? Colors.white24 : Colors.black12;
    final Color chipBg = isDark
        ? Colors.black54
        : Colors.white.withOpacity(.92);
    final Color chipText = isDark ? Colors.white : const Color(0xFF050505);

    return Semantics(
      button: true,
      label: 'Ouvrir $label en plein écran',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFullScreen(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in_rounded, size: 16, color: chipText),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: chipText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_full_rounded,
                        size: 16,
                        color: chipText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Plein écran",
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: chipText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fermer',
      barrierColor: Colors.black.withOpacity(.92),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 6.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.asset(assetPath),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: 'Fermer',
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
