import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PermisAPointsPage extends StatelessWidget {
  const PermisAPointsPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/permis_a_points';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
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
          "Permis à points",
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
            "Le permis à points",
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
                "Le permis de conduire est affecté d’un capital de points qui diminue automatiquement "
                "en cas d’infractions entraînant retrait de points. En cas de perte totale, le permis est "
                "invalidé pour solde nul et le droit de conduire disparaît à compter de la notification.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ I — Élément légal (en haut)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles L.223-1 à L.223-9 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "articles R.223-1 à R.223-4 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : fixent le capital initial, les retraits, les règles de cumul, la reconstitution, l’invalidation et les infractions liées au système.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Retrait de points uniquement pour des infractions commises avec un véhicule nécessitant un permis. ",
                  ),
                  TextSpan(
                    text: "(L.223-1 C.R.)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Élément matériel (les “3 éléments” pédagogiques du système)
          _ConditionCard(
            title: "II — Fonctionnement (3 points clés)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Capital initial & période probatoire"),
              const _BulletPoint(
                text:
                    "À l’obtention du premier droit de conduire (sauf catégorie AM), le permis est affecté de 6 points.",
              ),
              const _BulletPoint(
                text:
                    "Pendant le délai probatoire, l’accès aux 12 points est progressif si aucune infraction avec retrait n’est commise.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "articles L.223-1 et suivants du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("B) Retrait de points (conditions & plafonds)"),
              const _BulletPoint(
                text: "Délits : retrait forfaitaire de 6 points.",
              ),
              const _BulletPoint(
                text:
                    "Contraventions : retrait de 1, 2, 3, 4 ou 6 points selon l’infraction.",
              ),
              const _BulletPoint(
                text:
                    "Infractions simultanées : cumul plafonné à 8 points maximum.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Règle de cumul : "),
                TextSpan(
                  text: "article L.223-2 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("C) Quand le retrait devient effectif"),
              const _Paragraph(
                "Le retrait de points intervient lorsque la réalité de l’infraction est devenue définitive, notamment : "
                "paiement de l’amende forfaitaire, exécution d’une composition pénale, émission du titre exécutoire de l’AFM, "
                "ou décision judiciaire définitive (voies de recours épuisées).",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article L.223-1 du Code de la route",
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

          // III — Élément moral (adapté au contexte : obligations d’info + automatisation)
          _ConditionCard(
            title: "III — Élément moral / garanties",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Obligation d’information du contrevenant"),
              const _Paragraph(
                "Le policier doit informer le contrevenant que l’infraction est susceptible d’entraîner un retrait de points, "
                "sans être tenu de préciser le nombre de points retirés.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article L.223-3 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("B) Traitement automatisé & droit d’accès"),
              const _Paragraph(
                "Les retraits et reconstitutions sont gérés par traitement automatisé (SNPC). "
                "Le titulaire peut exercer un droit d’accès auprès du service préfectoral compétent.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article L.225-3 du Code de la route",
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

          // IV — Reconstitution (pédagogique + délais)
          _ConditionCard(
            title: "IV — Reconstitution du nombre de points",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L.223-6 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit les modalités de reconstitution automatique et le stage.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("A) Reconstitution automatique (principe)"),
              const _BulletPoint(
                text:
                    "12 points récupérés après un délai sans nouvelle infraction avec retrait (délai variable selon la nature de l’infraction).",
              ),
              const _BulletPoint(
                text:
                    "Pour une infraction ayant entraîné le retrait d’un seul point : ce point est réattribué au terme d’un délai de 6 mois.",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "B) Stage de sensibilisation à la sécurité routière",
              ),
              const _BulletPoint(
                text:
                    "Permet de récupérer 4 points, dans la limite du plafond du permis.",
              ),
              const _BulletPoint(
                text: "Stage volontaire : possible une fois par an.",
              ),
              const _BulletPoint(
                text:
                    "Stage obligatoire : en période probatoire après une infraction ayant entraîné un retrait d’au moins 3 points (selon le cas prévu par le code).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V — Circonstances aggravantes / infractions connexes (trafic + solde nul)
          _ConditionCard(
            title: "V — Infractions connexes & aggravations",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Solde nul : invalidation & injonction de restitution",
              ),
              const _Paragraph(
                "En cas de perte totale des points, l’invalidation du permis pour solde nul et l’injonction de le restituer "
                "sont notifiées par courrier recommandé. À compter de la notification, l’intéressé perd le droit de conduire.",
              ),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les délits liés à la conduite malgré injonction et au refus de restituer sont notamment visés par : ",
                  ),
                  TextSpan(
                    text: "article L.223-5 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " (voir natinf 22873 / 11049)."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) « Trafic de points »"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L.223-9 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réprime la vente/achat de points et les manœuvres visant à faire désigner une tierce personne comme auteur d’une contravention.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Lien procédure (désignation / réclamation) : ",
                ),
                TextSpan(
                  text: "article 529-10 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Aggravation : lorsque commis de façon habituelle ou par diffusion d’un message au public proposant ce service contre rémunération.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "La désignation d’un conducteur dans un cadre familial/amical, sans contrepartie, n’est pas réprimée.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Tentative & complicité (adapté : trafic de points)
          _ConditionCard(
            title: "VI — Tentative & complicité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Trafic de points (L.223-9 C.R.)"),
              const _BulletPoint(
                text:
                    "Tentative : en pratique, le texte vise déjà la « proposition » et l’« acceptation » contre rémunération (comportements préparatoires déjà incriminés).",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: "Complicité : OUI, selon les règles générales des ",
                ),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
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
