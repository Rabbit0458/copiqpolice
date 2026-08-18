import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
            "f00001",
            'Retour',
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
              "f00002",
              "Intervenir auprès de personnes ne jouissant pas de toutes leurs capacités mentales",
            ),
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
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00003",
                      "Si la plupart des urgences sont dues à l’alcoolisme (notamment en violences intra-familiales), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00004",
                      "le gardien de la paix peut aussi être confronté à des usagers dont le comportement incohérent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00005",
                      "traduit des difficultés de type psychiatrique.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (sans inventer de texte juridique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
              "f00006",
              "I — Cadre légal (référence du support)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "NOTE",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00007",
                          "Dans l’extrait fourni, aucun article de loi n’est cité. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00008",
                          "Si tu me donnes les références (CPP / CP / CSI / CSP…), je les intégrerai ici et elles seront affichées en rouge.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                    "f00009",
                    "Rappel visuel : un article affiché en rouge ressemble à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                    "f00010",
                    "Article 123 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I. CARACTÉRISTIQUES GÉNÉRALES
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
              "f00011",
              "II — Caractéristiques générales",
            ),
            cardColor: cardGen,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00012",
                      "Pour faciliter la relation, il faut garder à l’esprit qu’un malade mental est avant tout ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00013",
                      "quelqu’un qui souffre (angoisse) et dont la compréhension ordinaire de l’environnement est rompue.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00014",
                  "Perception de l’entourage",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00015",
                  "Soit partiellement décalée.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00016",
                  "Soit complètement distordue.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00017",
                  "Cette perception entraîne régulièrement des difficultés de communication.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00018",
                  "Dangerosité : attention aux idées reçues",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00019",
                      "Les personnes les plus dangereuses (pour elles-mêmes ou pour autrui) ne sont pas forcément celles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00020",
                      "qui crient ou s’agitent le plus. Un malade mental, surtout s’il est étranger, peut crier pour se faire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00021",
                      "« mieux comprendre » : le plus spectaculaire n’est pas toujours le plus dangereux.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00022",
                          "À l’inverse, une personne apathique n’est pas forcément inoffensive, et une personne muette ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00023",
                          "n’a pas forcément « quelque chose à cacher ». L’angoisse peut paralyser l’expression, parfois ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00024",
                          "de manière ponctuelle, puis laisser place à un désordre comportemental important.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. AVANT L'INTERVENTION
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
              "f00025",
              "III — Avant l’intervention",
            ),
            cardColor: cardBefore,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00026",
                      "Pour éviter des erreurs aux conséquences parfois graves, il est conseillé de se renseigner le plus ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00027",
                      "possible avant la prise de contact : sur la personne et sur son entourage.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00028",
                  "Objectifs des renseignements",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00029",
                  "Comprendre le contexte : antécédents de tentative de suicide, d’agression, épisodes récents, déclencheur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00030",
                  "Identifier les personnes ressources : proches, référents, habitudes de communication.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00031",
                  "Accélérer une prise en charge adaptée en contactant les personnes compétentes.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00032",
                  "Personnes compétentes à mobiliser",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00033",
                  "Deux types de personnes peuvent aider :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00034",
                  "Compétentes affectivement : mère, époux/épouse, ami(e)… (ils savent souvent « comment le prendre »).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00035",
                  "Compétentes professionnellement : médecin habituel, spécialiste.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00036",
                      "Ces informations facilitent aussi le dialogue en attendant l’intervention des personnes compétentes.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. CONSEILS PRATIQUES
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
              "f00037",
              "IV — Conseils pratiques (sur place)",
            ),
            cardColor: cardPrat,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00038",
                  "Communication & ambiance",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00039",
                  "Ne jamais laisser la personne crier seule : parler calmement, maintenir le dialogue, garder un environnement éclairé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00040",
                  "Éviter le silence et l’obscurité : ils augmentent l’angoisse et peuvent aggraver l’incohérence du comportement.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00041",
                  "Posture professionnelle",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00042",
                  "Rester neutre, courtois, et éviter toute ironie ou moquerie sur le comportement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00043",
                  "Proscrire toute grivoiserie ou remarque à connotation sexuelle (risque de perception fantasmatique : viol, insultes, menace…).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00044",
                  "Vérité & confiance",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00045",
                  "Ne pas mentir : mieux vaut mesurer la vérité que l’on peut dire plutôt que d’inventer une version rapidement démasquée.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00046",
                          "Exemple : il peut être plus sécurisant d’indiquer une conduite vers l’hôpital (lieu perçu comme « sécurisé ») ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                          "f00047",
                          "plutôt que de raconter des mensonges. Le mensonge augmente souvent l’angoisse, donc les cris et la gesticulation.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00048",
                  "Fermeté & sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00049",
                      "Ces principes n’excluent pas la fermeté si nécessaire, ni l’usage d’une force strictement adaptée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                      "f00050",
                      "pour éviter tout danger à la personne et aux tiers.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart",
                  "f00051",
                  "Dédramatiser autant que possible (vis-à-vis du malade et de l’entourage), sans perdre de vue la sécurité de tous.",
                ),
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
