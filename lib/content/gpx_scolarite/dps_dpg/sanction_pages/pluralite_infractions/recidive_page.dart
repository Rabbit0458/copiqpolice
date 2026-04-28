import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecidivePage extends StatelessWidget {
  const RecidivePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/pluralite_infractions/recidive';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color card = isDark
        ? const Color(0xFF2F2F2F)
        : const Color(0xFFF7F7FB);
    final Color card2 = isDark
        ? const Color(0xFF30323A)
        : const Color(0xFFF3F7FF);

    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    final Color lawRed = isDark
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFD32F2F);

    TextSpan law(String s) => TextSpan(
      text: s,
      style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    TextSpan t(String s) => TextSpan(text: s);

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
          'La sanction',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===================== TITRE (UNE SEULE FOIS) =====================
          Text(
            "La récidive",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Idée générale",
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                "La récidive est la principale cause qui permet au juge de dépasser le maximum normal de la peine. "
                "Le délinquant, après avoir été condamné pour une première infraction, en commet une seconde.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La récidive suppose :\n"
                "• une condamnation définitive passée en force de chose jugée (premier terme),\n"
                "• une seconde infraction (second terme).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: "Chapitre 1 — Les termes de la récidive",
            cardColor: card2,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                law("Articles 132-8 et suivants du Code pénal"),
                t("."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle(
                "1.1 — Premier terme : une première condamnation",
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                "La première condamnation doit avoir le caractère d’une peine. "
                "Ainsi, les sanctions administratives et les mesures de sûreté ne peuvent constituer le premier terme. "
                "Il en est de même d’un acquittement ou d’une mesure de rééducation prise à l’encontre d’un mineur.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Sont prises en compte les peines encourues pour telle infraction et non les peines prononcées par le tribunal.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  t(
                    "Sont prises en compte les condamnations prononcées par une juridiction pénale française ",
                  ),
                  t("ou d’un État membre de l’Union européenne : "),
                  law("article 132-23-1 du Code pénal"),
                  t(
                    ". Quand la condamnation provient d’un État membre, la qualification est appréciée au regard de la loi française, ",
                  ),
                  t("et les peines équivalentes sont retenues : "),
                  law("article 132-23-2 du Code pénal"),
                  t(
                    ". Les autres condamnations étrangères ne sont pas prises en considération.",
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _Paragraph(
                "La condamnation doit être définitive : elle doit être passée en force de chose jugée avant que la seconde infraction intervienne. "
                "Dans le cas contraire, on se trouve en présence d’un concours réel d’infractions.",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                t(
                  "Dans un avis du 26 janvier 2009, la Cour de cassation estime qu’une condamnation avec sursis, réputée non avenue (non révoquée), ",
                ),
                t("peut constituer le premier terme d’une récidive. "),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                t(
                  "Une condamnation par le tribunal de police ou le tribunal correctionnel ne devient définitive qu’à l’expiration du délai d’appel du Procureur général, ",
                ),
                t(
                  "qui est de 20 jours à compter du prononcé de la décision : ",
                ),
                law("article 505 du Code de procédure pénale"),
                t("."),
              ]),
              const SizedBox(height: 10),

              const _Paragraph(
                "La condamnation doit encore être inscrite au casier judiciaire au moment de la commission de la seconde infraction. "
                "Si elle a été effacée par une amnistie, elle ne peut plus servir de premier terme. "
                "En revanche, en cas de grâce, la récidive peut être retenue (la grâce dispensant seulement d’exécuter la peine).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("1.2 — Second terme : une infraction ultérieure"),
              const SizedBox(height: 6),

              _Paragraph.rich([
                t("Le Code pénal prévoit quatre cas de récidive : "),
                law("articles 132-8 à 132-11 du Code pénal"),
                t("."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1.2.1 — Crime/délit puni de 10 ans → crime"),
              _Paragraph.rich([
                law("Article 132-8 du Code pénal"),
                t(
                  " : celui qui, condamné une première fois pour un crime ou un délit puni de 10 ans d’emprisonnement, commet ultérieurement un autre crime, est en état de récidive.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Le second terme doit être un crime."),
              const _BulletPoint(
                text:
                    "Récidive générale : les infractions n’ont pas à être similaires.",
              ),
              const _BulletPoint(
                text:
                    "Récidive perpétuelle : pas de délai (tant que la première condamnation n’est pas effacée).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.2.2 — Crime/délit puni de 10 ans → délit"),
              _Paragraph.rich([
                law("Article 132-9 du Code pénal"),
                t(
                  " : celui qui, condamné une première fois pour un crime ou un délit puni de 10 ans d’emprisonnement, commet ultérieurement un nouveau délit, est en état de récidive.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Récidive générale : pas nécessairement identique.",
              ),
              const _BulletPoint(
                text:
                    "Récidive temporaire : la seconde infraction doit être commise dans un délai après l’expiration ou la prescription de la peine.",
              ),
              const SizedBox(height: 6),
              const _IntroBullet(
                text:
                    "Délai de 10 ans si le second délit est puni de 10 ans d’emprisonnement.",
              ),
              const _IntroBullet(
                text:
                    "Délai de 5 ans si le second délit est puni d’une peine inférieure à 10 ans.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.2.3 — La récidive correctionnelle"),
              _Paragraph.rich([
                law("Article 132-10 du Code pénal"),
                t(
                  " : celui qui, déjà condamné définitivement pour un délit, commet dans le délai de 5 ans le même délit ou un délit assimilé, est récidiviste.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Temporaire (délai : 5 ans)."),
              const _BulletPoint(
                text: "Spéciale : délits identiques ou assimilés.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Assimilations (exemples)",
                bodySpans: [
                  t(
                    "Le législateur a assimilé certains délits pour l’application de la récidive, notamment :\n",
                  ),
                  t(
                    "• vol, extorsion, chantage, escroquerie, abus de confiance : ",
                  ),
                  law("article 132-16 du Code pénal"),
                  t("\n• agression sexuelle et atteintes sexuelles : "),
                  law("article 132-16-1 du Code pénal"),
                  t("\n• infractions liées à la conduite d’un VTM : "),
                  law("article 132-16-2 du Code pénal"),
                  t("\n• traite des êtres humains et proxénétisme : "),
                  law("article 132-16-3 du Code pénal"),
                  t(
                    "\n• violences volontaires et tout délit commis avec la circonstance aggravante de violences : ",
                  ),
                  law("article 132-16-4 du Code pénal"),
                  t("\n• recel et délit ayant procuré la chose : "),
                  law("article 321-5 du Code pénal"),
                  t("."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("1.2.4 — La récidive contraventionnelle"),
              _Paragraph.rich([
                law("Article 132-11 du Code pénal"),
                t(
                  " : celui qui, déjà condamné définitivement pour une contravention de 5e classe, commet la même contravention, est récidiviste.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Spéciale : même contravention."),
              const _BulletPoint(
                text:
                    "Temporaire : dans les 12 mois suivant l’expiration ou la prescription de la peine.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                t(
                  "Dans certains cas, la récidive d’une contravention de 5e classe constitue un délit : ",
                ),
                law("article 132-11 alinéa 2 du Code pénal"),
                t(" (délai : 3 ans)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("1.2.5 — Cas spéciaux"),
              const _Paragraph(
                "Il existe des exceptions au droit commun de la récidive : certains textes spéciaux écartent l’aggravation, "
                "ou modifient les délais (ex. : infractions de chasse, délai de 12 mois au lieu de 5 ans pour les délits).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: "Chapitre 2 — Récidive et personnes morales",
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                t(
                  "Le Code pénal a prévu la récidive pour les personnes morales (régime propre).",
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph.rich([
                law("Article 132-12 du Code pénal"),
                t(
                  " : récidive crime (ou délit assimilé) → crime (générale et perpétuelle).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                law("Article 132-13 du Code pénal"),
                t(
                  " : crime (ou délit assimilé) → délit (générale et temporaire).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                law("Article 132-14 du Code pénal"),
                t(
                  " : délit → délit identique ou assimilé (spéciale et temporaire).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                law("Article 132-15 du Code pénal"),
                t(
                  " : récidive contraventionnelle (5e classe, si le règlement l’a prévue).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 =====================
          _ConditionCard(
            title: "Chapitre 3 — Preuve : le casier judiciaire",
            cardColor: card2,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                t(
                  "La preuve de la récidive repose principalement sur le casier judiciaire. ",
                ),
                t(
                  "Le juge se fonde essentiellement sur les mentions du bulletin n°1.\n\n",
                ),
                t("Organisation et fonctionnement : "),
                law("articles 768 et suivants du Code de procédure pénale"),
                t("."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("3.1 — Les bulletins"),
              const _BulletPoint(
                text:
                    "Bulletin n°1 : relevé intégral (réservé aux autorités judiciaires).",
              ),
              const _BulletPoint(
                text:
                    "Bulletin n°2 : relevé avec exclusions (selon les cas prévus).",
              ),
              const _BulletPoint(
                text:
                    "Bulletin n°3 : extrait délivré à la personne concernée (infractions les plus graves).",
              ),

              const SizedBox(height: 10),
              const _SubTitle("3.3 — Utilisation par le juge"),
              const _Paragraph(
                "Les mentions du bulletin n°1 font preuve de la récidive. "
                "Si l’intéressé conteste, le ministère public doit solliciter les copies des décisions auprès des greffes concernés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 4 =====================
          _ConditionCard(
            title: "Chapitre 4 — Effets de la récidive",
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle("4.1 — Personnes physiques"),
              const _BulletPoint(
                text:
                    "Art. 132-8 : aggravation pouvant conduire jusqu’à la perpétuité selon le maximum prévu.",
              ),
              const _BulletPoint(
                text:
                    "Art. 132-9 : doublement du maximum (emprisonnement et amende).",
              ),
              const _BulletPoint(
                text:
                    "Art. 132-10 : doublement des peines encourues (emprisonnement / amende).",
              ),
              const _BulletPoint(
                text:
                    "Art. 132-11 : amende maximale portée à 3 000 € (hors cas où la récidive devient un délit).",
              ),

              const SizedBox(height: 10),

              const _SubTitle("4.2 — Personnes morales"),
              const _Paragraph(
                "Principe : l’amende encourue est augmentée (souvent doublée, voire x10 en matière contraventionnelle), "
                "et les peines complémentaires applicables peuvent être prononcées selon les textes.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                t("Peines complémentaires possibles (personnes morales) : "),
                law("article 131-39 du Code pénal"),
                t("."),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  t(
                    "Le délai de commission de la nouvelle infraction est calculé à compter de l’expiration ou de la prescription de la peine.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),
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
