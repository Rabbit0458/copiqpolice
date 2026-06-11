import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPalpationSecuritePage extends StatelessWidget {
  const PaPalpationSecuritePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/patrouille/palpation-securite';

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
    final Color cardModal = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCases = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPrivate = isDark
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
            "La palpation de sécurité",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (courte + claire)
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La palpation de sécurité est une mesure de sûreté : elle consiste à appliquer les mains "
                "par-dessus les vêtements (et sur les accessoires/objets portés : sac, banane, casquette, etc.) "
                "pour vérifier qu’une personne n’est pas porteuse d’un objet dangereux pour elle-même ou pour autrui.\n\n"
                "➡️ Elle est sommaire, externe, administrative et guidée par des éléments objectifs (dangerosité potentielle).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (en rouge)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 434-16 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : la palpation est exclusivement une mesure de sûreté, non systématique, réservée aux cas où elle est nécessaire "
                      "pour la sécurité du policier/gendarme ou d’autrui ; elle vise à vérifier l’absence d’objet dangereux.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Principe : "),
                  TextSpan(
                    text: "pratiquée à l’abri du regard du public ",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: "lorsque les circonstances le permettent.\n",
                  ),
                  TextSpan(text: "Règle : "),
                  TextSpan(
                    text: "réalisée par une personne du même sexe",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text:
                        " (sauf situations exceptionnelles liées à la dangerosité/urgence).",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "À distinguer de la fouille intégrale : "),
                TextSpan(
                  text: "article 63-7 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (mesure de recherche de preuve, pouvant aller jusqu’au déshabillage complet).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Différences (pédagogie)
          _ConditionCard(
            title: "II — Différences à connaître",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Palpation de sécurité"),
              _BulletPoint(
                text:
                    "But : vérifier l’absence d’objet dangereux (mesure de sûreté).",
              ),
              _BulletPoint(
                text:
                    "Méthode : contact externe, par-dessus les vêtements, sans retrait de vêtement.",
              ),
              SizedBox(height: 10),
              _SubTitle("B) Fouille de sécurité"),
              _BulletPoint(
                text:
                    "Avant rétention (GAV, IPM…) ou sous mandat : vérifications plus poussées et adaptées au contexte.",
              ),
              _BulletPoint(
                text:
                    "Nécessité : suspicion d’objets dangereux ; déshabillage complet interdit.",
              ),
              SizedBox(height: 10),
              _SubTitle("C) Fouille intégrale"),
              _BulletPoint(
                text:
                    "But : recherche de preuve (poche/doublures, etc.) ; peut impliquer un déshabillage complet.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modalités
          _ConditionCard(
            title: "III — Modalités de mise en œuvre",
            cardColor: cardModal,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Quand la pratiquer ?"),
              _BulletPoint(
                text:
                    "Jamais systématique : uniquement si les circonstances (temps/lieux/comportement) rendent nécessaire la recherche d’un objet dangereux.",
              ),
              _BulletPoint(
                text:
                    "Respect et discernement : pas de caractère vexatoire, pas d’agressivité.",
              ),

              SizedBox(height: 12),

              _SubTitle("Comment la pratiquer ? (méthodique)"),
              _BulletPoint(
                text:
                    "Un seul agent effectue la palpation pendant qu’un ou deux collègues assurent la couverture et la sécurité de l’environnement.",
              ),
              _BulletPoint(
                text:
                    "Aucune dénudation : palpation au travers des vêtements uniquement.",
              ),
              _BulletPoint(
                text:
                    "Cibler d’abord les zones à risque (ceinture abdominale, creux lombaire, aisselles), puis compléter du haut vers le bas.",
              ),
              _BulletPoint(
                text:
                    "Dès découverte d’un objet suspect : informer immédiatement les collègues.",
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Technique recommandée (AMARIS)",
                bodySpans: [
                  TextSpan(
                    text:
                        "Privilégier la technique de pince : pressions successives avec le pouce et l’index, "
                        "plutôt que de faire glisser les mains le long du corps.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Saisie / procédure",
                bodySpans: [
                  TextSpan(
                    text:
                        "La palpation ne nécessite pas la qualité d’OPJ. Les objets dangereux découverts (armes, outils d’effraction…) "
                        "sont appréhendés matériellement puis remis à l’OPJ aux fins de saisie dans les formes de droit.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas pratiques
          _ConditionCard(
            title: "IV — Cas pratiques (terrain)",
            cardColor: cardCases,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Avant un contrôle d’identité"),
              _Paragraph(
                "Si la personne apparaît potentiellement dangereuse, il est conseillé d’effectuer une palpation de sécurité "
                "avant la mise en œuvre du contrôle.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Indice apparent : forme d’une arme sous un vêtement, objet saillant…",
              ),
              _BulletPoint(
                text:
                    "Comportement : alcool/stupéfiants, agressivité, agitation…",
              ),
              _BulletPoint(
                text:
                    "Connaissance/infos utiles : antécédents (si consultation de traitements possible), contexte à risque…",
              ),

              SizedBox(height: 12),

              _SubTitle("Après un contrôle d’identité sans infraction"),
              _Paragraph(
                "Une palpation postérieure ne se justifie plus si aucun comportement dangereux ou suspect n’est constaté.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "En revanche, si la personne devient menaçante ou si la situation dégénère, la palpation peut redevenir nécessaire "
                "car elle protège policiers et tiers.",
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Trace écrite",
                bodySpans: [
                  TextSpan(
                    text:
                        "Si le contrôle intervient dans des conditions dangereuses, il faut faire apparaître dans la procédure "
                        "le caractère délicat/dangereux de l’intervention.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Attention",
                bodySpans: [
                  TextSpan(
                    text:
                        "Une palpation non justifiée peut être qualifiée d’atteinte à la dignité : les saisies incidentes "
                        "et les procédures qui suivent peuvent être annulées.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(text: "Exemple jurisprudentiel : "),
                TextSpan(
                  text: "Cass. crim., 27 septembre 1988",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " — opération jugée régulière dès lors que les policiers se sont bornés à prendre les mesures nécessaires "
                      "à leur sécurité et à celle des tiers.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Particularités / dignité / transidentité
          _ConditionCard(
            title: "V — Dignité, discrétion et situations particulières",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Expliquer (si possible) : annoncer la palpation et son objectif (sécurité).",
              ),
              _BulletPoint(
                text:
                    "Ne pas exiger le retrait de vêtements ; éviter les positions vexatoires (appui mur, amené au sol, bras levés…).",
              ),
              _BulletPoint(
                text:
                    "Autant que possible : pratiquer à l’abri du regard du public.",
              ),
              _BulletPoint(
                text:
                    "Même sexe : principe. Exceptions uniquement si dangerosité/urgence ne permet pas autrement.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text:
                        "En matière de palpation/fouille, prendre en compte le genre. Certaines personnes transgenres peuvent présenter un formulaire explicatif "
                        "et demander que l’opération soit réalisée par un homme ou une femme. Dans la mesure du possible, il est recommandé de tenir compte de cette demande.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Agents privés
          _ConditionCard(
            title: "VI — Palpation par des agents privés de sécurité",
            cardColor: cardPrivate,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La loi autorise, sous conditions, des palpations par des agents de sécurité privée. "
                "Dans tous les cas : la personne doit donner son accord exprès et l’agent doit être du même sexe.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 613-2 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : agents d’entreprises de surveillance/gardiennage ou services internes de sécurité, "
                      "en cas de menaces graves pour la sécurité publique ou périmètre de protection par arrêté préfectoral.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 613-3 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : sécurité à l’entrée d’enceintes de manifestations sportives/récréatives/culturelles "
                      "rassemblant plus de 300 spectateurs (agents/membres du service d’ordre).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Mémo AMARIS
          _ConditionCard(
            title: "Mémo terrain (AMARIS) — “Comment faire ?”",
            cardColor: cardModal,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("1) J’annonce"),
              _BulletPoint(
                text:
                    "Informer la personne que je vais procéder à une palpation de sécurité.",
              ),
              _BulletPoint(
                text:
                    "Si le contexte le permet : inviter à remettre volontairement les objets estimés dangereux (politesse + calme).",
              ),

              SizedBox(height: 12),

              _SubTitle("2) Je respecte la dignité"),
              _BulletPoint(text: "Je ne suis ni brutal ni agressif."),
              _BulletPoint(text: "Je n’exige pas qu’elle ôte ses vêtements."),
              _BulletPoint(
                text:
                    "J’évite les positions vexatoires (mur, amené au sol, bras levés…).",
              ),
              _BulletPoint(text: "Même sexe (hors situation exceptionnelle)."),
              _BulletPoint(
                text: "À l’abri du regard du public dès que possible.",
              ),

              SizedBox(height: 12),

              _SubTitle("3) Je fais une palpation efficace"),
              _BulletPoint(
                text:
                    "Technique de pince : pressions successives + mouvement pouce/index.",
              ),

              SizedBox(height: 10),

              _NotaBox(
                title: "En résumé",
                bodySpans: [
                  TextSpan(
                    text:
                        "La palpation sert uniquement à rechercher un objet dangereux. "
                        "Elle doit respecter la dignité et être réalisée selon les techniques enseignées.",
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
