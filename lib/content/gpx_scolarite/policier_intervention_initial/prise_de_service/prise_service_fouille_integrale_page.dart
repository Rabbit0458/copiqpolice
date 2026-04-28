import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriseServiceFouilleIntegralePage extends StatelessWidget {
  const PriseServiceFouilleIntegralePage({super.key});

  static const String routeName =
      '/gpx/intervention/prise-service/fouille-integrale';

  // Couleur des articles de loi (CPP / CP / CSI / etc.)
  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
          "Mesures de sécurité",
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
            "La fouille intégrale",
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
            title: "Référence (élément légal)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 63-7 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : encadre la fouille intégrale, qui est un moyen de recherche de la preuve (et non une mesure de sécurité).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "I — Mesures de sécurité",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Constituent des mesures de sécurité :\n"
                "• la palpation de sécurité ;\n"
                "• la fouille de sécurité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "A) La palpation de sécurité",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La palpation de sécurité est une mesure administrative ayant pour finalité la sécurité "
                "des policiers, de la personne contrôlée ou interpellée, et du public.\n\n"
                "Elle consiste à détecter sur une personne (ou sur les accessoires qu’elle porte) tout objet "
                "susceptible de constituer un danger pour elle-même ou pour autrui.",
              ),
              SizedBox(height: 10),
              _SubTitle("Principes"),
              _BulletPoint(text: "Nécessité et proportionnalité."),
              _BulletPoint(
                text: "Mise en œuvre avec discernement et professionnalisme.",
              ),
              _BulletPoint(text: "Respect de la dignité de la personne."),
              SizedBox(height: 12),
              _SubTitle("Situations typiques"),
              _IntroBullet(
                text:
                    "Lors d’une interpellation en flagrant délit : palpation immédiate possible et retrait des armes/objets dangereux.",
              ),
              _IntroBullet(
                text:
                    "Surveillance de personnes interpellées/retenues dans les locaux : lors des déplacements et en cas d’interruption de surveillance, pour s’assurer de l’absence d’objet dangereux.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "B) La fouille de sécurité",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La fouille de sécurité est une mesure administrative pouvant être réalisée sur une personne retenue "
                "(garde à vue, I.P.M., mandat de justice…), juste avant son placement dans le local de rétention.\n\n"
                "Elle est motivée par des circonstances particulières qui justifient des vérifications plus adaptées.",
              ),
              SizedBox(height: 10),
              _SubTitle("Motifs pouvant la justifier"),
              _IntroBullet(
                text:
                    "Conditions de l’interpellation (tentative de fuite et/ou violences).",
              ),
              _IntroBullet(text: "Nature et gravité des faits reprochés."),
              _IntroBullet(
                text:
                    "Personnalité et comportement (antécédents judiciaires, âge, état de santé apparent, agressivité…).",
              ),
              _IntroBullet(
                text: "Découverte d’objets dangereux lors de la palpation.",
              ),
              _IntroBullet(
                text:
                    "Signes manifestes d’une consommation d’alcool ou de stupéfiants.",
              ),
              SizedBox(height: 12),
              _SubTitle("But"),
              _Paragraph(
                "Découvrir et écarter tout objet dangereux pour la personne concernée ou pour autrui.",
              ),
              SizedBox(height: 12),
              _SubTitle("Limites — déshabillage"),
              _Paragraph(
                "Le déshabillage complet est interdit. La fouille peut aller jusqu’aux sous-vêtements "
                "ou à l’ultime couche de vêtements.\n\n"
                "La personne peut être invitée à retirer ses accessoires (bretelles, ceinture, cravate, lacets…) "
                "et un sous-vêtement (notamment le soutien-gorge) dès lors que son port peut constituer un danger pour elle-même.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Tout déshabillage éventuel et ses raisons doivent être mentionnés dans le registre administratif (garde à vue, dégrisement, etc.).",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Règles de mise en œuvre"),
              _BulletPoint(
                text:
                    "Doit être effectuée par un policier du même sexe que la personne concernée.",
              ),
              _BulletPoint(
                text:
                    "Si la force est employée : les actes de résistance et les moyens de coercition doivent être décrits précisément (rapport ou P.V.).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        "En matière de palpation ou de fouille, il convient de prendre en compte le genre de la personne. "
                        "Les personnes transgenres peuvent présenter un « formulaire » expliquant leur situation et demander "
                        "que l’opération soit réalisée par un homme ou par une femme. La D.G.P.N. préconise, dans la mesure du possible, "
                        "de tenir compte de cette demande.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Fouille intégrale (différence essentielle)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La fouille intégrale est un moyen de recherche de la preuve, et non une mesure de sécurité. ",
                ),
                TextSpan(
                  text: "(art. 63-7 CPP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Condition de recours"),
              const _Paragraph(
                "Elle n’est possible que si la fouille par palpation ou l’utilisation de moyens de détection électronique "
                "ne peuvent pas être réalisées.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Finalité"),
              const _Paragraph(
                "Rechercher, sur la personne ou dans ses effets, des objets utiles à la manifestation de la vérité "
                "ou dont la détention est susceptible de constituer une infraction.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Décision"),
              const _Paragraph(
                "Il s’agit d’une mesure décidée par un officier de police judiciaire (O.P.J.) "
                "pour les nécessités d’une enquête en cours.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Cadre selon le type d’enquête",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Enquête de flagrant délit"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La fouille intégrale doit être réalisée par un O.P.J., sur une personne du même sexe. "
                      "Sur instructions de l’O.P.J., l’A.P.J. peut le seconder. — ",
                ),
                TextSpan(
                  text: "articles 20 CPP et D. 13 CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Enquête préliminaire"),
              const _Paragraph(
                "La fouille intégrale, assimilée à une perquisition, peut être effectuée par un O.P.J. "
                "ou un A.P.J. agissant sous son contrôle, dès lors que l’assentiment exprès et manuscrit du mis en cause "
                "a été obtenu.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Modalités pratiques (mise à nu)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La fouille intégrale implique le retrait de tous les vêtements de la personne avec mise à nu.\n\n"
                "Elle doit être effectuée dans un local fermé, par une personne du même sexe.",
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
