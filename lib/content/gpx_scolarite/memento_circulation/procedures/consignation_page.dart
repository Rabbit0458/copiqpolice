import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
            "f00002",
            "Procédures — circulation",
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00003",
              "La consignation",
            ),
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
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00004",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                    "f00005",
                    "Article L. 121-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                    "f00006",
                    "article A. 37-27-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                          "f00007",
                          "La consignation est une somme versée immédiatement pour garantir le paiement futur (amende, etc.) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                          "f00008",
                          "lorsque certaines garanties de représentation font défaut.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Personnes concernées
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00009",
              "II — Personnes concernées",
            ),
            cardColor: cardScope,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00010",
                      "Sont concernées les personnes (françaises ou étrangères) auteurs d’une infraction à la circulation routière ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00011",
                      "qui ne peuvent :",
                    ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00012",
                  "Justifier d’un domicile sur le territoire français.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00013",
                  "Justifier d’un emploi sur le territoire français.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00014",
                  "Justifier d’une caution agréée par l’administration (ex : Automobile-Club de France, Touring Club de France…).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions visées
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00015",
              "III — Infractions visées",
            ),
            cardColor: cardInfra,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00016",
                      "Sauf cas de paiement immédiat de l’amende forfaitaire ou de l’amende forfaitaire minorée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00017",
                      "(prévu pour certaines contraventions), la consignation s’applique :",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00018",
                  "Aux infractions au Code de la route : délits et contraventions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00019",
                  "Aux réglementations relatives aux transports routiers (dont marchandises dangereuses) et aux conditions de travail : délits et contraventions.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00020",
                      "Dans la pratique, la consignation est surtout exigée pour les infractions mettant en danger la sécurité des personnes.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                        "f00021",
                        "La décision imposant le paiement de la consignation est prise par le procureur de la République, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                        "f00022",
                        "qui doit statuer dans les ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                    "f00023",
                    "24 heures",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                    "f00024",
                    " suivant la constatation de l’infraction.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Montant consignation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00025",
              "IV — Montant de la consignation",
            ),
            cardColor: cardMontants,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00026",
                  "Montants indicatifs selon la nature de l’infraction :",
                ),
              ),
              const SizedBox(height: 12),
              _ConsignationAmountTable(isDark: isDark),
            ],
          ),

          const SizedBox(height: 14),

          // Mise en œuvre
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00027",
              "V — Mise en œuvre de la procédure",
            ),
            cardColor: cardMiseEnOeuvre,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00028",
                  "Perception immédiate",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00029",
                      "L’agent verbalisateur utilise un carnet de quittances à souches permettant la perception immédiate ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                      "f00030",
                      "du montant de la consignation (feuillets 1 et 2 remis au contrevenant).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00031",
                  "Refus de payer",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00032",
                  "Si le conducteur refuse de payer : le véhicule est immobilisé et l’agent avise immédiatement le procureur de la République.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00033",
                  "L’O.P.J. peut prescrire la mise en fourrière du véhicule.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00034",
                  "Paiement exigé auprès d’un comptable du Trésor",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00035",
                  "Si le conducteur exige de payer uniquement entre les mains d’un comptable du Trésor : le véhicule est retenu jusqu’au versement effectif.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00036",
                  "Titre de caution",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00037",
                  "Si le conducteur présente un titre de caution, l’infraction est relevée par procès-verbal en mentionnant :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00038",
                  "Le nom et le siège de l’association ayant délivré le carnet d’assistance.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00039",
                  "Le nom de l’organisme cautionnant la personne.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00040",
                  "Le numéro de sociétaire du contrevenant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00041",
                  "Le numéro de l’attestation de cautionnement.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00042",
                  "Modes de paiement acceptés",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00043",
                  "En règle générale, le paiement s’effectue en numéraire ou par chèque tiré sur une banque française.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00044",
                  "Un versement en travellers chèques ou en eurochèques peut être accepté.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00045",
                  "Quittance dématérialisée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00046",
                  "Le carnet de quittances n’est pas utilisé si l’agent est équipé d’un dispositif permettant l’envoi d’une quittance dématérialisée.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00047",
                  "Si paiement par chèque ou de façon dématérialisée (CB, télépaiement automatisé) : une quittance peut être envoyée à la demande à l’adresse électronique communiquée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                  "f00048",
                  "Si paiement en espèces : le contrevenant doit communiquer son adresse électronique pour l’envoi de la quittance dématérialisée.",
                ),
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
                    "f00049",
                    "Mis à jour le ",
                  ),
                ),
                TextSpan(
                  text: "15/06/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
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
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00050",
              "Délits punis d’une amende de 15 000 € au plus",
            ),
            montant: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00051",
              "1 125 € à 2 250 €",
            ),
          ),
          row(
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00052",
              "Délits punis d’une amende de plus de 15 000 €",
            ),
            montant: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00053",
              "2 250 € à 4 500 €",
            ),
          ),
          row(
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00054",
              "Contravention de 1ʳᵉ classe",
            ),
            montant: "11 €",
          ),
          row(
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00055",
              "Contravention de 2ᵉ classe",
            ),
            montant: "35 €",
          ),
          row(
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00056",
              "Contravention de 3ᵉ classe",
            ),
            montant: "68 €",
          ),
          row(
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00057",
              "Contravention de 4ᵉ classe",
            ),
            montant: "135 €",
          ),
          row(
            nature: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart",
              "f00058",
              "Contravention de 5ᵉ classe",
            ),
            montant: "750 €",
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
