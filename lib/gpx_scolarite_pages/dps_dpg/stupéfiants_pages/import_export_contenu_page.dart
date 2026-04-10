import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StupefiantsImportExportPage extends StatelessWidget {
  const StupefiantsImportExportPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/stupéfiants_pages/import_export';

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
            "L’importation ou l’exportation\nillicites de stupéfiants",
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
                "L’importation ou l’exportation illicites de stupéfiants constituent une infraction.",
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
                _law("Article 222-36 alinéa 1 du Code pénal"),
                const TextSpan(
                  text:
                      " : réprime l’importation ou l’exportation illicites de stupéfiants.",
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
              const _SubTitle("A) Importation / exportation illicites"),
              const _SubTitle("1) L’importation"),
              const _Paragraph(
                "Elle vise aussi bien le trafiquant international dirigeant un réseau que l’individu qui en importe "
                "au retour d’un voyage touristique. L’élément matériel est constitué dès lors que la personne "
                "pénètre ou tente de pénétrer sur le territoire national en possession de stupéfiants.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un voilier intercepté dans les eaux territoriales françaises en provenance du Maroc transportant "
                        "10 tonnes de résine de cannabis : peu importe l’allégation selon laquelle la drogue était destinée "
                        "aux Pays-Bas — ",
                  ),
                  _law("Cass. crim., 11 juin 2008"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Des individus se rendent plusieurs fois par mois aux Pays-Bas pour acheter de l’héroïne, livrée ensuite "
                        "à Strasbourg par un passeur : la loi n’exige pas que les prévenus franchissent eux-mêmes la frontière "
                        "avec l’héroïne — ",
                  ),
                  _law("Cass. crim., 7 avril 2004"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 14),

              const _SubTitle("2) L’exportation"),
              const _Paragraph(
                "Cet élément est, pour des raisons évidentes, plus rare.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Définition légale des « stupéfiants »"),
              _Paragraph.rich([
                _law("Article 222-41 du Code pénal"),
                const TextSpan(
                  text:
                      " : « constituent des stupéfiants, des substances ou plantes classées comme stupéfiants en application de ",
                ),
                _law("l’article L. 5132-7 du Code de la santé publique"),
                const TextSpan(text: " »."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article L. 5132-7 du Code de la santé publique"),
                const TextSpan(
                  text:
                      " : une substance est classée comme stupéfiant par décision du directeur général de l’Agence nationale "
                      "de sécurité du médicament et des produits de santé.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ainsi, seules les substances figurant sur les listes arrêtées par voie réglementaire doivent être retenues "
                "au sens de la définition légale, même si d’autres substances peuvent avoir des effets toxicomanogènes.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La liste exhaustive et évolutive figure en annexes de ",
                ),
                _law("l’arrêté du 22 février 1990"),
                const TextSpan(
                  text:
                      " : l’infraction ne s’applique qu’à une substance figurant sur cette liste et désignée avec suffisamment "
                      "de précision.",
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
              _SubTitle("Connaissance de cause"),
              _Paragraph(
                "L’intention coupable est requise. Elle peut être démontrée par les actes matériels "
                "comme par le profit tiré de ces actes.",
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
                _law("Article 222-36 alinéa 2 du Code pénal"),
                const TextSpan(
                  text: " : lorsque les faits sont commis en bande organisée.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article 222-37-1 du Code pénal"),
                const TextSpan(
                  text:
                      " : lorsque l’infraction est commise par un majeur agissant avec l’aide ou l’assistance, directe ou indirecte, "
                      "d’un mineur pour le transport, la détention, l’offre, la cession, l’acquisition ou la vente de stupéfiants.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "L’aide/assistance d’un mineur peut résulter de tout acte de sollicitation, d’incitation ou d’organisation intégrant un mineur dans un réseau de trafic (volontaire ou contrainte).",
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
                const TextSpan(text: "Qualification simple (délit) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 7 500 000 € d’amende. — ",
                ),
                _law("article 222-36 alinéa 1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravation (bande organisée) : "),
                const TextSpan(
                  text: "30 ans de réclusion et 7 500 000 € d’amende. — ",
                ),
                _law("article 222-36 alinéa 2 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravation (avec mineur – 1°) : "),
                const TextSpan(
                  text: "15 ans de réclusion et 7 500 000 € d’amende. — ",
                ),
                _law("article 222-37-1 1° du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravation cumulée (bande organisée + mineur) : ",
                ),
                const TextSpan(
                  text: "réclusion à perpétuité et 7 500 000 € d’amende. — ",
                ),
                _law("article 222-37-1 3° du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les tableaux prévoient une période de sûreté (selon les cas et les textes applicables).",
                  ),
                ],
              ),

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
                      " (réduction des deux tiers si l’auteur/complice avertit les autorités et permet de faire cesser les agissements ou d’identifier d’autres coupables).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Exemption de peine : "),
                _law("article 222-43-1 du Code pénal"),
                const TextSpan(
                  text:
                      " (si la personne ayant tenté l’infraction avertit les autorités et permet d’éviter la réalisation et d’identifier, le cas échéant, d’autres auteurs/complices).",
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
