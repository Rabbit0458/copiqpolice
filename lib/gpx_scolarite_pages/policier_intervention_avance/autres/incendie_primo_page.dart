import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncendiePrimoPage extends StatelessWidget {
  const IncendiePrimoPage({super.key});

  static const String routeName = '/gpx/intervention/autres/incendie-primo';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardEval = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPerim = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardVict = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSynth = isDark
        ? const Color(0xFF1F2B34)
        : const Color(0xFFEFF7FF);

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

    TextSpan lawSpan(String text) {
      return const TextSpan(); // (jamais utilisé ici, car aucun article cité)
    }

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
          "Intervention — Autres",
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
            "Primo-intervenant sur un incendie",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "De quoi s’agit-il ?",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Lorsque des policiers sont primo-intervenants sur un incendie, les premières minutes sont déterminantes : "
                "apprécier la situation, faciliter l’arrivée des secours, préserver la sécurité de l’équipage et des tiers.\n\n"
                "Chaque situation est singulière, mais des actes réflexes permettent d’agir plus vite et plus sereinement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément “légal” en haut : pas de texte juridique dans la fiche fournie
          _ConditionCard(
            title: "Références (à compléter si besoin)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La fiche AMARIS fournie est un mémo opérationnel et ne cite pas d’articles de loi. "
                "Si tu veux intégrer des bases juridiques (CPP / CSI / CP…), donne-moi les références et je les place ici en rouge, tout en haut.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "1 — Apprécier vite la situation & informer",
            cardColor: cardEval,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Actes réflexes dès l’arrivée"),
              _BulletPoint(
                text:
                    "Faire confirmer par le C.I.C que les services d’urgence ont été prévenus.",
              ),
              _BulletPoint(
                text:
                    "Dresser un premier bilan : nature de l’incendie, origine supposée, nombre de personnes présentes.",
              ),
              _BulletPoint(
                text:
                    "Évaluer le danger pour les personnes et les risques de propagation/aggravation.",
              ),
              SizedBox(height: 10),
              _SubTitle("Témoins"),
              _BulletPoint(
                text:
                    "Recueillir l’identité des témoins éventuels et les maintenir sur place.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Objectif : transmettre au C.I.C des informations essentielles, claires et utiles aux secours.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "2 — Mettre un périmètre de sécurité",
            cardColor: cardPerim,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Faciliter l’arrivée des secours"),
              _BulletPoint(
                text:
                    "Garantir l’accès des premiers engins de secours jusqu’au pied du bâtiment en feu.",
              ),
              _BulletPoint(
                text:
                    "Veiller à ce que les véhicules de police (verrouillés, stationnés à proximité) ne gênent pas l’accès des secours.",
              ),
              SizedBox(height: 10),
              _SubTitle("Protéger les tiers"),
              _BulletPoint(
                text:
                    "Interdire tout accès à la zone du sinistre (sécuriser, canaliser, éloigner).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À l’arrivée des secours et en coordination avec le COS, adapter le périmètre sans perturber les manœuvres.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Ne jamais se trouver à l’intérieur du périmètre de sécurité.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "3 — Prendre en compte les occupants & rassurer",
            cardColor: cardVict,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Paroles simples et rassurantes"),
              _Paragraph(
                "Si des personnes se manifestent aux fenêtres (ex. feu d’appartement), leur dire :",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Message",
                bodySpans: [
                  TextSpan(
                    text:
                        "« Les pompiers arrivent. Restez chez vous, à votre fenêtre, porte d’appartement fermée. »",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Évacuation : pas automatique"),
              _BulletPoint(
                text:
                    "Ne pas faire évacuer l’immeuble s’il n’y a pas de danger immédiat pour les occupants.",
              ),
              _BulletPoint(
                text:
                    "Ne pas faire évacuer les habitants situés au-dessus du foyer : risque d’exposition aux fumées toxiques.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Certains ERP peuvent avoir un schéma d’intervention spécifique : le C.I.C donnera les instructions.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "4 — Sauvetage exceptionnel (péril imminent)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "De façon exceptionnelle, et sans mettre ta vie ni celle des autres en danger, tenter de sauver les personnes exposées à un péril imminent.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Si tu montes dans les étages : ne pas prendre l’ascenseur, emprunter les escaliers.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Attention : sans protection contre le feu et les fumées, tu es vulnérable.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "5 — Préserver les traces et indices",
            cardColor: cardSynth,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Même sur un incendie, garder le réflexe “enquête” : préserver les traces et indices, éviter les intrusions et noter les informations utiles.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Limiter les accès, canaliser les déplacements, conserver les observations utiles (témoins, comportements, chronologie).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "En résumé (3 objectifs)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Faciliter l’arrivée des sapeurs-pompiers et renseigner les secours.",
              ),
              _IntroBullet(text: "Rassurer les personnes."),
              _IntroBullet(
                text:
                    "Tenter de sauver une personne en danger imminent (exceptionnellement, sans se mettre en danger).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "L’évacuation n’est pas systématique.",
                    style: TextStyle(fontWeight: FontWeight.w900),
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
