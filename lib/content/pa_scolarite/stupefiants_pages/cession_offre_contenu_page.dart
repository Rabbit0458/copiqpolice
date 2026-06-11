import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaStupefiantsCessionOffrePage extends StatelessWidget {
  const PaStupefiantsCessionOffrePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/cession_offre';

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
            "La cession ou l’offre illicites de stupéfiants\nà une personne en vue de sa consommation personnelle",
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
                "La cession ou l’offre illicites de stupéfiants à une personne en vue de sa consommation personnelle "
                "constituent des infractions. Cette qualification vise principalement les « petits dealers », "
                "avec une logique distincte des infractions de détention/transport/détention en vue de trafic.",
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
                _lawSpan("Article 222-39 alinéa 1 du Code pénal"),
                const TextSpan(
                  text:
                      " : définit et réprime la cession ou l’offre illicites de stupéfiants à une personne en vue de sa consommation personnelle.",
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
                "Cette qualification, orientée « cession/offre au détail », exclut celle de l’infraction réprimée par "
                "l’article 222-37 (notamment détention de stupéfiants). Elle vise la vente au détail d’une ou quelques doses, "
                "où l’acheteur est considéré comme un simple usager.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence d’exclusion : "),
                _lawSpan("article 222-37 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("A) Céder ou offrir en vue de la consommation"),
              const _Paragraph(
                "• L’offre correspond à l’instant qui précède la remise : l’acte matériel de remise n’a pas encore eu lieu, "
                "on propose des stupéfiants.\n"
                "• La cession signifie que le produit a changé de mains : la transaction est déjà réalisée.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le texte ne distingue pas le caractère onéreux ou désintéressé de la transaction. "
                "Peu importe que l’auteur ait pris l’initiative de l’opération ou qu’il ait simplement accédé à une demande.",
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "Dans les faits, il s’agit souvent d’usagers cherchant un gain pour satisfaire leurs propres besoins, "
                "ou d’une vente « au détail » d’une ou quelques doses.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un produit stupéfiant"),
              _Paragraph.rich([
                _lawSpan("Article 222-41 du Code pénal"),
                const TextSpan(
                  text:
                      " : « constituent des stupéfiants, des substances ou plantes classées comme stupéfiants » en application de ",
                ),
                _lawSpan("l’article L. 5132-7 du Code de la santé publique"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawSpan("Article L. 5132-7 du Code de la santé publique"),
                const TextSpan(
                  text:
                      " : précise qu’une substance est classée comme stupéfiant par décision du directeur général de l’Agence nationale "
                      "de sécurité du médicament et des produits de santé (ANSM).",
                ),
              ]),
              const SizedBox(height: 12),
              const _Paragraph(
                "Ainsi, même si d’autres substances peuvent produire des effets toxicomanogènes, seules sont retenues celles figurant "
                "sur des listes arrêtées par voie réglementaire. L’infraction ne peut s’appliquer qu’à une substance figurant sur ces listes, "
                "et elle doit être désignée avec suffisamment de précision.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La liste exhaustive et évolutive des substances classées comme stupéfiants figure en annexes de ",
                  ),
                  _lawSpan("l’arrêté du 22 février 1990"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un juge ne peut se contenter de viser de façon générale « des substances stupéfiantes » sans préciser lesquelles : ",
                  ),
                  _lawSpan("Cass. crim., 16 septembre 1985"),
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
                "L’auteur agit en connaissance de cause : il cède ou offre en sachant qu’il s’agit de produits stupéfiants "
                "et qu’il les remet/propose à une personne en vue de sa consommation personnelle.",
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
                _lawSpan("Article 222-39 alinéa 2 du Code pénal"),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsque les stupéfiants sont offerts ou cédés à des mineurs.",
              ),
              const _BulletPoint(
                text:
                    "Lorsque les faits sont commis dans des établissements d’enseignement/éducation ou dans les locaux de l’administration.",
              ),
              const _BulletPoint(
                text:
                    "Ainsi que lors des entrées/sorties des élèves ou du public, ou dans un temps très voisin, aux abords de ces établissements ou locaux.",
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
                const TextSpan(text: "Qualification simple (délit) : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                _lawSpan("article 222-39 alinéa 1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Qualification aggravée : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                _lawSpan("article 222-39 alinéa 2 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les personnes morales encourent les peines prévues par ",
                ),
                _lawSpan("l’article 222-42 du Code pénal"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — prévue par "),
                _lawSpan("l’article 222-40 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
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
                      " (peine réduite des deux tiers si l’auteur/complice avertit les autorités et permet de faire cesser les agissements ou d’identifier les autres coupables).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Exemption de peine : OUI — "),
                _lawSpan("article 222-43-1 du Code pénal"),
                const TextSpan(
                  text:
                      " (exempté si la personne avertit l’autorité administrative ou judiciaire, évite la réalisation de l’infraction et permet d’identifier les autres auteurs/complices).",
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
