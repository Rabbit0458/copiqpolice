import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetentionTransportSansMotifLegitimePage extends StatelessWidget {
  const DetentionTransportSansMotifLegitimePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations/detention_transport_sans_motif_legitime';

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
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

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
          "Destructions, dégradations",
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
            "La détention ou le transport de substances ou produits incendiaires ou explosifs sans motif légitime permettant de commettre des destructions, dégradations ou détériorations dangereuses",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Constitue une infraction la détention ou le transport sans motif légitime :\n"
                "1° de substances ou produits explosifs permettant de commettre les infractions définies à l’article 322-6, "
                "lorsque ces substances ou produits ne sont pas soumis, pour la détention ou le transport, à un régime particulier ;\n"
                "2° de substances ou produits incendiaires permettant de commettre les infractions définies à l’article 322-6 "
                "ainsi que d’éléments ou substances destinés à entrer dans la composition de produits ou engins incendiaires ou explosifs, "
                "lorsque leur détention ou leur transport ont été interdits par arrêté préfectoral en raison de l’urgence "
                "ou du risque de trouble à l’ordre public.",
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
                TextSpan(
                  text: "Article 322-11-1 alinéa 3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime la détention ou le transport, sans motif légitime, de substances ou produits incendiaires ou explosifs susceptibles de permettre des destructions, dégradations ou détériorations dangereuses pour les personnes.",
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
              const _SubTitle(
                "A) La possession de substances/produits, sans motif légitime",
              ),
              const _Paragraph(
                "L’auteur est trouvé en possession de substances ou produits soit incendiaires, soit explosifs. "
                "Cette possession peut prendre deux formes : la détention ou le transport.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Détention : avoir à sa disposition ces substances/produits, sans être nécessairement possesseur ou propriétaire (domicile, parties communes, chez autrui…).",
              ),
              const _BulletPoint(
                text:
                    "Transport : déplacer ces substances/produits ; être trouvé porteur sur la voie publique peut caractériser à la fois détention et transport.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) L’absence de motif légitime"),
              const _Paragraph(
                "La notion de « motif légitime » s’apprécie au cas par cas. "
                "Elle permet de poursuivre une personne qui, notamment dans un contexte de violences urbaines "
                "ou de manifestations violentes, transporte sans raison un bidon d’essence.\n"
                "À l’inverse, une personne qui en transporte de bonne foi pour remplir une tondeuse à gazon ne saurait être inquiétée.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Nature des substances : 2 régimes"),
              _NotaBox(
                title: "À retenir",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Une distinction existe selon la nature des substances détenues ou transportées :\n"
                        "• explosifs artisanaux non soumis à un régime particulier (1°)\n"
                        "• produits/substances incendiaires + éléments de composition interdits par arrêté préfectoral (2°).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "D) 1° — Substances ou produits explosifs non soumis à un régime particulier",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Sont visées des substances ou produits explosifs de fabrication artisanale. "
                      "Bien qu’ils ne soient pas des explosifs conventionnels, leur dangerosité est extrême : "
                      "la détention ou le transport ",
                ),
                const TextSpan(
                  text: "sans motif légitime",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " suffit à constituer l’infraction.\nExemple : transport d’un mélange explosif contenant du nitrate d’ammonium (engrais) avec de l’essence.",
                ),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "E) 2° — Produits incendiaires + éléments de composition malgré un arrêté préfectoral",
              ),
              const _Paragraph(
                "Ici, il s’agit de substances plus « banales » qui ne sont pas interdites en temps normal. "
                "Pour caractériser l’infraction, deux conditions doivent être réunies :",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Absence de motif légitime (condition nécessaire mais insuffisante à elle seule).",
              ),
              const _BulletPoint(
                text:
                    "Violation d’un arrêté préfectoral interdisant la détention/le transport (urgence ou risque de trouble à l’ordre public).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’arrêté préfectoral est une mesure temporaire liée aux circonstances de temps et de lieu "
                "(ex. interdiction de transporter des bidons d’essence dans un contexte de violences urbaines).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "F) Absence d’utilisation des produits (avant le passage à l’acte)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si ces substances étaient utilisées, elles pourraient entraîner des destructions dangereuses "
                      "au sens de ",
                ),
                TextSpan(
                  text: "l’article 322-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". L’incrimination ici réprime la détention/le transport avant toute utilisation. "
                      "Si l’auteur utilise ou tente d’utiliser ces substances, il sera poursuivi sur le fondement de 322-6, et non de 322-11-1.",
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
            children: [
              const _SubTitle("1° — Produits explosifs (article 322-11-1, 1°)"),
              const _Paragraph(
                "Il faut la conscience de détenir ou de transporter des substances ou produits explosifs "
                "sans motif légitime.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "2° — Produits incendiaires (article 322-11-1, 2°)",
              ),
              const _Paragraph(
                "Il faut ne disposer d’aucun motif légitime et ne pas respecter l’arrêté préfectoral "
                "interdisant la détention/le transport.",
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
                "Aucune circonstance aggravante prévue pour cette incrimination.",
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
              const _Paragraph(
                "Délit : 3 ans d’emprisonnement et 45 000 € d’amende.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Fondements : "),
                TextSpan(
                  text: "article 322-11-1, 1° et 2° du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 322-17 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI (droit commun). "),
                TextSpan(
                  text: "Article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : suppose un fait de complicité (aide/assistance, provocation ou instructions) et l’intention de s’associer à l’action de l’auteur principal.",
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
