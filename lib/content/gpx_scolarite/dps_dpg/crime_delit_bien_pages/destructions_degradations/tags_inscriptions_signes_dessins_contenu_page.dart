import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagsInscriptionsSignesDessinsPage extends StatelessWidget {
  const TagsInscriptionsSignesDessinsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations/tags_inscriptions_signes_dessins';

  static const Color _lawRed = Color(0xFFE53935);

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
          "Destructions / Dégradations",
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
            "Destructions, dégradations et détériorations par inscriptions, signes et dessins\ncommunément appelés « tags »",
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
                "Le fait de tracer des inscriptions, des signes ou des dessins, sans autorisation préalable, "
                "sur les façades, les véhicules, les voies publiques ou le mobilier urbain, lorsqu’il n’en est "
                "résulté qu’un dommage léger, constitue une infraction.",
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
                  text: "Article 322-1 II du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime les « tags » (inscriptions, signes et dessins).",
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
                "Ce texte permet de réprimer les auteurs de graffiti (« tags »). Le dommage doit être léger : "
                "l’inscription doit pouvoir être enlevée facilement, sans altération du support.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si les faits occasionnent des dommages importants (ex. signes indélébiles ou altération du support), "
                        "ils relèvent des dispositions de ",
                  ),
                  TextSpan(
                    text: "l’article 322-1 I du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("A) Une atteinte matérielle par traçage"),
              const _Paragraph(
                "Il s’agit d’un acte positif de traçage. Le terme « tracer » n’ayant pas de sens technique particulier, "
                "tout procédé peut être retenu : écriture, peinture, gravure…\n"
                "Le procédé employé ne doit toutefois pas être de nature à entraîner un dommage important.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Inscriptions"),
              const _BulletPoint(text: "Signes"),
              const _BulletPoint(text: "Dessins"),

              const SizedBox(height: 12),

              const _SubTitle("B) Sur un bien appartenant à autrui"),
              const _Paragraph(
                "Les biens protégés sont clairement énoncés et aucune autorisation préalable ne doit avoir été donnée à l’auteur.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Façades"),
              const _BulletPoint(text: "Véhicules"),
              const _BulletPoint(text: "Voies publiques"),
              const _BulletPoint(text: "Mobilier urbain"),
              const SizedBox(height: 10),
              const _Paragraph(
                "La loi ne distingue pas selon le caractère public ou privé des façades. Il en va de même pour les véhicules.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("C) Entraînant un dommage léger"),
              const _Paragraph(
                "Le dommage doit être léger (ex. inscription effaçable sans abîmer le crépi). "
                "Si l’inscription altère le support, le comportement relève alors du régime du dommage important.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Dans ce cas, application de "),
                TextSpan(
                  text: "l’article 322-1 I du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
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
              const _Paragraph(
                "Il s’agit du même élément moral que pour l’article 322-1 I : l’intention simple suffit. "
                "L’auteur est punissable dès lors qu’il a agi sciemment et volontairement.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il doit avoir agi en sachant ne pas être propriétaire du bien et n’avoir aucun droit de disposition. "
                "Aucun dol spécial n’est exigé : le mobile importe peu (vengeance, vandalisme, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Référence jurisprudentielle : "),
                  TextSpan(
                    text: "Cass. crim., 18 septembre 1991",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
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
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsque le bien détruit, dégradé ou détérioré est un registre, une minute ou un acte original de l’autorité publique.",
                ),
              ]),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : notamment lorsque :"),
              ]),
              const SizedBox(height: 8),

              const _BulletPoint(
                text:
                    "L’infraction est commise par plusieurs personnes agissant en qualité d’auteur ou de complice.",
              ),
              const _BulletPoint(
                text:
                    "Elle est facilitée par la particulière vulnérabilité d’une personne (âge, maladie, infirmité, déficience physique/psychique, grossesse), apparente ou connue.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise au préjudice de personnes dépositaires de l’autorité publique ou chargées d’une mission de service public, pour influencer leur comportement.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise au préjudice du conjoint/ascendant/descendant (ou personne vivant habituellement au domicile) des personnes visées ci-dessus, en raison de leurs fonctions.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise au préjudice d’un témoin, d’une victime ou d’une partie civile, pour empêcher/faire cesser une dénonciation, plainte ou déposition, ou en raison de celles-ci.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise dans un local d’habitation ou un lieu d’entrepôt de fonds/valeurs/marchandises/matériels, avec ruse, effraction ou escalade.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise à l’encontre d’un lieu classifié au titre du secret de la défense nationale.",
              ),
              const _BulletPoint(
                text:
                    "L’auteur dissimule volontairement tout ou partie de son visage afin de ne pas être identifié.",
              ),
              const _BulletPoint(
                text:
                    "Le bien est destiné à l’utilité ou à la décoration publique et appartient à une personne publique ou chargée d’une mission de service public.",
              ),
              const _BulletPoint(
                text:
                    "Elle porte sur du matériel destiné à prodiguer des soins de premiers secours.",
              ),
              const _BulletPoint(
                text:
                    "Le bien détruit, dégradé ou détérioré est destiné à la vaccination.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + attention flagrance/GAV
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(text: "3 750 € d’amende + T.I.G. — "),
                TextSpan(
                  text: "article 322-1 II du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée : "),
                const TextSpan(text: "7 500 € d’amende + T.I.G. — "),
                TextSpan(
                  text: "article 322-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (hypothèses prévues par l’article 322-3) : ",
                ),
                const TextSpan(text: "15 000 € d’amende + T.I.G. — "),
                TextSpan(
                  text: "article 322-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les personnes morales encourent les peines prévues par ",
                ),
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

              const _SubTitle("Amende forfaitaire délictuelle"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-1 II du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : permet de recourir à la procédure d’amende forfaitaire prévue par ",
                ),
                TextSpan(
                  text:
                      "les articles 495-17 à 495-25 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", y compris en cas de récidive."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 322-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (prévoit la tentative punissable pour ces délits).",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Complicité : OUI. Elle est punissable pour l’infraction consommée comme pour l’infraction tentée, "
                "si un fait de complicité et l’intention de s’associer à l’auteur principal sont caractérisés.",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: "ATTENTION",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ce délit n’étant pas sanctionné d’une peine d’emprisonnement, il interdit la mise en œuvre du cadre juridique de flagrance "
                        "et d’une mesure de garde à vue.",
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
