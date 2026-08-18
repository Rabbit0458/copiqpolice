import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RequisitionPersonnePage extends StatelessWidget {
  const RequisitionPersonnePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/requisitions/requisition_personne';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardOaths = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDocs = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardModel = isDark
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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
            "f00002",
            "Réquisition à personne",
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
              "f00003",
              "Canevas du procès-verbal de réquisition à personne",
            ),
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
            cardColor: cardModel,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00004",
                      "Structurer correctement un procès-verbal de réquisition adressé à une personne ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00005",
                      "(personne qualifiée notamment), en respectant le cadre juridique et les mentions indispensables.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (réquisition à personne qualifiée)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
              "f00006",
              "Élément légal — articles de référence",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00007",
                    "Articles 60 et 77-1 du Code de procédure pénale (CPP)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00008",
                    " : fondent la réquisition à personne qualifiée (constatations/examens techniques et scientifiques utiles à l’enquête).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                          "f00009",
                          "En flagrant délit, l’APJ agit sous le contrôle de l’OPJ. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                          "f00010",
                          "En enquête préliminaire, l’APJ agit sur autorisation du procureur de la République.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Étapes canevas
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
              "f00011",
              "Mentions indispensables — canevas (8 points)",
            ),
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00012",
                  "1) Instructions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00013",
                      "Préciser le cadre :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00014",
                      "• Flagrance : APJ sous contrôle OPJ.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00015",
                      "• Préliminaire : APJ sur autorisation du procureur.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00016",
                  "2) Cadre juridique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00017",
                  "Indiquer clairement si l’acte s’inscrit en enquête de flagrance ou en enquête préliminaire.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00018",
                  "3) Visa de l’article de référence",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00019",
                      "Le visa dépend du cadre et du type de réquisition :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00020",
                      "• à personne qualifiée,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00021",
                      "• générale,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00022",
                      "• informatique/téléphonique,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00023",
                      "• à manœuvrier.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00024",
                  "4) Identité de la personne requise",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00025",
                  "Mentionner une identité succincte (état civil + qualité/fonction si utile).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00026",
                  "5) Mission confiée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00027",
                  "Décrire précisément la mission et lister les actes attendus (constatations, examens, copies, etc.).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00028",
                  "6) Prestation de serment",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00029",
                  "Rappeler l’obligation de serment avant la mission, sauf inscription sur une liste d’experts.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00030",
                  "7) Remise de documents",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00031",
                  "Rappeler l’obligation d’accomplir la prestation et les garanties associées lors de la remise de l’acte.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00032",
                  "8) Mentions terminales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00033",
                  "Le rédacteur signe l’acte (date/heure si prévue par ton modèle).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Serment (pédago + articles en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
              "f00034",
              "Focus — prestation de serment (personne qualifiée)",
            ),
            cardColor: cardOaths,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00035",
                    "La personne qualifiée requise, en vertu des ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00036",
                    "articles 60 et 77-1 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00037",
                    ", doit prêter serment avant l’accomplissement de sa mission, sauf si elle est inscrite sur une liste d’experts.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00038",
                    "Listes d’experts prévues à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00039",
                    "l’article 157 du CPP",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                          "f00040",
                          "Serment formulé par écrit : « apporter son concours à la justice en son honneur et conscience ».\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                          "f00041",
                          "Il figure :\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                          "f00042",
                          "• en tête du rapport, OU\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                          "f00043",
                          "• sur une déclaration écrite séparée.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Remise + sécurité juridique
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
              "f00044",
              "Remise du document — bon réflexe",
            ),
            cardColor: cardDocs,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00045",
                      "Lors de la remise de la réquisition, rappeler clairement :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00046",
                      "• l’obligation d’accomplir la prestation,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00047",
                      "• l’objet exact de la mission,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00048",
                      "• les délais attendus,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                      "f00049",
                      "• et toute mention utile (scellés, restitution, confidentialité).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Image CANVA
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
              "f00050",
              "Modèle (CANVA) — aperçu",
            ),
            cardColor: cardModel,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              ZoomableAssetImage(
                assetPath: "assets/images/requisition_personne.png",
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
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
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
                : const Color(0xFF3E2723).withValues(alpha: .95),
          ),
          children: [...bodySpans],
        ),
      ),
    );
  }
}

// Les class suivantes doivent être utilisées dans ta page si je dois affiché une image de caneva : (UNIQUMENT POUR AFFICHER UNE IMAGE CANVA)

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.heroTag,
    this.borderRadius = 16,
    this.backgroundColor,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.enableHero = true,
  });

  final String assetPath;

  /// Si tu veux un Hero stable : passe un tag unique.
  /// Sinon, par défaut on utilise assetPath.
  final Object? heroTag;

  final double borderRadius;
  final Color? backgroundColor;

  final double minScale;
  final double maxScale;

  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg =
        backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF));

    final Color border = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.black.withValues(alpha: .08);

    final Color shadow = Colors.black.withValues(alpha: isDark ? .28 : .12);

    final tag = heroTag ?? assetPath;

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );

    if (enableHero) {
      image = Hero(tag: tag, child: image);
    }

    return Semantics(
      label: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
        "f00051",
        "Image zoomable",
      ),
      hint: ScolariteText.value(
        "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
        "f00052",
        "Touchez pour ouvrir, pincez pour zoomer, glissez pour déplacer",
      ),
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _openViewer(context, tag),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(child: image),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _Badge(
                    isDark: isDark,
                    text: "Zoom",
                    icon: Icons.zoom_in_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context, Object tag) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => _ZoomableImageViewer(
          assetPath: assetPath,
          heroTag: enableHero ? tag : null,
          minScale: minScale,
          maxScale: maxScale,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(opacity: curved, child: child);
        },
      ),
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({
    required this.assetPath,
    required this.heroTag,
    required this.minScale,
    required this.maxScale,
  });

  final String assetPath;
  final Object? heroTag;

  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color scrim = isDark
        ? Colors.black.withValues(alpha: .92)
        : Colors.black.withValues(alpha: .86);

    Widget image = Image.asset(
      assetPath,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Fond sombre
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              color: scrim,
            ),

            // Image zoom/pan
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  _TopBar(
                    onClose: () => Navigator.of(context).maybePop(),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: minScale,
                        maxScale: maxScale,
                        clipBehavior: Clip.none,
                        child: image,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HintBar(isDark: isDark),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose, required this.isDark});

  final VoidCallback onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .95);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _Pill(
            bg: bg,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 18, color: fg),
                const SizedBox(width: 8),
                Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                    "f00053",
                    "Aperçu",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: fg,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 18, color: fg),
                    const SizedBox(width: 6),
                    Text(
                      "Fermer",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: fg,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintBar extends StatelessWidget {
  const _HintBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withValues(alpha: .92);
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .10)
        : Colors.white.withValues(alpha: .12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _Pill(
        bg: bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pinch_rounded, size: 18, color: fg),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart",
                  "f00054",
                  "Pincez pour zoomer • Glissez pour déplacer • Tapez pour fermer",
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.isDark, required this.text, required this.icon});

  final bool isDark;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark
        ? Colors.white.withValues(alpha: .12)
        : Colors.black.withValues(alpha: .06);
    final Color fg = isDark
        ? Colors.white
        : Colors.black.withValues(alpha: .78);

    return _Pill(
      bg: bg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: .12),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
