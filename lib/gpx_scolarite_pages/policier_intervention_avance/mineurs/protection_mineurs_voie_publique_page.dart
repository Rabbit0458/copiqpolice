import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProtectionMineursVoiePubliquePage extends StatelessWidget {
  const ProtectionMineursVoiePubliquePage({super.key});

  static const String routeName = '/gpx/intervention/mineurs/voie-publique';

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
    final Color cardOps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRisk = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardAmber = isDark
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
            "La protection des mineurs sur la voie publique",
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
            title: "Finalité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les gardiens de la paix assurant la surveillance de la voie publique peuvent être amenés "
                "à assurer des missions particulières visant la protection physique et morale des mineurs.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Objectif : protéger le mineur, prévenir les risques et orienter vers les services compétents.",
              ),
              _IntroBullet(
                text:
                    "Réflexe : identifier, sécuriser, informer/aviser, tracer (main courante / PV / rapport).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Base légale en haut
          _ConditionCard(
            title: "Références essentielles (cadre légal)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Obligation scolaire : l’instruction est obligatoire pour les enfants (français et étrangers) entre 3 et 16 ans. ",
                ),
                TextSpan(
                  text: "Article L. 131-1 du Code de l’éducation",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Mendicité avec mineur de moins de 6 ans : ",
                ),
                TextSpan(
                  text: "article 227-15 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Disparition inquiétante / mineur en fugue : actes d’enquête possibles selon ",
                ),
                TextSpan(
                  text: "l’article 74-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (perquisitions, saisies, réquisitions, auditions… mais pas de GAV).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I — Obligation scolaire
          _ConditionCard(
            title: "I — Obligation scolaire (mineur sur la voie publique)",
            cardColor: cardOps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsqu’un enfant d’âge scolaire se trouve sur la voie publique durant les heures de classe sans motif légitime, "
                      "le policier adopte une conduite simple, protectrice et traçable. (",
                ),
                TextSpan(
                  text: "art. L. 131-1 du Code de l’éducation",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")"),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Conduite à tenir (réflexe opérationnel)"),
              const _BulletPoint(
                text:
                    "Relever l’identité du mineur, sans oublier la filiation.",
              ),
              const _BulletPoint(
                text:
                    "Le conduire dans l’établissement scolaire où il est inscrit.",
              ),
              const _BulletPoint(text: "Aviser la brigade des mineurs."),
              const _BulletPoint(text: "Rédiger une mention de main courante."),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le but n’est pas de sanctionner sur place, mais de protéger et de remettre le mineur dans un cadre normal "
                        "tout en assurant une traçabilité complète de l’intervention.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Racket scolaire
          _ConditionCard(
            title: "II — Racket scolaire",
            cardColor: cardRisk,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le racket relève de l’extorsion, prévue et réprimée par ",
                ),
                TextSpan(
                  text: "les articles 312-1 à 312-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’usage de la violence ou des menaces pour obtenir de l’argent, un objet ou un service est une forme de délinquance "
                "fréquente en milieu scolaire. Les victimes hésitent souvent à parler par peur de représailles.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Points d’attention terrain"),
              const _BulletPoint(
                text:
                    "Chaque signalement mérite une attention particulière, même si le préjudice est faible.",
              ),
              const _BulletPoint(
                text:
                    "Observation aux abords des établissements : repérer les plus âgés attendant les plus jeunes aux heures de sortie.",
              ),
              const _BulletPoint(
                text:
                    "Prioriser la protection de la victime + recueil d’éléments (témoignages, descriptions, lieux, horaires).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Mendicité
          _ConditionCard(
            title: "III — Mendicité impliquant un mineur",
            cardColor: cardAmber,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-15 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réprime le fait de maintenir un enfant de moins de 6 ans sur la voie publique ou dans un espace affecté "
                      "au transport collectif de voyageurs afin de solliciter la générosité des passants.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Peines",
                bodySpans: [
                  const TextSpan(
                    text: "7 ans d’emprisonnement et 100 000 € d’amende.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "En présence d’un très jeune enfant exposé sur la voie publique, l’approche doit rester prioritairement protectrice : "
                "mise à l’abri, évaluation immédiate du danger, et saisine/avis des services compétents.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Couvre-feu
          _ConditionCard(
            title: "IV — Interdiction d’aller et venir la nuit (couvre-feu)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le « couvre-feu » est une mesure limitant la liberté d’aller et venir des mineurs sur la voie publique "
                "entre 23h et 6h. Elle ne s’applique pas aux mineurs accompagnés d’un parent ou d’un titulaire de l’autorité parentale.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Deux cadres possibles"),
              _Paragraph.rich([
                const TextSpan(
                  text: "• Cadre judiciaire (sanction éducative 13–18 ans) : ",
                ),
                TextSpan(
                  text:
                      "article L. 112-2 du Code de la justice pénale des mineurs",
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
                  text: "• Cadre administratif (arrêté général < 13 ans) : ",
                ),
                TextSpan(
                  text: "article L. 132-8 du Code de la sécurité intérieure",
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

          // V — Cinéma / spectacle
          _ConditionCard(
            title: "V — Accès aux salles de cinéma et de spectacle",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’accès aux salles de cinéma peut être interdit aux mineurs de 18, 16 ou 12 ans selon les films projetés. "
                "Le gérant doit afficher l’interdiction aux guichets de délivrance des billets (le manquement constitue une contravention de 5e classe).",
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "Le préfet peut également interdire l’accès des mineurs à certains établissements offrant des spectacles "
                "ou dont la fréquentation est susceptible d’exercer une mauvaise influence sur la santé ou la moralité de la jeunesse "
                "(ex : pornographique/violent, risque de rixes…). Une affiche doit être apposée aux accès ; le non-respect est puni d’une contravention de 5e classe.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Prostitution des mineurs
          _ConditionCard(
            title: "VI — Prostitution des mineurs",
            cardColor: cardRisk,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Tout mineur se livrant à la prostitution est réputé en danger : son suivi relève du juge des enfants.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le recours à la prostitution d’un mineur est interdit : ",
                ),
                TextSpan(
                  text: "article 225-12-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La mise à disposition d’un mineur à un tiers pour permettre la commission de proxénétisme est aussi un délit : ",
                ),
                TextSpan(
                  text: "article 225-4-1",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article 225-4-2 (1°) du Code pénal",
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
                        "Réflexe terrain : mise en sécurité immédiate, évaluation du danger, et signalement/coordination avec les services spécialisés.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VII — Fugue (cadre)
          _ConditionCard(
            title: "VII — Fugues (périmètre)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les mesures relatives aux mineurs en fugue concernent en principe tous les mineurs de 18 ans, sauf :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Les mineurs émancipés âgés d’au moins 16 ans.",
              ),
              _BulletPoint(
                text:
                    "Les jeunes adultes de 18 à 21 ans placés par décision d’une juridiction pour enfants (assimilés à des mineurs en matière de fugue).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VIII — Mineur en fugue (prise en charge)
          _ConditionCard(
            title: "VIII — Le mineur en fugue",
            cardColor: cardOps,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Déclaration / disparition inquiétante"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La fugue d’un mineur doit toujours être considérée comme une disparition inquiétante et traitée comme telle, "
                      "même si elle paraît volontaire ou habituelle. ",
                ),
                TextSpan(
                  text: "Article 26 de la loi n° 95-73 du 21 janvier 1995",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (modifiée) : une disparition apparemment banale peut aboutir à un drame.",
                ),
              ]),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Sur instructions du procureur, les OPJ/APJ peuvent réaliser les actes des ",
                ),
                TextSpan(
                  text: "articles 56 à 62 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " pour découvrir la personne (perquisitions, saisies, réquisitions, auditions).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Dans ce cadre, les enquêteurs ne peuvent pas décider d’une mesure de garde à vue. "
                        "Les dispositions sont prévues par ",
                  ),
                  TextSpan(
                    text: "l’article 74-1 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "Informations à recueillir lors de la déclaration",
              ),
              const _BulletPoint(
                text:
                    "Identité + filiation, lieu de résidence des parents (si différent), photographie si possible.",
              ),
              const _BulletPoint(
                text:
                    "Signalement descriptif : âge réel/apparent, tenue, signes particuliers…",
              ),
              const _BulletPoint(text: "Situation scolaire."),
              const _BulletPoint(
                text:
                    "Effets emportés (sac, téléphone, argent, agenda…), derniers lieux, fréquentations.",
              ),
              const _BulletPoint(
                text:
                    "Moyen de locomotion éventuel (vélo, scooter…), fugues antérieures.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Certaines vérifications (voisins, camarades…) peuvent être lancées en parallèle par un autre fonctionnaire.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text: "Inscription systématique du mineur au F.P.R.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Découverte du mineur : prise en charge"),
              const _Paragraph(
                "La prise en charge d’un fugueur n’est pas une interpellation : c’est une mesure de protection. "
                "Le mineur doit être conduit au service, la brigade des mineurs doit être avisée, et ses directives suivies.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Précautions",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Placer le mineur dans un endroit neutre. Éviter les scènes violentes, la proximité de gardés à vue, "
                        "ou toute situation impressionnante pour un enfant.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Rédiger un rapport d’intervention / PV relatant les circonstances de la découverte.",
              ),
              const _BulletPoint(
                text: "Effectuer la cessation de recherches au F.P.R.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le magistrat doit obligatoirement être informé : l’adresse d’un mineur disparu ne peut être communiquée "
                      "au représentant légal qu’avec l’autorisation du juge des enfants. (",
                ),
                TextSpan(
                  text:
                      "article 26 de la loi du 21 janvier 1995 modifié par l’article 66 de la loi n° 2002-1138 du 9 septembre 2002",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")"),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Le mineur ne quitte les locaux que sous la conduite de ses parents ou d’une personne responsable.",
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
