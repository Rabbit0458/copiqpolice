import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotionLibertesPubliquesPage extends StatelessWidget {
  const NotionLibertesPubliquesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction/notion_libertes_publiques';

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
    final Color cardChap1 = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardChap2 = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDef = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
          "Libertés publiques",
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
            "Notion de libertés publiques",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===================== INTRO =====================
          _ConditionCard(
            title: "Idée clé",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La tendance contemporaine consiste à confondre libertés publiques et droits de l’homme. "
                "Pourtant, les libertés publiques ont un caractère juridique : ce sont des droits de l’homme intégrés au droit positif "
                "et protégés par un régime juridique spécifique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: "Chapitre 1 — Libertés publiques et droits de l’homme",
            cardColor: cardChap1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les libertés publiques sont une catégorie particulière de droits de l’homme : elles sont reconnues par l’État, "
                "insérées dans le droit positif, et dotées de garanties juridiques.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Ce que cela implique concrètement"),
              const _BulletPoint(
                text:
                    "Ce sont des droits : l’État doit s’abstenir d’y porter atteinte, mais aussi permettre leur exercice effectif.",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Exemple : la liberté d’enseignement suppose aussi des moyens concrets (ex. subventions à l’enseignement privé) afin d’éviter une liberté réservée aux plus aisés.",
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Ce sont des droits reconnus par l’État : ils organisent les rapports entre l’État et les individus (et parfois entre individus).",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Ils sont consacrés par un texte : constitutionnel, législatif, éventuellement réglementaire, ou une convention internationale ratifiée.",
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Ils bénéficient d’une protection juridique particulière : les libertés qualifiées de « fondamentales » ont un régime plus favorable que d’autres droits.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: "Chapitre 2 — Liberté et libertés publiques",
            cardColor: cardChap2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("2.1 — Notion de liberté"),
              const _Paragraph(
                "La liberté est une notion complexe : elle touche la culture, les sciences, la philosophie, la politique et l’économie. "
                "Au sens simple, la liberté est le pouvoir d’autodétermination : l’individu choisit lui-même son comportement.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Cette définition est la plus accessible, mais elle reste incomplète : toute liberté rencontre des limites (autrui, ordre public, sécurité, etc.).",
                  ),
                ],
                title: "À retenir",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2.2 — Notion de libertés publiques"),
              const _Paragraph(
                "La notion comporte deux aspects :\n"
                "• « libertés » : des droits et libertés fondamentaux.\n"
                "• « publiques » : l’intervention de l’État (reconnaissance, encadrement, sanction des atteintes).",
              ),
              const SizedBox(height: 12),

              // Définition mise en valeur
              _ConditionCard(
                title: "Définition",
                cardColor: cardDef,
                accent: accentAmber,
                titleColor: textMain,
                children: [
                  _Paragraph.rich([
                    const TextSpan(text: "Les libertés publiques sont des "),
                    const TextSpan(
                      text: "droits et libertés fondamentaux",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const TextSpan(text: " reconnus par l’État ("),
                    TextSpan(
                      text:
                          "texte constitutionnel, législatif, éventuellement réglementaire, ou convention internationale ratifiée",
                      style: const TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(
                      text:
                          "), dont l’exercice est réglementé et dont les atteintes sont sanctionnées.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Donc : une liberté devient « publique » lorsque l’État en consacre le principe, en aménage l’exercice "
                    "et en assure le respect (y compris par des sanctions en cas d’atteinte).",
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
