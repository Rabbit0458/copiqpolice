import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterpellationGeneralitesPage extends StatelessWidget {
  const InterpellationGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/interpellation/generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardGen = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCoerc = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPalp = isDark
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
          "Interpellation",
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
            "Généralités — Interpellation, palpation, menottage, présentation OPJ",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Élément légal (texte de référence)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 73 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : en cas de crime flagrant ou de délit flagrant puni d’emprisonnement, toute personne peut appréhender l’auteur et le conduire devant l’OPJ le plus proche. "
                      "La GAV n’est pas obligatoire si la personne n’est pas tenue sous contrainte et est informée qu’elle peut quitter les locaux à tout moment (sauf conduite par la force publique).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I. Interpellation — Généralités
          _ConditionCard(
            title: "I — L’interpellation",
            cardColor: cardGen,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Généralités"),
              const _BulletPoint(
                text:
                    "Autorisée uniquement en cas de crime flagrant ou de délit flagrant puni d’emprisonnement.",
              ),
              const _BulletPoint(
                text:
                    "Impossible pour un délit puni seulement d’une amende ou une contravention.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’interpellation par un agent de police judiciaire est possible dans les lieux publics "
                "(ou lieux libres d’accès).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’introduction dans des lieux privés (lieux normalement clos) pour interpeller "
                "un auteur présumé (crime/délit flagrant puni d’emprisonnement) n’est possible que par les seuls O.P.J., "
                "pendant les heures légales (6h–21h).",
              ),
              const SizedBox(height: 10),
              const _SubTitle(
                "Cas particuliers : entrée possible pour un A.P.J",
              ),
              _BulletPoint(
                text:
                    "Obligation de porter secours (réclamation depuis l’intérieur).",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 59 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " — réclamation faite de l’intérieur d’un domicile.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Art. 223-6 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " — assistance à personne en péril."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "État de nécessité (ex. fuite de gaz, alarme intempestive…).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Une introduction légale dans un lieu clos permet ensuite d’accomplir les actes autorisés par la loi "
                "(dont l’interpellation, si les conditions sont réunies).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Mandats & contrainte"),
              const _Paragraph(
                "Mandat d’amener / d’arrêt / de recherche : intervention uniquement pendant les heures légales "
                "et au dernier domicile connu, pour la seule appréhension de la personne visée.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En enquête préliminaire, une personne convoquée par un OPJ doit comparaître. À défaut, contrainte possible "
                      "avec autorisation du procureur : ",
                ),
                TextSpan(
                  text: "art. 78 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". L’appréhension forcée n’est possible que sur la voie publique.",
                ),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Sécurité : analyser, garder son sang-froid, demander des effectifs si infériorité numérique "
                        "ou lieu sensible. Les circonstances conditionnent ensuite la décision de GAV par l’OPJ.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // B. Usage de la coercition
          _ConditionCard(
            title: "B — L’usage de la coercition",
            cardColor: cardCoerc,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "Principe : nécessité + proportionnalité — ",
                ),
                TextSpan(
                  text: "art. R. 434-18 du C.S.I.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Tout recours injustifié à la force peut constituer des violences illégitimes et engager la responsabilité pénale et disciplinaire.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Décrire précisément la résistance et les moyens de coercition utilisés (rapport/PV).",
              ),
              const _BulletPoint(
                text:
                    "Préciser les blessures : celles dues à l’interpellation vs celles préexistantes (constat médical si besoin).",
              ),
              const _BulletPoint(
                text:
                    "Si l’état de santé est déficient : déclencher immédiatement les secours.",
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Personne conduite sous contrainte par la force publique (menottée / contrainte à monter dans un véhicule) : "
                      "GAV si conditions réunies. ",
                ),
                TextSpan(
                  text: "(rappel art. 73 C.P.P.)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si l’OPJ ne souhaite pas maintenir immédiatement la personne à disposition et que la GAV "
                        "n’est pas l’unique moyen d’atteindre un objectif, il peut la remettre en liberté et la convoquer.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Une personne mise à disposition ne sera pas nécessairement placée en GAV si elle est appréhendée "
                "sans contrainte par une personne autre qu’un agent de la force publique, et accepte d’être conduite au service "
                "sans coercition.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. Palpation
          _ConditionCard(
            title: "II — La palpation de sécurité",
            cardColor: cardPalp,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Elle doit être effectuée lorsqu’il est nécessaire de vérifier que la personne ne détient aucun objet dangereux — ",
                ),
                TextSpan(
                  text: "art. R. 434-16 du C.S.I.",
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
                    "Effectuée par une personne du même sexe (sauf dangerosité/urgence exceptionnelle).",
              ),
              const _BulletPoint(
                text:
                    "Par un seul fonctionnaire, pendant qu’un ou deux collègues sécurisent l’environnement.",
              ),
              const _BulletPoint(
                text:
                    "Au travers des vêtements : aucune dénudation n’est possible.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dès la découverte d’un objet suspect, informer immédiatement les autres intervenants. "
                "Armes/objets dangereux : appréhension et remise à l’OPJ.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. Menottage
          _ConditionCard(
            title: "III — Le menottage",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Justifié uniquement si dangerosité pour soi/autrui ou risque de fuite — ",
                ),
                TextSpan(
                  text: "art. 803 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "art. R. 434-17 du C.S.I.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Décision sous responsabilité personnelle du fonctionnaire (appréciation des risques). "
                "Rester mesuré : mineurs, personnes âgées, santé fragile…",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text: "Menottage excessivement serré : interdit.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Transport : dans un véhicule de service, l’interpellé est positionné à l’arrière, côté droit.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV. Présentation OPJ
          _ConditionCard(
            title: "IV — Présentation à l’officier de police judiciaire",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Dès la fin de l’intervention, conduire sans délai la personne devant un OPJ, "
                "dans des conditions de transport dignes. Cette rapidité permet de respecter "
                "les obligations légales liées à une éventuelle garde à vue.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si la présentation ne peut être réalisée dans un délai raisonnable, l’OPJ (avisé par radio) "
                      "peut décider une GAV et ordonner la notification verbale des droits — ",
                ),
                TextSpan(
                  text: "art. 63-1 à 63-4-3 du C.P.P.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’interpellation se concrétise par la rédaction d’un acte : procès-verbal (APJ/OPJ) "
                "ou rapport de mise à disposition (APJA).",
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
