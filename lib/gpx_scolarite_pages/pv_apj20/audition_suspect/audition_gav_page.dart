import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuditionGavPage extends StatelessWidget {
  const AuditionGavPage({super.key});

  static const String routeName = '/gpx/pv_apj20/audition_suspect/audition_gav';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cartes (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardGuide = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardProc = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardVigil = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
          "Audition GAV",
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
            "Canevas — procès-verbal d’audition du mis en cause gardé à vue",
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
            cardColor: cardGuide,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce canevas t’aide à rédiger une audition en garde à vue de manière claire, complète et juridiquement cadrée : "
                "mentions indispensables, visas utiles, déroulé logique et clôture propre.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Rendu pédagogique, structuré et exploitable en procédure.",
              ),
              _IntroBullet(
                text:
                    "Pensé pour éviter les oublis (lieu, délais, assistances, clôture).",
              ),
              _IntroBullet(
                text:
                    "Compatible avec audition au service ou hors service (hôpital, autre service, etc.).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal tout en haut (comme demandé)
          _ConditionCard(
            title: "Cadre juridique — visas (à placer en tête)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "L’action de l’enquêteur doit être située : ",
                ),
                TextSpan(
                  text: "enquête de flagrance",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                const TextSpan(text: " ou "),
                TextSpan(
                  text: "enquête préliminaire",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                const TextSpan(text: ", sous le contrôle de l’OPJ."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("Visas utiles (assistance / protections)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "• Visas relatifs à l’assistance de l’avocat lors des auditions : ",
                ),
                TextSpan(
                  text:
                      "articles du Code de procédure pénale (CPP) relatifs à l’assistance de l’avocat en GAV",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "• Majeur protégé (si concerné) : "),
                TextSpan(
                  text: "article 706-112-1 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (tutelle, curatelle, sauvegarde de justice).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "• Mineur (accompagnement possible) : "),
                TextSpan(
                  text: "article L.311-1 du CJPM",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (présence d’un titulaire de l’autorité parentale ou d’un adulte approprié, selon l’intérêt supérieur de l’enfant et sans préjudice à la procédure).",
                ),
              ]),
              const SizedBox(height: 12),

              _NotaBox(
                title: "Point de vigilance",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le délai d’attente de 2 heures doit être respecté avant de débuter la première audition en présence de l’avocat (à compter de l’avis à l’avocat choisi ou de permanence). ",
                  ),
                  const TextSpan(
                    text:
                        "Pendant ce délai, seule une audition portant sur les éléments essentiels d’identité est admise (état civil et adresse), à l’exclusion des éléments de personnalité.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "1 — Lieu de rédaction",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Mentionner l’endroit exact où se déroule l’audition. "
                "Dans certains cas, l’APJ peut entendre le mis en cause hors service (autre service, hôpital, etc.).",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Indiquer précisément : service / unité / commune / adresse (si utile).",
              ),
              _BulletPoint(
                text:
                    "Si hors service : préciser le motif (hospitalisation, transfert, contraintes opérationnelles…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "2 — Instructions & hiérarchie (flagrance / préliminaire)",
            cardColor: cardGuide,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Flagrance"),
              _Paragraph(
                "En flagrant délit, l’agent de police judiciaire agit conformément aux instructions reçues de l’officier de police judiciaire.",
              ),
              SizedBox(height: 10),
              _SubTitle("Préliminaire"),
              _Paragraph(
                "En enquête préliminaire, l’agent agit sous le contrôle de l’officier de police judiciaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "3 — Assistants éventuels",
            cardColor: cardGuide,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le rédacteur peut se faire assister d’un collègue. "
                "Si c’est le cas, le mentionner clairement en indiquant son grade, son nom et son service.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Grade — Nom — Service (et rôle concret si utile).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "4 — Présence de l’avocat",
            cardColor: cardVigil,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Avant de débuter la première audition (hors identité), respecter le délai d’attente de deux heures "
                "à compter du moment où l’avocat choisi ou de permanence a été avisé.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Pendant l’attente : "),
                  const TextSpan(
                    text:
                        "seule une audition d’identité (état civil + adresse) est possible, à l’exclusion de la personnalité.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Si l’avocat est présent : le mentionner, ainsi que l’heure d’arrivée et le moment effectif de début d’audition.",
              ),
              const _BulletPoint(
                text:
                    "Si absence à l’issue du délai : mentionner les diligences, l’heure de l’avis, et le début d’audition.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title:
                "5 — Présence d’un représentant légal / adulte approprié (mineur)",
            cardColor: cardVigil,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le mineur suspecté peut être accompagné lors de ses auditions (si l’enquêteur estime que c’est dans son intérêt et sans préjudice à la procédure) : ",
                ),
                TextSpan(
                  text: "article L.311-1 du CJPM",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Mentionner l’identité et la qualité de la personne présente (père/mère/tuteur/adulte approprié).",
              ),
              const _BulletPoint(
                text:
                    "L’audition peut débuter en l’absence de ces personnes à l’issue d’un délai de deux heures à compter de l’invitation : noter heures et diligences.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les personnes accompagnantes ne posent pas de questions et ne formulent pas d’observations.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "6 — Identité",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Renseigner les éléments essentiels d’identité (état civil et adresse). "
                "En phase d’attente avocat, rester strictement sur l’identité (pas de situation pro/familiale).",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "État civil complet."),
              _BulletPoint(
                text:
                    "Adresse complète + précisions utiles (bâtiment, étage, interphone si nécessaire).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "7 — Déclarations (récit libre)",
            cardColor: cardGuide,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Retranscrire le récit du mis en cause sur les faits reprochés en utilisant la première personne. "
                "Laisser parler : audition non subjective, non dirigée.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Si aveux : exiger des aveux circonstanciés (H.L.M. : Heure — Lieu — Motif).",
              ),
              _BulletPoint(
                text: "Rester factuel : pas d’interprétation, pas de jugement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "8 — Questions / réponses",
            cardColor: cardGuide,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Poser des questions pour préciser, rectifier, vérifier la cohérence, ou confronter à des éléments objectifs. "
                "Utiliser la forme questions–réponses en reformulant stricto sensu.",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Questions courtes, une idée à la fois."),
              _BulletPoint(
                text: "Horodatage si nécessaire (avant/après tel événement).",
              ),
              _BulletPoint(
                text:
                    "Confrontation aux contradictions : calmement, sur des faits vérifiables.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "9 — Objets / documents (présentation, confrontation)",
            cardColor: cardProc,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Mentionner la présentation des objets et/ou documents saisis, et la réaction du mis en cause. "
                "Décrire ce qui est montré (référence, scellés, pièces) et ce que la personne déclare.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Référencer précisément : scellés, PV annexes, pièces de procédure.",
              ),
              _BulletPoint(
                text: "Noter les explications, reconnaissances, contestations.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "10 — Clôture (énonciation terminale)",
            cardColor: cardVigil,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Indiquer impérativement l’heure de fin d’audition. "
                "Clore par une formule : aveux / persistance de la négation / maintien des déclarations.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Heure de fin indispensable (cohérence GAV / délais).",
              ),
              _BulletPoint(
                text:
                    "Mention finale : lecture faite / observations éventuelles / signatures.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Questions de l’avocat & observations écrites",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les questions de l’avocat, s’il est présent, interviennent à la fin de l’audition. "
                "L’enquêteur peut s’opposer à des questions si elles nuisent au bon déroulement de l’enquête : "
                "le refus doit être mentionné au PV.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Observations écrites : l’avocat peut remettre des observations à joindre au PV d’audition.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Aperçu visuel (recto / verso)",
            cardColor: cardGuide,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Clique sur les images pour ouvrir l’aperçu zoomable (pincez pour zoomer, glissez pour déplacer).",
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/audition_gav_recto.png',
                heroTag: 'audition_gav_recto',
              ),
              SizedBox(height: 12),
              ZoomableAssetImage(
                assetPath: 'assets/images/audition_gav_verso.png',
                heroTag: 'audition_gav_verso',
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
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.08);

    final Color shadow = Colors.black.withOpacity(isDark ? .28 : .12);

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
      label: "Image zoomable",
      hint: "Touchez pour ouvrir, pincez pour zoomer, glissez pour déplacer",
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
        ? Colors.black.withOpacity(.92)
        : Colors.black.withOpacity(.86);

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
    final Color fg = Colors.white.withOpacity(.95);
    final Color bg = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.white.withOpacity(.12);

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
                  "Aperçu",
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
    final Color fg = Colors.white.withOpacity(.92);
    final Color bg = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.white.withOpacity(.12);

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
                "Pincez pour zoomer • Glissez pour déplacer • Tapez pour fermer",
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
        ? Colors.white.withOpacity(.12)
        : Colors.black.withOpacity(.06);
    final Color fg = isDark ? Colors.white : Colors.black.withOpacity(.78);

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
        border: Border.all(color: Colors.white.withOpacity(.12), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
