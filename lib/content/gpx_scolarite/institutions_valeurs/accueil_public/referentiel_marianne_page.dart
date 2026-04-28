import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferentielMariannePage extends StatelessWidget {
  const ReferentielMariannePage({super.key});

  static const String routeName = '/gpx/institution/accueil_public/marianne';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCharte = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRef = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMesures = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDelais = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardBonnesPratiques = isDark
        ? const Color(0xFF202633)
        : const Color(0xFFF3F6FF);

    // ✅ Nouvelles cartes ajoutées (Discri / Harcèlement / Victimes)
    final Color cardDiscriIntro = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFEAF2FF);
    final Color cardDiscriDef = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFEFFAF2);
    final Color cardHarcDef = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF0F7);
    final Color cardCellule = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF6E0);
    final Color cardSanctions = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardVictimes = isDark
        ? const Color(0xFF202633)
        : const Color(0xFFF3F6FF);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
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
          "Accueil du public",
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
            "De la charte d’accueil du public\nau référentiel Marianne",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Idée générale",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La charte Marianne formalise des engagements simples de qualité d’accueil. "
                "Le référentiel Marianne prolonge cette logique sous forme de certification, avec des exigences "
                "mesurables et un suivi interne.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Charte Marianne
          _ConditionCard(
            title: "I — La charte Marianne",
            cardColor: cardCharte,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Adoptée par plus de 2 000 services publics, la charte Marianne décline des critères "
                "d’engagement garantissant la qualité de l’accueil, qu’il soit physique, par téléphone, "
                "par courrier ou par courriel.",
              ),
              SizedBox(height: 12),
              _SubTitle("Engagements clés"),
              _IntroBullet(
                text: "Faciliter l’accès des usagers dans les services.",
              ),
              _IntroBullet(
                text:
                    "Accueillir les usagers de manière attentive et courtoise.",
              ),
              _IntroBullet(
                text:
                    "Répondre de manière compréhensible et dans un délai annoncé.",
              ),
              _IntroBullet(text: "Traiter systématiquement les réclamations."),
              _IntroBullet(
                text:
                    "Recueillir les propositions des usagers pour améliorer la qualité du service public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Référentiel Marianne (certification)
          _ConditionCard(
            title: "II — Le référentiel Marianne",
            cardColor: cardRef,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dans le prolongement de la charte, le référentiel Marianne est une certification "
                "de la qualité de l’accueil, délivrée par un organisme indépendant.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il comprend 19 engagements structurés en 6 rubriques : les 5 premières reprennent "
                "les critères de la charte et engagent directement les services vis-à-vis des usagers ; "
                "la dernière est dédiée au pilotage et au suivi interne des exigences de qualité.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Dans la Police nationale",
                bodySpans: [
                  TextSpan(
                    text:
                        "La charte d’accueil du public et d’assistance aux victimes reste le texte de référence. "
                        "Toutefois, des mesures permettent de répondre aux engagements du référentiel Marianne.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mesures concrètes
          _ConditionCard(
            title: "Mesures concrètes dans les services de police",
            cardColor: cardMesures,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Évaluation externe"),
              _Paragraph(
                "Des « enquêtes mystère » (ou contrôles inopinés) peuvent être diligentées par les services "
                "de contrôle du ministère de l’Intérieur (DNSP, IGPN, etc.). Elles prennent la forme "
                "d’appels téléphoniques ou de visites à l’accueil des commissariats/bureaux de police.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Objectif : obtenir une appréciation extérieure de la qualité de l’accueil dans les services.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Délais du référentiel
          _ConditionCard(
            title: "Délais de réponse attendus (référentiel)",
            cardColor: cardDelais,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Téléphone"),
              _BulletPoint(
                text:
                    "Prise en charge en moins de 5 sonneries (agent ou serveur vocal interactif).",
              ),
              SizedBox(height: 10),
              _SubTitle("Courrier électronique"),
              _BulletPoint(
                text:
                    "Première réponse sous 5 jours ouvrés : réponse sur le fond OU réponse d’attente indiquant le délai prévisionnel.",
              ),
              _BulletPoint(
                text:
                    "Accusé de réception électronique adressé systématiquement suite à toute sollicitation.",
              ),
              SizedBox(height: 10),
              _SubTitle("Courrier postal"),
              _BulletPoint(
                text:
                    "Traitement sous 15 jours ouvrés (si délai non tenu : réponse d’attente indiquant le délai prévisionnel).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bonnes pratiques / adaptation
          _ConditionCard(
            title: "Exigences de qualité (attitude & accessibilité)",
            cardColor: cardBonnesPratiques,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les agents doivent être sensibilisés à l’accueil des personnes en difficulté "
                "(handicap, âge, état d’anxiété, non-maîtrise de la langue française…) et adapter "
                "leur comportement selon la difficulté perçue.",
              ),
              SizedBox(height: 10),
              _SubTitle("Points de vigilance"),
              _BulletPoint(
                text:
                    "Adapter le langage : réponses compréhensibles et accessibles au destinataire.",
              ),
              _BulletPoint(
                text:
                    "Mentionner les références de l’agent chargé du dossier (quand c’est prévu/possible).",
              ),
              _BulletPoint(
                text:
                    "Faciliter l’accomplissement des démarches pour les personnes à mobilité réduite.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Récap express
          _ConditionCard(
            title: "Synthèse (mémo rapide)",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Charte Marianne : engagements de qualité d’accueil (physique, téléphone, courrier, e-mail).",
              ),
              _BulletPoint(
                text:
                    "Référentiel Marianne : certification indépendante + exigences mesurables + suivi interne.",
              ),
              _BulletPoint(
                text:
                    "Police : la charte accueil du public/victimes reste la référence, mais des mesures permettent d’atteindre les engagements du référentiel.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // /////////////////////////////////////////////////////////////////////////////
          // //////////////////////  AJOUT — DISCRIMINATION / HARCELEMENT  //////////////
          // /////////////////////////////////////////////////////////////////////////////
          _ConditionCard(
            title: "Discrimination & harcèlement : en parler, c’est agir",
            cardColor: cardDiscriIntro,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Ces supports institutionnels rappellent les définitions, les démarches possibles "
                "et les dispositifs d’écoute et de signalement du ministère de l’Intérieur.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Source",
                bodySpans: [
                  const TextSpan(text: "Affiches et flyers (kit graphique) — "),
                  const TextSpan(
                    text: "egalite-diversite.interieur.ader.gouv.fr",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Référence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "INSTITUTIONS ET VALEURS / Retour Sommaire 130 — Mis à jour le 13/03/2025.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Témoins : que faire ?
          _ConditionCard(
            title: "Vous êtes témoin direct",
            cardColor: cardBonnesPratiques,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Si vous êtes témoin direct d’une situation de discrimination sur votre lieu de travail, vous pouvez :",
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Rendre compte à votre hiérarchie."),
              _BulletPoint(
                text:
                    "Signaler les faits aux interlocuteurs mentionnés (cellules d’écoute), si toute démarche auprès de votre hiérarchie a été rejetée et en l’absence d’initiative de la part de la victime.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Auteurs : sanctions
          _ConditionCard(
            title: "Vous êtes auteur : sanctions possibles",
            cardColor: cardSanctions,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Sanctions pénales"),
              const _BulletPoint(
                text:
                    "Discrimination : 3 ans d’emprisonnement et 45 000 € d’amende.",
              ),
              const _BulletPoint(
                text:
                    "Harcèlement moral : 2 ans de prison et 30 000 € d’amende.",
              ),
              const _BulletPoint(
                text:
                    "Harcèlement sexuel : 2 à 3 ans de prison et 30 000 € à 45 000 € d’amende.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Sanctions disciplinaires"),
              const _BulletPoint(
                text:
                    "Après étude du dossier et selon la gravité : jusqu’à la radiation des cadres ou la révocation.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Mesures administratives"),
              const _BulletPoint(text: "Suspension de fonction."),
              const _BulletPoint(text: "Mutation dans l’intérêt du service."),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: const [
                  TextSpan(text: "Référence document : @SICoP/2017."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cellule d'écoute : définition + phases
          _ConditionCard(
            title: "Qu’est-ce qu’une cellule d’écoute et de signalement ?",
            cardColor: cardCellule,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Communément appelés « cellules d’écoute », les dispositifs d’alerte et de signalement "
                "ont pour vocation d’écouter, analyser la situation et aider les agents à trouver une solution "
                "pour mettre fin aux pratiques discriminatoires et de harcèlement.",
              ),
              SizedBox(height: 12),
              _SubTitle("Les 4 phases du traitement"),
              _BulletPoint(text: "Recueil du signalement du déclarant."),
              _BulletPoint(text: "Entretien individuel avec le déclarant."),
              _BulletPoint(text: "Traitement par l’administration."),
              _BulletPoint(text: "Clôture du signalement."),
              SizedBox(height: 12),
              _NotaBox(
                title: "Confidentialité",
                bodySpans: [
                  TextSpan(
                    text:
                        "Soumises à des obligations de confidentialité et d’impartialité, les cellules peuvent être saisies par tout agent, "
                        "victime ou témoin (discrimination ou harcèlement moral/sexuel).",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Signalement anonyme",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les signalements anonymes (ou par un tiers) sont possibles, mais le traitement ne sera poursuivi "
                        "qu’avec l’accord de l’agent concerné.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définitions : discrimination / harcèlement
          _ConditionCard(
            title: "Définitions essentielles",
            cardColor: cardDiscriDef,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Qu’est-ce qu’une discrimination ?"),
              const _Paragraph(
                "C’est un traitement défavorable appliqué à une personne :",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Sur un des critères interdits par la loi (origine, sexe, orientation sexuelle, handicap, lieu de résidence… etc.).",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                TextSpan(
                  text: "article 225-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (énonce les critères de distinction constitutifs d’une discrimination).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Dans un domaine spécifié par la loi (ex. accès à l’emploi, sanctions disciplinaires, relations fournisseurs, etc.).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "À retenir",
                bodySpans: [
                  TextSpan(
                    text:
                        "Certaines différences de traitement sont prévues par la loi et ne constituent pas une discrimination "
                        "(ex. critère objectif de sélection pour un avancement).",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Qu’est-ce que le harcèlement ?"),
              _Paragraph.rich([
                TextSpan(
                  text: "Harcèlement moral : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-33-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article 6 quinquies de la loi n°83-634",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : propos ou comportements répétés ayant pour objet/effet une dégradation des conditions de travail "
                      "susceptible de porter atteinte aux droits et à la dignité, d’altérer la santé, ou de compromettre l’avenir professionnel.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Harcèlement sexuel : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: "article 222-33 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article 6 ter de la loi n°83-634",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : imposer de façon répétée des propos/comportements à connotation sexuelle "
                      "portant atteinte à la dignité (dégradant/humiliant) ou créant une situation intimidante, hostile ou offensante. "
                      "Peut aussi être constitué par une pression grave, même non répétée, pour obtenir un acte de nature sexuelle.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Que faire + cellules
          _ConditionCard(
            title: "Que faire en cas de discrimination ou de harcèlement ?",
            cardColor: cardHarcDef,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Premiers réflexes"),
              _BulletPoint(
                text:
                    "Solliciter un entretien avec sa hiérarchie de proximité.",
              ),
              _BulletPoint(
                text:
                    "Saisir un référent de proximité : référent RH local, assistant de prévention, référent diversité.",
              ),
              _BulletPoint(
                text:
                    "Demander un rendez-vous à l’assistant de service social ou au médecin de prévention.",
              ),
              SizedBox(height: 12),
              _SubTitle("Contacter une cellule d’écoute"),
              _BulletPoint(
                text:
                    "SIGNAL-DISCRI (Police nationale) : mail igpn-signal-discri@interieur.gouv.fr — tél. 01 86 21 55 55 — courrier IGPN, place Beauvau, 75800 Paris Cedex 08.",
              ),
              _BulletPoint(
                text:
                    "ALLO-DISCRI (Secrétariat général) : mail cellule-allo-discri@interieur.gouv.fr — tél. 01 80 15 33 00 — courrier Ministère de l’Intérieur, Place Beauvau, 75800 Paris Cedex 08.",
              ),
              _BulletPoint(
                text:
                    "STOP DISCRI (Gendarmerie nationale) : mail alerte-signalement@gendarmerie.interieur.gouv.fr — tél. 01 84 22 15 67 — courrier IGGN, 1 boulevard Henri Barbusse, 92240 Malakoff.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Victimes violences sexistes/sexuelles (fiche)
          _ConditionCard(
            title: "Victime de violences sexistes et sexuelles",
            cardColor: cardVictimes,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Une violence sexuelle peut être : un acte sexuel (avec ou sans pénétration) commis "
                "avec violence, contrainte, menace ou surprise, donc sans consentement. "
                "Aucune tenue, parole ou comportement (même sous alcool) ne justifie ces violences.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Déposer plainte (24h/24 – 7j/7)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les policiers ou gendarmes sont tenus de recevoir toutes les plaintes (",
                ),
                TextSpan(
                  text: "article 15-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Urgences & contacts essentiels"),
              const _BulletPoint(text: "En danger : 17 (Police/Gendarmerie)."),
              const _BulletPoint(text: "Depuis un portable : 112."),
              const _BulletPoint(
                text: "Pour personnes sourdes/malentendantes/muettes : 114.",
              ),
              const _BulletPoint(text: "Sapeurs-pompiers : 18."),
              const _BulletPoint(text: "Urgences médicales : 15."),
              const SizedBox(height: 12),
              const _SubTitle("Portail en ligne (tchat)"),
              const _BulletPoint(
                text:
                    "Signalement violences sexuelles et sexistes : 7j/7 24h/24 (service-public.fr / signalement-violences-sexuelles-sexistes.gouv.fr).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Numéro d’écoute"),
              const _BulletPoint(
                text:
                    "3919 : violences femmes info (appel gratuit et anonyme).",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Rappel",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Dans la procédure pénale, des mesures de protection peuvent être mises en place et la victime peut demander réparation "
                        "en se constituant partie civile.",
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
