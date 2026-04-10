import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NonRespectObligationsInterdictionsOrdonnanceProtectionPage
    extends StatelessWidget {
  const NonRespectObligationsInterdictionsOrdonnanceProtectionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions';

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
          "Violation d’ordonnances JAF",
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
            "Le non-respect des obligations ou interdictions imposées par une ordonnance de protection",
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
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le fait, pour une personne faisant l’objet d’une ou plusieurs obligations ou interdictions imposées dans une ordonnance de protection rendue en application des ",
                ),
                TextSpan(
                  text: "articles 515-9 ou 515-13 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ", ou dans une ordonnance provisoire de protection immédiate rendue en application de ",
                ),
                TextSpan(
                  text: "l’article 515-13-1 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: ", de ne pas s’y conformer, constitue une infraction.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Extension UE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les mêmes peines s’appliquent à la violation d’une mesure de protection civile prononcée dans un autre État membre de l’Union européenne, reconnue et exécutoire en France en application du ",
                  ),
                  TextSpan(
                    text:
                        "règlement (UE) n° 606/2013 du Parlement européen et du Conseil du 12 juin 2013",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " relatif à la reconnaissance mutuelle des mesures de protection en matière civile.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal (en haut)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-4-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime le non-respect des obligations ou interdictions imposées par une ordonnance de protection.",
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
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les mesures de protection des victimes de violences sont développées aux ",
                ),
                TextSpan(
                  text: "articles 515-9 à 515-13 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Elles renforcent les pouvoirs du juge aux affaires familiales afin d’éloigner l’auteur des violences du cadre de vie de la victime, y compris hors mariage.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle(
                "A) Une personne soumise à des obligations / interdictions",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 515-9 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsque des violences au sein du couple (même sans cohabitation) ou commises par un ex-conjoint/ex-partenaire/ex-concubin mettent en danger la victime ou ses enfants, le JAF peut délivrer en urgence une ordonnance de protection.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’ordonnance de protection est délivrée dans un délai maximal de six jours à compter de la fixation de la date d’audience, si le juge estime les violences vraisemblables et le danger établi. Elle n’est pas conditionnée à un dépôt de plainte pénale.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Des mesures précises fixées par le juge"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Pour une durée maximale de 12 mois (prolongeable sous conditions), le juge peut ordonner des mesures conformément à ",
                ),
                TextSpan(
                  text: "l’article 515-12 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", notamment celles prévues par "),
                TextSpan(
                  text: "l’article 515-11 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Interdiction de recevoir/rencontrer certaines personnes désignées, ou d’entrer en relation avec elles, de quelque façon que ce soit.",
              ),
              const _BulletPoint(
                text:
                    "Interdiction de se rendre dans certains lieux désignés où se trouve habituellement la partie demanderesse.",
              ),
              const _BulletPoint(
                text:
                    "Interdiction de détenir ou porter une arme ; remise des armes.",
              ),
              const _BulletPoint(
                text:
                    "Proposition de prise en charge sanitaire/sociale/psychologique ou stage de responsabilisation (information du procureur en cas de refus).",
              ),
              const _BulletPoint(
                text:
                    "Mesures sur la résidence séparée, la jouissance du logement, et la prise en charge des frais afférents.",
              ),
              const _BulletPoint(
                text:
                    "Attribution possible de la jouissance de l’animal de compagnie au sein du foyer.",
              ),
              const _BulletPoint(
                text:
                    "Mesures sur l’autorité parentale, droit de visite/hébergement et contributions (charges du mariage, aide matérielle, entretien/éducation des enfants).",
              ),
              const _BulletPoint(
                text:
                    "Dissimulation du domicile/résidence et élection de domicile (avocat, procureur, personne morale qualifiée) selon les cas.",
              ),
              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque l’interdiction prévue au 1° de l’article 515-11 est prononcée, le juge peut également fixer une interdiction de se rapprocher et ordonner le port d’un dispositif anti-rapprochement, conformément à ",
                ),
                TextSpan(
                  text: "l’article 515-11-1 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) L’existence d’une ordonnance provisoire de protection immédiate",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 515-13-1 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsque le JAF est saisi d’une demande d’ordonnance de protection, le ministère public peut, avec l’accord de la personne en danger, demander une ordonnance provisoire de protection immédiate.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Elle peut être délivrée dans un délai de vingt-quatre heures, au vu des seuls éléments joints à la requête, si des raisons sérieuses rendent vraisemblables les violences et le danger grave et immédiat.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "D) Une violation : le non-respect concret des obligations",
              ),
              const _Paragraph(
                "L’infraction sanctionne le non-respect effectif d’une ou plusieurs obligations/interdictions fixées par le juge. "
                "Le texte vise à rendre l’ordonnance pleinement contraignante et opérationnelle, afin de garantir la protection de la victime.",
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
            children: [
              const _SubTitle("Volonté de ne pas se conformer"),
              const _Paragraph(
                "Il s’agit d’une infraction intentionnelle : l’auteur agit en pleine connaissance de cause des obligations ou interdictions "
                "dont il fait l’objet. Il doit avoir été informé des termes de l’ordonnance de protection délivrée par le juge.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "En pratique : la caractérisation repose sur la preuve que la personne connaissait la décision (notification, audience contradictoire, remise, etc.) et a néanmoins violé une ou plusieurs mesures.",
                  ),
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
              _Paragraph(
                "Aucune circonstance aggravante prévue pour cette infraction.",
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
                const TextSpan(text: "Délit — "),
                TextSpan(
                  text: "article 227-4-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "3 ans d’emprisonnement."),
              const _BulletPoint(text: "45 000 € d’amende."),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Elle suppose un des faits constitutifs de complicité prévus par la loi (aide/assistance, provocation, instructions).",
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
