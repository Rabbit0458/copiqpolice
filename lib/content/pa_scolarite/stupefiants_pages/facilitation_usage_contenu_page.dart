import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaStupefiantsFacilitationUsagePage extends StatelessWidget {
  const PaStupefiantsFacilitationUsagePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/facilitation_usage';

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
            "La facilitation à l’usage illicite\nde stupéfiants",
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
                "Le fait de faciliter, par quelque moyen que ce soit, l’usage illicite de stupéfiants, "
                "de se faire délivrer des stupéfiants au moyen d’ordonnances fictives ou de complaisance, "
                "ou de délivrer des stupéfiants sur la présentation de telles ordonnances en connaissant leur caractère "
                "fictif ou complaisant, constitue une infraction.",
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
                _law("Article 222-37 alinéa 2 du Code pénal"),
                const TextSpan(
                  text:
                      " : définit et réprime le fait de faciliter l’usage illicite de stupéfiants.",
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
              const _SubTitle("A) Un acte facilitant l’usage illicite"),
              const _Paragraph(
                "Il s’agit d’un acte de complicité par fourniture de moyens que le législateur érige en infraction autonome. "
                "La facilitation est une aide matérielle apportée à l’usage de stupéfiants : les moyens ne sont pas limités "
                "(ex. prêt d’un local, bar servant de lieu de rendez-vous, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : le fait, pour un dirigeant ou animateur d’un établissement ouvert au public, "
                        "de permettre sciemment le trafic et l’usage de produits stupéfiants dans son établissement "
                        "constitue le délit prévu et puni par ",
                  ),
                  _law("l’article 222-37 alinéa 2 du Code pénal"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Les trois modalités visées par le texte"),
              const _Paragraph(
                "Le texte incrimine expressément trois formes de facilitation :\n"
                "• faciliter l’usage par quelque moyen que ce soit ;\n"
                "• se faire délivrer des stupéfiants via des ordonnances fictives ou de complaisance ;\n"
                "• délivrer des stupéfiants sur présentation de telles ordonnances en connaissant leur caractère fictif ou complaisant.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "1) Délivrer des ordonnances fictives ou de complaisance",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Cette modalité vise notamment les médecins qui procurent des facilités d’approvisionnement "
                      "aux toxicomanes (ex. prescriptions de médicaments classés stupéfiants sans respecter les dispositions des ",
                ),
                _law(
                  "articles R.5132-3 et R.5132-30 du Code de la santé publique",
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle(
                "2) Se faire délivrer des stupéfiants grâce à ces ordonnances",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Cette modalité vise les toxicomanes qui, au moyen d’ordonnances fictives ou de complaisance, "
                      "se font délivrer directement ou indirectement (par un tiers) des substances stupéfiantes par un pharmacien. "
                      "Si l’ordonnance est falsifiée, il est possible de retenir le faux en écriture privée (",
                ),
                _law("article 441-1 du Code pénal"),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle(
                "3) Délivrer des stupéfiants sur présentation de telles ordonnances",
              ),
              const _Paragraph(
                "Cette modalité vise les pharmaciens qui délivrent, en connaissance de cause, des médicaments classés stupéfiants "
                "sur présentation d’ordonnances fictives ou de complaisance.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Un produit stupéfiant"),
              _Paragraph.rich([
                _law("Article 222-41 du Code pénal"),
                const TextSpan(
                  text:
                      " : « constituent des stupéfiants, des substances ou plantes classées comme stupéfiants "
                      "en application de ",
                ),
                _law("l’article L.5132-7 du Code de la santé publique"),
                const TextSpan(text: " ».\n\n"),
                _law("Article L.5132-7 du Code de la santé publique"),
                const TextSpan(
                  text:
                      " : une substance est classée comme stupéfiant par décision du directeur général "
                      "de l’Agence nationale de sécurité du médicament et des produits de santé.\n\n"
                      "Ainsi, bien que d’autres substances puissent avoir des effets toxicomanogènes, seules doivent être retenues "
                      "celles figurant sur les listes arrêtées par voie réglementaire.\n\n"
                      "La liste exhaustive et évolutive figure en annexes de ",
                ),
                _law("l’arrêté du 22 février 1990"),
                const TextSpan(
                  text:
                      " : l’infraction ne s’applique donc qu’à une substance figurant sur cette liste, "
                      "désignée avec suffisamment de précision.",
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
                "L’auteur agit en connaissance de cause : il a la volonté, par ses manœuvres, "
                "de faciliter l’usage de produits stupéfiants, de s’en faire délivrer ou de les délivrer.",
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
                      " : lorsque l’infraction est commise par un majeur avec l’aide ou l’assistance, directe ou indirecte, d’un mineur.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Le mineur est utilisé pour le transport, la détention, l’offre, la cession, l’acquisition ou la vente de stupéfiants.",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "L’aide/assistance peut résulter de tout acte de sollicitation, d’incitation ou d’organisation intégrant un mineur dans un réseau (participation volontaire ou contrainte).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + réduction/exemption
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
                  text:
                      "10 ans d’emprisonnement et 7 500 000 € d’amende, période de sûreté. — ",
                ),
                _law("article 222-37 alinéa 2 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Qualification aggravée (crime) : "),
                const TextSpan(
                  text:
                      "15 ans de réclusion criminelle et 7 500 000 € d’amende, période de sûreté. — ",
                ),
                _law("article 222-37-1 1° du Code pénal"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les personnes morales encourent les peines prévues par ",
                ),
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
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Réduction de peine : prévue par "),
                  _law("l’article 222-43 du Code pénal"),
                  const TextSpan(
                    text:
                        " (réduction des deux tiers si avertissement des autorités permettant de faire cesser les agissements ou d’identifier les autres coupables ; "
                        "cas particulier de l’article 222-34 : perpétuité ramenée à 20 ans).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Exemption de peine : prévue par "),
                  _law("l’article 222-43-1 du Code pénal"),
                  const TextSpan(
                    text:
                        " (exemption si avertissement de l’autorité administrative/judiciaire permettant d’éviter la réalisation de l’infraction et d’identifier les auteurs/complices).",
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
  final String title = 'NOTA';

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
