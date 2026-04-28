import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVCIDecouverteArmePage extends StatelessWidget {
  const PVCIDecouverteArmePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/interpellation/ci_decouverte_arme';

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
            "PV de contrôle d’identité — découverte d’une arme",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / objectif
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas guide la rédaction d’un procès-verbal lorsque, à l’occasion d’un contrôle "
                "d’identité, une arme est découverte et que la situation conduit à une interpellation "
                "et à la remise de l’objet à l’officier de police judiciaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Fondement juridique en haut (articles en rouge)
          _ConditionCard(
            title: "I — Fondement juridique",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "Le cadre du contrôle d’identité est rappelé par ",
                ),
                const TextSpan(
                  text:
                      "les articles 78-2 (alinéas 2 à 17) et 78-2-1 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le recours éventuel au menottage doit être justifié conformément à ",
                ),
                const TextSpan(
                  text: "l’article 803 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Dans le PV, pense à faire ressortir clairement le cadre exact (alinéa) retenu pour le contrôle, "
                        "et à décrire précisément les circonstances ayant conduit à la découverte de l’arme.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Étapes du PV (canevas)
          _ConditionCard(
            title: "II — Canevas du procès-verbal (structure)",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de saisine"),
              const _BulletPoint(
                text: "Mentionner l’endroit exact où se situe l’équipage.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2) Instructions (PV de saisine)"),
              const _BulletPoint(
                text:
                    "Équipage en patrouille : le rédacteur agit conformément aux instructions permanentes du chef de service.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("3) Assistants éventuels"),
              const _BulletPoint(
                text:
                    "Citer les fonctionnaires accompagnants + préciser la tenue (uniforme, tenue bourgeoise, port du brassard police).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("4) Mission"),
              const _BulletPoint(
                text: "Indiquer le but de la mission initiale.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("5) Constatations"),
              const _BulletPoint(
                text:
                    "Relater les faits de manière précise et faire ressortir les éléments justifiant le contrôle d’identité.",
              ),
              const _BulletPoint(
                text:
                    "Préciser le cadre du contrôle (ex. art. 78-2 al. 2 à 17 / art. 78-2-1).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("6) Instructions (formule obligatoire)"),
              const _BulletPoint(
                text:
                    "Inscrire la formule : « sur l’ordre et sous la responsabilité d’un officier de police judiciaire » (sinon risque de nullité).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("7) Visa de l’article CPP"),
              const _BulletPoint(
                text:
                    "Viser l’alinéa de l’article 78-2 correspondant, ou l’article 78-2-1 selon le cas.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("8) Contrôle"),
              const _BulletPoint(
                text: "Mentionner l’heure et le lieu du contrôle.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("9) Palpation de sécurité"),
              const _BulletPoint(
                text:
                    "Non systématique : seulement si nécessaire selon circonstances de temps/lieux.",
              ),
              const _BulletPoint(
                text:
                    "Préciser la localisation et la description de l’arme découverte + la catégorie (port interdit).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("10) Cadre juridique (suite à la découverte)"),
              const _BulletPoint(
                text:
                    "Si port interdit : intervenir en flagrant délit (adapter selon les constatations).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("11) Interpellation"),
              const _BulletPoint(
                text:
                    "Indiquer l’heure et le lieu (si différent du lieu du contrôle).",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: "Si menottage : justifier précisément, conformément à ",
                ),
                const TextSpan(
                  text: "l’article 803 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " (risque de fuite / dangerosité / résistance…).",
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("12) Identité (style indirect)"),
              const _BulletPoint(
                text:
                    "État civil et adresse uniquement (pas de situation familiale/professionnelle).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Actes spécifiques (DRDA + suite)
          _ConditionCard(
            title: "III — Actes clés à ne pas rater",
            cardColor: cardActes,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("13) Présentation & appréhension (D.R.D.A.)"),
              const _BulletPoint(
                text:
                    "Représenter l’arme à la personne : elle peut faire une brève déclaration (style direct) sur l’appartenance, ou ne pas répondre.",
              ),
              const _BulletPoint(
                text:
                    "Ce n’est pas une audition : ne pas poser de questions hors appartenance.",
              ),
              const _BulletPoint(
                text:
                    "Appréhender l’arme pour remise à l’OPJ (Description — Représentée — Déclaration — Appréhendée).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("14) Avis O.P.J."),
              const _BulletPoint(
                text:
                    "Mentionner les instructions reçues de l’officier de police judiciaire.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("15) Retour au service"),
              const _BulletPoint(
                text:
                    "Si usage de la force : décrire la résistance + les moyens de coercition utilisés.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("16) Énonciation terminale (clôture)"),
              const _BulletPoint(
                text:
                    "Signature seulement si déclarations au style direct. Si tout est au style indirect : pas de signature.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("17) Présentation O.P.J."),
              const _BulletPoint(
                text:
                    "Présenter l’individu sans délai + compte-rendu verbal + remise de l’arme.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("18) Mention"),
              const _BulletPoint(
                text:
                    "Recherches administratives : FPR, TAJ (le cas échéant). Mentionner que la consultation a bien été effectuée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Images (tap => plein écran + zoom)
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
                assetPath: 'assets/images/canva_decouverte_arme.png',
                label: 'Recto — canevas',
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_decouverte_arme_verso.png',
                label: 'Verso — suite',
              ),
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
