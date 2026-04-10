import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BandeOrganiseePage extends StatelessWidget {
  const BandeOrganiseePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/bande_organisee';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgTop = isDark
        ? const Color(0xFF0B1220)
        : const Color(0xFFEAF2FF);
    final Color bgBottom = isDark ? const Color(0xFF070B12) : Colors.white;

    final Color cardBlue = isDark
        ? const Color(0xFF0F1B2E)
        : const Color(0xFFF3F7FF);
    final Color cardAmber = isDark
        ? const Color(0xFF1B1610)
        : const Color(0xFFFFF7E6);
    final Color cardTeal = isDark
        ? const Color(0xFF0F1E1B)
        : const Color(0xFFF0FFFB);

    final Color accentBlue = const Color(0xFF1565C0);
    final Color accentAmber = const Color(0xFFF9A825);
    final Color accentTeal = const Color(0xFF00897B);

    final Color titleColor = isDark ? Colors.white : const Color(0xFF0B1B3A);

    const lawRed = Color(0xFFD32F2F);

    TextSpan law(String text) => TextSpan(
      text: text,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'La bande organisée',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bandeau définition (comme sur la capture)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      .06,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withOpacity(
                        .08,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LA BANDE ORGANISÉE',
                        style: GoogleFonts.fustat(
                          fontSize: 14.5,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Paragraph.rich(const [
                        TextSpan(
                          text:
                              "« Constitue une bande organisée au sens de la loi tout groupement formé ou toute entente "
                              "établie en vue de la préparation, caractérisée par un ou plusieurs faits matériels, d’une ou plusieurs infractions. »",
                        ),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: '1 : DÉFINITION',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law("L’article 132-71 du du Code Pénal."),
                      const TextSpan(
                        text:
                            " définit la bande organisée. Il s’agit d’une circonstance aggravante réelle. "
                            "Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "La notion de bande organisée est proche de celle d’association de malfaiteurs définie par ",
                      ),
                      law("l’article 450-1 du code pénal"),
                      const TextSpan(
                        text:
                            ". Elle diffère de l’association de malfaiteurs qui est une infraction autonome, caractérisée "
                            "alors même que les opérations projetées sont restées au stade des actes préparatoires. "
                            "La question de la bande organisée quant à elle se pose après commission ou tentative de commission de certaines infractions.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Il s’agit d’une forme particulière de préméditation.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: '2 : CONDITIONS',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "« La bande organisée, suppose à la différence de la réunion, que les auteurs, coauteurs de l’infraction ont préparé, "
                            "par des moyens matériels qui sous-entendent l’existence d’une certaine organisation, la commission du crime ou du délit. » "
                            "(Cass. crim., 14 mai 1993)\n\n"
                            "La réunion présente un caractère fortuit et occasionnel qui suppose une concertation simple sans préméditation.",
                      ),
                    ]),
                    SizedBox(height: 10),
                    _SubTitle(
                      "2.1 - Une résolution d’agir en commun antérieure à l’action",
                    ),
                    _Paragraph(
                      "Il faut, pour que cette condition soit réalisée, que plusieurs personnes se soient réunies et aient arrêté la résolution d’agir en commun.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "La bande organisée implique donc la préméditation : « Elle suppose un plan concerté » "
                            "(Cass. crim., 30 novembre 2005).\n\n"
                            "Doit être établie l’existence de contacts préliminaires, voire d’une convention passée avant l’action.\n\n"
                            "Ainsi, dans le cadre d’un trafic de stupéfiants, la Cour de cassation a relevé que l’existence d’une bande organisée est établie : "
                            "par les contacts préliminaires pris par « B » avec les convoyeurs de drogue, les entretiens avec les protagonistes de ces transports "
                            "et sa participation à l’organisation des voyages (Cass. crim., 1er octobre 1998).",
                      ),
                    ]),
                    SizedBox(height: 10),
                    _SubTitle("2.2 - La nécessité d’une organisation"),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "La bande organisée suppose une certaine organisation comportant une direction, une hiérarchisation et une distribution des rôles "
                            "entre les participants : « Organisation structurée et hiérarchisée » (Cass. crim., 11 janvier 2017 ; 4 novembre 2004).\n\n"
                            "La bande organisée est une circonstance aggravante réelle qui ne nécessite pas de démontrer la participation continuelle à l’organisation "
                            "de l’opération (Cass. crim., 15 septembre 2004).\n\n"
                            "La jurisprudence ne se prononce pas sur le nombre de personnes nécessaire pour constituer une bande organisée. La notion de pluralité résulte "
                            "des termes « bande », « groupement » ou « entente ».",
                      ),
                    ]),
                  ],
                ),

                const SizedBox(height: 14),

                // Bloc complément (convention ONU + jurisprudence) + 2.3
                _ConditionCard(
                  title: '2 : CONDITIONS (suite)',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    const _Paragraph(
                      "Pour constituer une bande organisée, il est nécessaire d’être plus de deux. "
                      "La Convention des Nations Unies contre la criminalité transnationale organisée la définit dans les termes suivants : "
                      "« groupe structuré de trois personnes ou plus existant depuis un certain temps et agissant de concert dans le but de commettre "
                      "une ou plusieurs infractions graves ou des infractions établies conformément à la présente Convention, pour en tirer directement ou indirectement "
                      "un avantage financier ou un autre avantage matériel ».",
                    ),
                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: const [
                        TextSpan(
                          text:
                              "Jurisprudence : la seule constitution d’une équipe de plusieurs malfaiteurs ne peut suffire à qualifier la bande organisée, "
                              "dès lors que cette équipe ne répond pas au critère supplémentaire de structure existant depuis un certain temps "
                              "(Cass. crim., 8 juillet 2015).",
                        ),
                      ],
                      title: "JURISPRUDENCE",
                    ),
                    const SizedBox(height: 12),
                    const _SubTitle("2.3 - Le but poursuivi"),
                    const _Paragraph(
                      "Les actes préparatoires peuvent être caractérisés par la conception d’un plan d’exécution de l’infraction, "
                      "par l’acquisition de matériel, par le recrutement de personnel, etc.\n\n"
                      "Cette préparation peut ne viser qu’une seule infraction qu’elle ait été commise ou tentée.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application
                _ConditionCard(
                  title: '3 : CHAMP D’APPLICATION',
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    const _IntroBullet(
                      text:
                          "Le code pénal prévoit que la circonstance de commission en bande organisée est susceptible d’aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      const TextSpan(text: "• Le meurtre ("),
                      law("article 221-4 8° du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’empoisonnement ("),
                      law("article 221-5 al. 3 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• Les tortures ou actes de barbarie (",
                      ),
                      law("article 222-4 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le trafic de stupéfiants ("),
                      law(
                        "articles 222-35 al. 2 et 222-36 al. 2 du Code Pénal.",
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le trafic d’armes ("),
                      law("article 222-57 al. 2 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• L’enlèvement et la séquestration (",
                      ),
                      law("article 224-5-2 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• La traite des êtres humains ("),
                      law("article 225-4-3 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le proxénétisme ("),
                      law("article 225-8 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• L’exploitation de la mendicité (",
                      ),
                      law("article 225-12-7 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• L’exploitation de la vente à la sauvette (",
                      ),
                      law("article 225-12-10 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• Inciter un mineur à commettre un acte sexuel par voie électronique (",
                      ),
                      law("article 227-22-2 al. 2 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• Favoriser la corruption de mineur (",
                      ),
                      law("article 227-22 al. 3 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• La représentation pornographique de mineurs (",
                      ),
                      law("article 227-23 al. 5 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• Solliciter auprès d’un mineur la diffusion ou la transmission d’images pornographiques de mineurs (",
                      ),
                      law("article 227-23-1 al. 2 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le vol ("),
                      law("article 311-9 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’extorsion ("),
                      law("article 312-6 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’escroquerie ("),
                      law("article 313-2 al. 7 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’abus de confiance ("),
                      law("article 314-1-1 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le recel ("),
                      law("article 321-2 2° du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• Les destructions, dégradations ou détériorations dangereuses pour les personnes (",
                      ),
                      law("article 322-8 1° du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le blanchiment ("),
                      law("article 324-2 2° du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’évasion ("),
                      law("article 434-30 al. 2 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• Le transport ou la mise en circulation de fausse monnaie (",
                      ),
                      law("article 442-2 al. 2 du Code Pénal."),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),

                    const _Paragraph(
                      "Cette liste, non exhaustive, pourrait utilement être complétée par certaines infractions prévues par des lois particulières telles que :",
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      const TextSpan(
                        text: "• L’entrée et le séjour des étrangers (",
                      ),
                      law("CESEDA"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Les armes et munitions ("),
                      law("Code de la défense"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Les contrefaçons ("),
                      law("Code de la propriété intellectuelle"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• Le non-respect des dispositions réglementaires relatives à la production, fabrication, transport, importation, exportation, détention, offre, cession, acquisition et emploi de plantes, de substances ou de préparations classées comme vénéneuses (",
                      ),
                      law("article L. 5432-1 Code de la santé publique"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• La contrefaçon, la falsification, l’usage, l’acceptation d’un chèque contrefaisant ou falsifié ou d’un autre instrument de paiement ainsi que la tentative de ces délits (",
                      ),
                      law("article L. 163-4-2 Code monétaire et financier"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• Atteintes à la législation sur les déchets (",
                      ),
                      law("article L. 541-46 Code de l’environnement"),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: const [
                        TextSpan(
                          text:
                              "Tous les renvois d’articles et de codes (du Code Pénal., CESEDA, Code de la santé publique, Code monétaire et financier, Code de l’environnement…) "
                              "doivent être affichés en rouge pour ressortir immédiatement à la lecture.",
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ IMPORTANT : Tes widgets personnalisés (_ConditionCard, _SubTitle, _Paragraph, etc.)
// sont déjà fournis : colle-les ici EXACTEMENT tels quels, sans modification.

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
