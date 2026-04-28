import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationMandatPage extends StatelessWidget {
  const NotificationMandatPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/interpellation/notification_mandat';

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
    final Color cardProc = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardVigi = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDocs = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
            "PV — Notification d’un mandat (d’amener ou d’arrêt)",
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
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas guide la rédaction d’un procès-verbal de notification d’un mandat "
                "(mandat d’amener ou mandat d’arrêt), exécuté à moins de 200 km avec présentation "
                "immédiate au magistrat mandant.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "L’heure mentionnée lors de l’arrestation est fondamentale : elle peut marquer le début d’une mesure de rétention.",
              ),
              _IntroBullet(
                text:
                    "Les mentions doivent rester factuelles, précises, datées, et chronologiques.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal (références)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Mandats d’instruction : "),
                TextSpan(
                  text: "article 122 alinéa 5 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (mandat d’amener) et "),
                TextSpan(
                  text: "article 122 alinéa 6 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (mandat d’arrêt)."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Menottage / contrainte : "),
                TextSpan(
                  text: "article 803 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — le recours doit être motivé et circonstancié (dangerosité ou risque de fuite).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Déroulé du PV (structure pas à pas)",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de rédaction"),
              const _BulletPoint(
                text:
                    "Indiquer précisément le lieu où le procès-verbal est rédigé (service, unité, commune).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2) Instructions"),
              const _BulletPoint(
                text:
                    "Mentionner que l’agent de police judiciaire agit sous le contrôle de l’officier de police judiciaire.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("3) Exécution du mandat"),
              const _Paragraph(
                "L’agent de police judiciaire indique les références du mandat en vertu duquel il agit. "
                "Les mentions attendues sont les suivantes :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Type de mandat : amener ou arrêt."),
              const _BulletPoint(
                text:
                    "Date de délivrance + nom et qualité du magistrat mandant.",
              ),
              const _BulletPoint(text: "Identité de la personne concernée."),
              const _BulletPoint(
                text:
                    "Motif : personne soupçonnée / témoin assisté / mise en examen.",
              ),
              const _BulletPoint(text: "Infraction visée."),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Penser à faire référence aux articles relatifs au mandat (ex. ",
                  ),
                  TextSpan(
                    text: "art. 122 al. 5 et/ou art. 122 al. 6 C.P.P.",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("4) Assistants"),
              const _BulletPoint(
                text:
                    "Lister les fonctionnaires accompagnant le rédacteur (identité/qualité si nécessaire).",
              ),
              const _BulletPoint(
                text:
                    "Préciser la tenue : uniforme / tenue bourgeoise / port du brassard police.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("5) Transport"),
              const _BulletPoint(
                text:
                    "Transport au dernier domicile connu de la personne concernée.",
              ),
              const _BulletPoint(
                text:
                    "Respect des heures légales : 06h–21h (mentionner l’heure précise d’arrivée).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("6) Identité"),
              const _BulletPoint(
                text:
                    "Exposer qualités et motif de la visite, puis relever l’identité succincte.",
              ),
              const _BulletPoint(
                text:
                    "Préciser le document utilisé pour vérifier l’identité (CNI, passeport, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text: "Selon la situation (comportement/attitude), la ",
                  ),
                  const TextSpan(
                    text: "palpation de sécurité",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text: " peut être réalisée avant l’étape « identité ».",
                  ),
                ],
                title: "Organisation",
              ),
              const SizedBox(height: 12),

              const _SubTitle("7) Mandat de justice"),
              const _BulletPoint(
                text:
                    "Présenter et notifier le mandat à l’intéressé (mentionner la remise d’une copie).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("8) Arrestation"),
              const _BulletPoint(
                text:
                    "Mentionner l’heure exacte (fondamentale) : elle peut correspondre au début d’une mesure de rétention.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("9) Palpation de sécurité"),
              const _Paragraph(
                "Décrire la palpation de sécurité et, le cas échéant, la découverte d’objets "
                "(localisation + description).",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si recours au menottage : préciser les éléments motivant la mesure, conformément à ",
                ),
                TextSpan(
                  text: "l’article 803 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (risque de fuite, menaces, gestes de résistance, dangerosité pour soi/autrui).",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("10) Retour au service"),
              const _BulletPoint(
                text:
                    "Pour l’exécution des mandats, la coercition est possible : l’emploi de la force doit être circonstancié.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("11) Énonciation terminale (clôture)"),
              const _BulletPoint(
                text:
                    "La personne interpellée signe le procès-verbal (et l’heure est précisée).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("12) Avis magistrat"),
              const _BulletPoint(
                text:
                    "Informer le magistrat mandant et indiquer clairement les instructions reçues (présentation immédiate / mesure de rétention en attente).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("13) Présentation au magistrat mandant"),
              const _BulletPoint(
                text:
                    "Mentionner la présentation au magistrat mandant (date/heure) et tout élément utile (compte-rendu verbal, remise éventuelle d’objets).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Points de vigilance",
            cardColor: cardVigi,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _BulletPoint(
                text:
                    "Chronologie : dérouler les faits dans l’ordre, avec des heures exactes.",
              ),
              const _BulletPoint(
                text:
                    "Motivation : toute contrainte (menottage/force) doit être justifiée et décrite.",
              ),
              const _BulletPoint(
                text:
                    "Notification : mentionner la présentation du mandat + la remise d’une copie.",
              ),
              const _BulletPoint(
                text:
                    "Identité : rester strictement sur l’état civil et l’adresse (pas d’éléments de personnalité).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Canevas (visuels)",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph("Appuie pour ouvrir en plein écran et zoomer."),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_mandat_pv.png',
                label: 'Canevas — recto',
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_mandat_pv_verso.png',
                label: 'Canevas — verso',
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
