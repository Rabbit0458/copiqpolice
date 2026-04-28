import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVPlainteGeneralitesPage extends StatelessWidget {
  const PVPlainteGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/plainte/generalites';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMethod = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRights = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardProtect = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
          "Plainte",
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
            "Généralités — prise de plainte",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les officiers et agents de police judiciaire sont tenus de recevoir les plaintes, y compris lorsqu’elles sont déposées dans un service territorialement incompétent. — ",
                ),
                TextSpan(
                  text: "article 15-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Tout dépôt de plainte fait l’objet d’un procès-verbal et donne lieu à la délivrance immédiate d’un récépissé à la victime ; une copie peut être remise à sa demande.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La plainte est l’acte par lequel la personne victime d’un crime, d’un délit ou d’une contravention porte les faits à la connaissance de l’autorité compétente.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle peut être déposée contre X (auteur non identifié) ou contre personne dénommée (auteur connu de la victime).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Généralités / méthode
          _ConditionCard(
            title: "II — Généralités (méthode)",
            cardColor: cardMethod,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le policier ne doit pas se contenter de retranscrire les déclarations : il doit faire ressortir les éléments utiles permettant de diligenter une enquête et de qualifier les faits.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Ce qu’il faut faire apparaître clairement"),
              const _BulletPoint(
                text:
                    "Situer les faits dans le temps et l’espace (date/heure, lieu précis).",
              ),
              const _BulletPoint(
                text:
                    "Déterminer le cadre juridique de l’enquête (flagrance ou préliminaire).",
              ),
              const _BulletPoint(
                text:
                    "Permettre un éventuel transport sur les lieux (constatations, traces, témoins).",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Déterminer les faits et agissements de chaque acteur (rôle précis).",
              ),
              const _BulletPoint(
                text:
                    "Qualifier l’infraction (rendre visibles les éléments constitutifs : matériel et moral).",
              ),
              const _BulletPoint(text: "Préciser le mode opératoire."),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Décrire précisément les éléments utiles (objets volés, véhicules, signalements, tenues).",
              ),
              const _BulletPoint(
                text: "Enregistrer le préjudice subi par la victime.",
              ),
              const _BulletPoint(
                text:
                    "Prendre en compte les objets/documents remis (factures, captures, certificats, messages…).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Objectif : une plainte exploitable immédiatement (qualification, pistes d’enquête, actes à réaliser, éléments de preuve à préserver).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Droits des victimes
          _ConditionCard(
            title: "III — Droits des victimes d’infraction",
            cardColor: cardRights,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lors de la prise de plainte, l’APJ doit accorder une attention particulière aux victimes et garantir la confidentialité des déclarations. — ",
                ),
                TextSpan(
                  text: "article R. 434-20 du Code de la sécurité intérieure",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("A) Information de la victime"),
              _Paragraph.rich([
                const TextSpan(
                  text: "L’agent informe la victime de ses droits. — ",
                ),
                TextSpan(
                  text: "article 10-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Obtenir réparation de son préjudice."),
              const _BulletPoint(
                text:
                    "Se constituer partie civile et être assistée, si elle le souhaite, d’un avocat.",
              ),
              const _BulletPoint(
                text:
                    "Être aidée par un service/association agréée d’aide aux victimes (coordonnées actualisées).",
              ),
              _BulletPoint(
                text:
                    "Saisir la commission d’indemnisation des victimes d’infraction (CIVI) selon les cas.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Notamment lorsque l’infraction est visée aux ",
                ),
                TextSpan(
                  text: "articles 706-3",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ou "),
                TextSpan(
                  text: "706-14",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " du Code de procédure pénale."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Être informée des mesures de protection possibles.",
              ),
              const _BulletPoint(
                text:
                    "Être informée des peines encourues et des conditions d’exécution des condamnations (si applicable).",
              ),
              const _BulletPoint(
                text:
                    "Bénéficier, le cas échéant, d’un interprète et d’une traduction des informations indispensables.",
              ),
              const _BulletPoint(
                text:
                    "Être accompagnée à tous les stades par son représentant légal et par la personne majeure de son choix (y compris un avocat), sauf décision contraire motivée.",
              ),
              const _BulletPoint(
                text:
                    "Déclarer comme domicile l’adresse d’un tiers (avec accord exprès) ; certaines victimes peuvent déclarer leur adresse professionnelle selon les conditions prévues.",
              ),
              const _BulletPoint(
                text:
                    "Recevoir le certificat d’examen médical lorsqu’un examen a été requis par OPJ ou magistrat (selon conditions).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Cette information peut être donnée par tout moyen, notamment via un formulaire d’information (LRPPN).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mesures de protection générales + évaluation
          _ConditionCard(
            title: "IV — Mesures de protection",
            cardColor: cardProtect,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Mesures générales"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Interprète si la victime ne comprend pas le français. — ",
                ),
                TextSpan(
                  text: "article 10-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Accompagnement à tous les stades, notamment lors des auditions, par le représentant légal et une personne majeure de son choix (y compris un avocat), sauf décision contraire motivée. — ",
                ),
                TextSpan(
                  text: "article 10-4 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Pratique (avocat)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si la victime est accompagnée d’un avocat, celui-ci n’intervient pas pendant l’audition : il attend la fin pour poser des questions. Les questions/réponses sont retranscrites au PV ; des observations écrites peuvent être annexées.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Évaluation personnalisée"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Une évaluation personnalisée est mentionnée au PV afin de déterminer la nécessité de mesures spéciales de protection. — ",
                ),
                TextSpan(
                  text: "article 10-5 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Importance du préjudice subi."),
              const _BulletPoint(
                text: "Circonstances de commission de l’infraction.",
              ),
              const _BulletPoint(
                text: "Vulnérabilité particulière de la victime.",
              ),
              const _BulletPoint(
                text: "Risque d’intimidation ou de représailles.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Une évaluation approfondie peut être réalisée par une association conventionnée, sur décision du procureur de la République ou du juge d’instruction. — ",
                ),
                TextSpan(
                  text: "article D. 1-9 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("C) Mesures spécifiques (cas fréquents)"),

              _Paragraph.rich([
                TextSpan(
                  text:
                      "Mineur victime d’un crime ou d’un délit — article 706-53 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Peut être accompagné (à sa demande) : représentant légal, personne majeure de son choix, association d’aide aux victimes.",
              ),
              const _BulletPoint(
                text:
                    "Peut dénoncer seul les faits : une enquête peut être diligentée même sans plainte du représentant légal (si discernement suffisant).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Après examen médical d’un mineur : le médecin peut refuser de remettre une copie aux représentants légaux si cela est contraire à l’intérêt supérieur de l’enfant ou si le mineur (maturité suffisante) refuse. — ",
                  ),
                  TextSpan(
                    text: "article D1-12 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Mineur victime d’infraction à caractère sexuel : enregistrement audiovisuel obligatoire pour certaines infractions. Référence : ",
                ),
                TextSpan(
                  text: "article 706-47 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (liste), et "),
                TextSpan(
                  text: "article 706-52 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (règles d’enregistrement)."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Même si l’audition est filmée, un PV d’audition / d’entretien est rédigé.",
              ),
              const _BulletPoint(
                text:
                    "L’enregistrement peut être exclusivement sonore sur décision du procureur ou du juge si l’intérêt du mineur le justifie.",
              ),
              const _BulletPoint(
                text:
                    "Préférence pour services spécialisés (méthodologie + formation).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Situations particulières (rappels opérationnels)",
              ),
              const _BulletPoint(
                text:
                    "Victime transgenre : accueillir d’abord selon l’apparence, puis selon le genre déclaré ; dans le PV, utiliser civilité/prénom choisis, tout en mentionnant l’identité officielle dans les rubriques d’identité du LRPPN.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Victime de violences conjugales : la prise en charge n’est pas conditionnée à un certificat médical ; orienter vers les services spécialisés si possible ; avis hiérarchie + parquet ; réquisition d’examen médical (blessures + retentissement psychologique).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Bracelet anti-rapprochement",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Lors du dépôt de plainte, informer la victime éligible qu’elle peut demander un bracelet anti-rapprochement. — ",
                  ),
                  TextSpan(
                    text: "article 15-3-2 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; mesure prévue par "),
                  TextSpan(
                    text: "article 138-3 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("E) Mesures pratiques de sécurité"),
              const _BulletPoint(
                text:
                    "Aider à trouver un hébergement d’urgence si retour au domicile impossible (115 / dispositifs locaux).",
              ),
              const _BulletPoint(
                text:
                    "Assistance possible pour récupérer des effets personnels au domicile (selon disponibilité opérationnelle).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "À penser",
                bodySpans: [
                  const TextSpan(
                    text:
                        "En violences conjugales, procéder aux consultations utiles (TAJ, MCI, FPR, base locale LRPPN, fichiers armes selon procédures en vigueur) et envisager la saisie des armes si nécessaire.",
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
