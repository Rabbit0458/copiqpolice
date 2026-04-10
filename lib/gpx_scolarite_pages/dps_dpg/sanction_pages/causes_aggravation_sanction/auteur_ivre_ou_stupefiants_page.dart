import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuteurIvreOuStupefiantsPage extends StatelessWidget {
  const AuteurIvreOuStupefiantsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/auteur_ivre_ou_stupefiants';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardColor = isDark ? const Color(0xFF2F2F2F) : Colors.white;
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = textMain;

    const Color lawRed = Color(0xFFE53935);

    TextSpan law(String s) => const TextSpan(text: '');

    TextSpan _law(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w800),
    );

    TextSpan _t(String s) => TextSpan(text: s);

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
          "Auteur ivre / stupéfiants",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          Text(
            "Auteur ivre ou sous l’emprise\nde stupéfiants",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Circonstance aggravante : « par une personne agissant en état d’ivresse manifeste "
            "ou sous l’emprise manifeste de produits stupéfiants ».",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= 1 — DÉFINITION =========================
          _ConditionCard(
            title: "1 — Définition",
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                "Cette circonstance aggravante peut être retenue lorsque la personne boit en connaissance "
                "des effets de l’alcool et commet ensuite en état d’ivresse une infraction qu’elle n’a pas "
                "à proprement parler voulue avant de boire, et qu’elle n’aurait pas voulu en son état normal.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La grande majorité des décisions jurisprudentielles se refusent à voir dans l’ivresse "
                "une cause légale d’exemption de la peine.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Cette solution semble devoir être appliquée a fortiori à l’usage volontaire de produits "
                "stupéfiants, illicite en tant que tel, contrairement à la consommation d’alcool.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il s’agit d’une circonstance aggravante réelle : ses effets s’étendent à tous les auteurs, "
                "coauteurs et complices de l’infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ========================= 2 — CONDITIONS =========================
          _ConditionCard(
            title: "2 — Conditions",
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle(
                "2.1 — L’état d’ivresse manifeste et l’emprise manifeste de stupéfiants",
              ),
              const _Paragraph(
                "Ces états sont ceux définis par le code de la santé publique, le code de la route et la "
                "jurisprudence s’y rapportant.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Cependant, aucune précision n’a été rapportée par le législateur concernant les éléments "
                "permettant de les caractériser en tant que circonstance aggravante de certaines infractions pénales.",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                _t("On peut néanmoins retenir "),
                _law("l’article L. 3354-1 du C.S.P."),
                _t(
                  " qui prévoit que les officiers ou agents de police judiciaire doivent, lors de la constatation "
                  "d’un crime, d’un délit ou d’un accident de la circulation, faire procéder sur la personne de "
                  "l’auteur présumé aux vérifications prévues au ",
                ),
                _law("I de l’article L. 234-1 du code de la route"),
                _t(" et à "),
                _law("l’article L. 4274-14 du code des transports"),
                _t(
                  ", destinées à établir la preuve de la présence d’alcool dans son organisme lorsqu’il semble que "
                  "le crime, le délit ou l’accident a été commis ou causé sous l’empire d’un état alcoolique. "
                  "Ces vérifications sont obligatoires dans tous les cas de crimes, délits ou accidents suivis de mort ; "
                  "et, lorsqu’elles peuvent être utiles, elles sont également effectuées sur la victime.",
                ),
              ]),

              const SizedBox(height: 10),
              const _Paragraph(
                "Aucune disposition spéciale ne prévoit une telle procédure en matière de produits stupéfiants.",
              ),

              const SizedBox(height: 14),
              const _SubTitle(
                "2.2 — La constitution de la preuve de ces états",
              ),
              const _Paragraph(
                "La détermination de l’état manifeste d’ivresse ou d’emprise de stupéfiants peut s’avérer "
                "difficile à apprécier dans certains cas. La question de la preuve a été soulevée à plusieurs reprises "
                "lors du vote de la loi, mais elle est restée sans réponse.",
              ),
              const SizedBox(height: 10),
              const _IntroBullet(
                text:
                    "Comment faire la preuve de l’état d’ivresse manifeste lorsque la victime porte plainte quelques heures, voire quelques jours après les faits ?",
              ),
              const _IntroBullet(
                text:
                    "À l’inverse, comment déterminer la date de consommation de produits stupéfiants alors que leur présence demeure plusieurs jours dans l’organisme ?",
              ),
              const _IntroBullet(
                text:
                    "Quelle est l’influence du degré de dépendance à ces produits sur le comportement individuel ?",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Éclairage",
                bodySpans: [
                  _t(
                    "Les représentants du Conseil national de l’Ordre des médecins indiquent que la conjugaison "
                    "de trois types de dépistage (analyses d’urine, de sang et des cheveux) permet de détecter "
                    "précisément le niveau de consommation de stupéfiants (faible, moyen ou important) et la date "
                    "à laquelle ces produits ont été consommés.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ====================== 3 — CHAMP D’APPLICATION =====================
          _ConditionCard(
            title: "3 — Champ d’application",
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                "Cette circonstance aggravante est notamment prévue / utilisée dans les infractions suivantes :",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "• Le meurtre ("),
                _law("article 221-4, 11° C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "• Les violences volontaires ("),
                _law(
                  "articles 222-8 et 222-10, 11°, 222-12 et 222-13, 14°, et 222-14-5 al. 4 C.P.",
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "• Le viol ("),
                _law("article 222-24, 12° C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "• Les agressions sexuelles ("),
                _law("article 222-28, 8° C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "• Les agressions sexuelles sur mineur de quinze ans ou personne vulnérable (",
                ),
                _law("article 222-30, 7° C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "• Les atteintes sexuelles sans violence sur mineur de quinze ans (",
                ),
                _law("article 227-26, 5° C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "• L’empoisonnement ("),
                _law("article 221-5 al. 3 C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(text: "• Les tortures ou actes de barbarie ("),
                _law("article 222-3, 11° C.P."),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(
                  text: "• L’administration de substances nuisibles (",
                ),
                _law("article 222-15 C.P."),
                const TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 22),
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
