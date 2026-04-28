import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstatationsGeneralitesPage extends StatelessWidget {
  const ConstatationsGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/constatations/generalites';

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
    final Color cardGen = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPv = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPts = isDark
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
          "Constatations",
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
            "Les constatations — généralités",
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
                "Les constatations ont pour but de fixer l’état des lieux, d’établir la réalité de l’infraction "
                "et de rechercher les objets, traces et indices susceptibles d’orienter l’enquête.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (si tu veux rajouter des articles exacts, tu peux compléter ici)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les constatations s’inscrivent dans le cadre de l’enquête (flagrance ou préliminaire). "
                      "Selon le cas, viser : ",
                ),
                TextSpan(
                  text: "articles 53 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ou "),
                TextSpan(
                  text: "articles 75 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le reste (sécurisation, préservation des traces, PTS) relève des bonnes pratiques opérationnelles "
                        "et des consignes de service (UCG / LRPPN / doctrine locale).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Généralités
          _ConditionCard(
            title: "II — Généralités (réflexes premiers intervenants)",
            cardColor: cardGen,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le déroulement des opérations de constatations dépend de la nature de l’infraction, "
                "des circonstances et des lieux (voie publique, lieux publics, propriétés privées).",
              ),
              SizedBox(height: 12),
              _BulletPoint(
                text: "Visite de sécurité ou de pénétration des lieux.",
              ),
              _BulletPoint(
                text:
                    "Évacuation des lieux (présence d’un auteur sur place / blessés éventuels).",
              ),
              _BulletPoint(
                text:
                    "Interdiction d’accès (périmètre de sécurité si la gravité des faits l’exige).",
              ),
              _BulletPoint(
                text:
                    "Protection des traces (y compris en cas d’intempéries) et avis au représentant PTS.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si des mesures conservatoires urgentes doivent être prises avant l’arrivée de la PTS : "
                        "prélever avec des gants, noter l’emplacement exact au moment du prélèvement, "
                        "conditionner de manière protectrice, et remettre au plus vite au service PTS compétent.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modèles PV
          _ConditionCard(
            title: "III — Constatations (modèles de PV)",
            cardColor: cardPv,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Modèles utilisables"),
              _BulletPoint(
                text:
                    "Procès-verbal ordinaire (PVO) si l’affaire débute contre personne dénommée.",
              ),
              _BulletPoint(
                text:
                    "Procès-verbal normalisé : CRI initial (saisine) ou complémentaire, lorsque l’affaire débute contre auteur inconnu.",
              ),
              _BulletPoint(
                text:
                    "Également utilisé dans une enquête contre personne dénommée si des éléments importants apparaissent (objets dérobés/découverts, traces/indices, mode opératoire, auteurs remarqués…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Assistance PTS
          _ConditionCard(
            title: "IV — Assistance P.T.S.",
            cardColor: cardPts,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le transport du représentant de la police technique et scientifique (SDPTS, BPTS ou SRPTS) "
                "doit être systématique sur les scènes d’infractions, notamment en matière de petite et moyenne délinquance.",
              ),
              SizedBox(height: 12),
              _BulletPoint(
                text:
                    "Préserver les lieux en l’état et conserver traces/indices jusqu’aux opérations PTS.",
              ),
              _BulletPoint(
                text:
                    "Les constatations ne devraient débuter qu’en présence du fonctionnaire PTS (sauf nécessité absolue).",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Pour rédiger correctement un PV de constatations, il est recommandé de renseigner l’annexe II (cambriolages).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Découverte d'une arme
          _ConditionCard(
            title: "V — Découverte d’une arme à feu",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Toute découverte d’une arme à feu impose une mise en protection immédiate et la conservation des traces.",
              ),
              SizedBox(height: 12),
              _BulletPoint(
                text:
                    "Port de gants (jetables) et éventuellement masque anti-poussière.",
              ),
              _BulletPoint(
                text:
                    "Mise en sécurité de l’arme en respectant les règles habituelles.",
              ),
              _BulletPoint(
                text:
                    "Compte-rendu précis : position des éléments mobiles au moment de la découverte (cartouche engagée, douille percutée, culasse, chien…), et positions des munitions dans le barillet.",
              ),
              _BulletPoint(
                text:
                    "Sous-conditionnement séparé : arme et éléments d’approvisionnement (chargeur, munitions extraites) séparés (kraft/carton) pour préserver les traces, avant présentation OPJ et placement sous scellé.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si le protocole ne peut être respecté : établir un périmètre de sécurité et ne pas modifier les lieux avant l’arrivée PTS.",
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
