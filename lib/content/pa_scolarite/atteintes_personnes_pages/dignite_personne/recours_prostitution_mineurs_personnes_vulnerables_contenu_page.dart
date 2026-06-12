import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRecoursProstitutionMineursPersonnesVulnerablesPage
    extends StatelessWidget {
  const PaRecoursProstitutionMineursPersonnesVulnerablesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/dignite_personne/recours_prostitution_mineurs_personnes_vulnerables';

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
          "Dignité de la personne",
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
            "Le recours à la prostitution de mineur\nou de personne particulièrement vulnérable",
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
                "Le fait de solliciter, d’accepter ou d’obtenir, en échange d’une rémunération, d’une promesse "
                "de rémunération, de la fourniture d’un avantage en nature ou de la promesse d’un tel avantage, "
                "des relations de nature sexuelle de la part d’une personne se livrant à la prostitution (même "
                "de façon occasionnelle), lorsque cette personne est mineure ou présente une particulière vulnérabilité "
                "(apparente ou connue de l’auteur) due à une maladie, une infirmité, un handicap ou un état de grossesse, "
                "constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigé)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-12-1 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime le recours à la prostitution d’un mineur ou d’une personne particulièrement vulnérable.",
                ),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Article 611-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " (créé par la loi n° 2016-444 du 13 avril 2016) réprime le recours à la prostitution d’une personne majeure (contravention de 5e classe).",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Article 225-12-1 alinéa 1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " réprime le recours à la prostitution d’une personne majeure lorsqu’il est commis en récidive (délit non puni d’une peine d’emprisonnement).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (pédagogique, structuré)
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Les actes visés : solliciter, accepter, obtenir",
              ),
              const _Paragraph(
                "Les termes « solliciter », « accepter » ou « obtenir » s’entendent dans leur sens courant. "
                "Le choix de ces verbes traduit la volonté du législateur d’incriminer :\n"
                "• les actes de nature sexuelle (relation consommée ou simple attouchement),\n"
                "• mais aussi les actes préalables, même non sexuels, qui tendent à obtenir une relation sexuelle.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La procédure peut être diligentée dès qu’il apparaît qu’un accord est conclu, ",
                  ),
                  TextSpan(
                    text:
                        "sans attendre le commencement d’un attouchement ou d’un rapprochement sexuel ",
                  ),
                  TextSpan(
                    text:
                        "(circulaire ministère de la Justice du 24 avril 2002).",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "Il n’est pas nécessaire que l’auteur ait pris l’initiative. Le simple fait d’accepter une telle relation "
                "est punissable, même si elle a été proposée par la personne se livrant à la prostitution.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) La victime : mineur ou personne particulièrement vulnérable",
              ),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "La prostitution est définie comme l’activité consistant à se prêter, moyennant rémunération, ",
                ),
                TextSpan(
                  text:
                      "à des contacts physiques afin de satisfaire les besoins sexuels d’autrui — ",
                ),
                TextSpan(
                  text: "Cass. crim., 26 mars 1996",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La personne se livrant à la prostitution, même occasionnellement (une seule fois suffit), doit être :\n"
                "• un mineur (y compris entre 15 et 18 ans, ou émancipé),\n"
                "• ou une personne présentant une particulière vulnérabilité.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La preuve de l’âge peut être rapportée par tout moyen. ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 17 juillet 1991",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : aucune force probante automatique n’est donnée aux actes d’état civil étrangers.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Jurisprudences utiles (âge / apparence)"),
              _ConditionCard(
                title: "Repères jurisprudentiels",
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGreen,
                titleColor: textMain,
                children: const [
                  _BulletPoint(
                    text:
                        "L’argument « je ne connaissais pas l’âge » peut être écarté si l’apparence et le contexte rendent l’ignorance impossible.",
                  ),
                  _BulletPoint(
                    text:
                        "Un visage imberbe peut être incompatible avec la croyance du client en la majorité.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) La contrepartie : rémunération / promesse / avantage",
              ),
              const _Paragraph.rich([
                TextSpan(
                  text: "Article 225-12-1 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " exige une rémunération (ou promesse) ou un avantage (ou promesse d’avantage) pour caractériser l’infraction.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le délit n’est pas constitué si une relation sexuelle intervient sans être la contrepartie d’une rémunération "
                "ou d’une promesse, même si la personne se prostitue habituellement ou occasionnellement.",
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
              _SubTitle(
                "Intention de l’auteur + connaissance de la situation",
              ),
              _Paragraph(
                "Il suffit que l’auteur ait l’intention d’obtenir des relations de nature sexuelle avec une personne "
                "se livrant à la prostitution, en sachant qu’elle est mineure ou particulièrement vulnérable.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La minorité doit être connue, et la vulnérabilité doit être « apparente ou connue ». "
                "Autrement dit : l’auteur ne peut pas se retrancher derrière une ignorance invraisemblable si les indices sont évidents.",
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
                  text: "Article 225-12-2 1° à 4° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " — Premier degré d’aggravation :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Infraction commise de façon habituelle ou à l’égard de plusieurs personnes (l’habitude peut être retenue dès deux actes).",
              ),
              _BulletPoint(
                text:
                    "Mise en contact via l’utilisation d’un réseau de communication pour diffuser des messages à un public non déterminé.",
              ),
              _BulletPoint(
                text:
                    "Faits commis par une personne abusant de l’autorité que lui confèrent ses fonctions (autorité légale ou de fait).",
              ),
              _BulletPoint(
                text:
                    "Auteur ayant délibérément ou par imprudence mis la vie de la personne en danger ou commis des violences.",
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-12-2 alinéa 6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " — Second degré d’aggravation :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lorsqu’il s’agit d’un mineur de quinze ans (hors les cas où les faits constituent un viol ou une agression sexuelle).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette circonstance aggravante peut s’appliquer même si la relation sexuelle n’a pas été consommée. "
                        "Lorsque la relation est consommée et que l’auteur est majeur, les faits peuvent relever du viol ou de l’agression sexuelle.",
                  ),
                ],
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
                TextSpan(text: "Qualification simple : "),
                TextSpan(text: "75 000 € d’amende. — "),
                TextSpan(
                  text: "article 225-12-1 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (1er degré) : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 225-12-2 1° à 4° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Aggravée (2e degré – mineur de 15 ans) : ",
                ),
                TextSpan(
                  text: "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 225-12-2 alinéa 6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Application de la loi française"),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Article 225-12-3 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : la loi française est applicable lorsque les délits sont commis à l’étranger par un Français ou par une personne résidant habituellement sur le territoire français.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 225-12-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : amende (selon les modalités de l’article 131-38) + peines complémentaires (article 131-39 : dissolution, interdiction d’exercer, etc.).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " (aide et assistance, provocation, instructions).",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
