import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgentsVerbalisateursCirculationPage extends StatelessWidget {
  const AgentsVerbalisateursCirculationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);

    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);

    final Color cardTypes = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color cardProb = isDark
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
          "Circulation routière",
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
            "Compétence des agents verbalisateurs\n(en matière de circulation routière)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Cadre général",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le formalisme procédural de constatation (procès-verbal ou rapport) des infractions routières "
                "varie selon la nature de l’infraction (délit ou contravention) et la qualification judiciaire "
                "de l’agent verbalisateur.\n\n"
                "Le non-respect de ces règles peut modifier la valeur probante de l’acte rédigé ou entraîner "
                "la nullité de la procédure.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (article(s) en rouge)
          _ConditionCard(
            title: "I — Fondement légal (compétence générale)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 12 et 14 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définissent la mission de police judiciaire et la compétence générale pour rechercher et constater les infractions.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 21 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : encadre l’action des agents de police judiciaire (APJ) dans la constatation des infractions.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 21-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : fixe les règles relatives aux agents de police judiciaire adjoints (APJA).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 429 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : précise la valeur probante des procès-verbaux et rapports (régularité, compétence, constatations personnelles).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Recherche & constatation des infractions routières",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les O.P.J., A.P.J. et A.P.J.A. disposent d’une compétence générale pour rechercher et constater "
                "les infractions, conformément au code de procédure pénale.\n\n"
                "La constatation des délits et contraventions en matière de circulation routière "
                "(code de la route, code des assurances, code de la voirie routière, réglementation des transports routiers) "
                "relève également de leur compétence.\n\n"
                "D’autres agents d’administrations (ex : gardes champêtres, contrôleurs des transports terrestres, "
                "agents des douanes) peuvent aussi constater certaines infractions routières.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Formes procédurales de constatation",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le code de procédure pénale confère aux O.P.J., A.P.J. et A.P.J.A. une compétence générale "
                "pour constater les infractions à la loi pénale, y compris celles du domaine routier.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Qui peut rédiger quoi ? (règles essentielles)"),
              const SizedBox(height: 6),

              const _BulletPoint(
                text:
                    "OPJ : procès-verbal « ordinaire » ou PVe — délits et contraventions à la circulation routière.",
              ),
              const _BulletPoint(
                text:
                    "APJ : procès-verbal « ordinaire » ou PVe — contraventions au code de la route dont la liste est fixée par le code de la route.",
              ),
              const _BulletPoint(
                text:
                    "APJA (policiers adjoints / réservistes opérationnels non OPJ ou APJ) : rapport — notamment pour les contraventions pour lesquelles ils ne sont pas autorisés à dresser procès-verbal.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "En dehors de leur ressort territorial, les OPJ, APJ et APJA peuvent rendre compte par rapport au procureur de la République compétent de toute infraction dont ils ont été témoins.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Deux types de procès-verbaux utilisés",
            cardColor: cardTypes,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("1) Procès-verbal électronique (PVe)"),
              const _Paragraph(
                "Toutes les contraventions soumises à la procédure de l’amende forfaitaire "
                "(ex : stationnement, vitesse, équipements…) peuvent être relevées au moyen d’appareils électroniques sécurisés.",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Terminal mobile NEO 2 (smartphone/tablette) : appareil portatif avec écran tactile permettant notamment de recueillir la signature du contrevenant.",
              ),
              const _IntroBullet(
                text:
                    "IHM web (interface homme-machine/web) : application informatique permettant notamment de constater certaines infractions au service (ex : non justification dans les 5 jours de l’attestation d’assurance).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’application PVe automatise et dématérialise la procédure, de la constatation à l’envoi de l’avis de contravention "
                "au domicile du contrevenant (ou du titulaire du certificat d’immatriculation) par le centre national de traitement de Rennes.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) Procès-verbal « ordinaire »"),
              const _Paragraph(
                "Le procès-verbal « ordinaire », rédigé via le logiciel de rédaction de procédure, est utilisé pour constater :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Les délits."),
              const _BulletPoint(
                text:
                    "Les contraventions non forfaitisées (plusieurs infractions simultanées dont au moins une ne peut donner lieu à amende forfaitaire).",
              ),
              const _BulletPoint(
                text:
                    "Les contraventions de 5e classe, et celles de 4e classe entraînant S.P.C. sur instructions du parquet.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Valeur probante des actes",
            cardColor: cardProb,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Selon "),
                TextSpan(
                  text: "l’article 429 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ", le procès-verbal ou le rapport n’a valeur probante que s’il est régulier en la forme, "
                      "si l’auteur agit dans l’exercice de ses fonctions et rapporte, sur une matière de sa compétence, "
                      "ce qu’il a vu, entendu ou constaté personnellement.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("1) Délits"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les procès-verbaux et rapports constatant les délits ne valent qu’à titre de simples renseignements — ",
                ),
                TextSpan(
                  text: "article 430 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("2) Contraventions"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En règle générale, les procès-verbaux et rapports constatant les contraventions font foi jusqu’à preuve contraire — ",
                ),
                TextSpan(
                  text: "article 537 du Code de procédure pénale",
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
                      "En matière routière, les agents verbalisateurs autres que les OPJ et APJ doivent être assermentés afin que les procès-verbaux conservent leur valeur probante — ",
                ),
                TextSpan(
                  text: "article L. 130-7 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article 537 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 10),

              const _Paragraph(
                "La prestation de serment initiale des APJA n’a pas à être renouvelée en cas de changement de lieu d’affectation.\n\n"
                "Le défaut d’assermentation modifie la force probante : l’acte ne fait plus foi jusqu’à preuve contraire, "
                "mais ne vaut qu’à titre de simples renseignements.",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Tout procès-verbal doit être soigneusement rédigé en respectant le formalisme imposé. "
                        "Les erreurs (date, lieu, chiffres, immatriculation, etc.) peuvent créer un doute et conduire à l’annulation de la procédure.",
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
