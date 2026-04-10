import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecherchesInfructueusesMandatPage extends StatelessWidget {
  const RecherchesInfructueusesMandatPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/interpellation/recherches_infructueuses_mandat';

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
            "PV — Perquisition / recherches infructueuses\n(exécution d’un mandat d’amener ou d’arrêt)",
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
            cardColor: cardCanva,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas sert à rédiger un procès-verbal lorsque, en exécution d’un mandat "
                "(d’amener ou d’arrêt), la personne visée n’est pas trouvée : les recherches au domicile "
                "sont réalisées, puis l’absence est constatée et la transmission au magistrat est formalisée.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "But exclusif : rechercher la personne visée par le mandat (et non « perquisitionner » au sens classique).",
              ),
              _IntroBullet(
                text:
                    "Respecter strictement les heures légales d’introduction au domicile : 06h00 → 21h00.",
              ),
              _IntroBullet(
                text:
                    "Mentionner l’heure précise d’arrivée, les assistants, et le déroulé de la visite.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (cadre juridique)
          _ConditionCard(
            title: "I — Cadre juridique",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "La « visite domiciliaire » liée au mandat ",
                ),
                const TextSpan(text: "ne doit pas être assimilée "),
                const TextSpan(text: "à la perquisition de l’"),
                TextSpan(
                  text: "article 56 du Code de procédure pénale",
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
                        "Si la personne ne peut être saisie, un PV de perquisition et de recherches infructueuses "
                        "est adressé au magistrat qui a délivré le mandat : ",
                  ),
                  TextSpan(
                    text: "article 134 du Code de procédure pénale",
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
            title: "II — Structure du PV (plan pédagogique)",
            cardColor: cardGuide,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("À écrire comme un déroulé chronologique"),
              _BulletPoint(
                text:
                    "Style clair, factuel, daté/horodaté (heure précise d’arrivée, déroulé, clôture).",
              ),
              _BulletPoint(
                text:
                    "Identité : relever l’identité succincte de la personne présente (si quelqu’un ouvre) + préciser le support de vérification.",
              ),
              _BulletPoint(
                text:
                    "Déclaration éventuelle (style indirect) : absence de la personne visée, et lieu possible où elle se trouve.",
              ),
              _BulletPoint(
                text:
                    "Visite des lieux : préciser les conditions (serrurier réquisitionné si nécessaire, présence de deux témoins requis).",
              ),
              _BulletPoint(
                text:
                    "Avis magistrat : informer et noter les instructions reçues.",
              ),
              _BulletPoint(
                text:
                    "Clôture / transmission : mentionner la transmission du PV et la fin de mission.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Canevas détaillé (à recopier / adapter)",
            cardColor: cardSteps,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Lieu de rédaction"),
              const _Paragraph(
                "Indiquer la ville / service / date et l’heure de rédaction.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("2) Instructions"),
              const _Paragraph(
                "Rappeler que l’agent de police judiciaire agit sous le contrôle de l’officier de police judiciaire.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("3) Exécution de mandat"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Indiquer les références du mandat en vertu duquel vous agissez :\n"
                      "• type de mandat (amener ou arrêt)\n"
                      "• date de délivrance + nom/qualité du magistrat mandant\n"
                      "• identité de la personne concernée\n"
                      "• motif (soupçonnée / témoin assisté / mise en examen)\n"
                      "• infraction visée\n\n"
                      "Puis : renvoyer aux articles relatifs au mandat et préciser le cadre.",
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("4) Assistants"),
              const _Paragraph(
                "Mentionner les fonctionnaires accompagnants + la tenue de l’équipage "
                "(uniforme, tenue bourgeoise, port du brassard police).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("5) Transport"),
              const _Paragraph(
                "Préciser l’adresse du dernier domicile connu, rappeler le respect des heures légales (06h–21h) "
                "et indiquer l’heure précise d’arrivée sur place.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("6) Identité"),
              const _Paragraph(
                "Relever l’identité succincte de la personne présente (si une personne est sur place). "
                "Préciser le document à partir duquel l’identité est vérifiée.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("7) Visite"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Visiter les lieux afin de s’assurer de la présence ou non de la personne visée.\n\n"
                      "Cette visite a pour but exclusif de rechercher la personne faisant l’objet du mandat. ",
                ),
                TextSpan(
                  text:
                      "Elle n’est pas assimilée à la perquisition de l’article 56 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ".\n\n"),
                TextSpan(
                  text:
                      "En l’absence de la personne : la visite peut être réalisée après réquisition d’un serrurier "
                      "et en présence de deux témoins requis.\n\n",
                ),
                TextSpan(
                  text:
                      "Si la personne ne peut être saisie : PV adressé au magistrat délivrant le mandat — article 134 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("8) Énonciation terminale (clôture)"),
              const _Paragraph("Clore le PV en précisant l’heure."),

              const SizedBox(height: 10),
              const _SubTitle("9) Avis magistrat"),
              const _Paragraph(
                "Informer le magistrat mandant et indiquer les instructions reçues.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("10) Clôture / transmission"),
              const _Paragraph(
                "Mentionner la transmission du procès-verbal (et à qui), puis fin de mission.",
              ),

              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Conseil : notez systématiquement les heures clés (arrivée, début/fin visite, clôture) "
                        "et les personnes présentes (serrurier, témoins requis, assistants).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "CANVA — Modèle PV (zoom)",
            cardColor: cardCanva,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Appuyez sur l’image pour l’ouvrir en plein écran et zoomer.",
              ),
              SizedBox(height: 12),
              _ZoomableAssetImage(
                assetPath: 'assets/images/canva_infructueuse_pv_recto.png',
                label: 'Modèle PV',
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
