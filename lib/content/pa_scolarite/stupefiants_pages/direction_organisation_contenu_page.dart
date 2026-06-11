import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaStupefiantsDirectionOrganisationPage extends StatelessWidget {
  const PaStupefiantsDirectionOrganisationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/direction_organisation';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
        ? const Color(0xFF20242A)
        : const Color(0xFFF3F6FA);

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
          "Stupéfiants",
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
            "La direction ou l’organisation\nd’un trafic de stupéfiants",
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
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait de diriger ou d’organiser un groupement ayant pour objet la production, la fabrication, "
                "l’importation, l’exportation, le transport, la détention, l’offre, la cession, l’acquisition ou l’emploi "
                "illicites de stupéfiants constitue une infraction.",
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
                _lawSpan("Article 222-34 alinéa 1 du Code pénal"),
                const TextSpan(
                  text:
                      " : définit et réprime la direction ou l’organisation d’un trafic de stupéfiants.",
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
              const _Paragraph(
                "Cette incrimination ne doit pas être confondue avec l’association de malfaiteurs en vue de préparer un trafic "
                "de stupéfiants (infraction délictuelle).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Différence essentielle :\n"
                "• l’association de malfaiteurs peut être constituée alors même que le trafic n’a pas encore été réalisé ;\n"
                "• ici, l’infraction suppose la commission effective d’un trafic de stupéfiants.",
              ),
              const SizedBox(height: 14),

              const _SubTitle(
                "A) La direction ou l’organisation d’un groupement",
              ),
              const _Paragraph(
                "Le « groupement » désigne un ensemble de personnes (et non la simple réunion de moyens matériels par un seul individu). "
                "Il peut prendre n’importe quelle forme, y compris celle d’une société destinée à dissimuler la nature exacte de l’activité.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il requiert une structuration minimale : l’infraction suppose qu’il est effectivement dirigé ou organisé. "
                "La notion est voisine de l’association de malfaiteurs ou de la bande organisée.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le seul fait d’être membre du groupement n’est pas réprimé au titre de cet article, "
                        "sauf si l’intéressé fait partie de ceux qui le dirigent ou l’organisent.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Un groupement ayant pour but le trafic de stupéfiants",
              ),
              _Paragraph.rich([
                _lawSpan("Article 222-34 du Code pénal"),
                const TextSpan(
                  text:
                      " : vise les faits de production, fabrication, importation, exportation, transport, détention, offre, cession, "
                      "acquisition ou emploi illicites de stupéfiants. Il s’agit des actes constitutifs d’un trafic.",
                ),
              ]),
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
                "L’intention coupable est requise : l’auteur doit diriger ou organiser en connaissance de cause un groupement "
                "ayant pour objet le trafic de stupéfiants.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle peut être mise en évidence par les actes matériels accomplis, mais aussi par le profit tiré de ces actes.",
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
                "Aucune circonstance aggravante spécifique n’est prévue pour cette incrimination.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + exemption/réduction
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Qualification : "),
                const TextSpan(text: "crime. "),
                const TextSpan(text: "Peines principales : "),
                const TextSpan(
                  text:
                      "réclusion criminelle à perpétuité et 7 500 000 € d’amende — ",
                ),
                _lawSpan("article 222-34 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Période de sûreté : OUI."),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text: "La responsabilité des personnes morales est prévue à ",
                ),
                _lawSpan("l’article 222-42 du Code pénal"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text:
                    "Tentative : OUI (toujours punissable en matière de crime).",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI — conformément aux "),
                _lawSpan("articles 121-6 et 121-7 du Code pénal"),
                const TextSpan(
                  text: " (aide et assistance, provocation, instructions).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Exemption & réduction de peine"),
              _Paragraph.rich([
                const TextSpan(text: "Réduction de peine : OUI — "),
                _lawSpan("article 222-43 du Code pénal"),
                const TextSpan(
                  text:
                      " (pour le cas de l’article 222-34 : la réclusion criminelle à perpétuité est ramenée à vingt ans si la personne avertit les autorités "
                      "et permet de faire cesser les agissements et d’identifier les autres coupables).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Exemption de peine : OUI — "),
                _lawSpan("article 222-43-1 du Code pénal"),
                const TextSpan(
                  text:
                      " (exempté si la personne avertit l’autorité administrative ou judiciaire, évite la réalisation de l’infraction et "
                      "permet d’identifier les autres auteurs/complices).",
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
  const _NotaBox({required this.bodySpans});

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
