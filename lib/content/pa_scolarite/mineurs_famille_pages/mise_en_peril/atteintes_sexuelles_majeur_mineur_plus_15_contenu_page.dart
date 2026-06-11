import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteintesSexuellesMajeurMineurPlus15Page extends StatelessWidget {
  const PaAtteintesSexuellesMajeurMineurPlus15Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_plus_15';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
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
          tooltip: 'Retour',
        ),
        title: Text(
          "Mise en péril",
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
            "Les atteintes sexuelles par un majeur sur un mineur de plus de quinze ans",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Hors les cas de viol ou d’agression sexuelle (section « du viol, de l’inceste, et des autres agressions sexuelles »), "
                "les atteintes sexuelles sur un mineur âgé de plus de quinze ans constituent une infraction dans certains cas précis :",
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    "Lorsqu’elles sont commises par toute personne majeure ayant sur la victime une autorité de droit ou de fait.",
              ),
              _IntroBullet(
                text:
                    "Lorsqu’elles sont commises par une personne majeure qui abuse de l’autorité que lui confèrent ses fonctions.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-27 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : prévoit et réprime les atteintes sexuelles, autres que les viols ou agressions sexuelles, "
                      "commises sur un mineur de plus de quinze ans, même émancipé.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Une atteinte sexuelle"),
              _Paragraph(
                "L’atteinte sexuelle se définit comme tout agissement en rapport avec l’activité sexuelle. "
                "Elle suppose un contact physique entre l’auteur et la victime. "
                "Elle peut être le fait de l’auteur sur la victime, mais aussi celui effectué par la victime sur l’auteur.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Hors champ",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’article 227-27 exclut les cas de viol ou d’agression sexuelle (section « du viol, de l’inceste, et des autres agressions sexuelles »). "
                        "Ainsi, l’atteinte sexuelle visée ici suppose un contact physique commis ",
                  ),
                  TextSpan(
                    text: "sans violence, contrainte, menace ni surprise",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Repères (si violence/contrainte/menace/surprise)",
                bodySpans: [
                  TextSpan(
                    text: "Viol si pénétration ou acte bucco-génital — ",
                  ),
                  TextSpan(
                    text: "article 222-23 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(text: "Agression sexuelle — "),
                  TextSpan(
                    text: "article 222-27 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un auteur majeur"),
              _Paragraph(
                "L’infraction n’est imputable qu’à un majeur : les actes accomplis entre mineurs sont exclus du champ d’application.",
              ),
              SizedBox(height: 10),

              _SubTitle(
                "C) Un majeur avec autorité (droit ou fait) OU abus d’autorité fonctionnelle",
              ),
              _Paragraph(
                "Le texte vise expressément les personnes pouvant être incriminées :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Toute personne majeure ayant sur la victime une autorité de droit (ex. tuteur) ou une autorité de fait, établie par des circonstances caractérisant cette autorité (ex. chef scout).",
              ),
              _BulletPoint(
                text:
                    "Une personne majeure abusant de l’autorité que lui confèrent ses fonctions : l’autorité dite « fonctionnelle » peut être légale ou de fait. L’auteur investi d’une puissance quelconque sur le mineur en abuse pour commettre l’atteinte sexuelle.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si l’auteur est un ascendant ou un membre de la famille ayant autorité sur le mineur (listés à ",
                  ),
                  TextSpan(
                    text: "l’article 222-22-3 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        "), les faits ne relèvent pas de l’atteinte sexuelle de l’article 227-27 et peuvent constituer : ",
                  ),
                  TextSpan(
                    text: "un viol incestueux",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: " ("),
                  TextSpan(
                    text: "articles 222-22-3 et 222-23-2 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ") ou "),
                  TextSpan(
                    text: "une agression sexuelle incestueuse",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: " ("),
                  TextSpan(
                    text: "articles 222-22-3 et 222-29-3 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("D) Une victime mineure de plus de quinze ans"),
              _Paragraph(
                "Au jour des faits, la victime doit être âgée de plus de quinze ans et de moins de dix-huit ans, même émancipée (notamment par le mariage).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Erreur sur l’âge",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’erreur sur l’âge de la victime n’atténue pas la responsabilité pénale. Toutefois, dans certaines hypothèses, "
                        "des poursuites peuvent être impossibles s’il est acquis que l’auteur ignorait l’âge réel, notamment si la victime "
                        "avait le comportement et le développement physique d’un adulte — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 04 janvier 1902",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "Il appartient à l’auteur de justifier qu’il a été trompé — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 07 février 1957",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’auteur est pleinement conscient d’exercer une atteinte sexuelle sur un mineur âgé de plus de quinze ans. "
                "Il s’agit d’une infraction intentionnelle : l’élément moral repose sur la conscience de l’acte accompli.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Aucune circonstance aggravante spécifique n’est prévue pour cette infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Délit : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 227-27 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Application de la loi française en cas de faits commis à l’étranger dans certains cas — ",
                  ),
                  TextSpan(
                    text: "article 227-27-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " (même en l’absence de plainte de la victime ou de dénonciation officielle du pays).",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Responsabilité pénale possible dans les conditions prévues par ",
                ),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 227-27-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (tentative punissable pour les délits d’atteintes sexuelles sur mineurs).",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI — "),
                TextSpan(
                  text: "article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide et assistance, provocation ou instructions données).",
                ),
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
