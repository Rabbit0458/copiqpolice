import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAbandonDeFamillePage extends StatelessWidget {
  const PaAbandonDeFamillePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_de_famille';

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
          "Abandon de famille",
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
            "L’abandon de famille",
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
                "Le fait, pour une personne, de ne pas exécuter une décision judiciaire ou l’un des titres "
                "mentionnés aux 2° à 6° du I de l’article 373-2-2 du code civil lui imposant de verser au profit "
                "d’un enfant mineur, d’un descendant, d’un ascendant ou du conjoint une pension, une contribution, "
                "des subsides ou des prestations de toute nature dues en raison d’une obligation familiale, "
                "en demeurant plus de deux mois sans s’acquitter intégralement de cette obligation, constitue une infraction.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Intermédiation financière",
                bodySpans: [
                  TextSpan(
                    text:
                        "Lorsque l’intermédiation financière des pensions alimentaires est mise en œuvre, "
                        "le fait pour le parent débiteur de demeurer plus de deux mois sans s’acquitter intégralement "
                        "des sommes dues entre les mains de l’organisme débiteur des prestations familiales "
                        "assurant l’intermédiation constitue la même infraction.",
                  ),
                ],
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
                  text: "Article 227-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : définit et réprime le délit d’abandon de famille.",
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
              _SubTitle(
                "A) Un acte imposant le versement d’une somme d’argent",
              ),
              _Paragraph(
                "L’infraction suppose l’existence d’une obligation familiale portant sur une pension, une contribution, "
                "des subsides ou une prestation de toute nature (obligations prévues par le code civil) au profit :\n"
                "• d’un enfant mineur\n"
                "• d’un descendant\n"
                "• d’un ascendant\n"
                "• du conjoint\n\n"
                "Exemples : contribution aux charges du mariage, pension alimentaire, prestation compensatoire après divorce, etc.",
              ),
              SizedBox(height: 14),

              _SubTitle("B) Un acte exécutoire (décision ou titre)"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’abandon de famille consiste à ne pas exécuter une décision judiciaire ou l’un des titres "
                      "mentionnés aux 2° à 6° du I de ",
                ),
                TextSpan(
                  text: "l’article 373-2-2 du code civil",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ". L’obligation doit être exécutoire."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Peuvent notamment constituer un fondement exécutoire :\n"
                "• une décision juridictionnelle\n"
                "• une convention judiciairement homologuée\n"
                "• une convention prévue à l’article 229-1 du code civil\n"
                "• un acte notarié\n"
                "• une convention à laquelle l’organisme débiteur des prestations familiales a donné force exécutoire\n"
                "• une transaction ou un acte constatant un accord issu d’une médiation/conciliation/procédure participative\n\n"
                "La décision doit être exécutoire et portée légalement à la connaissance du débiteur (ou exécutée volontairement, "
                "ou dont il a eu légalement connaissance).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Durée",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’obligation de payer se poursuit pendant toute la période prévue par l’acte exécutoire, "
                        "tant qu’une décision ultérieure ne l’a pas supprimée.",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("C) Un défaut de paiement"),
              _SubTitle("1) Inexécution de l’intégralité du paiement"),
              _Paragraph(
                "Le débiteur doit s’acquitter intégralement de l’obligation :\n"
                "• le délit est constitué si le non-paiement est total ou partiel\n"
                "• des paiements partiels, en nature, des compensations ne permettent pas d’exonérer\n"
                "• le refus de prendre en compte une indexation peut aussi caractériser l’infraction.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Refus d’indexation (réévaluation) : "),
                  TextSpan(
                    text: "(Cass. crim., 26 octobre 1987)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                "2) Défaut de paiement pendant plus de deux mois",
              ),
              _Paragraph(
                "Le texte exige que le débiteur demeure plus de deux mois sans s’acquitter intégralement : "
                "le délai doit être dépassé (plus de deux mois et non deux mois seulement).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Délai « plus de deux mois » : "),
                  TextSpan(
                    text: "(C.A. Paris, 16 mars 1994)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Point de départ du délai :\n"
                "• la date de signification de la décision ordonnant le versement, ou\n"
                "• le jour du dernier versement intégral (en cas d’interruption des paiements).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Effet du délai",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le délit est constitué dès l’expiration des deux mois : aucune situation postérieure "
                        "n’efface rétroactivement l’infraction (même si le paiement intervient tardivement, "
                        "ou si la décision est ensuite modifiée/cassée).",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Cassation ultérieure sans effet : "),
                  TextSpan(
                    text: "(Cass. crim., 26 juillet 1977)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Réformation partielle sans effet : "),
                  TextSpan(
                    text: "(Cass. crim., 21 mai 1980)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Paiement tardif sans effet : "),
                  TextSpan(
                    text: "(Cass. crim., 23 mars 1981)",
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
              _SubTitle(
                "Volonté de ne pas exécuter l’acte imposant le versement",
              ),
              _Paragraph(
                "Le délit d’abandon de famille sanctionne l’inexécution volontaire de l’acte fixant le montant "
                "de la pension/prestation, à condition que l’auteur ait eu connaissance légale de l’acte.\n\n"
                "La charge de la preuve (caractère intentionnel et connaissance de l’acte) appartient à la partie poursuivante.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le délit n’est pas constitué si le non-paiement résulte d’une situation de précarité persistante "
                        "ne dépendant pas de la volonté du débiteur : ces circonstances peuvent établir le caractère involontaire "
                        "du défaut de paiement ",
                  ),
                  TextSpan(
                    text: "(C.A. Aix-en-Provence, 01 juillet 1994)",
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
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(text: "2 ans d’emprisonnement."),
              _BulletPoint(text: "15 000 € d’amende."),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-4-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : prévoit la responsabilité pénale des personnes morales.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Peines encourues : amende selon "),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: ", et peines complémentaires prévues par ",
                ),
                TextSpan(
                  text: "l’article 131-39, 2° à 9° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " (interdiction d’exercer, etc.)."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non punissable)."),
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
                  text: " (aide et assistance, provocation ou instructions).",
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
