import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaStupefiantsBlanchimentProduitPage extends StatelessWidget {
  const PaStupefiantsBlanchimentProduitPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/blanchiment_produit';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
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
            "Le blanchiment du produit\ndu trafic de stupéfiants",
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
                "Constitue une infraction le fait de faciliter, par tout moyen, la justification mensongère de l’origine "
                "des biens ou des revenus de l’auteur d’une infraction de trafic de stupéfiants, ou d’apporter son concours "
                "à une opération de placement, de dissimulation ou de conversion du produit de ces infractions.",
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
                _law("Article 222-38 alinéa 1 du Code pénal"),
                const TextSpan(
                  text:
                      " : définit et réprime le blanchiment du produit du trafic de stupéfiants.",
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
              const _SubTitle("A) Un agissement facilitant le blanchiment"),
              const _Paragraph(
                "L’infraction vise deux catégories d’agissements :\n"
                "• faciliter une justification mensongère de l’origine des biens/revenus ;\n"
                "• ou apporter son concours à des opérations de placement, dissimulation ou conversion.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "1) Faciliter, par un moyen frauduleux, une justification mensongère",
              ),
              const _Paragraph(
                "Il s’agit d’une aide matérielle, pouvant être apportée par n’importe quel moyen "
                "(exemples : fausses factures, fausses fiches de paie, reconnaissances de dettes, etc.).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "2) Apporter son concours à une opération de placement, dissimulation ou conversion",
              ),
              const _Paragraph(
                "Il s’agit principalement d’opérations bancaires ou financières. Des manquements aux obligations de vigilance "
                "imposées à certains professionnels/établissements peuvent caractériser ces agissements répréhensibles.",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Exemple : alimentation d’un compte par versements en espèces/chèques et transferts à l’étranger sous couvert "
                        "de mandats postaux — ",
                  ),
                  _law("Cass. crim., 23 octobre 1997"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Sur des biens/revenus issus du « trafic » de stupéfiants",
              ),
              const _Paragraph(
                "Le blanchiment vise le produit des infractions de trafic suivantes (infractions d’origine) :",
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                _law("Article 222-34 du Code pénal"),
                const TextSpan(
                  text:
                      " : diriger ou organiser un groupement ayant pour objet la production, fabrication, importation, exportation, "
                      "transport, détention, offre, cession, acquisition ou emploi illicites de stupéfiants.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _law("Article 222-35 du Code pénal"),
                const TextSpan(
                  text:
                      " : production ou fabrication illicites de stupéfiants.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _law("Article 222-36 du Code pénal"),
                const TextSpan(
                  text:
                      " : importation ou exportation illicites de stupéfiants.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _law("Article 222-37 du Code pénal"),
                const TextSpan(
                  text:
                      " : transport, détention, offre, cession, acquisition ou emploi illicites de stupéfiants, "
                      "et facilitation de l’usage illicite (dont ordonnances fictives/de complaisance).",
                ),
              ]),

              const SizedBox(height: 12),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La jurisprudence admet le cumul des poursuites pour l’infraction principale et le blanchiment de son produit : "
                        "l’incrimination de blanchiment peut aussi s’appliquer à l’auteur de l’infraction d’origine.",
                  ),
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
              _SubTitle("Faciliter en connaissance de cause"),
              _Paragraph(
                "L’auteur agit en connaissance de cause : il a la volonté, par ses manœuvres, de faciliter la justification mensongère "
                "de l’origine des biens ou des revenus, ou d’apporter son concours à une opération de placement, dissimulation "
                "ou conversion du produit des infractions de trafic visées.",
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
                _law("Article 222-38 alinéa 2 du Code pénal"),
                const TextSpan(
                  text:
                      " : lorsque l’infraction porte sur des biens ou fonds provenant de l’un des crimes mentionnés aux ",
                ),
                _law(
                  "articles 222-34, 222-35 et 222-36 (deuxième alinéa) du Code pénal",
                ),
                const TextSpan(text: "."),
              ]),
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
                const TextSpan(text: "Qualification simple (délit) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 750 000 € d’amende. — ",
                ),
                _law("article 222-38 alinéa 1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’amende peut être portée jusqu’à la totalité de la valeur des biens ou fonds ayant fait l’objet des opérations "
                        "de blanchiment.",
                  ),
                ],
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "Qualification aggravée (crime) : "),
                const TextSpan(
                  text:
                      "peines prévues pour certains crimes de trafic (référence) — ",
                ),
                _law("article 222-38 alinéa 2 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Référence aux peines de : "),
                _law("222-34, 222-35 et 222-36 alinéa 2 du Code pénal"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Peines prévues par "),
                _law("l’article 222-42 du Code pénal"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — prévue par "),
                _law("l’article 222-40 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI — conformément aux "),
                _law("articles 121-6 et 121-7 du Code pénal"),
                const TextSpan(
                  text:
                      " (aide et assistance, provocation, instructions données).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Exemption & réduction de peine"),
              _Paragraph.rich([
                const TextSpan(text: "Réduction de peine : "),
                _law("article 222-43 du Code pénal"),
                const TextSpan(
                  text:
                      " (réduction des deux tiers si l’auteur/complice avertit les autorités et permet de faire cesser les agissements "
                      "ou d’identifier d’autres coupables).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Exemption de peine : "),
                _law("article 222-43-1 du Code pénal"),
                const TextSpan(
                  text:
                      " (si la personne ayant tenté l’infraction avertit les autorités et permet d’éviter la réalisation et d’identifier, "
                      "le cas échéant, d’autres auteurs/complices).",
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
