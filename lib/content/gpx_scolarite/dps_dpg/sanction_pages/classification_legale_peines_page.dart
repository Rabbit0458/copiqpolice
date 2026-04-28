import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationLegalePeinesPage extends StatelessWidget {
  const ClassificationLegalePeinesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/classification_peines/classification_legale_peines';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // ✅ Tous les articles de loi doivent être rouges
    final Color lawRed = const Color(0xFFE53935);

    Color cardBg(Color light, Color dark) => isDark ? dark : light;

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
          "Classification légale des peines",
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
            "La classification légale des peines",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Idée générale",
            cardColor: cardBg(const Color(0xFFF6F7FB), const Color(0xFF2B2B2B)),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _Paragraph(
                "Le code pénal a établi une échelle des peines qui commande la classification "
                "tripartite des infractions en crimes, délits ou contraventions.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Elle figure aux "),
                TextSpan(
                  text: "articles 131-1 à 131-18",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "131-37 à 131-44-1",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: " du "),
                TextSpan(
                  text: "code pénal",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: "Chapitre 1 — Peines applicables aux personnes physiques",
            cardColor: cardBg(const Color(0xFFEFF7FF), const Color(0xFF263244)),
            accent: const Color(0xFF42A5F5),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _SubTitle("1.1 — Les peines criminelles"),

              const _SubTitle("1.1.1 — Peines principales"),
              const _Paragraph(
                "Les peines principales encourues en matière criminelle sont :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Réclusion ou détention criminelle à perpétuité",
              ),
              const _BulletPoint(
                text: "Réclusion ou détention criminelle de 30 ans au plus",
              ),
              const _BulletPoint(
                text: "Réclusion ou détention criminelle de 20 ans au plus",
              ),
              const _BulletPoint(
                text: "Réclusion ou détention criminelle de 15 ans au plus",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La réclusion est applicable aux crimes de droit commun, la détention aux crimes politiques.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le juge peut prononcer une peine d’une durée inférieure à celles mentionnées à ",
                ),
                TextSpan(
                  text: "l’art. 131-1 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ", mais la durée de la réclusion ou de la détention doit être de 10 ans au moins.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Une peine d’amende peut également être appliquée, mais uniquement lorsque le texte "
                "réprimant le crime le prévoit expressément.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.1.2 — Peines complémentaires"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Peuvent être prononcées une ou plusieurs peines complémentaires prévues à ",
                ),
                TextSpan(
                  text: "l’article 131-10 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ". Elles s’ajoutent aux peines principales et sont spécialement prévues par le texte "
                      "qui réprime l’infraction.",
                ),
              ]),

              const SizedBox(height: 14),

              // ===================== 1.2 =====================
              const _SubTitle("1.2 — Les peines correctionnelles"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Les peines correctionnelles sont énumérées à ",
                ),
                TextSpan(
                  text: "l’article 131-3 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 8),
              const _SubTitle("1.2.1 — Peines principales"),
              const _BulletPoint(
                text:
                    "Emprisonnement : échelle de 8 degrés (10 ans, 7 ans, 5 ans, 3 ans, 2 ans, 1 an, 6 mois, 2 mois).",
              ),
              const _BulletPoint(
                text:
                    "L’emprisonnement peut faire l’objet d’un sursis, d’un sursis probatoire ou d’un aménagement.",
              ),
              const _BulletPoint(text: "Amende : montant minimum de 3 750 €."),

              const SizedBox(height: 12),
              const _SubTitle("1.2.2 — Peines alternatives"),
              const _Paragraph(
                "Les peines alternatives ne figurent pas dans le texte réprimant l’infraction : elles "
                "sont prévues par des dispositions générales et peuvent être substituées par le juge.",
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Détention à domicile sous surveillance électronique (15 jours à 6 mois) : art. 131-4-1 du C.P.",
              ),
              _BulletPoint(
                text:
                    "Jour-amende à la place de l’amende si le délit est puni d’emprisonnement : art. 131-5 du C.P.",
              ),
              _BulletPoint(
                text:
                    "Peines privatives ou restrictives de droits : art. 131-6 du C.P.",
              ),
              _BulletPoint(
                text:
                    "Travail d’intérêt général (20 à 400 heures) à la place de l’emprisonnement : art. 131-8 du C.P.",
              ),
              const SizedBox(height: 8),

              // ✅ Mise en rouge des articles cités dans les bullets ci-dessus
              _NotaBox(
                title: "Rappel (articles)",
                bodySpans: [
                  TextSpan(
                    text: "art. 131-4-1",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  const TextSpan(text: ", "),
                  TextSpan(
                    text: "131-5",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  const TextSpan(text: ", "),
                  TextSpan(
                    text: "131-6",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  const TextSpan(text: ", "),
                  TextSpan(
                    text: "131-8",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  const TextSpan(text: " du "),
                  TextSpan(
                    text: "Code pénal",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.2.3 — Peines complémentaires"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Peines complémentaires possibles, notamment celles énoncées à ",
                ),
                TextSpan(
                  text: "l’article 131-10 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ". Elles peuvent être prononcées en plus des peines principales ou à leur place.",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("1.2.4 — Peines de stage et sanction-réparation"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Peine de stage : obligation d’accomplir un stage (≤ 1 mois) (",
                ),
                TextSpan(
                  text: "art. 131-5-1 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Sanction-réparation : indemnisation du préjudice de la victime (",
                ),
                TextSpan(
                  text: "art. 131-8-1 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      "). Ces peines peuvent être alternatives (à la place de l’emprisonnement ou de l’amende) "
                      "ou complémentaires (s’ajoutant à la peine prononcée).",
                ),
              ]),

              const SizedBox(height: 14),

              // ===================== 1.3 =====================
              const _SubTitle("1.3 — Les peines contraventionnelles"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Les peines contraventionnelles sont prévues à ",
                ),
                TextSpan(
                  text: "l’article 131-12 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("1.3.1 — Peines principales"),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 131-13 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " dispose que constituent des contraventions les infractions que la loi punit d’une amende "
                      "n’excédant pas 3 000 €.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph("Montant maximal selon la classe :"),
              const SizedBox(height: 8),
              const _BulletPoint(text: "1ère classe : 38 € au plus"),
              const _BulletPoint(text: "2ème classe : 150 € au plus"),
              const _BulletPoint(text: "3ème classe : 450 € au plus"),
              const _BulletPoint(text: "4ème classe : 750 € au plus"),
              const _BulletPoint(
                text:
                    "5ème classe : 1 500 € au plus (pouvant être porté à 3 000 € en cas de récidive).",
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.3.2 — Peines alternatives"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Uniquement pour les contraventions de 5ème classe : peines privatives ou restrictives de droits prévues à ",
                ),
                TextSpan(
                  text: "l’article 131-14 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("1.3.3 — Peines complémentaires"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si le règlement le prévoit expressément, elles sont listées aux ",
                ),
                TextSpan(
                  text: "articles 131-16 et 131-17 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ". Le juge peut les prononcer en plus de l’amende ou, à titre principal, à la place de l’amende.",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("1.3.4 — Sanction-réparation"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Prévue uniquement pour les contraventions de 5ème classe : elle peut être prononcée à la place ou en même temps que l’amende (",
                ),
                TextSpan(
                  text: "art. 131-15-1 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: "Chapitre 2 — Peines applicables aux personnes morales",
            cardColor: cardBg(const Color(0xFFFFF8E1), const Color(0xFF2F2A1B)),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La répression applicable aux personnes morales figure aux ",
                ),
                TextSpan(
                  text: "articles 131-37 à 131-49 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("2.1 — Peines criminelles et correctionnelles"),
              _Paragraph.rich([
                const TextSpan(text: "Elles figurent à "),
                TextSpan(
                  text: "l’article 131-37 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " : amende et, dans les cas prévus par la loi, les peines de l’article 131-39 et la peine de l’article 131-39-2. "
                      "En matière correctionnelle : sanction-réparation (art. 131-39-1).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 131-38 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " fixe le taux maximum de l’amende : quintuple de celui prévu pour les personnes physiques. "
                      "Si crime sans amende prévue pour les personnes physiques : amende = 1 000 000 €.",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("2.2 — Peines contraventionnelles"),
              _Paragraph.rich([
                const TextSpan(text: "Énoncées à "),
                TextSpan(
                  text: "l’article 131-40 du C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " : amende et, pour les contraventions de 5ème classe, peines privatives/restrictives (art. 131-42) + sanction-réparation (art. 131-44-1).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Peines complémentaires possibles ("),
                TextSpan(
                  text: "art. 131-43 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ") : elles peuvent s’ajouter à une peine principale ou être prononcées seules à titre de peine principale.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _NotaBox(
            bodySpans: [
              const TextSpan(
                text:
                    "Retenez surtout la logique : la nature de la peine (criminelle, correctionnelle, contraventionnelle) "
                    "structure la classification des infractions. Les articles du Code pénal encadrent l’échelle, les "
                    "peines alternatives et les peines applicables aux personnes morales.",
              ),
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
