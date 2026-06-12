import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaSecuriteTrajetLieuxPage extends StatelessWidget {
  const PaSecuriteTrajetLieuxPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/accident-circulation/securite-trajet-lieux';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardI = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardII = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardIII = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNota = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Accident de circulation",
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
            "Sécurité pendant le trajet et sur les lieux du constat",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: "Objectif & contexte",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’accident corporel de la circulation nécessite, dans tous les cas, l’intervention des services de police "
                "pour assurer la sécurité sur la voie publique, effectuer l’enquête et, en l’absence éventuelle des services spécialisés, porter secours.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’intervention s’effectue en équipe, sous les ordres du chef de bord, qui désigne :\n"
                "• les agents chargés d’assurer la sécurité de l’intervention\n"
                "• les agents chargés d’effectuer les constatations",
              ),
              SizedBox(height: 12),
              _SubTitle("Pourquoi c’est important ?"),
              _Paragraph(
                "Les mesures de sécurité sont déterminantes : les accidents de policiers survenus à la suite de cette mission "
                "représentent 7,2 % du total des accidents des fonctionnaires de police.",
              ),
              SizedBox(height: 8),
              _IntroBullet(text: "En allant sur les lieux : 16 %"),
              _IntroBullet(text: "En constatant : 78 %"),
              _IntroBullet(text: "En revenant : 6 %"),
            ],
          ),

          const SizedBox(height: 14),

          // I
          _ConditionCard(
            title: "I — Sécurité pendant le trajet",
            cardColor: cardI,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le respect des règles de sécurité commence dès le début de l’intervention, notamment sur le trajet.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Localisation précise : connaître exactement le point d’accident permet de gagner du temps sans augmenter le risque.",
              ),
              _BulletPoint(
                text:
                    "Itinéraire adapté : le bon choix d’axe et de sens d’approche peut être aussi efficace qu’une conduite en urgence.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II
          _ConditionCard(
            title: "II — Sécurité avant les constatations",
            cardColor: cardII,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le responsable met en place une signalisation avancée dite « de danger », destinée à assurer la sécurité des intervenants.",
              ),
              SizedBox(height: 12),
              _SubTitle("A) Signalisation avancée « tri-flash »"),
              _BulletPoint(
                text:
                    "Installer un panneau « tri-flash » portant l’inscription « accident » de part et d’autre de l’obstacle.",
              ),
              _BulletPoint(
                text:
                    "Distance indicative : environ 150 m (augmenter si vitesse élevée ; réduire si Vmax = 50 km/h).",
              ),
              _BulletPoint(
                text:
                    "Bornes à respecter : distance maximale 300 m, minimale 100 m.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Agent « protecteur »"),
              _BulletPoint(
                text:
                    "Déposer au moins un agent protecteur à proximité de l’équipe opérationnelle.",
              ),
              _BulletPoint(
                text:
                    "Mission : obtenir le ralentissement et, si nécessaire, l’arrêt des véhicules arrivant sur zone.",
              ),
              _BulletPoint(
                text:
                    "Matériel : palette de signalisation lumineuse (balancée à bout de bras dans un plan vertical).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III
          _ConditionCard(
            title: "III — Sécurité pendant les constatations",
            cardColor: cardIII,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Positionnement du véhicule d’intervention"),
              _BulletPoint(
                text:
                    "Moyens de signalisation allumés (gyrophares : bleu et orange).",
              ),
              _BulletPoint(
                text:
                    "Si le véhicule intervient en premier : se garer en protection des obstacles.",
              ),
              _BulletPoint(
                text:
                    "Si les secours sont déjà sur place : stationner sans gêner la circulation ni les opérations.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Principes généraux sur zone"),
              _Paragraph(
                "Au cours des constatations, des mesures de sécurité doivent être prises à l’égard des véhicules accidentés "
                "et des personnes intervenantes. Lorsque les policiers arrivent les premiers sur les lieux, ils doivent porter secours "
                "aux blessés avec toutes les précautions nécessaires, en attendant les services spécialisés.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Sécurité des lieux"),
              _BulletPoint(
                text:
                    "Mettre en place des dispositifs coniques (cônes de Lubeck) à bandes rouges/blanches pour baliser les limites de chaussée.",
              ),
              _BulletPoint(
                text: "Espacement : environ 5 m entre chaque élément.",
              ),
              _BulletPoint(
                text:
                    "Fixer des bandes plastiques réfléchissantes rouges/blanches sur le véhicule accidenté du côté de la déviation.",
              ),
              _BulletPoint(
                text:
                    "Utiliser une raquette de signalisation (feux fixes/clignotants), tenue à la main ou sur mât, au droit de l’obstacle.",
              ),
              _BulletPoint(
                text:
                    "La nuit : éclairer véhicules et chargements avec des projecteurs orientés pour éviter l’éblouissement.",
              ),
              SizedBox(height: 12),
              _SubTitle("D) Mesures complémentaires"),
              _BulletPoint(
                text:
                    "Vérifier que les contacts des véhicules sont coupés ; neutraliser les batteries si besoin.",
              ),
              _BulletPoint(text: "Éloigner les fumeurs."),
              _BulletPoint(text: "Contenir les curieux."),
              _BulletPoint(
                text: "Faciliter la circulation (circulation alternée, etc.).",
              ),
              _BulletPoint(text: "Appeler des renforts si nécessaire."),
            ],
          ),

          const SizedBox(height: 14),

          // Personnel
          _ConditionCard(
            title: "B — Sécurité du personnel",
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "De jour comme de nuit, les personnels de police doivent obligatoirement revêtir des équipements vestimentaires "
                "pourvus de dispositifs réfléchissants.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Chasuble réfléchissante ou imperméable de signalisation : obligatoire.",
              ),
              _BulletPoint(
                text:
                    "La nuit : dans la mesure du possible, port du bâton lumineux lors des déplacements.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Bon réflexe : se rendre visible très tôt, se positionner hors des flux, et anticiper les réactions des usagers pour éviter l’accident secondaire.",
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
  final String title = 'NOTA';

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
