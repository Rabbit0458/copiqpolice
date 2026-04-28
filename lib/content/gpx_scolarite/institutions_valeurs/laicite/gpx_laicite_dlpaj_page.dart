import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GpxLaiciteDlpajPage extends StatelessWidget {
  const GpxLaiciteDlpajPage({super.key});

  static const String routeName = '/gpx/institution/laicite/laicite_dlpaj';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardAgents = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUsagers = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardMemo = isDark
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
          "Institutions & valeurs",
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
            "La laïcité",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Source : DLPAJ / bureau des cultes",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Références juridiques en haut (comme demandé)
          _ConditionCard(
            title: "Références juridiques essentielles",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  "Article 10 de la Déclaration des droits de l’homme et du citoyen",
                ),
                const TextSpan(
                  text:
                      " : « Nul ne doit être inquiété pour ses opinions, même religieuses, pourvu que leur manifestation ne trouble pas l’ordre public établi par la Loi. »",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article 1er de la Constitution de 1958"),
                const TextSpan(
                  text:
                      " : « La France est une République indivisible, laïque, démocratique et sociale. »",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(
                  "Loi du 9 décembre 1905 (séparation des Églises et de l’État)",
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _law("Article 1er (loi de 1905)"),
                const TextSpan(
                  text:
                      " : liberté de conscience et libre exercice des cultes, sous réserve de l’ordre public.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _law("Article 2 (loi de 1905)"),
                const TextSpan(
                  text:
                      " : « La République ne reconnaît, ne salarie ni ne subventionne aucun culte. »",
                ),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "À connaître",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La circulaire du Premier ministre du 13 avril 2007 (charte de la laïcité dans les services publics) rappelle la neutralité des agents publics ; la charte doit être affichée dans les services publics.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I. Qu'est-ce que la laïcité ?
          _ConditionCard(
            title: "I — Qu’est-ce que la laïcité ?",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Définition"),
              const _Paragraph(
                "Il n’existe pas de définition juridique officielle unique. "
                "Le Conseil d’État (Rapport public 2004 « Un siècle de laïcité ») décrit une triple dimension :",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    "Neutralité de l’État vis-à-vis des croyances et des religions.",
              ),
              const _IntroBullet(
                text:
                    "Respect de la liberté de religion et du libre exercice des cultes.",
              ),
              const _IntroBullet(
                text:
                    "Pluralisme : toutes les religions doivent pouvoir s’exprimer.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Attention",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La laïcité n’est ni le reniement des religions, ni un choix spirituel particulier : c’est un cadre commun d’organisation de l’espace public et du service public.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. Agents publics
          _ConditionCard(
            title: "II — La laïcité et les agents publics",
            cardColor: cardAgents,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Neutralité dans l’exercice des fonctions"),
              const _Paragraph(
                "Il est interdit d’avantager ou de pénaliser les usagers (ou les cocontractants de l’administration) "
                "en fonction de convictions politiques, religieuses ou philosophiques.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "La neutralité s’applique aussi aux salariés d’organismes de droit privé chargés d’une mission de service public.",
              ),
              const _BulletPoint(
                text:
                    "En revanche, elle ne s’applique pas aux salariés d’organismes de droit privé n’assurant pas une mission de service public (ex : agents d’entretien dans les commissariats).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Ne pas manifester sa religion au travail"),
              const _Paragraph(
                "Les agents publics ne doivent pas adopter d’attitudes pouvant traduire une adhésion visible à une croyance. "
                "Cela peut constituer une faute professionnelle et entraîner une sanction disciplinaire.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Ne pas porter de signe religieux visible sur le lieu de travail.",
              ),
              const _BulletPoint(
                text:
                    "Ne pas faire de prosélytisme auprès des usagers ou des collègues (ex : courriels religieux).",
              ),
              const _BulletPoint(
                text:
                    "Ne pas utiliser les moyens du service à des fins religieuses (ex : afficher son mail pro sur le site d’une association religieuse).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Liberté de conscience préservée (hors service)",
              ),
              const _Paragraph(
                "Il est interdit de prendre en compte les opinions ou la pratique religieuse (hors travail) "
                "dans le recrutement, la carrière ou la gestion administrative des agents.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Devoir de réserve",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Dans la sphère privée, l’expression des convictions est possible mais doit rester compatible avec la dignité, l’impartialité et la sérénité des fonctions (pas de manifestation excessive susceptible d’avoir un retentissement sur le service).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. Usagers & citoyens
          _ConditionCard(
            title:
                "III — La laïcité et les usagers du service public / citoyens",
            cardColor: cardUsagers,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Principe : liberté d’expression des convictions",
              ),
              const _Paragraph(
                "La règle est que les usagers ont le droit d’exprimer leurs convictions religieuses. "
                "Ils peuvent porter des signes religieux (kippa, foulard, turban, etc.) dans les services publics "
                "(commissariat, mairie, préfecture, équipement public).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Cette liberté vaut aussi dans l’espace public : chacun peut porter des signes religieux dans la rue, "
                "exprimer ses convictions et exercer son culte, dès lors que l’ordre public n’est pas troublé.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Exceptions : limites à respecter"),
              const _Paragraph(
                "La charte de la laïcité dans les services publics rappelle que l’expression des convictions religieuses "
                "s’exerce dans les limites : neutralité du service public, bon fonctionnement, ordre public, santé et hygiène.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("1) Motifs d’ordre public"),
              const _BulletPoint(
                text:
                    "Documents d’identité : obligation d’être photographié « tête nue » (décret de 1955).",
              ),
              const _BulletPoint(
                text:
                    "Dissimulation du visage : interdite dans l’espace public par la loi du 11 octobre 2010 (sauf lieux de culte ouverts au public).",
              ),
              const _BulletPoint(
                text:
                    "Prière de rue : si elle gêne la circulation ou trouble l’ordre public, elle peut être limitée.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Bon fonctionnement / santé / hygiène"),
              const _Paragraph(
                "Un usager ne peut pas exiger qu’un service public s’adapte à ses convictions religieuses.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Restauration collective : la circulaire du ministère de l’Intérieur du 16 août 2011 rappelle que les menus confessionnels ne sont ni un droit pour les usagers, ni une obligation pour les collectivités. Des menus de substitution peuvent exister en pratique.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) Élèves des collèges et lycées publics"),
              const _Paragraph(
                "Ils ne doivent pas porter de signes religieux ostensibles dans l’enceinte des établissements. "
                "Des signes « discrets » peuvent être autorisés.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _law("Loi du 15 mars 2004"),
                const TextSpan(
                  text:
                      " : encadre le port de signes religieux dans les écoles, collèges et lycées publics.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Aide-mémoire (visuel + clair)
          _ConditionCard(
            title: "Aide-mémoire (à retenir)",
            cardColor: cardMemo,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("Règle générale"),
              const _Paragraph(
                "Tous les citoyens peuvent porter des signes religieux en tous lieux (commissariat, mairie, rue, équipements publics, etc.).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Sauf (3 cas majeurs)"),
              const _IntroBullet(
                text:
                    "Les agents publics dans l’exercice de leurs fonctions (neutralité).",
              ),
              const _IntroBullet(
                text:
                    "Les élèves des collèges et lycées publics dans l’enceinte des établissements (signes ostensibles interdits).",
              ),
              const _IntroBullet(
                text:
                    "La dissimulation du visage (voile intégral) dans l’espace public (interdite par la loi du 11 octobre 2010).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Ne pas confondre",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Voile intégral (visage dissimulé) ≠ voile couvrant les cheveux : seul le voile intégral est interdit dans l’espace public.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Pour aller plus loin (sans lien cliquable)
          _ConditionCard(
            title: "Pour aller plus loin",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Consulter l’intranet de la direction des libertés publiques et des affaires juridiques (DLPAJ) "
                "pour des ressources complémentaires sur la laïcité et le cadre juridique applicable.",
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
