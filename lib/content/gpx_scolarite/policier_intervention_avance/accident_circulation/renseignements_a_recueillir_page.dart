import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RenseignementsARecueillirPage extends StatelessWidget {
  const RenseignementsARecueillirPage({super.key});

  static const String routeName =
      '/gpx/intervention/accident-circulation/renseignements-a-recueillir';

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
    final Color cardLieux = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardVeh = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPers = isDark
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
          "Accident circulation",
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
            "Renseignements à recueillir (accident corporel)",
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
            title: "Objectif opérationnel",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Une procédure de constat d’accident est d’autant plus pertinente qu’elle repose sur "
                "des renseignements complets, recueillis méthodiquement dès que les lieux sont sécurisés.\n\n"
                "Ces éléments servent à :\n"
                "• comprendre les circonstances et facteurs présumés (lieux, véhicules, usagers, témoins),\n"
                "• alimenter la procédure, le plan accident (positions, traces, indices),\n"
                "• compléter le B.A.A.C. (bulletin d’analyse des accidents corporels).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre légal en haut (comme demandé)
          _ConditionCard(
            title: "Cadre légal (à connaître)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les policiers agissent notamment dans les conditions fixées par ",
                ),
                TextSpan(
                  text: "l’article 20 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ", pour rechercher et constater les infractions concernées.\n",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Infractions au code de la route et atteintes involontaires : ",
                ),
                TextSpan(
                  text: "article L. 130-3 du Code de la route",
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
                        "Après sécurisation : constatations + procédures adaptées (alcoolémie, stupéfiants, rétention du permis, etc.).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Lieux
          _ConditionCard(
            title: "I — Les lieux de l’accident",
            cardColor: cardLieux,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Localisation"),
              _BulletPoint(
                text:
                    "Commune : si la route est limite de deux communes → retenir celle où circulait l’usager présumé responsable.",
              ),
              _BulletPoint(text: "Agglomération ou hors agglomération."),
              _BulletPoint(
                text:
                    "Intersection (ou proximité) : rencontre d’au moins 2 voies. Proximité : < 50 m en agglomération, < 150 m hors agglomération.",
              ),
              _BulletPoint(
                text:
                    "Voie(s) : nature + nom (ex : avenue…), catégorie administrative + numéro (ex : RD1089).",
              ),
              _BulletPoint(
                text:
                    "Point de choc initial / sortie de route : numéro + voie, et/ou n° de route, coordonnées GPS, PK (autoroute) ou repère (PR hors autoroute).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Caractéristiques de la chaussée"),
              _BulletPoint(
                text:
                    "Régime : sens unique / bidirectionnelle, chaussées séparées (terre-plein/îlot), voie à affectation variable.",
              ),
              _BulletPoint(
                text:
                    "Nombre de voies : circulation générale + voies spéciales (pistes/bandes cyclables, couloirs bus/taxis, voies réservées, tram, covoiturage…).",
              ),
              _BulletPoint(
                text:
                    "Priorité : feux, priorité à droite, STOP, cédez-le-passage, route prioritaire, giratoire à feux, etc.",
              ),
              _BulletPoint(text: "Profil : plat, pente, sommet/bas de côte."),
              _BulletPoint(
                text: "Tracé : rectiligne, courbe gauche/droite, en S.",
              ),
              _BulletPoint(
                text:
                    "État de surface : sèche, mouillée, flaques, inondée, enneigée, boueuse, verglacée, corps gras/huile, dégradations (nid de poule, affaissement…).",
              ),
              _BulletPoint(
                text:
                    "Aménagements : tunnel/souterrain, pont, bretelle, voie ferrée (PN/tram), carrefour aménagé, zone piétonne, péage, chantier…",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Météo & luminosité"),
              _Paragraph(
                "Noter les conditions (éblouissement, pluie, neige, brouillard…) et la luminosité "
                "(aube, jour, crépuscule, nuit avec/sans éclairage public) : elles peuvent favoriser l’accident "
                "ou en aggraver les conséquences.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Véhicules
          _ConditionCard(
            title: "II — Véhicules impliqués",
            cardColor: cardVeh,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Typologie"),
              _BulletPoint(
                text:
                    "Accident sans collision : 1 seul véhicule sans choc (sortie de route simple, tonneau…).",
              ),
              _BulletPoint(
                text:
                    "Accident avec collision : obstacle fixe (arbre, glissière, bâtiment…) ou mobile (véhicule, piéton, animal…), ou collision entre véhicules (avant/arrière/côté), ou carambolage (chaîne / multiple).",
              ),
              SizedBox(height: 12),
              _SubTitle("Identification conventionnelle"),
              _Paragraph(
                "Pour la compréhension : chaque véhicule (y compris EDPM, cycle, véhicule en fuite) "
                "est identifié par une lettre (A → Z). La lettre A est attribuée au véhicule dont le conducteur "
                "est présumé responsable.",
              ),
              SizedBox(height: 12),
              _SubTitle("A) Éléments d’identification (carte grise)"),
              _BulletPoint(text: "Descriptifs : marque, modèle, couleur."),
              _BulletPoint(
                text:
                    "Catégorie : rubrique J1 (genre national). Exemple : MTL / MTT1 / MTT2. Véhicule spécial : préciser la fonction (scolaire, taxi, ambulance, handicar…).",
              ),
              _BulletPoint(text: "Immatriculation."),
              _BulletPoint(text: "Date de première mise en circulation."),
              _BulletPoint(text: "Nom et adresse du propriétaire."),
              _BulletPoint(
                text:
                    "CNIT (rubrique D.2.1) ou type mine (anciennes cartes grises).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si non immatriculé (mini-moto, EDPM, cycle…) : relever tout élément utile (genre, marque, modèle, couleur…).",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("B) Éléments circonstanciels"),
              _BulletPoint(text: "Sens de circulation."),
              _BulletPoint(
                text:
                    "Manœuvre principale (ex : dépassement, ouverture de portière…).",
              ),
              _BulletPoint(text: "Conformité de l’assurance."),
              _BulletPoint(
                text: "Conformité contrôle/visite technique (si applicable).",
              ),
              _BulletPoint(
                text:
                    "État du véhicule / chargement (arrimage, pneus, éclairage…).",
              ),
              _BulletPoint(
                text:
                    "Point de choc initial (avant, arrière, avant gauche, côté droit…).",
              ),
              _BulletPoint(
                text:
                    "Conséquences : dégâts décrits + véhicule repris par conducteur ou enlevé par dépannage.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Personnes
          _ConditionCard(
            title: "III — Personnes concernées",
            cardColor: cardPers,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Usagers (conducteurs, passagers, piétons)"),
              const _Paragraph(
                "Sont concernés : conducteurs, passagers, piétons (et assimilés : pousser une poussette, "
                "conduire un cycle à la main, PMR en fauteuil à allure du pas, personne sortie du véhicule pour changer une roue…).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Renseignements à relever pour chaque usager"),
              const _BulletPoint(text: "Petite identité."),
              const _BulletPoint(
                text:
                    "État : indemne / blessé / décédé + gravité des dommages.",
              ),
              const _BulletPoint(
                text: "Lieu d’hospitalisation (si applicable).",
              ),
              const _BulletPoint(
                text:
                    "Nature du trajet (domicile-travail, domicile-école, professionnel…).",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Alcoolémie (contrôle obligatoire) : conducteurs et accompagnateurs d’élève conducteur — ",
                ),
                TextSpan(
                  text: "article L. 234-3 alinéa 1 du Code de la route",
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
                      "Piétons et passagers : recherche d’imprégnation alcoolique selon ",
                ),
                TextSpan(
                  text: "l’article L. 3354-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Stupéfiants : dépistage obligatoire puis vérifications le cas échéant (conducteurs et accompagnateurs d’élève conducteur).",
              ),

              const SizedBox(height: 12),
              const _SubTitle("Focus conducteur"),
              const _BulletPoint(text: "Responsabilité présumée."),
              const _BulletPoint(
                text:
                    "Permis : n°, validité, date d’obtention, catégorie adaptée au véhicule.",
              ),
              const _BulletPoint(text: "Infraction(s) commise(s)."),
              const _BulletPoint(
                text:
                    "Équipements de sécurité : ceinture, casque, gants, gilet rétro-réfléchissant…",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Rétention du permis : possible notamment en accident corporel/mortel s’il existe des raisons plausibles de soupçonner une infraction (téléphone tenu en main, vitesse, règles de croisement/dépassement, intersection/priorités…).",
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const _SubTitle("Focus passager"),
              const _BulletPoint(text: "Place occupée dans le véhicule."),
              const _BulletPoint(
                text:
                    "Équipements de sécurité : ceinture, casque, dispositif enfant…",
              ),

              const SizedBox(height: 12),
              const _SubTitle("Focus piéton"),
              const _BulletPoint(
                text:
                    "Localisation : sur chaussée, trottoir, à ± 50 m d’un passage piéton…",
              ),
              const _BulletPoint(
                text:
                    "Manœuvre : sens de traversée, descente d’un véhicule, etc.",
              ),
              const _BulletPoint(text: "Infraction éventuellement commise."),
            ],
          ),

          const SizedBox(height: 14),

          // Témoins
          _ConditionCard(
            title: "IV — Témoins",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les témoins sont des personnes présentes sur les lieux sans être impliquées, mais pouvant "
                "apporter des éléments déterminants (vitesse excessive/inadaptée, dépassement dangereux, "
                "refus de priorité, téléphone, absence d’éclairage…).\n\n"
                "Recueillir leurs identités, coordonnées, emplacement au moment des faits et le récit précis.",
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
