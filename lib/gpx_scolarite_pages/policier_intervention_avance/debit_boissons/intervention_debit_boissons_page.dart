import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterventionDebitBoissonsPage extends StatelessWidget {
  const InterventionDebitBoissonsPage({super.key});

  static const String routeName =
      '/gpx/intervention/debit-boissons/intervention';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCases = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPrinciples = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);

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
          "Débit de boissons",
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
            "Intervention dans un débit de boissons",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Cadre légal (rappels utiles)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Selon le contexte de l’intervention, vous pouvez vous appuyer sur : ",
                ),
                TextSpan(
                  text: "l’article 78-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (contrôle d’identité), "),
                TextSpan(
                  text: "l’article 78-2-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (réquisitions du procureur), et "),
                TextSpan(
                  text: "l’article 53 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (flagrance) lorsque les conditions sont réunies.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Le cadre juridique exact dépend du motif (mission commandée, réquisition, trouble à l’ordre public, infraction constatée). "
                        "Avant l’action, clarifier le cadre et la conduite à tenir avec la hiérarchie / l’OPJ avisé.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition / risques
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention dans un débit de boissons requiert la plus grande vigilance en raison :\n"
                "• de la configuration des lieux,\n"
                "• du nombre de consommateurs,\n"
                "• et de leur possible état d’excitation ou d’ébriété.\n\n"
                "Une intervention dans ce type d’établissement est toujours potentiellement dangereuse.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas d'intervention
          _ConditionCard(
            title: "II — Les cas d’intervention",
            cardColor: cardCases,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Déclenchement de l’intervention"),
              _BulletPoint(
                text:
                    "Contrôle ordonné par la hiérarchie (ex. contrôle d’identité).",
              ),
              _BulletPoint(
                text:
                    "Réquisition d’un particulier (consommateur ou non) : différend, tapage, etc.",
              ),
              _BulletPoint(
                text:
                    "Réquisition du débitant ou de son représentant : différend, bagarre, etc.",
              ),
              _BulletPoint(
                text:
                    "Constatation d’une infraction : fermeture tardive, tapage, bagarre, ivresse…",
              ),
              _BulletPoint(
                text:
                    "Trouble à l’ordre public : tapage, rixe, altercation, attroupement…",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Objectifs possibles sur place"),
              _BulletPoint(
                text:
                    "Constatation crimes et délits : interpellation des auteurs si nécessaire.",
              ),
              _BulletPoint(
                text:
                    "Police administrative : vérifications sécurité / hygiène / salubrité (selon mission).",
              ),
              _BulletPoint(
                text:
                    "Contrôle des pièces administratives et du respect de la réglementation générale (selon compétence et cadre fixé).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principes de base
          _ConditionCard(
            title: "III — Principes de base",
            cardColor: cardPrinciples,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Avant l’action : se préparer"),
              const _Paragraph(
                "Recueillir un maximum d’informations sur l’établissement lorsque c’est possible :",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(text: "Propriétaire ou gérant."),
              const _BulletPoint(text: "Personnel de service."),
              const _BulletPoint(
                text:
                    "Disposition interne : sous-sol, étage, arrière-salle, couloirs, points d’étranglement…",
              ),
              const _BulletPoint(
                text:
                    "Disposition extérieure : arrière-cour, sorties sur parking, immeuble, issues secondaires…",
              ),
              const _BulletPoint(
                text:
                    "Clientèle habituelle / ambiance (tensions connues, habitudes, événements).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Coordination & effectif"),
              const _BulletPoint(
                text:
                    "Se concerter sur le mode d’intervention et la répartition des rôles.",
              ),
              const _BulletPoint(
                text: "Intervenir à 3 ou 4 fonctionnaires (jamais seul).",
              ),
              const _BulletPoint(
                text:
                    "Utiliser des signes conventionnels si besoin pour alerter d’un geste suspect.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Sécurité & information radio"),
              const _BulletPoint(
                text:
                    "S’équiper au préalable des matériels individuels et collectifs de protection.",
              ),
              const _BulletPoint(
                text:
                    "Avertir le PC radio avant l’action (mission commandée ou d’initiative) : lieu + motif.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Arrivée sur les lieux"),
              const _BulletPoint(
                text:
                    "Privilégier une arrivée discrète (éviter avertisseurs sonores/lumineux).",
              ),
              const _BulletPoint(
                text: "Aux abords : mémoriser les issues (portes, fenêtres).",
              ),
              const _BulletPoint(
                text:
                    "Observer si possible à travers les vitres : disposition, nombre, emplacement des consommateurs, ambiance générale.",
              ),
              const SizedBox(height: 12),

              _NotaBox(
                title: "Vigilance",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Un débit de boissons concentre souvent : promiscuité, alcoolisation, effet de groupe, objets détournables (bouteilles, verres), "
                        "et multiples issues. La préparation + la coordination de l’équipage font la différence.",
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
