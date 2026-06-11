import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMenottagePage extends StatelessWidget {
  const PaMenottagePage({super.key});

  static const String routeName = '/pa/dps_dpg/policier_intervention/patrouille/menottage';

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
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMinors = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPv = isDark
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
          "Patrouille",
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
            "Le menottage",
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
                "Le menottage est une mesure de sûreté, relevant des pouvoirs de coercition utilisés "
                "en matière d’arrestation et de détention. Il sert à prévenir un danger immédiat "
                "ou une tentative de fuite.\n\n"
                "⚠️ Il ne doit jamais être systématique : la décision repose sur l’appréciation de la situation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (articles rouges)
          _ConditionCard(
            title: "I — Fondements juridiques",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 803 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : nul ne peut être soumis au port de menottes/entraves que si la personne est considérée "
                      "dangereuse pour autrui ou pour elle-même, ou susceptible de tenter de prendre la fuite.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 434-17 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : rappelle les mêmes principes et encadre l’usage du menottage en tant que mesure de sûreté.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La décision engage la responsabilité personnelle de l’agent : elle doit être prise avec discernement (",
                ),
                TextSpan(
                  text: "article R. 434-10 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ") en fonction des circonstances de temps, de lieu, et du comportement/état de la personne.",
                ),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Règle d’or : si l’absence de risques n’est pas évidente, des mesures de sûreté peuvent être appliquées. "
                        "L’objectif est de garantir la sécurité des tiers, des policiers et de la personne appréhendée, "
                        "et d’empêcher toute soustraction à l’action de la justice.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Appréciation / publics particuliers
          _ConditionCard(
            title: "II — Appréciation des risques",
            cardColor: cardMinors,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’agent apprécie l’ensemble des éléments :\n"
                "• personnalité et antécédents connus (si éléments disponibles),\n"
                "• comportement (agressivité, agitation, provocation à la rébellion, fuite…),\n"
                "• état physique et psychologique,\n"
                "• circonstances de temps et de lieu (nuit, foule, isolement, environnement hostile…).",
              ),
              SizedBox(height: 10),
              _SubTitle(
                "Situations nécessitant une appréciation particulièrement fine",
              ),
              _BulletPoint(
                text:
                    "Mineurs, personnes qui se sont volontairement constituées prisonnières, personnes âgées ou dont l’état de santé réduit la mobilité.",
              ),
              _BulletPoint(
                text:
                    "En dehors de situations circonstanciées, il est exclu de menotter un simple témoin.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Mineurs : le menottage est à proscrire pour les moins de 13 ans non mis en cause dans une affaire criminelle, "
                        "sauf avis contraire du magistrat compétent. Pour les plus de 13 ans, il doit être exercé avec discernement, "
                        "notamment selon la gravité des faits.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PV / justification + image/dignité
          _ConditionCard(
            title: "III — Justification et traçabilité (procès-verbal)",
            cardColor: cardPv,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sur le plan pratique, l’emploi du menottage doit être justifié et retranscrit juridiquement "
                "dans le procès-verbal d’interpellation.",
              ),
              SizedBox(height: 10),
              _SubTitle("À mentionner dans le PV"),
              _BulletPoint(
                text:
                    "Les circonstances et l’évaluation du risque (dangerosité / fuite).",
              ),
              _BulletPoint(
                text:
                    "Le comportement observé (fuite, provocation à la rébellion, menaces, agitation…).",
              ),
              _BulletPoint(
                text:
                    "Les incidents survenus lors du menottage (ex. blessure, résistance…).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Il est nécessaire de prendre toute mesure utile afin d’éviter que la personne menottée soit photographiée "
                        "ou fasse l’objet d’un enregistrement audiovisuel.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principes de base (technique)
          _ConditionCard(
            title: "IV — Principes de base (sécurité & technique)",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text: "Le menottage ne doit pas être excessivement serré.",
              ),
              _BulletPoint(text: "Exécuter fermement mais sans agressivité."),
              _BulletPoint(
                text:
                    "Autant que possible : emmener la personne à l’écart (hors de la vue des tiers).",
              ),
              _BulletPoint(
                text:
                    "Limiter l’impact sur le public : si un amené au sol est nécessaire, il doit être le plus bref possible, puis extraire rapidement du lieu.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais menotter à un point fixe (poteau, radiateur…) ou mobile (véhicule…).",
              ),
              _BulletPoint(
                text:
                    "Utiliser uniquement les menottes administratives en dotation (responsabilité).",
              ),
              _BulletPoint(
                text:
                    "Une fois commencée, la pose doit aller jusqu’au terme : ne pas changer de technique en cours.",
              ),
              _BulletPoint(text: "Toujours menotter dans le dos."),
              SizedBox(height: 10),
              _NotaBox(
                title: "Point sécurité majeur",
                bodySpans: [
                  TextSpan(
                    text:
                        "Après la pose de la première menotte, ne jamais lâcher la menotte libre : elle peut devenir une arme.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Dès que la personne est menottée : effectuer systématiquement une palpation de la zone lombaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conduite / escorte
          _ConditionCard(
            title: "V — Conduite et escorte",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pour conduire la personne, le policier se place derrière elle :\n"
                "• légèrement à droite si la personne est droitière,\n"
                "• légèrement à gauche si elle est gauchère,\n"
                "afin que l’arme du policier reste la plus éloignée possible.\n\n"
                "Si la personne devient récalcitrante ou agressive, une pression contrôlée sur les menottes "
                "en direction du sol peut suffire à la déséquilibrer et reprendre le contrôle.",
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
