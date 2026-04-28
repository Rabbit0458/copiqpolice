import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PortOuUsageArmePage extends StatelessWidget {
  const PortOuUsageArmePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme';

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

    const Color lawRed = Color(0xFFD32F2F);

    TextSpan law(String txt) => TextSpan(
      text: txt,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Le port ou l’usage d'une arme",
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
                // Bandeau définition légale (sans répéter le titre)
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
                  child: const _Paragraph(
                    "« Est une arme tout objet conçu pour tuer ou blesser.\n"
                    "Tout autre objet susceptible de présenter un danger pour les personnes est assimilé à une arme dès lors qu'il est utilisé pour tuer, blesser ou menacer ou qu'il est destiné, par celui qui en est porteur, à tuer, blesser ou menacer.\n"
                    "Est assimilé à une arme tout objet qui, présentant avec l'arme définie au premier alinéa une ressemblance de nature à créer une confusion, est utilisé pour menacer de tuer ou de blesser ou est destiné, par celui qui en est porteur, à menacer de tuer ou de blesser.\n"
                    "L'utilisation d'un animal pour tuer, blesser ou menacer est assimilée à l'usage d'une arme. En cas de condamnation du propriétaire de l'animal ou si le propriétaire est inconnu, le tribunal peut décider de remettre l'animal à une œuvre de protection animale ou reconnue d'utilité publique ou déclarée, laquelle pourra librement en disposer. »",
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
                      law("L’article 132-75 du C.P."),
                      const TextSpan(
                        text:
                            " définit ce qu’est une arme. Le port ou l’usage d’une arme constitue une circonstance aggravante réelle. "
                            "Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "L’arme peut également être constitutive d’un des éléments matériels d’infractions autonomes, tel que le port illégal d’arme.",
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
                  children: [
                    const _SubTitle("2.1 - Une arme"),
                    _Paragraph.rich([
                      const TextSpan(text: "Le premier alinéa de "),
                      law("l’article 132-75 du C.P."),
                      const TextSpan(
                        text:
                            " concerne les armes par nature tandis que les trois autres concernent des cas assimilés : "
                            "armes par destination, armes factices et animal.",
                      ),
                    ]),
                    const SizedBox(height: 10),

                    const _SubTitle("2.1.1 - Des armes par nature"),
                    const _Paragraph(
                      "L’alinéa 1 précise qu’« est une arme tout objet conçu pour tuer ou blesser ». "
                      "L’arme proprement dite est un objet qui n’a pas d’autre utilité que de donner la mort ou d’occasionner des blessures.",
                    ),
                    const SizedBox(height: 8),

                    const _Paragraph("Il s’agit notamment :"),
                    const SizedBox(height: 6),
                    const _IntroBullet(
                      text:
                          "Des armes à feu (guerre, défense, chasse, collection), des engins explosifs ou incendiaires et des gaz toxiques.",
                    ),
                    const _IntroBullet(
                      text:
                          "Exemples : fusils de chasse, fusils à canon scié, fusils à pompe, grenades, bombes, cocktails Molotov, bombes aérosol au gaz lacrymogène, etc.",
                    ),
                    const SizedBox(height: 6),
                    const _IntroBullet(
                      text:
                          "Des armes blanches (tranchantes, perçantes ou contondantes).",
                    ),
                    const _IntroBullet(
                      text:
                          "Exemples : baïonnettes, poignards, matraques, cannes à épée, arbalètes, coups-de-poing américains, lances-pierres de compétition, couteaux à cran d’arrêt, nerfs de bœuf, etc.",
                    ),
                    const SizedBox(height: 8),
                    _NotaBox(
                      bodySpans: [
                        const TextSpan(
                          text:
                              "Peut aussi constituer une arme un objet transformé pour en faire une : ",
                        ),
                        const TextSpan(
                          text:
                              "« un couteau dont les deux côtés de la lame avaient été rendus tranchants par meulage » (Cass. crim., n° 68-91.697 du 29 janvier 1969).",
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const _SubTitle("2.1.2 - Des cas assimilés"),
                    _Paragraph.rich([
                      const TextSpan(text: "Les alinéas 2 à 4 de "),
                      law("l’article 132-75 du C.P."),
                      const TextSpan(
                        text: " assimilent trois autres cas à l’arme :",
                      ),
                    ]),
                    const SizedBox(height: 8),

                    const _SubTitle("2.1.2.1 - Les armes par destination"),
                    const _Paragraph(
                      "Ce sont des objets susceptibles de présenter un danger pour les personnes. Il s’agit d’instruments, outils, appareils, engins de la vie courante. "
                      "Bien qu’ils ne soient pas conçus pour servir d’arme, ils peuvent être utilisés pour tuer, blesser ou menacer.",
                    ),
                    const SizedBox(height: 6),
                    const _BulletPoint(
                      text:
                          "Exemples : couteau de cuisine, marteau, véhicule automobile, batte de baseball, chaîne à vélo, barre de fer, bouteille, seringue, tabouret de bar, etc.",
                    ),

                    const SizedBox(height: 10),

                    const _SubTitle("2.1.2.2 - Les armes factices ou simulées"),
                    const _Paragraph(
                      "L’objet utilisé pour tromper une personne doit présenter une ressemblance suffisante avec l’arme qu’il imite. "
                      "Son utilisation pour menacer de tuer ou de blesser traduit la volonté de faire croire que l’arme simulée est réelle.",
                    ),
                    const SizedBox(height: 6),
                    const _Paragraph(
                      "« Une arme factice peut être considérée comme une arme apparente ou cachée » (Cass. crim., n° 92-82.717 du 5 août 1992).",
                    ),

                    const SizedBox(height: 10),

                    const _SubTitle("2.1.2.3 - Les animaux"),
                    const _Paragraph(
                      "L’utilisation d’un animal pour tuer, blesser ou menacer est assimilée à l’usage d’une arme. "
                      "Cet alinéa vise notamment l’utilisation de chiens comme arme.",
                    ),

                    const SizedBox(height: 12),

                    const _SubTitle("2.2 - Son utilisation"),
                    const _Paragraph(
                      "L’arme peut constituer une circonstance aggravante lorsqu’elle a été utilisée ou portée.",
                    ),
                    const SizedBox(height: 6),

                    const _SubTitle("2.2.1 - L’usage et la menace d’une arme"),
                    const _Paragraph(
                      "Il ne suffit pas que l’auteur ait été porteur d’une arme : il faut qu’il l’ait utilisée pour tuer, blesser ou menacer.",
                    ),
                    const SizedBox(height: 8),

                    const _SubTitle("2.2.2 - Le port d’une arme"),
                    const _Paragraph(
                      "Dans ce cas, il suffit que l’auteur ait été porteur d’une arme apparente ou cachée au moment des faits.",
                    ),

                    const SizedBox(height: 12),

                    const _SubTitle("2.3 - Le but poursuivi"),
                    const _Paragraph(
                      "L’arme peut, lorsque l’individu en a fait usage ou en a seulement été porteur, constituer une circonstance aggravante d’une infraction commise ou tentée pour laquelle la loi l’a prévu.",
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
                    const _Paragraph(
                      "Le code pénal prévoit que la circonstance d’usage ou menace d’une arme est susceptible d’aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(
                          text: "Les tortures ou actes de barbarie (",
                        ),
                        TextSpan(
                          text: "article 222-3 10° C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "Le viol ("),
                        TextSpan(
                          text: "article 222-24 7° C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "Les agressions sexuelles ("),
                        TextSpan(
                          text: "article 222-28 5° C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(
                          text:
                              "Les agressions sexuelles sur mineur de 15 ans ou sur personne particulièrement vulnérable (",
                        ),
                        TextSpan(
                          text: "article 222-30 al. 6 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "Les violences ("),
                        TextSpan(
                          text:
                              "articles 222-8, 222-10, 222-12, 222-13 10° et 222-14-5 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "L’évasion ("),
                        TextSpan(
                          text: "article 434-30 al. 1 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "Le concours à une évasion ("),
                        TextSpan(
                          text: "article 434-32 al. 3 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const _Paragraph(
                      "Le code pénal prévoit que la circonstance de port d’arme est susceptible d’aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "Le proxénétisme ("),
                        TextSpan(
                          text: "article 225-7 al. 8 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(
                          text: "La participation à un attroupement (",
                        ),
                        TextSpan(
                          text: "article 431-5 al. 1 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(
                          text:
                              "La participation à une manifestation ou à une réunion publique (",
                        ),
                        TextSpan(
                          text: "article 431-10 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "La rébellion ("),
                        TextSpan(
                          text: "article 433-8 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const _Paragraph(
                      "Le code pénal prévoit enfin que la circonstance d’usage, menace ou port d’une arme est susceptible d’aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "Le vol ("),
                        TextSpan(
                          text: "article 311-8 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(text: "L’extorsion ("),
                        TextSpan(
                          text: "article 312-5 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        const TextSpan(
                          text: "L’extorsion en bande organisée (",
                        ),
                        TextSpan(
                          text: "article 312-6 al. 3 C.P.",
                          style: const TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ")."),
                      ],
                    ),

                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        const TextSpan(
                          text:
                              "Retenir la circonstance aggravante suppose de distinguer :\n"
                              "• l’arme par nature ;\n"
                              "• les cas assimilés (destination, factice/simulée, animal) ;\n"
                              "• et le critère « usage/menace » versus « port » selon l’infraction visée.",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ligne “bullet” compatible avec ton rendu, mais en RichText pour pouvoir mettre les articles en rouge.
class _LawBulletRow extends StatelessWidget {
  const _LawBulletRow({required this.textSpans});

  final List<TextSpan> textSpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: textColor,
                ),
                children: textSpans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ IMPORTANT : tes widgets personnalisés (_ConditionCard, _SubTitle, _Paragraph, _IntroBullet,
// _BulletPoint, _NotaBox) sont déjà fournis : colle-les sous ce commentaire EXACTEMENT tels quels.

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
