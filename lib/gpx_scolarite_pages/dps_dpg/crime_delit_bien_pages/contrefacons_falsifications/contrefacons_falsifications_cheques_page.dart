import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContrefaconsFalsificationsChequesPage extends StatelessWidget {
  const ContrefaconsFalsificationsChequesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications';

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

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Contrefaçons & falsifications",
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
            "Contrefaçons et falsifications de chèques ou autres instruments de paiement",
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
              _Paragraph("Constitue une infraction le fait de :"),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    "Contrefaire ou falsifier un chèque ou un autre instrument mentionné à l’article L. 133-4 du code monétaire et financier.",
              ),
              _IntroBullet(
                text:
                    "Faire ou tenter de faire usage, en connaissance de cause, d’un chèque ou d’un autre instrument mentionné à l’article L. 133-4 contrefait ou falsifié.",
              ),
              _IntroBullet(
                text:
                    "Accepter, en connaissance de cause, de recevoir un chèque ou un autre instrument mentionné à l’article L. 133-4 contrefait ou falsifié.",
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
                  text: "Article L. 163-3 du Code monétaire et financier",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : incrimine les actes délictueux concernant les chèques et les autres instruments de paiement "
                      "mentionnés à l’article L. 133-4 (dont les cartes de paiement ou de retrait).",
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
                "Le texte fait apparaître trois comportements répréhensibles distincts, "
                "relatifs à l’usage de moyens de paiement expressément énumérés (chèques et instruments visés par l’article L. 133-4 du C.M.F.).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Un moyen de paiement visé par la loi"),
              _NotaBox(
                title: "Définition",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un instrument de paiement s’entend de tout dispositif personnalisé et/ou de l’ensemble de procédures convenu "
                        "entre l’utilisateur et le prestataire de services de paiement, utilisé pour donner un ordre de paiement "
                        "(virements, prélèvements, cartes de paiement et de retrait).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un comportement répréhensible"),
              const _Paragraph(
                "L’article L. 163-3 du C.M.F. vise trois comportements distincts :",
              ),
              const SizedBox(height: 8),

              const _SubTitle("1) La contrefaçon ou la falsification"),
              const _Paragraph(
                "• La contrefaçon consiste soit en l’imitation de modèles existants et véritables, soit en la création de modèles totalement imaginaires. "
                "Le document contrefaisant doit correspondre à la définition légale du document d’origine.\n\n"
                "• La falsification consiste en l’altération d’un document réel et véritable : ajouts, surcharges, grattages, ratures, suppressions, intercalations…",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "2) L’usage d’un moyen de paiement contrefait ou falsifié",
              ),
              const _Paragraph(
                "Il s’agit d’actes distincts de la contrefaçon/falsification. L’auteur de l’usage peut être la même personne ou une personne différente. "
                "L’usager est punissable même si l’auteur de la falsification reste inconnu ou impuni, à condition qu’il sache que le chèque/la carte est contrefait(e) ou falsifié(e).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "3) L’acceptation d’un moyen de paiement contrefait ou falsifié",
              ),
              const _Paragraph(
                "Dans ce cas, l’auteur accepte « en connaissance de cause » que le chèque ou la carte de paiement/retrait "
                "soit utilisé(e) dans son établissement.",
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
                "Il s’agit d’infractions intentionnelles : l’agent doit agir sciemment et volontairement, en mauvaise foi. "
                "La mauvaise foi se déduit souvent des moyens employés et du but poursuivi.\n\n"
                "L’intention simple suffit : l’auteur est punissable dès lors qu’il a agi sciemment et volontairement, "
                "sachant que son intervention permet de contrefaire, falsifier, user ou accepter un moyen de paiement contrefait.",
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
                  text: "Article L. 163-4-2 du Code monétaire et financier",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : lorsque les faits sont commis en bande organisée.",
                ),
              ]),
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
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 375 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 163-3 du C.M.F.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (bande organisée) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 1 000 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 163-4-2 du C.M.F.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article L. 163-10-1 du C.M.F.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", dans les conditions de "),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (infractions définies notamment aux articles L. 163-2 à L. 163-4, L. 163-7 et L. 163-10).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text: "Tentative : OUI (selon le comportement visé).",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "Tentative",
                bodySpans: [
                  const TextSpan(text: "• Délits prévus au 1° de "),
                  TextSpan(
                    text: "l’article L. 163-3",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " : tentative prévue et réprimée par "),
                  TextSpan(
                    text: "l’article L. 163-4-1 du C.M.F.",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Délits figurant au 2° de "),
                  TextSpan(
                    text: "l’article L. 163-3",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: " : la tentative est directement prévue.\n",
                  ),
                  const TextSpan(text: "• Délits définis au 3° de "),
                  TextSpan(
                    text: "l’article L. 163-3",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " : tentative non expressément prévue."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Complicité : OUI — règles générales, notamment ",
                ),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (aide/assistance, provocation, instructions), punissable pour l’infraction consommée comme pour l’infraction tentée.",
                ),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text: "L’article L. 163-4 du Code monétaire et financier",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " prévoit et réprime la fabrication, l’acquisition, la détention, la cession, l’offre ou la mise à disposition "
                        "d’équipements, instruments, programmes informatiques ou données conçus/spécialement adaptés dans l’objectif de "
                        "contrefaire ou falsifier un chèque ou un instrument mentionné à l’article L. 133-4 du C.M.F.",
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
