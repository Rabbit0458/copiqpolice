import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsignationPage extends StatelessWidget {
  const ConsignationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/consignation';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardScope = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardInfra = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMontants = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardMiseEnOeuvre = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
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
          "Procédures — circulation",
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
            "La consignation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 121-4 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article A. 37-27-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "La consignation est une somme versée immédiatement pour garantir le paiement futur (amende, etc.) "
                        "lorsque certaines garanties de représentation font défaut.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Personnes concernées
          _ConditionCard(
            title: "II — Personnes concernées",
            cardColor: cardScope,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sont concernées les personnes (françaises ou étrangères) auteurs d’une infraction à la circulation routière "
                "qui ne peuvent :",
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: "Justifier d’un domicile sur le territoire français.",
              ),
              _IntroBullet(
                text: "Justifier d’un emploi sur le territoire français.",
              ),
              _IntroBullet(
                text:
                    "Justifier d’une caution agréée par l’administration (ex : Automobile-Club de France, Touring Club de France…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions visées
          _ConditionCard(
            title: "III — Infractions visées",
            cardColor: cardInfra,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Sauf cas de paiement immédiat de l’amende forfaitaire ou de l’amende forfaitaire minorée "
                "(prévu pour certaines contraventions), la consignation s’applique :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Aux infractions au Code de la route : délits et contraventions.",
              ),
              const _BulletPoint(
                text:
                    "Aux réglementations relatives aux transports routiers (dont marchandises dangereuses) et aux conditions de travail : délits et contraventions.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Dans la pratique, la consignation est surtout exigée pour les infractions mettant en danger la sécurité des personnes.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La décision imposant le paiement de la consignation est prise par le procureur de la République, "
                      "qui doit statuer dans les ",
                ),
                const TextSpan(
                  text: "24 heures",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " suivant la constatation de l’infraction.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Montant consignation
          _ConditionCard(
            title: "IV — Montant de la consignation",
            cardColor: cardMontants,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Montants indicatifs selon la nature de l’infraction :",
              ),
              const SizedBox(height: 12),
              _ConsignationAmountTable(isDark: isDark),
            ],
          ),

          const SizedBox(height: 14),

          // Mise en œuvre
          _ConditionCard(
            title: "V — Mise en œuvre de la procédure",
            cardColor: cardMiseEnOeuvre,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("Perception immédiate"),
              const _Paragraph(
                "L’agent verbalisateur utilise un carnet de quittances à souches permettant la perception immédiate "
                "du montant de la consignation (feuillets 1 et 2 remis au contrevenant).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Refus de payer"),
              const _BulletPoint(
                text:
                    "Si le conducteur refuse de payer : le véhicule est immobilisé et l’agent avise immédiatement le procureur de la République.",
              ),
              const _BulletPoint(
                text:
                    "L’O.P.J. peut prescrire la mise en fourrière du véhicule.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Paiement exigé auprès d’un comptable du Trésor"),
              const _BulletPoint(
                text:
                    "Si le conducteur exige de payer uniquement entre les mains d’un comptable du Trésor : le véhicule est retenu jusqu’au versement effectif.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Titre de caution"),
              const _Paragraph(
                "Si le conducteur présente un titre de caution, l’infraction est relevée par procès-verbal en mentionnant :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Le nom et le siège de l’association ayant délivré le carnet d’assistance.",
              ),
              const _BulletPoint(
                text: "Le nom de l’organisme cautionnant la personne.",
              ),
              const _BulletPoint(
                text: "Le numéro de sociétaire du contrevenant.",
              ),
              const _BulletPoint(
                text: "Le numéro de l’attestation de cautionnement.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Modes de paiement acceptés"),
              const _Paragraph(
                "En règle générale, le paiement s’effectue en numéraire ou par chèque tiré sur une banque française.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Un versement en travellers chèques ou en eurochèques peut être accepté.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Quittance dématérialisée"),
              const _Paragraph(
                "Le carnet de quittances n’est pas utilisé si l’agent est équipé d’un dispositif permettant l’envoi d’une quittance dématérialisée.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Si paiement par chèque ou de façon dématérialisée (CB, télépaiement automatisé) : une quittance peut être envoyée à la demande à l’adresse électronique communiquée.",
              ),
              const _BulletPoint(
                text:
                    "Si paiement en espèces : le contrevenant doit communiquer son adresse électronique pour l’envoi de la quittance dématérialisée.",
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(text: "Mis à jour le "),
                const TextSpan(
                  text: "15/06/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsignationAmountTable extends StatelessWidget {
  const _ConsignationAmountTable({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color headerBg = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF1F1F1);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    Widget headerCell(
      String t, {
      int flex = 5,
      TextAlign align = TextAlign.left,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: text,
          ),
        ),
      );
    }

    Widget cell(
      String t, {
      int flex = 5,
      TextAlign align = TextAlign.left,
      bool strong = false,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13.5,
            color: subText,
          ),
        ),
      );
    }

    Widget row({required String nature, required String montant}) {
      return Container(
        decoration: BoxDecoration(
          color: rowBg,
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(nature, flex: 7, strong: true),
            cell(montant, flex: 3, align: TextAlign.right),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                headerCell("Infraction", flex: 7),
                headerCell("Montant", flex: 3, align: TextAlign.right),
              ],
            ),
          ),
          row(
            nature: "Délits punis d’une amende de 15 000 € au plus",
            montant: "1 125 € à 2 250 €",
          ),
          row(
            nature: "Délits punis d’une amende de plus de 15 000 €",
            montant: "2 250 € à 4 500 €",
          ),
          row(nature: "Contravention de 1ʳᵉ classe", montant: "11 €"),
          row(nature: "Contravention de 2ᵉ classe", montant: "35 €"),
          row(nature: "Contravention de 3ᵉ classe", montant: "68 €"),
          row(nature: "Contravention de 4ᵉ classe", montant: "135 €"),
          row(nature: "Contravention de 5ᵉ classe", montant: "750 €"),
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
