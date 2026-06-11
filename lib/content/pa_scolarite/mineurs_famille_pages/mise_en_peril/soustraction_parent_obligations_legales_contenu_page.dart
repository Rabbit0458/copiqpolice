import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaSoustractionParentObligationsLegalesPage extends StatelessWidget {
  const PaSoustractionParentObligationsLegalesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/soustraction_parent_obligations_legales';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Mise en péril",
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
            "La soustraction d’un parent à ses obligations légales",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait, par le père ou la mère, de se soustraire, sans motif légitime, à ses obligations légales "
                "au point de compromettre la santé, la sécurité, la moralité ou l’éducation de son enfant mineur, "
                "constitue une infraction.",
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
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-17 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime la soustraction d’un parent à ses obligations légales.",
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
            children: const [
              _SubTitle("A) Les personnes visées par l’infraction"),
              _Paragraph(
                "Deux conditions personnelles structurent l’infraction : une victime mineure et un auteur déterminé (le père ou la mère).",
              ),
              SizedBox(height: 10),

              _SubTitle("• Une victime mineure"),
              _Paragraph(
                "La victime doit être un mineur, sans condition d’âge : toute personne âgée de moins de 18 ans est concernée.",
              ),
              SizedBox(height: 10),

              _SubTitle("• L’auteur : le père ou la mère"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le texte vise exclusivement le père et la mère (à l’exclusion des autres ascendants). "
                      "Aucune référence n’est faite à l’exercice de l’autorité parentale ou à la garde : "
                      "c’est le lien de filiation (légitime, naturel ou adoptif) qui conditionne les poursuites. "
                      "Ce que l’on réprime ici est une défaillance parentale.",
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle("B) Une soustraction aux obligations légales"),
              _Paragraph(
                "Le texte incrimine le fait de se soustraire aux obligations découlant de la qualité de père ou mère "
                "et, notamment, aux devoirs liés à l’autorité parentale.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Référence utile",
                bodySpans: [
                  TextSpan(
                    text: "Article 371-1 du Code civil",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : l’autorité parentale appartient aux parents jusqu’à la majorité ou l’émancipation de l’enfant "
                        "pour le protéger dans sa sécurité, sa santé et sa moralité, assurer son éducation et permettre son développement, "
                        "dans le respect dû à sa personne. Elle s’exerce sans violences physiques ou psychologiques.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Il n’est pas nécessaire que le parent ait quitté le domicile familial : ce qui est réprimé est un abandon moral "
                "consistant à se soustraire à ses devoirs, même en étant physiquement présent.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exemples fréquents",
                bodySpans: [
                  TextSpan(
                    text:
                        "Peuvent caractériser l’abandon moral ou matériel : mauvais traitements, inconduite notoire, "
                        "manque de direction nécessaire, défaut de soins.",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("C) Des conséquences éventuelles pour le mineur"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’infraction n’est constituée que si la soustraction est susceptible de ",
                ),
                TextSpan(
                  text:
                      "« compromettre la santé, la sécurité, la moralité ou l’éducation de l’enfant »",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Les juges apprécient au cas par cas. Il n’est pas requis que la compromission soit irréversible : "
                "le texte n’exige pas que le dommage se soit effectivement réalisé ; il suffit qu’il soit susceptible de se réaliser. "
                "En revanche, la carence des parents doit être effective.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(text: "Carence effective exigée — "),
                  TextSpan(
                    text: "Cass. crim., 11 juillet 1994",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  TextSpan(
                    text:
                        "Père poursuivi pour avoir abandonné ses deux enfants (12 et 17 ans) sur une aire d’autoroute et avoir indiqué "
                        "ne pas avoir eu l’intention de revenir les chercher — ",
                  ),
                  TextSpan(
                    text: "C.A. Douai, 17 novembre 2004",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  TextSpan(
                    text:
                        "Père ayant conditionné psychologiquement ses enfants, sans scolarisation ni suivi médical (absence de vaccination), "
                        "les maintenant hors circuit scolaire — ",
                  ),
                  TextSpan(
                    text: "C.A. Paris, 30 juin 2006",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("D) Une absence de motif légitime"),
              _Paragraph(
                "Les faits ne sont punissables que si le parent s’est soustrait sans motif légitime. "
                "C’est au prévenu d’apporter la preuve d’un motif grave ; l’appréciation de la légitimité relève du juge.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Appréciation des juges",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les tribunaux retiennent généralement le motif légitime de manière restrictive :\n"
                        "• Une demande en divorce ne constitue pas, en soi, un motif grave — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 30 mai 1967",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ".\n• L’incarcération peut constituer un motif légitime si le parent n’a pas cessé d’habiter au domicile conjugal avant et après — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 26 mars 1957",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ".\n• Les convictions religieuses n’excusent pas la carence parentale — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 11 juillet 1994",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
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
                "Il s’agit d’une infraction intentionnelle : le parent se soustrait volontairement à ses devoirs parentaux "
                "avec la conscience que cette carence pourrait avoir des conséquences dommageables pour l’enfant.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’intention repose sur la conscience du danger moral encouru par le mineur — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 21 octobre 1998",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-17 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lorsque la soustraction a directement conduit à la commission, par le mineur, d’au moins un crime "
                    "ou de plusieurs délits ayant donné lieu à une condamnation définitive.",
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-17 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lorsque l’auteur s’est rendu coupable, sur le même mineur ou au détriment de ce dernier, "
                    "de délits prévus notamment par les articles 227-3, 227-4, 227-4-3, 227-5 à 227-7, 227-17-1 et 433-18-1 "
                    "(dont la non-déclaration d’une naissance auprès de l’officier d’état civil).",
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
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Forme simple : "),
                TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 227-17 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Forme aggravée : "),
                TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 227-17 alinéas 2 et 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité possible prévue par "),
                TextSpan(
                  text: "l’article 227-17-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : amende selon "),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et peines complémentaires prévues par "),
                TextSpan(
                  text: "l’article 131-39 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (dissolution, placement sous surveillance judiciaire, interdiction d’exercer, etc.).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non prévue)."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide et assistance, provocation ou instructions données).",
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
