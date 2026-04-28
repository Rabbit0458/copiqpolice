import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntervenirMaladesMentauxPage extends StatelessWidget {
  const IntervenirMaladesMentauxPage({super.key});

  static const String routeName =
      '/gpx/intervention/malades-mentaux/intervenir';

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
    final Color cardGen = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardBefore = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPrat = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

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
          "Intervention",
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
            "Intervenir auprès de personnes ne jouissant pas de toutes leurs capacités mentales",
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
            title: "Contexte",
            cardColor: cardGen,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Si la plupart des urgences sont dues à l’alcoolisme (notamment en violences intra-familiales), "
                "le gardien de la paix peut aussi être confronté à des usagers dont le comportement incohérent "
                "traduit des difficultés de type psychiatrique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (sans inventer de texte juridique)
          _ConditionCard(
            title: "I — Cadre légal (référence du support)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "NOTE",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Dans l’extrait fourni, aucun article de loi n’est cité. "
                        "Si tu me donnes les références (CPP / CP / CSI / CSP…), je les intégrerai ici et elles seront affichées en rouge.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Rappel visuel : un article affiché en rouge ressemble à ",
                ),
                const TextSpan(
                  text: "Article 123 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I. CARACTÉRISTIQUES GÉNÉRALES
          _ConditionCard(
            title: "II — Caractéristiques générales",
            cardColor: cardGen,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Pour faciliter la relation, il faut garder à l’esprit qu’un malade mental est avant tout "
                "quelqu’un qui souffre (angoisse) et dont la compréhension ordinaire de l’environnement est rompue.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Perception de l’entourage"),
              const _IntroBullet(text: "Soit partiellement décalée."),
              const _IntroBullet(text: "Soit complètement distordue."),
              const SizedBox(height: 10),
              const _Paragraph(
                "Cette perception entraîne régulièrement des difficultés de communication.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Dangerosité : attention aux idées reçues"),
              const _Paragraph(
                "Les personnes les plus dangereuses (pour elles-mêmes ou pour autrui) ne sont pas forcément celles "
                "qui crient ou s’agitent le plus. Un malade mental, surtout s’il est étranger, peut crier pour se faire "
                "« mieux comprendre » : le plus spectaculaire n’est pas toujours le plus dangereux.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "À l’inverse, une personne apathique n’est pas forcément inoffensive, et une personne muette "
                        "n’a pas forcément « quelque chose à cacher ». L’angoisse peut paralyser l’expression, parfois "
                        "de manière ponctuelle, puis laisser place à un désordre comportemental important.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. AVANT L'INTERVENTION
          _ConditionCard(
            title: "III — Avant l’intervention",
            cardColor: cardBefore,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Pour éviter des erreurs aux conséquences parfois graves, il est conseillé de se renseigner le plus "
                "possible avant la prise de contact : sur la personne et sur son entourage.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Objectifs des renseignements"),
              const _BulletPoint(
                text:
                    "Comprendre le contexte : antécédents de tentative de suicide, d’agression, épisodes récents, déclencheur.",
              ),
              const _BulletPoint(
                text:
                    "Identifier les personnes ressources : proches, référents, habitudes de communication.",
              ),
              const _BulletPoint(
                text:
                    "Accélérer une prise en charge adaptée en contactant les personnes compétentes.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Personnes compétentes à mobiliser"),
              const _Paragraph("Deux types de personnes peuvent aider :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Compétentes affectivement : mère, époux/épouse, ami(e)… (ils savent souvent « comment le prendre »).",
              ),
              const _BulletPoint(
                text:
                    "Compétentes professionnellement : médecin habituel, spécialiste.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Ces informations facilitent aussi le dialogue en attendant l’intervention des personnes compétentes.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. CONSEILS PRATIQUES
          _ConditionCard(
            title: "IV — Conseils pratiques (sur place)",
            cardColor: cardPrat,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("Communication & ambiance"),
              const _BulletPoint(
                text:
                    "Ne jamais laisser la personne crier seule : parler calmement, maintenir le dialogue, garder un environnement éclairé.",
              ),
              const _BulletPoint(
                text:
                    "Éviter le silence et l’obscurité : ils augmentent l’angoisse et peuvent aggraver l’incohérence du comportement.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Posture professionnelle"),
              const _BulletPoint(
                text:
                    "Rester neutre, courtois, et éviter toute ironie ou moquerie sur le comportement.",
              ),
              const _BulletPoint(
                text:
                    "Proscrire toute grivoiserie ou remarque à connotation sexuelle (risque de perception fantasmatique : viol, insultes, menace…).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Vérité & confiance"),
              const _BulletPoint(
                text:
                    "Ne pas mentir : mieux vaut mesurer la vérité que l’on peut dire plutôt que d’inventer une version rapidement démasquée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Exemple : il peut être plus sécurisant d’indiquer une conduite vers l’hôpital (lieu perçu comme « sécurisé ») "
                        "plutôt que de raconter des mensonges. Le mensonge augmente souvent l’angoisse, donc les cris et la gesticulation.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Fermeté & sécurité"),
              const _Paragraph(
                "Ces principes n’excluent pas la fermeté si nécessaire, ni l’usage d’une force strictement adaptée "
                "pour éviter tout danger à la personne et aux tiers.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Dédramatiser autant que possible (vis-à-vis du malade et de l’entourage), sans perdre de vue la sécurité de tous.",
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
