import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PpMandatsPrincipesGenerauxPage extends StatelessWidget {
  const PpMandatsPrincipesGenerauxPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_mandats_principes_generaux';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.75);

    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF4F6FB);
    const Color articleRed = Color(0xFFD32F2F);

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
          'Mandats de justice — Principes',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            'Les mandats de justice\n(Articles 122 à 136 du Code de procédure pénale)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              letterSpacing: .2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            "Les mandats de justice sont des actes judiciaires écrits permettant d’ordonner la recherche, "
            "la comparution, l’arrestation ou la détention d’une personne. Ils ne peuvent être délivrés que par des magistrats "
            "et obéissent à des règles de forme et de fond strictes, fixées aux articles 122 à 136 du Code de procédure pénale.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: 'Chapitre 1 — Principes généraux qui régissent les mandats',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              // ================== 1.1 DÉFINITION ============================
              const _SubTitle(
                '1.1 — Définition et nature des mandats de justice',
              ),
              const _Paragraph(
                "Les mandats de justice sont des actes judiciaires écrits par lesquels un magistrat ordonne "
                "soit la recherche et la présentation d’une personne, soit sa comparution, soit son arrestation, "
                "soit encore son placement en détention. Ils constituent des instruments essentiels de contrainte "
                "dans le cadre de la procédure pénale.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "Principalement utilisés par le juge d’instruction, les textes qui définissent les mandats et fixent leurs règles "
                "de forme et de fond figurent dans la section VI du chapitre du Code de procédure pénale consacré au juge d’instruction.",
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: "Selon "),
                TextSpan(
                  text: "l’Article 122 alinéa 1 du Code de procédure pénale",
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ", il existe cinq types de mandats :"),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(text: "le mandat de recherche ;"),
              const _BulletPoint(text: "le mandat de comparution ;"),
              const _BulletPoint(text: "le mandat d’amener ;"),
              const _BulletPoint(text: "le mandat de dépôt ;"),
              const _BulletPoint(text: "le mandat d’arrêt."),

              const SizedBox(height: 14),

              // ================== 1.2 PRINCIPES GÉNÉRAUX ====================
              const _SubTitle(
                '1.2 — Principes généraux applicables aux mandats',
              ),
              const _Paragraph(
                "Plusieurs principes généraux encadrent la délivrance et l’exécution des mandats de justice. "
                "Ils garantissent à la fois l’efficacité de la mesure et le respect des droits fondamentaux de la personne concernée.",
              ),
              const SizedBox(height: 8),

              // Incommunicabilité / non-délégation
              const _Paragraph(
                "Les mandats de justice sont des actes non délégables : un magistrat ne peut pas déléguer son pouvoir de délivrer un mandat "
                "à un officier de police judiciaire, y compris lorsqu’il lui confie l’exécution d’une commission rogatoire. "
                "Seul le magistrat signataire peut décider de décerner un mandat de comparution, d’amener, de dépôt, d’arrêt ou de recherche.",
              ),

              const SizedBox(height: 10),

              // Article 123 al.1 & al.2 CPP
              _Paragraph.rich([
                const TextSpan(text: "En ce qui concerne la forme, "),
                TextSpan(
                  text: "l’Article 123 alinéa 1 du Code de procédure pénale",
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      " dispose que « tout mandat précise l’identité de la personne à l’encontre de laquelle il est décerné ; "
                      "il est daté et signé par le magistrat qui l’a décerné et est revêtu de son sceau ».",
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En outre, les mandats d’amener, de dépôt, d’arrêt et de recherche doivent mentionner la nature des faits imputés à la personne, "
                      "leur qualification juridique ainsi que les articles de loi applicables, conformément à ",
                ),
                TextSpan(
                  text: "l’Article 123 alinéa 2 du Code de procédure pénale",
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 10),

              const _Paragraph(
                "Les mandats de justice sont des actes individuels et écrits : ils visent nominativement une personne déterminée, "
                "dont l’identité est précisément indiquée, et prennent nécessairement la forme d’un écrit signé par le magistrat compétent.",
              ),

              const SizedBox(height: 10),

              // Diffusion d'urgence — Article 123 al.6 CPP
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En cas d’urgence, certains mandats peuvent être diffusés par tous moyens de communication (télégramme, télécopie, courriel, etc.). "
                      "Il s’agit des mandats d’amener, d’arrêt et de recherche, comme le prévoit ",
                ),
                TextSpan(
                  text: "l’Article 123 alinéa 6 du Code de procédure pénale",
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(text: "Dans ce cas, "),
                TextSpan(
                  text: "l’Article 123 alinéa 7 du Code de procédure pénale",
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      " exige que les mentions essentielles de l’original soient reproduites : identité de la personne visée, "
                      "nature des faits et qualification juridique, ainsi que le nom et la qualité du magistrat mandant. "
                      "L’original ou une copie du mandat doit ensuite être transmis à l’agent chargé de son exécution dans les délais les plus brefs.",
                ),
              ]),

              const SizedBox(height: 10),

              // Article 124 CPP — Exécution sur tout le territoire
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Enfin, la portée territoriale des mandats est définie par ",
                ),
                TextSpan(
                  text: "l’Article 124 du Code de procédure pénale",
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ", selon lequel « les mandats sont exécutoires dans toute l’étendue du territoire de la République ». "
                      "Un mandat délivré par un magistrat peut donc être exécuté partout en France, sans limitation de ressort.",
                ),
              ]),

              const SizedBox(height: 14),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les mandats de justice constituent des outils puissants de contrainte à la disposition des magistrats. "
                        "La rigueur des règles de forme (mentions obligatoires, signature, sceau, identité précise) et de fond "
                        "(compétence du magistrat, caractère individuel de la mesure) garantit à la fois l’efficacité de la procédure pénale "
                        "et la protection des droits fondamentaux des personnes visées.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
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
