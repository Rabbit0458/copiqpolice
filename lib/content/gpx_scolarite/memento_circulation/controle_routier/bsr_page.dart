import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BsrPage extends StatelessWidget {
  const BsrPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/bsr';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardKeyPoints = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNatinf = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardNotes = isDark
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
          "Contrôle routier",
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
            "Le brevet de sécurité routière (B.S.R.)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Définition",
            cardColor: cardNotes,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le B.S.R. concerne la conduite des cyclomoteurs et des quadricycles légers à moteur (ex : « voiturette »). "
                "Il permet, dès 14 ans, de conduire ces véhicules sous conditions, et s’articule aujourd’hui avec la catégorie AM.",
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
            children: [
              _Paragraph.rich([
                _lawSpan("R. 211-1"),
                const TextSpan(text: " et "),
                _lawSpan("R. 211-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Conditions d’obligation (qui est concerné ?)",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le conducteur d’un cyclomoteur ou d’un quadricycle léger à moteur, né à compter du ",
                ),
                TextSpan(
                  text: "01 janvier 1988",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ", doit être titulaire du permis de conduire, ou du B.S.R., ou d’un titre européen équivalent.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Cyclomoteur : NATINF 11385 (défaut de BSR / titre équivalent).",
              ),
              const _BulletPoint(
                text:
                    "Quadricycle léger : NATINF 25341 (défaut de BSR / titre équivalent).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le B.S.R. permet la conduite dès 14 ans, à condition d’être titulaire de l’option correspondant au véhicule.",
                  ),
                  const TextSpan(text: " ("),
                  TextSpan(
                    text: "NATINF 11384",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " / "),
                  TextSpan(
                    text: "NATINF 21214",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Catégorie AM (depuis 19/01/2013)",
            cardColor: cardKeyPoints,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Depuis le "),
                TextSpan(
                  text: "19 janvier 2013",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ", le B.S.R. correspond à la catégorie AM du permis de conduire.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’attestation de suivi de la formation pratique du BSR autorise, pendant 4 mois à compter de sa délivrance, "
                "la conduite du véhicule correspondant à l’option (cyclomoteur ou quadricycle léger). "
                "Au-delà, le conducteur doit être en possession du titre sous forme de permis de conduire portant la catégorie AM.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Équivalence (AAC)",
                bodySpans: const [
                  TextSpan(
                    text:
                        "L’attestation « option quadricycle léger à moteur » est également délivrée par équivalence aux élèves ayant suivi "
                        "une formation initiale dans le cadre de l’apprentissage anticipé de la conduite (AAC, catégorie B).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Particularité juridique du B.S.R.",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Délivré sous l’ancien modèle ou sous la forme d’un permis avec catégorie AM, le B.S.R. ",
                ),
                TextSpan(
                  text:
                      "n’est pas un titre de conduite assimilable au permis de conduire",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " ("),
                _lawSpan("L. 221-1 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Conséquence : les dispositions du Code de la route relatives au permis à points, à la rétention, "
                "à la suspension ou à l’annulation du permis de conduire ne sont pas applicables au B.S.R.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les titulaires d’un B.S.R. délivré avant le 19/01/2013 peuvent demander l’échange contre un permis doté de la catégorie AM, "
                        "ou continuer à circuler avec l’un des anciens modèles de B.S.R.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Infractions & suites (NATINF)",
            cardColor: cardNatinf,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Conduite avant 14 ans"),
              const _BulletPoint(
                text: "Cyclomoteur : NATINF 11384 (mineur de moins de 14 ans).",
              ),
              const _BulletPoint(
                text:
                    "Quadricycle léger : NATINF 21214 (mineur de moins de 14 ans).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Défaut de B.S.R. / titre équivalent"),
              _Paragraph.rich([
                const TextSpan(text: "Cyclomoteur : "),
                TextSpan(
                  text: "NATINF 11385",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " — base : "),
                _lawSpan("R. 211-2 du Code de la route"),
                const TextSpan(text: " (AF min. 2e classe)."),
              ]),
              _Paragraph.rich([
                const TextSpan(text: "Quadricycle léger : "),
                TextSpan(
                  text: "NATINF 25341",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " — base : "),
                _lawSpan("R. 211-2 du Code de la route"),
                const TextSpan(text: " (AF min. 2e classe)."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Non-justification dans les 5 jours"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Non-justification dans les 5 jours de la possession du B.S.R. (ou titre européen équivalent / permis) : ",
                ),
                TextSpan(
                  text: "NATINF 21213",
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " — base : "),
                _lawSpan("R. 233-1 du Code de la route"),
                const TextSpan(text: " (AF min. 2e classe)."),
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
