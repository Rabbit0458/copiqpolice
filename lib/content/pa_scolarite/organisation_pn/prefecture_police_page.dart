import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrefecturePolicePage extends StatelessWidget {
  const PrefecturePolicePage({super.key});

  static const String routeName =
      '/pa/institution/organisation_pn/prefecture_police';

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
    final Color cardRole = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardAttrib = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardStruct = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCab = isDark
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
          "Préfecture de Police",
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
            "III — La Préfecture de Police",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro — contexte
          _ConditionCard(
            title: "Contexte",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "À Paris, le préfet de police est un haut fonctionnaire nommé en Conseil des ministres. "
                "Il assure la direction et la coordination de missions essentielles de sécurité et d’ordre public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Rôle du préfet de police
          _ConditionCard(
            title: "Rôle du préfet de police",
            cardColor: cardRole,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text: "Responsable de la sécurité dans la capitale.",
              ),
              _BulletPoint(
                text:
                    "Responsable de la police administrative exercée au nom de l’État dans la capitale.",
              ),
              _BulletPoint(
                text:
                    "Supérieur hiérarchique des fonctionnaires, y compris ceux de la police judiciaire (pouvoir disciplinaire et de notation).",
              ),
              _BulletPoint(
                text:
                    "Préfet pour l’administration de la police de Paris et des départements des Hauts-de-Seine, de la Seine-Saint-Denis et du Val-de-Marne.",
              ),
              _BulletPoint(
                text:
                    "Préfet de la zone de défense de Paris (8 départements d’Île-de-France).",
              ),
              _BulletPoint(
                text:
                    "Responsable du commandement opérationnel unique de la sécurité dans les transports ferrés en Île-de-France.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Attributions
          _ConditionCard(
            title: "Attributions principales",
            cardColor: cardAttrib,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La Préfecture de Police se voit confier de nombreuses attributions, notamment :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Assurer la sécurité des personnes et des biens.",
              ),
              _BulletPoint(text: "Assurer la sécurité civile."),
              _BulletPoint(text: "Délivrer des titres administratifs."),
              _BulletPoint(text: "Assurer la circulation."),
              _BulletPoint(
                text:
                    "Lutter contre les nuisances et protéger l’environnement.",
              ),
              _BulletPoint(
                text: "Prévenir les événements troublant l’ordre public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Structure de la PP
          _ConditionCard(
            title: "Organisation de la Préfecture de Police",
            cardColor: cardStruct,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Services administratifs"),
              _BulletPoint(
                text: "Direction des usagers et des polices administratives",
              ),
              _BulletPoint(text: "Direction des ressources humaines"),
              _BulletPoint(
                text:
                    "Direction des finances, de la commande publique et de la performance",
              ),
              _BulletPoint(
                text:
                    "Direction de l’innovation, de la logistique et des technologies",
              ),
              _BulletPoint(
                text: "Direction de l’immobilier et de l’environnement",
              ),
              _BulletPoint(
                text: "Service des affaires juridiques et du contentieux",
              ),
              _BulletPoint(text: "Service de l’administration des étrangers"),
              SizedBox(height: 14),
              _SubTitle("B) Services actifs"),
              _BulletPoint(
                text:
                    "Direction de la sécurité de proximité de l’agglomération parisienne",
              ),
              _BulletPoint(
                text:
                    "D.O.P.C. — Direction de l’Ordre public et de la Circulation",
              ),
              _BulletPoint(text: "Direction de la police judiciaire"),
              _BulletPoint(text: "Direction du renseignement"),
            ],
          ),

          const SizedBox(height: 14),

          // Cabinet du préfet
          _ConditionCard(
            title: "Services rattachés au cabinet du préfet de police",
            cardColor: cardCab,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Certains services sont directement attachés au cabinet du préfet de police :",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(text: "Le laboratoire central"),
              const _BulletPoint(text: "Le laboratoire de toxicologie"),
              _BulletPoint(
                text:
                    "La brigade des sapeurs-pompiers de Paris (unité militaire à la disposition du préfet de police)",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le sigle « P.P. » est souvent utilisé pour désigner la Préfecture de Police, mais dans cette page, "
                        "les intitulés sont volontairement écrits en clair pour un apprentissage plus pédagogique.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Petit rappel “style loi” (même si ici pas d’article, ça garde le standard)
          _ConditionCard(
            title: "Repère visuel (articles de loi)",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Rappel : lorsque des références juridiques sont présentes dans une page (Code pénal, Code de procédure pénale, Code de la sécurité intérieure, etc.), elles doivent apparaître en ",
                ),
                TextSpan(
                  text: "rouge",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " pour être repérées immédiatement."),
              ]),
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
