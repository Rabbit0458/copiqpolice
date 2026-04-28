import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriseServiceRisqueEvasionFuitePage extends StatelessWidget {
  const PriseServiceRisqueEvasionFuitePage({super.key});

  static const String routeName =
      '/gpx/intervention/prise-service/risque-evasion-fuite';

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
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
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
          "Prise de service",
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
            "Maîtriser le risque d’évasion et de fuite",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Références (élément légal) en haut
          _ConditionCard(
            title: "Références (élément légal)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Usage des menottes (principes) — "),
                TextSpan(
                  text: "article 803 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : le menottage n’est pas automatique et doit être justifié (dangerosité / risque de fuite).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Devoir de protection et de dignité — "),
                TextSpan(
                  text: "article R. 434-17 du Code de la sécurité intérieure",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : vigilance et mesures adaptées pour préserver la sécurité des agents et des personnes privées de liberté.",
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "NOTE",
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette page synthétise des principes opérationnels de sécurité (type mémo). Elle ne remplace pas les instructions locales ni l’appréciation hiérarchique.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // De quoi s'agit-il ?
          _ConditionCard(
            title: "De quoi s’agit-il ?",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "De nombreux incidents (évasions, fuites, tentatives) rappellent les risques liés à la privation de liberté "
                "et la nécessité de maintenir des principes généraux de sécurité.\n\n"
                "Les évasions et fuites créent un danger pour les agents et pour la personne surveillée, "
                "et nuisent au bon déroulement des investigations et des procédures.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectif
          _ConditionCard(
            title: "Objectif opérationnel",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Réduire le risque d’évasion/fuite en appliquant une vigilance continue et des règles simples "
                "lors des déplacements et des transports, avec une attention partagée par tous (agents de surveillance + occupants des bureaux).",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Sécurité des agents et du public."),
              _BulletPoint(text: "Sécurité de la personne privée de liberté."),
              _BulletPoint(
                text:
                    "Protection des procédures (judiciaires et administratives).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Vigilance constante
          _ConditionCard(
            title: "I — Vigilance constante (le réflexe n°1)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Partage des informations de dangerosité"),
              _Paragraph(
                "Les informations sur l’agressivité ou le degré de dangerosité doivent être consignées "
                "et portées à la connaissance de tous les agents en contact avec la personne.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "ATTENTION",
                bodySpans: [
                  TextSpan(
                    text:
                        "Une attitude passive et calme n’est pas un indicateur fiable.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("B) Menottage : ni automatique, ni oublié"),
              _BulletPoint(text: "Le menottage ne doit pas être systématique."),
              _BulletPoint(
                text:
                    "Il s’applique aux personnes dangereuses pour elles-mêmes ou pour autrui, ou susceptibles de prendre la fuite.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Déplacements dans les locaux
          _ConditionCard(
            title: "II — Déplacements dans les locaux (zone à risque)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les risques d’évasion sont accrus lors de tout déplacement : entrées/sorties des locaux, toilettes, "
                "bureaux des enquêteurs, parking, cour du commissariat…",
              ),
              SizedBox(height: 12),
              _SubTitle("A) Positionnement et progression"),
              _IntroBullet(
                text:
                    "Placer la personne du côté opposé aux ouvertures (portes et fenêtres).",
              ),
              _IntroBullet(
                text: "Dans les cages d’escalier : progresser côté mur.",
              ),
              _IntroBullet(
                text:
                    "Se positionner derrière la personne lors de la conduite.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Sécurisation des ouvertures et de l’environnement"),
              _IntroBullet(
                text:
                    "Les agents en charge de la surveillance et les occupants des bureaux s’assurent que les ouvertures sont fermées et verrouillées.",
              ),
              _IntroBullet(
                text:
                    "Rester vigilant sur les objets pouvant être projetés (presse-papier, cadres, bouteilles) ou utilisés comme arme (coupe-papier, ciseaux, briquet, stylo…).",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Dispositifs de sécurité"),
              _BulletPoint(
                text:
                    "Contrôler régulièrement : fermeture des cellules, dispositifs d’alerte, vidéosurveillance.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Transports hors locaux
          _ConditionCard(
            title: "III — Transports hors des locaux (surveillance renforcée)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le risque d’évasion augmente lors des perquisitions, conduites en milieu hospitalier, "
                "présentations à magistrat, ou en milieu carcéral.",
              ),
              SizedBox(height: 12),
              _SubTitle("A) En véhicule"),
              _BulletPoint(
                text:
                    "La personne est assise à l’arrière, jamais derrière le conducteur.",
              ),
              _BulletPoint(
                text:
                    "Dans la mesure du possible : positionnée entre deux agents, ceinture de sécurité bouclée.",
              ),
              _BulletPoint(
                text:
                    "Équipage de 2 agents : activer la « sécurité enfants » de la portière côté interpellé.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) À pied"),
              _BulletPoint(
                text:
                    "Le policier se positionne derrière la personne afin que l’arme ne soit pas accessible.",
              ),
              _BulletPoint(
                text:
                    "Menottes dans le dos : un agent droitier maintient par la main gauche (inverse pour un agent gaucher).",
              ),
              _BulletPoint(
                text:
                    "Le recours à une chaîne d’accompagnement peut être envisagé.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Checklist
          _ConditionCard(
            title: "Check-list express (à appliquer à chaque situation)",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Les infos de dangerosité sont-elles connues de tous ceux qui vont être en contact ?",
              ),
              _BulletPoint(
                text:
                    "Portes/fenêtres/verrouillage : tout est sécurisé avant et pendant le passage ?",
              ),
              _BulletPoint(
                text: "Objets à risque dans la zone : retirés/écartés ?",
              ),
              _BulletPoint(
                text:
                    "Positionnement : personne côté opposé aux ouvertures, progression côté mur, agent derrière ?",
              ),
              _BulletPoint(
                text:
                    "Transport véhicule : arrière, jamais derrière conducteur, ceinture bouclée, sécurité enfant si besoin ?",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé
          _ConditionCard(
            title: "En résumé",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La surveillance des personnes privées de liberté requiert une vigilance de tous les instants : "
                "sécurité des agents, bon déroulement des procédures et attente légitime des victimes.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "BON RÉFLEXE",
                bodySpans: [
                  TextSpan(
                    text:
                        "Lorsqu’un individu est libéré, son identité est systématiquement vérifiée afin d’éviter toute confusion sur la personne.",
                    style: TextStyle(fontWeight: FontWeight.w900),
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
