import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuspectLibreGeneralitesPage extends StatelessWidget {
  const SuspectLibreGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/gav_suspect_libre/suspect_libre_generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardStatus = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardScope = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInfo = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRights = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMinor = isDark
        ? const Color(0xFF1F2B33)
        : const Color(0xFFF2FBFF);

    // Accents
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
    final Color accentCyan = isDark
        ? const Color(0xFF4DD0E1)
        : const Color(0xFF00838F);

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
          "Suspect libre",
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
            "Généralités — statut du suspect libre",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Idée clé",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Le suspect libre permet d’entendre une personne soupçonnée en dehors du cadre de la garde à vue.",
              ),
              _IntroBullet(
                text:
                    "Elle est libre de quitter les locaux à tout moment : l’audition n’a pas de durée maximale.",
              ),
              _IntroBullet(
                text: "Les droits doivent être notifiés avant toute audition.",
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
                  text: "Article 61-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit les conditions d’audition libre d’une personne soupçonnée et impose l’information préalable sur ses droits.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le témoin (absence de raisons plausibles de soupçonner) relève d’un autre cadre : ",
                  ),
                  TextSpan(
                    text: "article 62 C.P.P.",
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

          _ConditionCard(
            title: "II — Le statut du suspect libre",
            cardColor: cardStatus,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Définition"),
              _Paragraph.rich([
                const TextSpan(text: "Le suspect libre est une personne ("),
                TextSpan(
                  text: "art. 61-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "À l’encontre de laquelle il existe des raisons plausibles de soupçonner qu’elle a commis ou tenté de commettre une infraction (contravention, délit ou crime).",
              ),
              const _BulletPoint(
                text:
                    "Qui accepte d’être entendue sans contrainte par les services d’enquête.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La personne est libre de quitter à tout moment les locaux où elle est entendue : "
                "la durée de l’audition n’est pas limitée dans le temps.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("À distinguer : le témoin"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le témoin est une personne à l’encontre de laquelle il n’existe aucune raison plausible de soupçonner (",
                ),
                TextSpan(
                  text: "article 62 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Aucun droit spécifique n’a à être notifié ; audition sans limite de temps.",
              ),
              const _BulletPoint(
                text:
                    "Il peut toutefois être retenu sous contrainte si nécessaire, pendant le temps strictement nécessaire, sans excéder 4 heures.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Champ d’application",
            cardColor: cardScope,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Absence de contrainte"),
              _Paragraph.rich([
                const TextSpan(text: "Principe : pas de contrainte ("),
                TextSpan(
                  text: "article 61-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Si la personne a été conduite sous contrainte par la force publique devant l’O.P.J., "
                "elle ne peut pas être entendue librement.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Indicateurs typiques de contrainte"),
              const _BulletPoint(
                text:
                    "Personne contrainte à monter dans le véhicule de police.",
              ),
              const _BulletPoint(text: "Personne menottée durant le trajet."),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Avant toute audition, l’enquêteur doit demander à la personne de confirmer qu’elle a suivi de son plein gré les agents et qu’elle n’a subi aucune contrainte lors du transport.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Conséquences si contrainte"),
              const _BulletPoint(
                text:
                    "Placement en garde à vue si les conditions sont réunies.",
              ),
              const _BulletPoint(
                text:
                    "Ou remise en liberté avec convocation pour une audition ultérieure.",
              ),
              const SizedBox(height: 14),

              const _SubTitle("2) Cas particuliers"),
              const _Paragraph(
                "Certains contextes permettent une audition libre si les conditions sont respectées.",
              ),
              const SizedBox(height: 10),
              const _SubTitle(
                "• Chambre de sûreté (ivresse publique et manifeste)",
              ),
              const _Paragraph(
                "Une personne placée en chambre de sûreté le temps de recouvrer la raison peut ensuite être entendue librement "
                "sur la contravention d’ivresse publique et manifeste : les dispositions de l’audition libre s’appliquent.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("• Dépistage alcool/stupéfiants positif"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La personne retenue pour dépistage/vérifications peut être entendue librement si : elle n’a pas été contrainte de demeurer à disposition, et si elle a été informée des droits de l’",
                ),
                TextSpan(
                  text: "article 61-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle(
                "• Personne gardée à vue entendue sur des faits distincts",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si, pendant une garde à vue, la personne est entendue sur des faits distincts en tant que suspect, certains droits de l’audition libre doivent être notifiés (1°, 3°, 4° et 5° de l’",
                ),
                TextSpan(
                  text: "article 61-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "), conformément à l’"),
                TextSpan(
                  text: "article 65 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("3) Cadres d’enquête"),
              const _BulletPoint(text: "Enquête de flagrance."),
              const _BulletPoint(text: "Enquête préliminaire."),
              const _BulletPoint(text: "Commission rogatoire (exécution)."),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Information du suspect libre",
            cardColor: cardInfo,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Convocation du mis en cause"),
              const _Paragraph(
                "Si l’enquête le permet, une convocation écrite peut être adressée. Elle peut préciser :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "L’infraction soupçonnée (commise ou tentée).",
              ),
              const _BulletPoint(
                text:
                    "Le droit d’être assisté d’un avocat dès le début de l’audition ou à tout moment.",
              ),
              const _BulletPoint(
                text: "Les conditions d’accès à l’aide juridictionnelle.",
              ),
              const _BulletPoint(
                text:
                    "Les modalités de désignation d’un avocat commis d’office.",
              ),
              const _BulletPoint(
                text: "Les lieux où obtenir des conseils juridiques.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Notification des droits"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Même en présence d’une convocation écrite préalable, les droits doivent être notifiés avant toute audition et consignés par PV, conformément à l’",
                ),
                TextSpan(
                  text: "article 61-1 C.P.P.",
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
                    "PV spécifique possible, ou intégration dans le PV d’audition.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Droits du suspect libre",
            cardColor: cardRights,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Droits à notifier avant toute audition"),
              _Paragraph.rich([
                const TextSpan(text: "Droits visés à l’"),
                TextSpan(
                  text: "article 61-1 C.P.P.",
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
                    "Qualification, date et lieu présumés de l’infraction soupçonnée (toutes les infractions retenues doivent être communiquées).",
              ),
              const _BulletPoint(
                text:
                    "Droit de quitter les locaux à tout moment (si volonté de partir : aviser immédiatement l’O.P.J.).",
              ),
              const _BulletPoint(text: "Droit à un interprète, si nécessaire."),
              const _BulletPoint(
                text:
                    "Droit de faire des déclarations, répondre aux questions ou se taire.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Assistance d’un avocat (conditions)"),
              const _Paragraph(
                "Le droit à l’assistance d’un avocat s’exerce au cours de l’audition, de la confrontation, "
                "ou lors d’opérations de reconstitution et séances d’identification, lorsque la personne est soupçonnée d’un crime ou d’un délit puni d’emprisonnement.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Possibilité de s’entretenir au préalable avec l’avocat (temps suffisant).",
              ),
              const _BulletPoint(
                text:
                    "Choix libre de l’avocat ou désignation d’office par le bâtonnier.",
              ),
              const _BulletPoint(
                text:
                    "Frais d’avocat à la charge de la personne, sauf conditions d’aide juridictionnelle (remise d’une notice d’information).",
              ),
              const _BulletPoint(
                text:
                    "La personne peut changer d’avis à tout moment et demander un avocat en cours de procédure.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Accès à certaines pièces"),
              const _Paragraph(
                "Si l’infraction est un crime ou un délit puni d’emprisonnement : la personne est informée de son droit de consulter les PV d’audition ou de confrontation antérieurs.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Aucune copie ne peut être obtenue ou réalisée.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Conseils juridiques (accès au droit)"),
              const _Paragraph(
                "La personne peut bénéficier, le cas échéant gratuitement, de conseils juridiques dans une structure d’accès au droit "
                "(maison de justice et du droit ou autres structures départementales).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un formulaire de notification des droits peut être remis (traductions disponibles sur le site du ministère de la Justice).",
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _SubTitle("Majeur protégé"),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article 706-112-2 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : si tutelle/curatelle, avis au tuteur/curateur. Celui-ci peut désigner un avocat ou demander un avocat commis d’office.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si le majeur protégé n’a pas été assisté par un avocat et que le tuteur/curateur n’a pu être avisé, ses déclarations ne pourront pas servir à elles seules de fondement à une condamnation.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VI — Garanties spécifiques applicables au mineur",
            cardColor: cardMinor,
            accent: accentCyan,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Avis aux représentants légaux"),
              _Paragraph.rich([
                const TextSpan(text: "Références : "),
                TextSpan(
                  text: "articles L. 412-1 et L. 412-2 C.J.P.M.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Obligation d’aviser par tout moyen les représentants légaux, la personne ou le service auquel le mineur est confié.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("2) Assistance d’un avocat"),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article L. 412-2 C.J.P.M.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : le mineur est assisté d’un avocat."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "À défaut de désignation par le mineur ou ses représentants, le bâtonnier est informé afin qu’un avocat soit commis d’office.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("3) Droit à l’information"),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article R. 412-1 C.J.P.M.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Droit à ce que les représentants légaux ou l’adulte approprié soient informés.",
              ),
              const _BulletPoint(
                text: "Droit d’être accompagné (si décidé) lors des auditions.",
              ),
              const _BulletPoint(
                text:
                    "Droit à la protection de la vie privée (interdiction de diffusion, publicité restreinte, interdiction de publier des éléments d’identification).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("4) Droit à l’accompagnement"),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article L. 311-1 C.J.P.M.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Le mineur a le droit d’être accompagné par ses représentants légaux lors des auditions/interrogatoires. "
                "L’enquêteur apprécie selon les circonstances (intérêt supérieur de l’enfant, absence de préjudice à la procédure).",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "5) Remplacement des titulaires de l’autorité parentale",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article L. 311-2 C.J.P.M.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Information/accompagnement écartés si contraire à l’intérêt supérieur de l’enfant.",
              ),
              const _BulletPoint(
                text:
                    "Ou si aucun représentant légal n’a pu être joint malgré des efforts raisonnables / identité inconnue.",
              ),
              const _BulletPoint(
                text:
                    "Ou si cela compromet significativement la procédure (ex : parents impliqués).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Dans ces cas, un adulte approprié peut être désigné par le mineur (personne majeure acceptée par l’enquêteur) ou par le magistrat. L’enquêteur ne peut pas désigner lui-même un adulte approprié.",
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
