import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaHomicideInvolontairePage extends StatelessWidget {
  const PaHomicideInvolontairePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/homicide_involontaire';

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
          "Atteintes involontaires",
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
            "L’homicide involontaire",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
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
                "Le fait de causer, dans les conditions et selon les distinctions prévues à l’article 121-3, "
                "par maladresse, imprudence, inattention, négligence ou manquement à une obligation de sécurité "
                "ou de prudence imposée par la loi ou le règlement, la mort d’autrui, constitue un homicide involontaire.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Définition structurée par "),
                TextSpan(
                  text: "l’article 121-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " (faute + causalité)."),
              ]),
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
                  text: "Article 221-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : prévoit et réprime l’homicide involontaire.",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Référence centrale : "),
                TextSpan(
                  text: "article 121-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (distinction causalité directe/indirecte et niveau de faute exigé).",
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
              _SubTitle("A) Un acte involontaire : la faute"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (en référence à l’article 121-3) énumère 5 comportements fautifs (liste limitative).",
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle("1) La faute simple (imprudence simple)"),
              _Paragraph(
                "Il faut caractériser au moins un des comportements suivants :",
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Maladresse"),
              _BulletPoint(text: "Imprudence"),
              _BulletPoint(text: "Inattention"),
              _BulletPoint(text: "Négligence"),
              SizedBox(height: 8),
              _Paragraph(
                "Ces fautes s’apprécient par comparaison avec le comportement attendu d’une personne normalement "
                "prudente, diligente et attentive (ou du professionnel moyen/diligent selon le cas).",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "2) Manquement à une obligation de sécurité/prudence (loi ou règlement)",
              ),
              _Paragraph(
                "Le règlement s’entend des actes administratifs à caractère général et impersonnel. "
                "L’inobservation d’une obligation textuelle peut suffire en elle-même : il faut pouvoir préciser "
                "la source et la nature exacte de l’obligation violée.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Les juges doivent préciser l’obligation violée : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 juin 2002",
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
                "3) La faute caractérisée (si causalité indirecte)",
              ),
              _Paragraph(
                "Si la faute a causé indirectement le dommage, il faut une faute d’imprudence lourde : "
                "exposition d’autrui à un danger d’une particulière gravité, que l’auteur ne pouvait ignorer. "
                "Elle apparaît grossière et inacceptable compte tenu des circonstances ou des fonctions exercées.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text: "Exemples : battue de chasse mal encadrée ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 8 mars 2005)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " ; remise des clés à une personne alcoolisée sans permis ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 14 décembre 2010)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " ; défaut de questions essentielles par un médecin du SAMU ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 2 décembre 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un lien de causalité"),
              _Paragraph(
                "La faute doit avoir concouru au dommage. Il peut exister plusieurs fautes ayant participé au décès.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Deux conducteurs se suivent à vive allure : responsabilité retenue car ils participent ensemble à une action dangereuse — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 23 juillet 1986",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Pas besoin d’un lien direct et immédiat : ",
                ),
                TextSpan(
                  text: "Cass. crim., 14 février 1996",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " — il suffit que l’existence d’un lien de causalité soit certaine (dommage apprécié dans son dernier état).",
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                "1) Personnes physiques : causalité directe vs indirecte",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 121-3 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : sont auteurs indirects ceux qui ont créé/contribué à créer la situation ayant permis le dommage "
                      "ou qui n’ont pas pris les mesures permettant de l’éviter.",
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Causalité directe : une faute quelconque peut suffire (faute simple).",
              ),
              _BulletPoint(
                text:
                    "Causalité indirecte : il faut une faute délibérée ou une faute caractérisée.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Illustrations",
                bodySpans: [
                  TextSpan(
                    text:
                        "Location d’un jet-ski confié à une personne sans permis requis — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 5 octobre 2004",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text:
                        "Accidents du travail (direction/chef d’établissement) — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 28 mars 2006",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("C) Sur la personne d’autrui + dommage"),
              _Paragraph(
                "La victime doit être une personne humaine vivante, distincte de l’auteur.",
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text: "Enfant ayant survécu 1 heure après la naissance — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 2 décembre 2003",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph("Le dommage : la mort de la victime."),
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
                "En matière d’infractions non intentionnelles, l’intention de tuer n’est pas requise.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Toutefois, en cas de violation manifestement délibérée d’une obligation particulière de sécurité/prudence, "
                      "il faut établir que l’agent a adopté un comportement risqué en connaissance de cause (sans vouloir le résultat).",
                ),
              ]),
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
                  text: "Article 221-6 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque la mort résulte d’une violation manifestement délibérée d’une obligation particulière "
                      "de sécurité ou de prudence imposée par la loi ou le règlement.",
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Obligation prévue par un texte + obligation précisément déterminée (action/abstention précise).",
              ),
              _BulletPoint(
                text:
                    "Violation consciente + création d’un risque mortel qui se réalise.",
              ),
              _BulletPoint(
                text: "Lien de causalité certain (direct ou indirect).",
              ),

              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : 3 degrés d’aggravation (conducteur VTAM).",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "1er degré : homicide commis par le conducteur d’un véhicule terrestre à moteur.",
              ),
              _BulletPoint(
                text:
                    "2e degré : violation manifestement délibérée OU accompagnement d’un délit routier (alcool/stupéfiants/refus vérifs/sans permis/excès ≥ 50 km/h/délit de fuite…).",
              ),
              _BulletPoint(
                text: "3e degré : deux ou plus des circonstances du 2e degré.",
              ),

              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : 3 degrés d’aggravation (agression par un chien).",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "1er degré : agression par un chien (propriétaire ou détenteur au moment des faits).",
              ),
              _BulletPoint(
                text:
                    "2e degré : une situation listée (détention illicite, ivresse/stupéfiants, absence de mesures du maire, pas de permis de détention, pas de vaccin, chien cat. 1/2 sans muselière/laisse, mauvais traitements…).",
              ),
              _BulletPoint(
                text: "3e degré : deux ou plusieurs circonstances du 2e degré.",
              ),

              SizedBox(height: 14),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 434-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque l’homicide involontaire est suivi d’un délit de fuite (hors cas déjà visés par l’article 221-6-1).",
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
            children: const [
              _SubTitle(
                "Peines encourues — personnes physiques (synthèse)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (simple) : 3 ans d’emprisonnement et 45 000 € d’amende.",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (faute délibérée) : 5 ans d’emprisonnement et 75 000 € d’amende.",
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                "Aggravations spécifiques (conducteur / chien / fuite)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : 5 ans / 7 ans / 10 ans + amendes selon degrés.",
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 221-6-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : 5 ans / 7 ans / 10 ans + amendes selon degrés.",
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 434-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : doublement des peines prévues (hors article 221-6-1).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 221-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (même si causalité indirecte : responsabilité possible en cas de faute simple).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text: "Tentative : NON (résultat non recherché).",
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    "Complicité : NON (jurisprudence : exclue en matière non intentionnelle).",
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
