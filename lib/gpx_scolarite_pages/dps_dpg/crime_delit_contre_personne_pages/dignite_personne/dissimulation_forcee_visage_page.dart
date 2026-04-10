import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DissimulationForceeVisagePage extends StatelessWidget {
  const DissimulationForceeVisagePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/dissimulation_forcee_visage';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return const TextSpan(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Atteintes à la dignité",
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
            "La dissimulation forcée du visage",
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
                "Le fait pour toute personne d’imposer à une ou plusieurs autres personnes de dissimuler leur visage "
                "par menace, violence, contrainte, abus d’autorité ou abus de pouvoir, en raison de leur sexe, constitue une infraction.",
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
                const TextSpan(
                  text: "Article 225-4-10 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : prévoit et réprime la dissimulation forcée du visage.",
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
            children: [
              const _SubTitle("A) Une dissimulation du visage imposée"),
              const _Paragraph(
                "Cette dissimulation imposée constitue une forme de violence à l’encontre de la victime.\n\n"
                "Ce délit protège la victime : il peut lui permettre de s’exonérer de l’infraction de dissimulation du visage "
                "dans l’espace public si elle démontre la contrainte subie.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Référence : "),
                  const TextSpan(
                    text: "article 122-2 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " (« n’est pas responsable pénalement la personne qui a agi sous l’empire d’une force ou d’une contrainte à laquelle elle n’a pu résister »).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Une ou plusieurs personnes visées"),
              const _Paragraph(
                "Les situations de contrainte à dissimuler son visage prennent principalement place dans le cadre familial. "
                "Elles sont souvent exercées au sein du couple ou par des parents sur leurs enfants.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Un des cinq moyens énumérés par la loi"),
              const _Paragraph(
                "Tous les moyens de pression sont pris en compte : menace, violence, contrainte, abus d’autorité ou abus de pouvoir.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("• La menace"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Est considéré comme une menace tout acte d’intimidation inspirant la crainte d’un mal ",
                ),
                const TextSpan(
                  text: "(Cass. crim., 11 juin 1937)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ". Elle se distingue des violences car elle porte atteinte à l’intégrité morale.",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("• La violence"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La violence peut impliquer un contact physique (coups, gifle, morsure…) mais peut aussi être retenue sans contact : "
                      "comportement impressionnant fortement la personne au point de lui causer un choc émotif ",
                ),
                const TextSpan(
                  text: "(Cass. crim., 30 avril 1996)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("• La contrainte"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Elle s’apprécie selon la capacité de résistance de la victime ",
                ),
                const TextSpan(
                  text: "(Cass. crim., 8 juin 1994)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ". Elle peut être corporelle (violences) ou psychologique (pressions assimilables à des menaces).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("• Abus d’autorité / abus de pouvoir"),
              const _Paragraph(
                "L’autorité peut être légale (autorité parentale), professionnelle (employeur), ou de fait (ascendant exercé sur une autre personne).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Fondement : le sexe de la victime"),
              const _Paragraph(
                "La dissimulation doit être imposée en raison du sexe de la victime. "
                "À l’heure actuelle, les femmes apparaissent comme les principales victimes.",
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
              _BulletPoint(
                text: "Conscience d’exercer une pression sur la victime.",
              ),
              _BulletPoint(
                text: "Volonté d’imposer à autrui de dissimuler son visage.",
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
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-4-10 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Lorsque le fait est commis au préjudice d’un mineur.",
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
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(
                  text: "1 an d’emprisonnement et 30 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-10 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Qualification aggravée (mineur) : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 60 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-10 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Responsabilité selon le principe général : ",
                ),
                const TextSpan(
                  text: "article 121-2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément aux "),
                const TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (aide/assistance, provocation, instructions données).",
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
