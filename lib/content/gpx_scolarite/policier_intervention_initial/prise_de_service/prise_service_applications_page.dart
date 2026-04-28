import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriseServiceApplicationsPage extends StatelessWidget {
  const PriseServiceApplicationsPage({super.key});

  static const String routeName =
      '/gpx/intervention/prise-service/applications';

  // Couleur des articles de loi (CPP / CP / CSI / etc.)
  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Prise de service",
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
            "Applications « Main courante » et « Déclaration d’usagers »",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut : aucun article fourni -> on n’invente pas.
          _ConditionCard(
            title: "Référence (cadre)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le contenu fourni décrit des outils applicatifs internes (main courante et déclaration d’usagers) "
                "et leurs usages opérationnels. Aucun article de loi n’est explicitement mentionné dans ton texte pour servir "
                "de fondement juridique direct.\n\n"
                "➡️ Si ton cours indique une référence (CPP/CSI/Code de déontologie/notes de service), place-la ici : "
                "je la mettrai en rouge automatiquement.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: 'IMPORTANT',
                bodySpans: const [
                  TextSpan(
                    text:
                        "On n’invente jamais les références : on affiche uniquement celles présentes dans ta source officielle.",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Fonctions de la « main courante »",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La main courante remplit plusieurs fonctions essentielles au suivi de l’activité et au partage "
                "de l’information au sein des services.",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Gestion chronologique des événements."),
              _BulletPoint(
                text:
                    "Gestion des emplois et des activités du personnel de sécurité publique.",
              ),
              _BulletPoint(
                text:
                    "Diffusion et partage d’information dans le cadre de missions de police judiciaire et du traitement de l’information criminelle.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La réception des déclarations d’usagers s’effectue, elle, sur une application dédiée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "I — Gestion chronologique des événements",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Elle consiste en la saisie de tous les événements traités (d’initiative comme sur réquisition) "
                "par tous les services de sécurité publique et par les unités de renfort (CRS, EGM, voire polices municipales).",
              ),
              SizedBox(height: 12),
              _SubTitle("Chaque intervention donne lieu à une fiche"),
              _Paragraph(
                "Chaque intervention fait l’objet de la création d’une fiche relatant l’intervention dans son intégralité.",
              ),
              SizedBox(height: 10),
              _IntroBullet(text: "heure de saisine ;"),
              _IntroBullet(
                text: "heure d’arrivée sur les lieux et d’intervention ;",
              ),
              _IntroBullet(
                text: "équipage intervenant (composition du véhicule) ;",
              ),
              _IntroBullet(text: "nature des faits ;"),
              _IntroBullet(
                text:
                    "secteur (circonscription découpée en secteurs, incluant les quartiers sensibles, permettant une localisation géographique des faits dénoncés) ;",
              ),
              _IntroBullet(text: "identité des personnes concernées."),
              SizedBox(height: 12),
              _SubTitle("Le « film » des événements"),
              _Paragraph(
                "Le « film » constitué par l’ensemble des événements enregistrés peut être consulté par les chefs de service et d’unité. "
                "Il constitue une « grille de lecture » des interventions (ou des faits dénoncés), ainsi que de leur répartition dans le temps et dans l’espace.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Gestion des emplois",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Il s’agit de la saisie de l’ensemble des heures de travail effectuées par la totalité des fonctionnaires, "
                "sans distinction de corps ni de services d’appartenance.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Les fonctionnalités de la main courante permettent la transmission des informations enregistrées "
                "à l’échelon central de chaque direction concernée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Réception des déclarations d’usagers",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’application « déclaration d’usagers » permet de recevoir des doléances ne présentant pas de caractère pénal "
                "(exemples : abandon de domicile conjugal, conflits de voisinage, différent locatif…).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Une victime ne souhaitant pas déposer plainte peut également effectuer une déclaration pour des infractions peu importantes "
                "entraînant un faible préjudice.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Certaines déclarations peuvent donner lieu à des interventions, voire à des verbalisations (ex : rondes et patrouilles suite à des nuisances sonores).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "À retenir (opérationnel)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Main courante"),
              _BulletPoint(
                text:
                    "Outil de traçabilité : événements, interventions, répartition dans le temps et dans l’espace.",
              ),
              _BulletPoint(
                text:
                    "Outil de pilotage : consultation par les chefs de service / d’unité.",
              ),
              SizedBox(height: 12),
              _SubTitle("Déclaration d’usagers"),
              _BulletPoint(
                text:
                    "Canal dédié pour les doléances sans caractère pénal (et parfois pour des faits mineurs).",
              ),
              _BulletPoint(
                text:
                    "Peut déclencher une action terrain (rondes, intervention) et, selon les cas, une verbalisation.",
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
