import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatutJuridiqueMineurPage extends StatelessWidget {
  const StatutJuridiqueMineurPage({super.key});

  static const String routeName = '/gpx/intervention/mineurs/statut-juridique';

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
    final Color cardRights = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDuties = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
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
          "Mineurs",
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
            "Le statut juridique du mineur",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: "Contexte opérationnel",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier est confronté à des mineurs délinquants mais aussi à des mineurs victimes. "
                "Dans toutes les missions, il ne faut jamais oublier qu’un mineur bénéficie de droits assortis "
                "d’une protection particulière, mais également de devoirs à respecter.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Toujours adopter une posture protectrice et adaptée à l’âge, sans oublier le cadre légal.",
              ),
              _IntroBullet(
                text:
                    "Penser systématiquement à l’autorité parentale (droits/devoirs des parents + intérêt de l’enfant).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre légal en haut
          _ConditionCard(
            title: "Références essentielles (cadre légal)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’autorité parentale est un ensemble de droits et devoirs exercés dans l’intérêt de l’enfant. ",
                ),
                TextSpan(
                  text: "Article 371-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : protection (sécurité, santé, vie privée, moralité), éducation, développement, respect de la personne.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "L’autorité parentale s’exerce "),
                  const TextSpan(
                    text: "sans violences physiques ou psychologiques",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text:
                        " et les parents associent l’enfant aux décisions selon son âge/maturité (",
                  ),
                  TextSpan(
                    text: "article 371-1 du Code civil",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Droits
          _ConditionCard(
            title: "I — Les droits des mineurs",
            cardColor: cardRights,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Droit à l’hébergement"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le mineur trouve d’abord sa sécurité en étant hébergé chez ses parents où il est normalement domicilié. ",
                ),
                TextSpan(
                  text: "Article 108-2 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Atteintes sévèrement punies :\n"),
                  const TextSpan(
                    text: "• Abandon / non-représentation d’enfant : ",
                  ),
                  TextSpan(
                    text: "articles 227-3 et 227-5 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text: "• Enlèvement / détournement de mineur : ",
                  ),
                  TextSpan(
                    text:
                        "article 224-5, articles 227-7 et 227-8 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Droit à l’entretien"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les parents doivent satisfaire aux besoins de l’enfant (nourriture, logement, santé, éducation). ",
                ),
                TextSpan(
                  text: "Article 203 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : les dépenses sont supportées selon les ressources et la situation sociale.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "En cas de séparation (divorce) : l’obligation d’entretien prend souvent la forme d’une pension alimentaire.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Droit à l’éducation"),
              const _Paragraph(
                "Les parents ont le droit et le devoir d’assurer l’éducation : instruction, formation professionnelle, "
                "mais aussi formation civique, morale et religieuse. Le choix des méthodes d’éducation leur appartient, "
                "mais le juge peut intervenir si elles entraînent des violences ou sont contraires aux bonnes mœurs (assistance éducative).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 624-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : amende (750 €) si un parent ne fait pas fréquenter assidûment l’école à un enfant soumis à l’obligation scolaire, sans motif légitime/excuse valable.",
                ),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("D) Droit à la santé"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les parents doivent assurer et veiller à la santé de leurs enfants. ",
                ),
                TextSpan(
                  text: "Article 371-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Exemples d’atteintes / infractions citées",
                bodySpans: [
                  const TextSpan(
                    text:
                        "• Exemples (défaut de soins, inconduite notoire, etc.) : ",
                  ),
                  TextSpan(
                    text: "article 378-1 du Code civil",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Violences sur mineur : "),
                  TextSpan(
                    text:
                        "articles 222-8, 222-10 (1°), 222-12 (1°), 222-13 (1°), 222-14 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "• Atteintes à la santé/sécurité/moralité/éducation : ",
                  ),
                  TextSpan(
                    text: "article 227-17 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text: "• Privation volontaire d’aliments ou de soins : ",
                  ),
                  TextSpan(
                    text: "articles 227-15 et 227-16 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Constitue notamment une privation de soins : maintenir un enfant de moins de 6 ans sur la voie publique "
                        "ou dans un espace de transport collectif, dans le but de solliciter la générosité des passants.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Obligation scolaire : "),
                TextSpan(
                  text: "article L. 131-1 du Code de l’éducation",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article 227-17-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("E) Droit à l’image & respect de la vie privée"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les parents protègent le droit à l’image du mineur dans le respect de sa vie privée, "
                      "et associent l’enfant à ce droit selon son âge et sa maturité. ",
                ),
                TextSpan(
                  text: "Article 372-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "F) Droit au recours à la justice & défense des intérêts",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 388-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : le mineur capable de discernement peut être entendu, dans toute procédure le concernant, "
                      "par le juge (ou la personne désignée). La demande ne peut être écartée que par décision spécialement motivée.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Le mineur peut être entendu seul, avec un avocat, ou avec une personne de son choix (si conforme à son intérêt).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("G) Droit à l’aide juridictionnelle"),
              _Paragraph.rich([
                const TextSpan(text: "Attribuée de droit au mineur : "),
                TextSpan(
                  text: "article 9-1 de la loi n° 91-647 du 10 juillet 1991",
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

          // II — Devoirs
          _ConditionCard(
            title: "II — Les devoirs des mineurs",
            cardColor: cardDuties,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "En contrepartie de la protection dont il bénéficie, le mineur doit respecter un certain nombre de devoirs.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Respect des parents"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 371 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’enfant, à tout âge, doit honneur et respect à ses père et mère.",
                ),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("B) Devoir d’obéissance"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 371-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’enfant doit respecter l’autorité des parents jusqu’à sa majorité ou son émancipation.",
                ),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("C) Devoir de domiciliation"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le mineur non émancipé est domicilié chez ses parents : ",
                ),
                TextSpan(
                  text: "article 108-2 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Si les parents ont des domiciles distincts : domiciliation chez celui avec lequel il réside, "
                "ou alternativement selon décision de justice.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’enfant ne peut quitter la maison familiale sans permission des parents et ne peut en être retiré "
                      "que dans les cas prévus par la loi : ",
                ),
                TextSpan(
                  text: "article 371-3 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("D) Obligation de scolarisation"),
              const _Paragraph(
                "L’instruction est obligatoire pour les enfants (français et étrangers), entre 3 ans et 16 ans.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 131-1 du Code de l’éducation",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : cadre général de l’obligation d’instruction.",
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
