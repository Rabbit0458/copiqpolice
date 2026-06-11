import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteintesInvolontairesIttInferieure3MoisPage extends StatelessWidget {
  const PaAtteintesInvolontairesIttInferieure3MoisPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            "Atteintes involontaires à l’intégrité de la personne\n(I.T.T. ≤ 3 mois — Contraventions)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (sans répéter des titres inutilement)
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Hors les cas prévus par "),
                TextSpan(
                  text: "les articles 222-20 et 222-20-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ", le fait de causer à autrui, par maladresse, imprudence, inattention, négligence ou manquement à une obligation de sécurité ou de prudence imposée par la loi ou le règlement, "
                      "dans les conditions et selon les distinctions prévues à ",
                ),
                TextSpan(
                  text: "l’article 121-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ", une incapacité totale de travail d’une durée inférieure ou égale à trois mois constitue une infraction.\n\n"
                      "Le fait, par la violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence prévue par la loi ou le règlement, "
                      "de porter atteinte à l’intégrité d’autrui sans qu’il résulte d’I.T.T. constitue également une infraction.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Infractions prévues et réprimées par "),
                TextSpan(
                  text:
                      "les articles R. 625-2, R. 625-3 et R. 622-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Point-clé",
                bodySpans: [
                  TextSpan(
                    text:
                        "On est ici sur des contraventions : le régime est particulier (élément moral non exigé, distinctions selon ITT, etc.).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (pédagogique + visuel)
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Un acte involontaire : la faute"),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article R. 610-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " précise que les dispositions des 3e et 4e alinéas de ",
                ),
                TextSpan(
                  text: "l’article 121-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " sont applicables aux contraventions lorsque le règlement exige une faute d’imprudence ou de négligence.",
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle("1) La faute simple (imprudence simple)"),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article R. 625-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ", en référence à l’article 121-3, énumère une liste limitative de comportements fautifs (les juges doivent en caractériser au moins un).",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Maladresse, imprudence, inattention, négligence.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "• Imprudence / maladresse / inattention : agir sans précautions.\n"
                "• Négligence : ne pas se soucier des conséquences de son abstention.\n"
                "Ces fautes s’apprécient par comparaison avec la conduite d’une personne « normalement » adroite, attentive, prudente et diligente "
                "(ou du professionnel moyen/diligent selon le cas).",
              ),
              SizedBox(height: 12),

              _BulletPoint(
                text:
                    "Manquement à une obligation de sécurité ou de prudence imposée par la loi ou le règlement.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "Le terme « règlement » vise des actes administratifs à caractère général et impersonnel. "
                "L’inobservation d’une obligation textuelle suffit : il n’est pas nécessaire de viser des devoirs généraux de prudence. "
                "Les magistrats doivent pouvoir préciser la source et la nature exacte de l’obligation violée.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Cass. crim., 18 juin 2002",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : nécessité de préciser la source et la nature exacte de l’obligation violée.",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                "2) La faute caractérisée (cas de causalité indirecte)",
              ),
              _Paragraph(
                "Si la faute est en lien direct avec le dommage, une faute simple suffit. "
                "Pour un auteur dont la faute n’est qu’indirectement à l’origine du dommage, "
                "il faut démontrer une faute caractérisée : lourde, exposant autrui à un danger d’une particulière gravité, "
                "que l’auteur ne pouvait ignorer (faute grossière, inacceptable).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Exemples de jurisprudence :\n"),
                  TextSpan(
                    text:
                        "• Remettre volontairement les clés à une personne sans permis et alcoolisée — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 14 décembre 2010",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "• Médecin du SAMU n’ayant pas posé les bonnes questions — ",
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

              SizedBox(height: 14),

              _SubTitle(
                "3) Violation manifestement délibérée d’une obligation particulière",
              ),
              _Paragraph(
                "Il faut :\n"
                "• une obligation particulière de prudence/sécurité prévue par la loi ou le règlement,\n"
                "• la connaissance de cette obligation,\n"
                "• un choix délibéré de ne pas la respecter.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un lien de causalité"),
              _Paragraph(
                "Un lien de causalité entre la faute et l’atteinte (physique ou psychique) est nécessaire. "
                "Quand plusieurs fautes concourent au dommage, la causalité n’a pas à être immédiate : "
                "le dommage est apprécié dans son dernier état.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "Causalité directe / indirecte (personnes physiques)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 121-3 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " définit les auteurs indirects : ils ne sont pas directement à l’origine du dommage mais ont créé/contribué à créer la situation dangereuse ou n’ont pas pris les mesures permettant de l’éviter.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : professionnel de location confiant un scooter des mers à une personne sans permis — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 5 octobre 2004",
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
                bodySpans: [
                  TextSpan(
                    text:
                        "La causalité indirecte est souvent retenue pour le chef d’entreprise/directeur d’établissement en matière d’accidents du travail — ",
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
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Exemples (maire : lien indirect) :\n"),
                  TextSpan(
                    text:
                        "• Aire de jeux : buse non fixée écrasant un enfant — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 20 mars 2001",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "• Absence de réglementation des déplacements de dameuses sur piste de luge — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 mars 2003",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("C) Sur la personne d’autrui (victime)"),
              _BulletPoint(text: "Une personne humaine."),
              _BulletPoint(text: "Une personne vivante."),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : enfant ayant survécu une heure après sa naissance et décédé des suites d’un accident — ",
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

              SizedBox(height: 14),

              _SubTitle("D) Un dommage"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 625-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : atteinte physique/psychique entraînant une I.T.T. ≤ 3 mois consécutifs (pas de périodes additionnées).",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 625-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : atteinte sans I.T.T., mais résultant d’une violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence.",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 622-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : atteinte sans I.T.T."),
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
            children: const [
              _Paragraph("Non exigé en matière contraventionnelle."),
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
                "La contravention de 5e classe prévue par R. 625-3 constitue l’aggravation de la contravention de 2e classe prévue par R. 622-1 "
                "en cas de violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence imposée par la loi ou le règlement.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "article R. 625-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " (aggravation de "),
                TextSpan(
                  text: "R. 622-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité (pédago + propre)
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph(
                "Les qualifications sont contraventionnelles (2e ou 5e classe selon les cas).",
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "• Atteintes involontaires sans I.T.T. (2e classe) — ",
                ),
                TextSpan(
                  text: "article R. 622-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : "),
                TextSpan(text: "amende de 2e classe."),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(text: "• I.T.T. ≤ 3 mois (5e classe) — "),
                TextSpan(
                  text: "article R. 625-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : "),
                TextSpan(text: "amende de 5e classe."),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      "• Sans I.T.T. + violation manifestement délibérée d’une obligation particulière (5e classe) — ",
                ),
                TextSpan(
                  text: "article R. 625-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : "),
                TextSpan(text: "amende de 5e classe."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Responsabilité pénale des personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Prévue notamment par "),
                TextSpan(
                  text: "l’article R. 625-5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article R. 622-1 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Même si la causalité avec le dommage est indirecte, la responsabilité peut être engagée en cas de faute simple.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON."),
              _BulletPoint(text: "Complicité : NON."),
            ],
          ),

          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/* ///////////////////////////////////////////////////////////////////////////
   ///                   TES WIDGETS PERSONNALISÉS EXACTS                  ///
   ///////////////////////////////////////////////////////////////////////////

   ✅ Colle ici exactement tes widgets (_ConditionCard, _SubTitle, _Paragraph, etc.)
   (Tu m’as dit qu’ils sont déjà prêts, donc je ne les réécris pas.)
*/

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
