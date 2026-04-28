import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegimeJuridiqueReglementationAmenagementPage extends StatelessWidget {
  const RegimeJuridiqueReglementationAmenagementPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement';

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
    final Color cardChap1 = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardExe = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardException = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAmenagement = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Libertés publiques",
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
            "Régime juridique : réglementation et aménagement des libertés publiques",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===================== INTRO =====================
          _ConditionCard(
            title: "Idée générale",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Il n’existe pas de liberté publique « absolue » : une liberté sans limites ferait disparaître l’État "
                "au profit de l’anarchie. Les libertés sont donc garanties, mais encadrées, pour permettre la vie en société.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La Déclaration de 1789 rappelle déjà la logique : la liberté consiste à pouvoir faire tout ce qui ne nuit pas à autrui — ",
                ),
                TextSpan(
                  text: "Art. 4 de la DDHC",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 : AUTORITÉS =====================
          _ConditionCard(
            title: "Chapitre 1 — Les autorités qui réglementent les libertés",
            cardColor: cardChap1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La réglementation des libertés publiques relève principalement du législateur, et subsidiairement du pouvoir exécutif.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "1.1 — Rôle du législateur (compétence de principe)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Seule la loi peut fixer des « bornes » aux libertés publiques — ",
                ),
                TextSpan(
                  text: "Art. 4 de la DDHC",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La Constitution de 1958 confirme : la loi fixe les règles concernant les droits civiques et les garanties fondamentales accordées aux citoyens pour l’exercice des libertés publiques — ",
                ),
                TextSpan(
                  text: "Art. 34 de la Constitution",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("Ce que le législateur peut faire"),
              const _BulletPoint(
                text:
                    "Créer de nouvelles libertés (dans le respect de la hiérarchie des normes).",
              ),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Exemples : "),
                  TextSpan(
                    text:
                        "loi n° 70-643 du 17 juillet 1970 (vie privée) — art. 9 du Code civil",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "loi n° 2024-200 du 8 mars 2024 (IVG).",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Définir les modalités concrètes d’exercice (ex. droit de grève encadré par des lois).",
              ),
              const _BulletPoint(
                text:
                    "Restreindre une liberté (même constitutionnelle) pour concilier un autre objectif constitutionnel (ex. continuité du service public).",
              ),
              const _BulletPoint(
                text:
                    "Supprimer une liberté sous contrôle (ex. interdiction du droit de grève de certains fonctionnaires).",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "Limites : remise en cause de situations existantes",
              ),
              const _Paragraph(
                "Le législateur ne peut remettre en cause des situations intéressant une liberté publique que :\n"
                "• si elles ont été illégalement acquises ;\n"
                "• ou si cette remise en cause est réellement nécessaire pour atteindre l’objectif constitutionnel poursuivi.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== POUVOIR EXÉCUTIF =====================
          _ConditionCard(
            title: "1.2 — Rôle du pouvoir exécutif (pouvoir réglementaire)",
            cardColor: cardExe,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Si la loi fixe le cadre, le pouvoir réglementaire est essentiel pour la mise en œuvre : "
                "il complète la loi et peut aussi réglementer pour le maintien de l’ordre public.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Deux hypothèses principales"),
              const _BulletPoint(
                text:
                    "Compléter la loi (ex. le code de la route : partie réglementaire complète la partie législative).",
              ),
              const _BulletPoint(
                text:
                    "Maintien de l’ordre public (hypothèse la plus importante).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Autorités compétentes"),
              const _Paragraph(
                "Au plan national : Président de la République / Premier ministre.\n"
                "Au plan local : préfet, maire, président du conseil départemental (selon compétences).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Période normale : règles de contrôle"),
              const _BulletPoint(
                text:
                    "Interdiction générale et absolue d’une liberté : impossible.",
              ),
              _BulletPoint(
                text:
                    "Une interdiction temporaire n’est légale que si elle est indispensable au maintien de l’ordre public.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Jurisprudence : "),
                  TextSpan(
                    text: "C.E., 19 mai 1933, Benjamin",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " — plus une liberté est fondamentale, plus le contrôle du juge est exigeant.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== PÉRIODES EXCEPTIONNELLES =====================
          _ConditionCard(
            title:
                "1.2.2 — Périodes exceptionnelles : extension des restrictions",
            cardColor: cardException,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "En période de troubles graves, la réglementation des libertés publiques s’intensifie. "
                "Les régimes exceptionnels élargissent les pouvoirs de police et peuvent restreindre certaines libertés.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) État de siège"),
              _Paragraph.rich([
                const TextSpan(text: "Prévu par "),
                TextSpan(
                  text: "l’Art. 36 de la Constitution",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (décrété en Conseil des ministres ; prorogation > 12 jours = Parlement).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Conditions : "),
                TextSpan(
                  text: "art. L. 2121-1 du Code de la défense",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — péril imminent résultant d’une guerre étrangère ou d’une insurrection armée.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Conséquences : transfert de pouvoirs aux autorités militaires ; extension des pouvoirs de police (perquisitions jour/nuit, censure, contrôle correspondances…) ; réactivation des juridictions militaires.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Pouvoirs exceptionnels (état de crise)"),
              _Paragraph.rich([
                const TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "Art. 16 de la Constitution",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — menace grave et immédiate + interruption du fonctionnement régulier des pouvoirs publics.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Le Président prend les mesures exigées par les circonstances (après consultations prévues).",
              ),
              const _BulletPoint(
                text:
                    "Régime risqué pour les libertés : contrôle limité (acte de gouvernement) et durée non précisée dans la Constitution.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) État d’urgence"),
              _Paragraph.rich([
                const TextSpan(text: "Prévu par "),
                TextSpan(
                  text: "la loi n° 55-385 du 3 avril 1955",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — péril imminent (atteintes graves à l’ordre public) ou calamité publique.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Déclaration initiale 12 jours ; prorogation par une loi fixant la durée.",
              ),
              const _BulletPoint(
                text:
                    "Permet des restrictions ciblées (assignations à résidence, perquisitions administratives, interdictions…).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) État d’urgence sanitaire"),
              _Paragraph.rich([
                const TextSpan(text: "Créé par "),
                TextSpan(
                  text: "la loi n° 2020-290 du 23 mars 2020",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " pour faire face à l’épidémie de Covid-19 (mesures exceptionnelles limitant certaines libertés).",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("E) Théorie des circonstances exceptionnelles"),
              const _Paragraph(
                "Théorie jurisprudentielle : en situation anormale (guerre, troubles, grèves, cataclysmes, épidémies…), "
                "le juge admet une extension des pouvoirs de police, avec des atteintes possibles aux libertés.",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Arrêts repères : "),
                  TextSpan(
                    text: "C.E., 28 mai 1918, Heyriès",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "C.E., 14 déc. 1943, Devaux",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text:
                        "C.E., 7 déc. 1979, Société « Les Fils de Henri Ramel »",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "C.E., 18 mai 1983, Félix Rodes",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("F) Mesure intermédiaire : plan Vigipirate"),
              const _Paragraph(
                "Plan gouvernemental (Premier ministre) : dispositif permanent de vigilance, prévention et protection contre le terrorisme. "
                "Il s’appuie sur l’évaluation de la menace et organise une réaction coordonnée.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Niveaux depuis 1er décembre 2016 : Vigilance / Sécurité renforcée – risque attentat / Urgence attentat.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 : AMÉNAGEMENT =====================
          _ConditionCard(
            title: "Chapitre 2 — Les moyens de réglementation : l’aménagement",
            cardColor: cardAmenagement,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Aménager les libertés publiques, c’est fixer des limites à leur exercice. "
                "En démocratie, deux grandes techniques existent : le régime répressif et le régime préventif.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("2.1 — Régime répressif (le plus favorable)"),
              const _BulletPoint(
                text:
                    "Principe : la liberté est la règle ; seuls les abus sont sanctionnés.",
              ),
              const _BulletPoint(
                text:
                    "Si l’abus constitue une infraction : sanction prononcée par un juge.",
              ),
              const _BulletPoint(
                text:
                    "Si le trouble à l’ordre public n’est pas une infraction : le préfet ou le maire peut interdire pour faire cesser le trouble.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "Art. 5 de la DDHC",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — « tout ce qui n’est pas défendu par la loi ne peut être empêché ».",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("2.2 — Régime préventif"),
              const _BulletPoint(
                text: "Objectif : éviter les abus (on agit avant, pas après).",
              ),
              const _BulletPoint(
                text:
                    "L’exercice de la liberté dépend d’une décision administrative (ordre public).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2.2.1 — Autorisation préalable"),
              const _Paragraph(
                "Régime rigoureux : sans autorisation (ou en cas de refus), la liberté ne s’exerce pas.\n"
                "Exemples : visa d’exploitation cinématographique, permis de construire, permis de conduire.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2.2.2 — Déclaration préalable"),
              const _Paragraph(
                "Moins attentatoire : l’exercice est soumis à une déclaration à l’administration.\n"
                "Exemples : manifestations, associations, préavis de grève, déclaration au parquet pour la presse.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("2.2.3 — Interdiction préalable"),
              const _Paragraph(
                "L’autorité administrative peut interdire :\n"
                "• au titre d’une police spéciale (texte) ;\n"
                "• ou au titre de la police générale (sans texte) si l’ordre public l’exige.",
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "Police spéciale : "),
                TextSpan(
                  text: "art. L. 211-4 du CSI",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (interdiction d’une manifestation si risque de trouble).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Dissolution administrative : "),
                TextSpan(
                  text: "art. L. 212-1 du CSI",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Dans les communes à police étatisée, seul le préfet est compétent pour interdire une manifestation. Référence : ",
                  ),
                  TextSpan(
                    text: "C.E., 28 avril 1989, Commune de Montgeron",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Contrôle du juge : "),
                  const TextSpan(
                    text:
                        "compétence, forme, but, motivations, et examen détaillé des circonstances. Exemple majeur : ",
                  ),
                  TextSpan(
                    text: "C.E., 19 mai 1933, Benjamin",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " — l’interdiction n’est légale que si elle est l’unique moyen de maintenir l’ordre.",
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
