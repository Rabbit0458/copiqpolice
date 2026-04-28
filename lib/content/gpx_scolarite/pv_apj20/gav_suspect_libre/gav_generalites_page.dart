import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GavGeneralitesPage extends StatelessWidget {
  const GavGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/gav_suspect_libre/gav_generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards (lisible, propre)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardObjectives = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDuration = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNotification = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRights = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardProtectedAdult = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color cardMinor = isDark
        ? const Color(0xFF1F2B33)
        : const Color(0xFFF2FBFF);

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
          "Garde à vue",
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
            "Notification du placement en garde à vue\net des droits par un A.P.J.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "À retenir",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "La décision de placer en garde à vue relève exclusivement de l’O.P.J.",
              ),
              _IntroBullet(
                text:
                    "Le gardien de la paix (A.P.J.) peut notifier le placement en G.A.V. et les droits, sous le contrôle de l’O.P.J.",
              ),
              _IntroBullet(
                text:
                    "Le contrôle de l’O.P.J. n’implique pas forcément sa présence physique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: "I — Élément légal (placement en garde à vue)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 62-2 alinéa 1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : fixe les conditions et les objectifs justifiant une garde à vue (crimes/délits punis d’emprisonnement).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Impossible de placer en garde à vue pour une contravention ou pour un délit puni uniquement d’une amende. Référence : ",
                  ),
                  TextSpan(
                    text: "article 62-2 alinéa 1 C.P.P.",
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
            title: "II — Généralités",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Personnes concernées"),
              _Paragraph(
                "Seules peuvent être placées en garde à vue les personnes à l’encontre desquelles il existe une ou plusieurs raisons plausibles de soupçonner "
                "qu’elles ont commis ou tenté de commettre un crime ou un délit puni d’une peine d’emprisonnement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Objectifs visés",
            cardColor: cardObjectives,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La garde à vue doit être l’unique moyen de parvenir à au moins un des objectifs suivants (",
                ),
                TextSpan(
                  text: "article 62-2 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ") :"),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Permettre l’exécution des investigations impliquant la présence ou la participation de la personne.",
              ),
              const _BulletPoint(
                text:
                    "Garantir la présentation de la personne devant le procureur de la République (suite à donner à l’enquête).",
              ),
              const _BulletPoint(
                text:
                    "Empêcher la modification des preuves ou indices matériels.",
              ),
              const _BulletPoint(
                text:
                    "Empêcher des pressions sur témoins/victimes, famille ou proches.",
              ),
              const _BulletPoint(
                text: "Empêcher la concertation avec coauteurs ou complices.",
              ),
              const _BulletPoint(
                text:
                    "Garantir la mise en œuvre de mesures destinées à faire cesser l’infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Durée de la garde à vue (droit commun)",
            cardColor: cardDuration,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La durée initiale de la garde à vue de droit commun est fixée à 24 heures.\n"
                "Le point de départ coïncide avec le moment où la personne est privée de liberté.",
              ),
              const SizedBox(height: 10),
              _SubTitle("Prolongation (24 h supplémentaires max.)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Une prolongation peut être autorisée par le procureur de la République, sur demande de l’O.P.J., pour une durée maximale de 24 heures, lorsque : ",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "L’infraction est un crime ou un délit puni d’une peine d’emprisonnement ≥ 1 an.",
              ),
              _BulletPoint(
                text:
                    "La mesure est l’unique moyen de parvenir à au moins un objectif prévu par l’article 62-2 C.P.P. (ou de permettre la présentation devant l’autorité judiciaire lorsque les locaux adaptés n’existent pas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Notification de la G.A.V. et des droits",
            cardColor: cardNotification,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La personne placée en garde à vue est immédiatement informée de son placement en garde à vue et des droits y étant attachés par un O.P.J. ou par un A.P.J. sous le contrôle d’un O.P.J. (",
                ),
                TextSpan(
                  text: "article 63-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le contrôle de l’O.P.J. n’implique pas nécessairement sa présence physique. En revanche, l’O.P.J. doit aviser le procureur dès le début de la mesure et rédiger le PV d’avis à parquet.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("A) Information sur la mesure"),
              _Paragraph.rich([
                const TextSpan(text: "Au titre de l’"),
                TextSpan(
                  text: "article 63-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", la personne est informée :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "De son placement en garde à vue, de la durée de la mesure et des éventuelles prolongations.",
              ),
              const _BulletPoint(
                text:
                    "De l’infraction reprochée : qualification, date et lieu présumés.",
              ),
              _BulletPoint(
                text:
                    "Des motifs justifiant la mesure : au moins un objectif de l’article 62-2 C.P.P.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VI — Information sur les droits",
            cardColor: cardRights,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Un document énonçant les droits est remis à la personne gardée à vue. "
                "Elle est autorisée à conserver ce document pendant toute la durée de privation de liberté.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("1) Droit de faire prévenir"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 63-2 I C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : avis possible à :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "La personne avec laquelle elle vit habituellement, ou un parent en ligne directe, ou un frère/une sœur, ou toute autre personne désignée.",
              ),
              const _BulletPoint(text: "Son employeur."),
              const _BulletPoint(
                text:
                    "Les autorités consulaires (si la personne est de nationalité étrangère).",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ces avis doivent intervenir au plus tard dans un délai de trois heures à compter de la demande, sauf circonstances insurmontables (mention au PV). Ils peuvent être différés ou refusés par le procureur, sur demande de l’O.P.J., si indispensable pour les objectifs de l’enquête ou pour prévenir une atteinte grave.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) Droit de communiquer"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 63-2 II C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : communication avec un tiers (avisable) si compatible avec les objectifs de l’enquête.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Modalités : écrit / téléphone / entretien (au choix de l’enquêteur).",
              ),
              const _BulletPoint(
                text:
                    "Durée maximale : 30 minutes, sous contrôle de l’O.P.J./A.P.J. (éventuellement en présence).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("3) Droit à un examen médical"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 63-3 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Demandé par la personne gardée à vue."),
              const _BulletPoint(
                text: "Ou désigné d’office par le procureur ou l’O.P.J.",
              ),
              const _BulletPoint(
                text:
                    "De droit si un membre de la famille / la personne prévenue le demande (même sans demande du gardé à vue).",
              ),
              const _BulletPoint(
                text: "Possible un second examen en cas de prolongation.",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: "Vidéotransmission possible sous conditions (",
                ),
                TextSpan(
                  text: "article 63-3 alinéa 5 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La personne ne peut pas être contrainte à l’examen : en cas de refus, mention en procédure. Les diligences doivent intervenir au plus tard dans les 3 heures suivant la demande (sauf circonstances insurmontables).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("4) Droit à l’assistance d’un avocat"),
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 63-3-1 à 63-4-3 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : la personne est avisée dès le début de la mesure qu’elle peut être assistée par un avocat.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Désignation : avocat choisi ou commis d’office.",
              ),
              const _BulletPoint(
                text:
                    "Changement d’avis possible à tout moment (même après un refus initial).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Contenu du droit"),
              const _BulletPoint(text: "Entretien confidentiel de 30 minutes."),
              _BulletPoint(
                text:
                    "Consultation de certains PV (notification GAV/droits, certificat médical, PV d’audition/confrontation).",
              ),
              const _BulletPoint(text: "Aucune copie des documents consultés."),
              const _BulletPoint(
                text:
                    "Assistance aux auditions/confrontations (questions possibles à l’issue).",
              ),
              _BulletPoint(
                text: "Observations écrites possibles, jointes à la procédure.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Possibilité d’audition/confrontation immédiate sur décision écrite et motivée du procureur, si indispensable (prévenir atteinte grave ou éviter compromission sérieuse). Références : ",
                ),
                TextSpan(
                  text: "article 63-4-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "5) Droit d’être informée dans une langue comprise",
              ),
              const _Paragraph(
                "Recours à un interprète si doute sur la capacité à parler/comprendre le français, notamment pour les personnes de nationalité étrangère. "
                "Interprète possible à distance (télécommunication sonore ou audiovisuelle).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("6) Droit de consulter certaines pièces"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 63-4-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : consultation dans les meilleurs délais et au plus tard avant une éventuelle prolongation :",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "PV de notification du placement en G.A.V. et des droits.",
              ),
              const _BulletPoint(text: "Certificat médical."),
              const _BulletPoint(
                text: "PV d’audition et de confrontation de la personne.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("7) Droit de présenter des observations"),
              const _Paragraph(
                "La personne est informée qu’elle peut présenter des observations au procureur de la République "
                "ou, le cas échéant, au juge des libertés et de la détention lors d’une demande de prolongation.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("8) Droit au silence"),
              const _Paragraph(
                "La personne est informée qu’elle peut faire des déclarations, répondre aux questions ou se taire. "
                "Le droit au silence ne s’applique pas à la déclaration d’identité (état civil). "
                "Le silence n’interrompt pas l’audition : l’enquêteur peut poser des questions, actées en procédure.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VII — Le majeur protégé",
            cardColor: cardProtectedAdult,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsqu’un majeur est placé en garde à vue, il faut lui demander s’il fait l’objet d’une mesure de protection juridique (tutelle, curatelle, sauvegarde de justice) (",
                ),
                TextSpan(
                  text: "article D. 15-5-7 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Garanties supplémentaires"),
              _BulletPoint(text: "Avis au tuteur/curateur/mandataire spécial."),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article 706-112-1 C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (délai : 6 heures à compter du moment où l’existence de la mesure apparaît, sauf circonstances insurmontables).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Rôle possible du tuteur/curateur/mandataire (avocat/médecin/communication) : ",
                ),
                TextSpan(
                  text: "article D. 47-14 C.P.P.",
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
                  const TextSpan(
                    text:
                        "Si la personne n’a pas demandé d’avocat ou de médecin, le tuteur/curateur/mandataire spécial peut (dans les conditions prévues) solliciter ces diligences.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VIII — Le mineur gardé à vue",
            cardColor: cardMinor,
            accent: accentCyan,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Selon l’âge, les mineurs de 10 à 18 ans peuvent être placés en retenue ou en garde à vue. "
                "En dessous de 10 ans, aucune mesure de rétention n’est possible.\n\n"
                "Dans ce module, les règles relatives aux mineurs sont présentées sous forme de tableaux (retour sommaire).",
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
