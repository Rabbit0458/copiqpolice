import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaHistoireReperesPage extends StatelessWidget {
  const PaHistoireReperesPage({super.key});

  static const String routeName = '/pa/institution/histoire/reperes';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardRep = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDates = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMission = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCadre = isDark
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
          "Institution",
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
            "Histoire de la Police nationale — repères",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Image d'illustration (zoom + plein écran)
          _ConditionCard(
            title: "Points de repères — chronologiques",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Astuce : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      "tape sur l’image pour l’ouvrir en plein écran et zoomer.",
                ),
              ]),
              SizedBox(height: 10),
              _ZoomableAssetImage(
                assetPath: 'assets/images/histoire_pn.png',
                semanticLabel:
                    "Frise chronologique : Points de repères de l’histoire en France et repères Police nationale",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intro pédagogique
          _ConditionCard(
            title: "Repère rapide",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Cette page te donne des repères simples : comprendre l’évolution, retenir quelques dates clés, et replacer le rôle de la Police nationale dans l’organisation de l’État.",
              ),
              _IntroBullet(
                text:
                    "Objectif : une lecture claire et mémorisable (chronologie + idées forces).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Repères généraux
          _ConditionCard(
            title: "I — Repères essentiels",
            cardColor: cardRep,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("À retenir"),
              _BulletPoint(
                text:
                    "La police en France évolue avec l’État : centralisation, professionnalisation, modernisation des moyens et des missions.",
              ),
              _BulletPoint(
                text:
                    "La Police nationale s’inscrit dans une logique républicaine : protection des personnes et des biens, maintien de l’ordre public, lutte contre la criminalité, assistance aux populations.",
              ),
              SizedBox(height: 10),
              _SubTitle("Pourquoi ces repères sont utiles ?"),
              _Paragraph(
                "En intervention et dans le cadre institutionnel, connaître quelques repères historiques aide à comprendre : "
                "les missions, les évolutions, et le sens des règles de neutralité, d’égalité de traitement et de service au public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Chronologie (repères)
          _ConditionCard(
            title: "II — Repères chronologiques",
            cardColor: cardDates,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Quelques jalons (à mémoriser)"),
              _BulletPoint(
                text:
                    "1667 : création de la Lieutenance générale de police à Paris (organisation policière structurée).",
              ),
              _BulletPoint(
                text:
                    "1791–1795 : réorganisations révolutionnaires (police au service de l’ordre public et des institutions).",
              ),
              _BulletPoint(
                text:
                    "XIXe siècle : professionnalisation progressive, développement de la police judiciaire et des services spécialisés.",
              ),
              _BulletPoint(
                text:
                    "1941 : création de la « Police nationale » (unification dans le contexte de l’époque).",
              ),
              _BulletPoint(
                text:
                    "Après 1945 : refondation républicaine, modernisation, structuration des directions et spécialités.",
              ),
              _BulletPoint(
                text:
                    "Période contemporaine : adaptation aux nouvelles menaces (terrorisme, cyber, criminalités organisées) et aux exigences de l’État de droit.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Astuce mémo : retiens 1667 (structuration), 1941 (Police nationale), après 1945 (refondation) + une idée-force : modernisation continue.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Missions & valeurs
          _ConditionCard(
            title: "III — Missions & valeurs (fil conducteur)",
            cardColor: cardMission,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Missions"),
              _BulletPoint(text: "Protection des personnes et des biens."),
              _BulletPoint(
                text: "Maintien / rétablissement de l’ordre public.",
              ),
              _BulletPoint(
                text:
                    "Police judiciaire : constatation des infractions, recherche des auteurs, rassemblement des preuves.",
              ),
              _BulletPoint(
                text:
                    "Sécurité routière, assistance et secours aux populations, prévention.",
              ),
              SizedBox(height: 12),
              _SubTitle("Valeurs professionnelles"),
              _BulletPoint(
                text: "Neutralité, respect, sang-froid, discernement.",
              ),
              _BulletPoint(text: "Égalité de traitement des usagers."),
              _BulletPoint(
                text: "Proportionnalité et cadre légal de l’action.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "À travers l’histoire, ce fil conducteur reste le même : agir au service du public, dans un cadre républicain, "
                "avec des missions qui s’adaptent aux évolutions de la société.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Pour aller plus loin / méthode d'apprentissage
          _ConditionCard(
            title: "IV — Méthode rapide pour réviser",
            cardColor: cardCadre,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Mini-plan de révision (2 minutes)"),
              _BulletPoint(
                text: "1) Récite : 1667 → 1941 → après 1945 → aujourd’hui.",
              ),
              _BulletPoint(
                text:
                    "2) Associe chaque date à 1 mot-clé : structuration / unification / refondation / adaptation.",
              ),
              _BulletPoint(
                text:
                    "3) Termine par 3 missions : protéger / maintenir l’ordre / enquêter.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si tu veux, tu peux me donner tes captures d’écran « Histoire » et je te mets exactement le contenu attendu, au mot près, dans ce template.",
                  ),
                ],
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
  const _ZoomableAssetImage({
    required this.assetPath,
    required this.semanticLabel,
  });

  final String assetPath;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return Dialog(
                insetPadding: const EdgeInsets.all(12),
                backgroundColor: isDark
                    ? const Color(0xFF111111)
                    : Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 6,
                    panEnabled: true,
                    child: Image.asset(assetPath, fit: BoxFit.contain),
                  ),
                ),
              );
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF3F3F3),
            padding: const EdgeInsets.all(6),
            child: AspectRatio(
              // On affiche TOUTE l'image sans crop (important pour lire)
              aspectRatio: 1120 / 791,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 3,
                panEnabled: true,
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
