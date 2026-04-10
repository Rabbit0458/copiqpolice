import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReiterationInfractionsPage extends StatelessWidget {
  const ReiterationInfractionsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/pluralite_infractions/reiteration_infractions';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color card = isDark
        ? const Color(0xFF2F2F2F)
        : const Color(0xFFF7F7FB);
    final Color card2 = isDark
        ? const Color(0xFF30323A)
        : const Color(0xFFF3F7FF);

    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    final Color lawRed = isDark
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFD32F2F);

    TextSpan law(String s) => TextSpan(
      text: s,
      style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    TextSpan t(String s) => TextSpan(text: s);

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
          'La sanction',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===================== TITRE (UNE SEULE FOIS) =====================
          Text(
            "La réitération d’infractions",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 12),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: "Chapitre 1 — Conditions de la réitération d’infractions",
            cardColor: card2,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                t(
                  "La loi du 12 décembre 2005 a consacré une notion jusque-là jurisprudentielle, en définissant la réitération comme étant le fait, pour une personne déjà condamnée définitivement pour un crime ou un délit, de commettre une nouvelle infraction ne répondant pas aux conditions de la récidive légale : ",
                ),
                law("article 132-16-7 alinéa 1 du Code pénal"),
                t("."),
              ]),
              const SizedBox(height: 12),

              const _Paragraph(
                "La réitération suppose donc :\n"
                "• une infraction commise après une condamnation définitive pour une infraction précédente ;\n"
                "• et une nouvelle infraction qui ne remplit pas les conditions de la récidive légale.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Concrètement",
                bodySpans: [
                  t(
                    "La réitération peut notamment viser des situations où :\n",
                  ),
                  t(
                    "• la première infraction est punie d’une peine inférieure à 10 ans ;\n",
                  ),
                  t(
                    "• la nouvelle infraction est différente ou non assimilable à l’infraction précédente ;\n",
                  ),
                  t(
                    "• ou l’infraction est identique, mais commise au-delà du délai de 5 ans après l’expiration ou la prescription de la peine prononcée pour la première infraction.\n\n",
                  ),
                  t(
                    "Les infractions commises en réitération sont traitées comme des infractions uniques.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: "Chapitre 2 — Effets de la réitération d’infractions",
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                t(
                  "Le Code pénal prévoit que les peines prononcées pour l’infraction commise en réitération se cumulent, sans limitation de quantum, et sans qu’il soit possible d’ordonner leur confusion : ",
                ),
                law("article 132-16-7 alinéa 2 du Code pénal"),
                t("."),
              ]),
              const SizedBox(height: 12),

              const _Paragraph(
                "Ainsi, une personne déjà condamnée définitivement qui commet une nouvelle infraction voit s’additionner, "
                "sans possibilité de confusion, la peine prononcée pour la nouvelle infraction avec la peine liée à la première infraction.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  t(
                    "La situation du réitérant est donc moins favorable que celle du prévenu auteur de plusieurs infractions n’ayant pas fait l’objet de condamnations définitives, "
                    "et bénéficiant du cumul plafonné des peines, voire de la confusion des peines.",
                  ),
                ],
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
