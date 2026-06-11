import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaStupefiantsIntroductionPage extends StatelessWidget {
  const PaStupefiantsIntroductionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/stupefiants/introduction';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return const TextSpan(); // (jamais utilisé directement)
  }

  TextSpan _lawSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

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

    final Color cardKey = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);

    final Color cardClassif = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color cardProc = isDark
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
          "Stupéfiants",
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
            "Introduction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro générale
          _ConditionCard(
            title: "Contexte général",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’extension du phénomène toxicomaniaque dans le monde, à laquelle la France n’a pas échappé, "
                "s’est traduite au niveau international par l’élaboration de conventions constituant la base de référence "
                "en matière de lutte contre la drogue.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Convention unique sur les stupéfiants (1961), amendée par le protocole de 1972.",
              ),
              _IntroBullet(
                text: "Convention sur les substances psychotropes (1971).",
              ),
              _IntroBullet(
                text:
                    "Convention contre le trafic des stupéfiants et des substances psychotropes (1988).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dispositif FR
          _ConditionCard(
            title: "Logique du dispositif français",
            cardColor: cardKey,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La France a ratifié et transposé ces conventions. Le dispositif répressif distingue :\n"
                "• les toxicomanes, qu’il importe de soigner ;\n"
                "• les trafiquants, qu’il faut sanctionner plus sévèrement.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Répression du trafic dans le Code pénal : ",
                ),
                _lawSpan("articles 222-34 à 222-43-1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Usage et provocation à l’usage dans le Code de la santé publique : ",
                ),
                _lawSpan(
                  "articles L. 3421-1 et L. 3421-4 du Code de la santé publique",
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Autres comportements liés"),
              const _BulletPoint(
                text: "Provocation directe d’un mineur à l’usage ou au trafic.",
              ),
              _Paragraph.rich([
                _lawSpan("Articles 227-18 et 227-18-1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Non-justification de ressources."),
              _Paragraph.rich([
                _lawSpan("Articles 321-6 et 321-6-1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Association de malfaiteurs."),
              _Paragraph.rich([
                _lawSpan("Article 450-1 du Code pénal"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (définition légale)
          _ConditionCard(
            title: "Définition légale des stupéfiants",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article 222-41 du Code pénal"),
                const TextSpan(
                  text:
                      " : « constituent des stupéfiants, des substances ou plantes classées comme stupéfiants » ",
                ),
                const TextSpan(text: "en application de "),
                _lawSpan("l’article L. 5132-7 du Code de la santé publique"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La définition légale est plus restrictive que la définition médicale : "
                "même si d’autres substances peuvent avoir des effets toxicomanogènes, "
                "seules sont retenues celles figurant sur des listes évolutives arrêtées par voie réglementaire.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les substances vénéneuses non classées stupéfiants (ex. anabolisants, hormones de croissance) "
                        "relèvent du Code de la santé publique. L’incrimination vise notamment la production, le transport, "
                        "l’importation, l’exportation, la détention, l’offre, la cession, l’acquisition, l’emploi et la culture illicite — ",
                  ),
                  _lawSpan("article L. 5432-1 du Code de la santé publique"),
                  const TextSpan(
                    text:
                        ". Il n’existe pas d’incrimination spécifique de l’usage illicite de ces produits ; "
                        "on peut retenir, selon les cas, la détention, l’acquisition ou le transport illicite.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Classification (pédagogique, sans tableau lourd)
          _ConditionCard(
            title: "Classification des produits",
            cardColor: cardClassif,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La classification comporte plusieurs centaines de substances. "
                "Ici, on retient les produits les plus fréquemment rencontrés/consommés, "
                "avec un repère simple : aspect + effets dominants.",
              ),
              SizedBox(height: 12),
              _SubTitle("A) Stimulants / excitants (SNC)"),
              _BulletPoint(
                text:
                    "Cocaïne (base, chlorhydrate), crack : forte dépendance, risques cardiovasculaires, agitation.",
              ),
              _BulletPoint(
                text:
                    "Amphétamines / méthamphétamine : stimulation, anorexigène, irritabilité, hallucinations, risque de surdosage.",
              ),
              _BulletPoint(
                text:
                    "Ecstasy / MDMA : stimulant avec nuances hallucinogènes, risques hyperthermie/déshydratation.",
              ),
              _BulletPoint(
                text:
                    "Khat : légère excitation, euphorie, puis torpeur ; dépendance possible.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Perturbateurs / hallucinogènes"),
              _BulletPoint(
                text:
                    "Cannabis (herbe, résine, huile) : euphorie, baisse de vigilance, troubles cognitifs, dépendance possible.",
              ),
              _BulletPoint(
                text:
                    "LSD : altération du temps/de l’espace, risque de flash-back et de surdosage.",
              ),
              _BulletPoint(
                text:
                    "Champignons hallucinogènes / psilocybine : vertiges, anxiété, phénomènes visuels, risque surdosage.",
              ),
              _BulletPoint(
                text:
                    "GHB : désinhibition, perte de mémoire ; risque majeur en mélange avec alcool.",
              ),
              _BulletPoint(
                text:
                    "Kétamine : ivresse dissociative, hallucinations ; risques accrus si alcool.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Calmants / sédatifs"),
              _BulletPoint(
                text:
                    "Opiacés (opium, morphine, héroïne) : somnolence, myosis, forte dépendance, risque de surdosage.",
              ),
              _BulletPoint(
                text:
                    "Rach / rachacha : produit artisanal dérivé du pavot, utilisé comme “descente”, dépendance et surdosage.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Procédure spécifique (706-73 CPP)
          _ConditionCard(
            title: "Procédure pénale spécifique",
            cardColor: cardProc,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les crimes et délits de trafic de stupéfiants prévus par les articles 222-34 à 222-40 du Code pénal "
                "peuvent relever de la procédure spécifique applicable à la criminalité et à la délinquance organisées.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                _lawSpan("article 706-73 du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
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
  const _NotaBox({required this.bodySpans});

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
