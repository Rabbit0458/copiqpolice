import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompteRenduOPJPage extends StatelessWidget {
  const CompteRenduOPJPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/interpellation/compte_rendu_opj';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardGuide = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardSteps = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCanva = isDark
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
            "Canevas — Compte-rendu à l’OPJ",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Objectif
          _ConditionCard(
            title: "Objectif",
            cardColor: cardCanva,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas permet de faire un compte-rendu clair et complet à l’OPJ après une intervention : "
                "qui intervient, pourquoi, où/quand, ce qui s’est passé, les mesures prises, et les éléments utiles "
                "pour l’enquête (mis en cause, victimes, témoins, objets, fichiers consultés).",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Écrire chronologiquement, de façon factuelle et vérifiable (heures, lieux, identités, actions).",
              ),
              _IntroBullet(
                text:
                    "Distinguer : origine → motif (cadre légal) → récit → suites/mesures → éléments d’enquête.",
              ),
              _IntroBullet(
                text:
                    "Toujours préciser ce qui est constaté, ce qui est déclaré, et par qui.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre légal (si tu veux ajouter des articles plus tard, ils seront en rouge)
          _ConditionCard(
            title: "I — Cadre légal (rappel)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le compte-rendu doit situer l’intervention dans un cadre légal clair (flagrant délit, contrôle "
                "d’identité, exécution d’un mandat, situation d’un étranger, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Quand un article de loi doit être cité, écris-le sous la forme : ",
                  ),
                  TextSpan(
                    text:
                        "« Article XXX du Code de procédure pénale » / « Article XXX du Code pénal »",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " (toujours en rouge)."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Structure
          _ConditionCard(
            title: "II — Structure du compte-rendu (plan)",
            cardColor: cardGuide,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("À faire apparaître dans cet ordre"),
              _BulletPoint(text: "1) Agents intervenants"),
              _BulletPoint(text: "2) Origine de l’intervention"),
              _BulletPoint(text: "3) Date / heure / lieu d’intervention"),
              _BulletPoint(text: "4) Motif d’intervention (cadre légal)"),
              _BulletPoint(text: "5) Récit des faits"),
              _BulletPoint(
                text: "6) Conditions d’interpellation / conduite au poste",
              ),
              _BulletPoint(text: "7) Mis en cause"),
              _BulletPoint(text: "8) Victime(s)"),
              _BulletPoint(text: "9) Témoin(s)"),
              _BulletPoint(text: "10) Préjudice matériel estimé"),
              _BulletPoint(text: "11) Objet(s) appréhendé(s)"),
              _BulletPoint(text: "12) Autre(s) mesure(s) prise(s)"),
              _BulletPoint(text: "13) Recherches fichiers"),
            ],
          ),

          const SizedBox(height: 14),

          // Canevas détaillé
          _ConditionCard(
            title: "III — Canevas détaillé (à recopier / adapter)",
            cardColor: cardSteps,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Agents intervenants"),
              _Paragraph(
                "Unité d’affectation, composition de l’équipage (grade, nom, prénom) et tenue des agents "
                "(tous en uniforme ou tenue bourgeoise avec port du brassard police).",
              ),

              SizedBox(height: 10),
              _SubTitle("2) Origine de l’intervention"),
              _Paragraph(
                "Préciser l’origine :\n"
                "• Initiative (flagrance en patrouille, contrôle routier, contrôle d’identité…)\n"
                "• Réquisition particulier (victime ou témoin)\n"
                "• Appel C.I.C. (intervention signalée par radio)\n"
                "• Instructions (mission ordonnée : contrôle débit de boissons, recherche et interpellation, "
                "réquisition / instructions du procureur : alcoolémie / STUP / contrôle d’identité…).",
              ),

              SizedBox(height: 10),
              _SubTitle("3) Date / heure / lieu d’intervention"),
              _Paragraph(
                "Indiquer précisément : date, heure de début, lieu (adresse / secteur).",
              ),

              SizedBox(height: 10),
              _SubTitle("4) Motif d’intervention (cadre légal)"),
              _Paragraph(
                "Expliquer clairement pourquoi l’OPJ doit être informé : interpellation / conduite au poste "
                "(flagrant délit, contrôle d’identité, exécution d’un mandat, situation étranger…), "
                "ou toute autre intervention (ex : découverte de cadavre…).",
              ),

              SizedBox(height: 10),
              _SubTitle("5) Récit des faits"),
              _Paragraph(
                "Relater fidèlement les faits constatés et l’action des policiers.\n"
                "Préciser le comportement et le rôle de chacun des mis en cause.\n"
                "Indiquer l’heure et le lieu exacts d’interpellation si différents du début d’intervention.",
              ),

              SizedBox(height: 10),
              _SubTitle("6) Conditions d’interpellation / conduite au poste"),
              _Paragraph(
                "Motif justifiant le menottage (dangereux pour lui-même / autrui, ou susceptible de prendre la fuite).\n"
                "Actes de résistance et moyens de coercition utilisés.\n"
                "Description des blessures éventuelles (liées à l’interpellation ou pré-existantes).",
              ),

              SizedBox(height: 10),
              _SubTitle("7) Mis en cause"),
              _Paragraph(
                "Nombre de mis en cause.\n"
                "Identités contrôlées (C.N.I., passeport…), déclarées ou non communiquées.\n"
                "Mineur(s) / majeur(s).\n"
                "Éléments particuliers : comportement (ivresse…), qualité connue/déclarée (majeur protégé, personnalité locale…).",
              ),

              SizedBox(height: 10),
              _SubTitle("8) Victime(s)"),
              _Paragraph(
                "Nombre, identité(s), qualité(s) si nécessaire (PDAP, personne vulnérable, personnalité locale…).\n"
                "Nature et gravité des blessures.\n"
                "Lieu d’hospitalisation le cas échéant.\n"
                "Intention de déposer plainte.",
              ),

              SizedBox(height: 10),
              _SubTitle("9) Témoin(s)"),
              _Paragraph(
                "Identité des témoins présents.\n"
                "Ce qu’ils peuvent apporter : signalement(s), déroulement, rôle de chacun, éléments orientant les recherches.",
              ),

              SizedBox(height: 10),
              _SubTitle("10) Préjudice matériel estimé"),
              _Paragraph(
                "Nature et gravité des dégâts.\n"
                "Montant estimé.\n"
                "Objets dérobés : nature, nombre, valeur déclarée.",
              ),

              SizedBox(height: 10),
              _SubTitle("11) Objet(s) appréhendé(s)"),
              _Paragraph(
                "Objets utiles à l’enquête : découverts sur les lieux, en possession du mis en cause "
                "au moment de l’interpellation (ex : sac contenant objets dérobés), "
                "ou découverts lors de la palpation (ex : arme, pied-de-biche…).",
              ),

              SizedBox(height: 10),
              _SubTitle("12) Autre(s) mesure(s) prise(s)"),
              _Paragraph(
                "Exemples : destination véhicule volé, immobilisation du véhicule, rétention du permis, "
                "sécurisation des lieux par un autre équipage, préservation des traces et indices…",
              ),

              SizedBox(height: 10),
              _SubTitle("13) Recherches fichiers"),
              _Paragraph("Préciser les fichiers consultés et le résultat."),
            ],
          ),

          const SizedBox(height: 14),

          // Canva
          _ConditionCard(
            title: "CANVA — Modèle (zoom)",
            cardColor: cardCanva,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Appuyez sur l’image pour l’ouvrir en plein écran et zoomer.",
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/compte_rendu_opj.png',
                label: 'Compte-rendu OPJ',
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
