import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaStupefiantsTransportDetentionOffrePage extends StatelessWidget {
  const PaStupefiantsTransportDetentionOffrePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/transport_detention_offre';

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
            "Le transport, la détention, l’offre,\nla cession, l’acquisition ou l’emploi\nillicites de stupéfiants",
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
                "Le transport, la détention, l’offre, la cession, l’acquisition ou l’emploi illicites de stupéfiants "
                "constituent des infractions.",
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
                _law("Article 222-37 alinéa 1 du Code pénal"),
                const TextSpan(
                  text:
                      " : réprime le transport, la détention, l’offre, la cession, l’acquisition ou l’emploi illicites de stupéfiants.",
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
              const _SubTitle("A) Les agissements visés"),
              const _Paragraph(
                "Il s’agit des comportements d’intermédiaires, grossistes ou détaillants, acheteurs ou revendeurs. "
                "Le trafic visé est celui réalisé entre plusieurs personnes : la cession à une personne déterminée "
                "en vue de sa consommation personnelle est, elle, visée par un autre texte.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                _law("article 222-39 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle(
                "B) Trafic : preuve souvent par un faisceau d’indices",
              ),
              const _Paragraph(
                "Le trafic visé ici correspond notamment à l’achat dans le but de revendre. "
                "En pratique, la jurisprudence facilite la démonstration du trafic grâce à un réseau d’indices (faisceau).",
              ),
              const SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Retenu : personne n’ayant pas seulement « offert » pour consommation personnelle, mais s’étant livrée au commerce "
                        "des stupéfiants via des déplacements réguliers, sans consommer elle-même l’héroïne — ",
                  ),
                  _law("Cass. crim., 30 octobre 1995"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le trafic résulte souvent d’un faisceau d’indices : témoignages de toxicomanes + découverte au domicile de stupéfiants "
                        "et de matériel (balance/peson, couteau, produit de coupe, etc.) — ",
                  ),
                  _law("Cass. crim., 5 novembre 1998"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Les notions clés (définitions opérationnelles)",
              ),

              const _SubTitle("1) Le transport"),
              const _Paragraph(
                "C’est le fait de transporter des produits stupéfiants sans autorisation de l’administration.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Être trouvé porteur de stupéfiants sur la voie publique caractérise à la fois le délit de détention et celui de transport — ",
                  ),
                  _law("Cass. crim., 8 avril 1999"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) La détention"),
              const _Paragraph(
                "Elle concerne toute personne en possession de stupéfiants. La détention peut être retenue même si le produit "
                "n’est pas sur la personne, mais à proximité (ex : cache).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Détention retenue : stupéfiants dissimulés dans une cache à quelques mètres ; ex. détenu sachant que des doses "
                        "étaient cachées sous le matelas d’un autre détenu de la cellule — ",
                  ),
                  _law("Cass. crim., 17 octobre 1994"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "La jurisprudence rappelle que la détention illicite ne peut être réprimée que si elle s’inscrit dans un trafic "
                "ou dans le cadre de l’infraction spécifique de cession/usage personnel prévue par le code pénal.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Non retenu : détention pour une personne trouvée porteuse de 3 g de cannabis pour sa consommation personnelle ; "
                        "l’usage implique une détention préalable et le délit de détention est réservé aux hypothèses de trafic — ",
                  ),
                  _law("Cass. crim., 14 mars 2017"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) L’offre"),
              const _Paragraph(
                "L’offre correspond à l’instant qui précède la remise : l’acte matériel de remise n’a pas encore eu lieu, "
                "mais des stupéfiants sont proposés.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("4) La cession"),
              const _Paragraph(
                "La cession signifie que le produit a changé de mains : la transaction est réalisée.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("5) L’acquisition"),
              const _Paragraph(
                "L’acquisition est, pour celui qui reçoit le produit, le résultat de l’offre ou de la cession.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("6) L’emploi"),
              const _Paragraph(
                "L’emploi se distingue de l’usage : il vise toute utilisation de produits stupéfiants en dehors de la consommation "
                "(ex : couper des doses).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Définition légale des « stupéfiants » (cadre commun)",
              ),
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
                      " : une substance est classée comme stupéfiant par décision du directeur général de l’Agence nationale de sécurité "
                      "du médicament et des produits de santé.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ainsi, seules les substances figurant sur les listes arrêtées par voie réglementaire doivent être retenues "
                "au sens de la définition légale.",
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
                      " : l’infraction ne s’applique qu’à une substance figurant sur cette liste et désignée avec suffisamment de précision.",
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
                "L’intention coupable est requise. Elle peut être mise en évidence aussi bien par les actes matériels "
                "que par le profit tiré de ces actes.",
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
                    "L’aide/assistance d’un mineur peut être caractérisée par tout acte de sollicitation, d’incitation ou d’organisation intégrant un mineur dans un réseau de trafic (volontaire ou contrainte).",
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
                _law("article 222-37 alinéa 1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Qualification aggravée (crime) : "),
                const TextSpan(
                  text: "15 ans de réclusion et 7 500 000 € d’amende. — ",
                ),
                _law("article 222-37-1 1° du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
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
