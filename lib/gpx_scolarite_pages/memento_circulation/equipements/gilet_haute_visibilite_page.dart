import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GiletHauteVisibilitePage extends StatelessWidget {
  const GiletHauteVisibilitePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/gilet_haute_visibilite';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _boldSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(fontWeight: FontWeight.w900),
  );

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
          "Équipements",
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
            "Gilet de haute visibilité",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // À retenir
          _ConditionCard(
            title: "À retenir",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le gilet de haute visibilité concerne :\n"
                "• le conducteur d’un véhicule à moteur (disposer + porter en cas d’arrêt d’urgence) ;\n"
                "• le conducteur d’un E.D.P.M. / cyclomobile léger (porter la nuit ou par visibilité insuffisante) ;\n"
                "• le conducteur ou passager d’un cycle (hors agglomération, la nuit ou par visibilité insuffisante).",
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
                _lawSpan("R. 416-19 du Code de la route"),
                const TextSpan(text: " (véhicules à moteur) • "),
                _lawSpan("R. 412-43-3 du Code de la route"),
                const TextSpan(text: " (E.D.P.M./cyclomobile léger) • "),
                _lawSpan("R. 431-1-1 du Code de la route"),
                const TextSpan(text: " (cycles)."),
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
              const _SubTitle("A) Conducteur d’un véhicule à moteur"),
              const _Paragraph(
                "En circulation, tout conducteur d’un véhicule à moteur (sauf véhicules agricoles) doit disposer "
                "d’un gilet de haute visibilité conforme à la réglementation.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Où doit se trouver le gilet ?"),
              const _BulletPoint(
                text:
                    "2/3 roues ou quadricycle à moteur non carrossé : sur lui ou dans un rangement du véhicule (filet, coffre…).",
              ),
              const _BulletPoint(
                text: "Autres véhicules : à portée de main du conducteur.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Contrôle",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le gilet doit être présenté à toute réquisition. En cas de non-présentation immédiate, "
                        "le conducteur n’est pas tenu de justifier de sa possession.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF (disposer du gilet)",
                bodySpans: [
                  _boldSpan("26987"),
                  const TextSpan(text: " — "),
                  _lawSpan("R. 416-19 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Port du gilet en cas d’arrêt d’urgence"),
              const _Paragraph(
                "Le conducteur doit revêtir le gilet lorsqu’il est amené à quitter son véhicule immobilisé "
                "sur la chaussée ou ses abords à la suite d’un arrêt d’urgence.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Présignalisation",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La présignalisation de l’obstacle doit également être assurée (feux de détresse + triangle de présignalisation).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF (descente sans gilet)",
                bodySpans: [
                  _boldSpan("26985"),
                  const TextSpan(text: " — "),
                  _lawSpan("R. 416-19 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Conducteur d’un E.D.P.M. / cyclomobile léger",
              ),
              const _Paragraph(
                "Lorsqu’il circule la nuit ou le jour lorsque la visibilité est insuffisante, le conducteur "
                "doit porter :\n"
                "• un gilet de haute visibilité conforme, ou\n"
                "• un équipement rétro-réfléchissant.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Option",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Il peut également porter un dispositif d’éclairage complémentaire non éblouissant et non clignotant.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _boldSpan("33361"),
                  const TextSpan(text: " — "),
                  _lawSpan("R. 412-43-3 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Conducteur ou passager d’un cycle"),
              const _Paragraph(
                "Hors agglomération, la nuit, ou le jour lorsque la visibilité est insuffisante : "
                "tout conducteur ou passager d’un cycle doit porter un gilet de haute visibilité conforme.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _boldSpan("26988"),
                  const TextSpan(text: " — "),
                  _lawSpan("R. 431-1-1 du Code de la route"),
                  const TextSpan(text: "."),
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
                "Manquement aux obligations de disposer/porter un gilet de haute visibilité (ou équipement rétro-réfléchissant "
                "pour E.D.P.M.) dans les situations prévues par le Code de la route.",
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
                "Aucune circonstance aggravante spécifique n’est mentionnée dans l’extrait du mémento.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Véhicule à moteur"),
              _Paragraph.rich([
                const TextSpan(text: "Ne pas disposer d’un gilet : "),
                _boldSpan("NATINF 26987"),
                const TextSpan(text: " — "),
                _lawSpan("R. 416-19 du Code de la route"),
                const TextSpan(text: " — "),
                const TextSpan(text: "AF 1re classe."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Quitter le véhicule (arrêt d’urgence) sans gilet : ",
                ),
                _boldSpan("NATINF 26985"),
                const TextSpan(text: " — "),
                _lawSpan("R. 416-19 du Code de la route"),
                const TextSpan(text: " — "),
                const TextSpan(text: "AF min. 4e classe."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Cycle"),
              _Paragraph.rich([
                _boldSpan("NATINF 26988"),
                const TextSpan(text: " — "),
                _lawSpan("R. 431-1-1 du Code de la route"),
                const TextSpan(text: " — "),
                const TextSpan(text: "AF min. 2e classe."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("E.D.P.M. / cyclomobile léger"),
              _Paragraph.rich([
                _boldSpan("NATINF 33361"),
                const TextSpan(text: " — "),
                _lawSpan("R. 412-43-3 du Code de la route"),
                const TextSpan(text: " — "),
                const TextSpan(text: "AF min. 2e classe."),
              ]),
              const SizedBox(height: 12),

              const _BulletPoint(
                text:
                    "D.I.A. et dépistage stupéfiants : facultatifs (mention mémento).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité
          _ConditionCard(
            title: "VI — Tentative & complicité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Tentative : NON (contravention liée à un manquement constaté).",
              ),
              _BulletPoint(
                text:
                    "Complicité : NON (obligation personnelle selon la situation).",
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
