import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteintesVolontairesQualifieesViolencesPage extends StatelessWidget {
  const PaAtteintesVolontairesQualifieesViolencesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_volontaires_qualifiees_violences';

  static const Color _lawRed = Color(0xFFE53935);

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
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
          "Violences",
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
            "Les atteintes volontaires à l’intégrité de la personne\nqualifiées violences",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
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
                "Les atteintes volontaires à l’intégrité physique et/ou psychique de la personne sont des violences "
                "et constituent une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles R. 624-1 et R. 625-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définissent et répriment les violences contraventionnelles.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-11 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : définit et réprime les violences délictuelles.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-9 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime les violences ayant entraîné une mutilation ou une infirmité permanente.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime les violences ayant entraîné la mort sans intention de la donner.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Un acte positif"),
              _Paragraph(
                "Les violences supposent un comportement actif : la simple abstention ne constitue pas une violence "
                "(dans ce cas, d’autres qualifications peuvent être retenues : privation de soins, etc.).",
              ),
              SizedBox(height: 10),

              _SubTitle("1) Un contact physique (direct ou indirect)"),
              _Paragraph(
                "Sont visés tous les comportements impliquant un contact physique entre l’auteur et la victime : "
                "coups de poing, gifles, morsures, etc.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le contact peut ne pas être direct : le moyen importe peu (arme, objet quelconque, animal excité par l’auteur, etc.).",
              ),

              SizedBox(height: 14),

              _SubTitle("2) Une atteinte psychique"),
              _Paragraph(
                "Les violences volontaires peuvent être caractérisées par une agression psychique : "
                "des agissements impressionnant fortement la victime, causant un choc émotif ou un trouble psychologique.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le délit est constitué même sans atteinte physique, par tout acte de nature à impressionner vivement la victime et à lui causer un choc émotif : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 mars 2008 (n°07-86.075)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-14-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : codifie la jurisprudence et rappelle que les violences, au sens des articles 222-7 et suivants, "
                      "sont constituées quelle que soit leur nature, y compris psychologique.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  TextSpan(
                    text:
                        "Individu qui descend de sa voiture avec une barre de fer et frappe l’arrière du véhicule de la victime : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 18 mars 2008",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Sur la personne d’autrui"),
              _BulletPoint(text: "Une personne humaine."),
              _BulletPoint(text: "Une personne vivante."),
              _BulletPoint(text: "Une personne distincte de l’auteur."),

              SizedBox(height: 14),

              _SubTitle("C) Un résultat dommageable"),
              _Paragraph(
                "Les violences supposent une atteinte à l’intégrité physique et/ou psychique. "
                "La réalité du dommage doit être établie (souvent par certificat médical).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Brimades ayant entraîné un état anxio-dépressif grave avec ITT > 8 jours : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 4 mars 2003",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "Conscience de commettre un acte affectant l’intégrité d’autrui",
              ),
              _Paragraph(
                "Le délit est consommé lorsque les violences sont intentionnelles : "
                "l’auteur agit avec la connaissance qu’il en résultera un préjudice pour la victime. "
                "Il n’est pas nécessaire qu’il ait voulu précisément le dommage constaté.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’infraction est constituée dès qu’il existe un acte volontaire de violence dirigée contre une ou plusieurs personnes, "
                        "quel que soit le mobile, même si l’auteur n’a pas voulu le dommage résultant : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 3 octobre 1991",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Violences (ITT ≤ 8 jours ou aucune ITT)"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-13 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : prévoit trois degrés d’aggravation."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Exemples de circonstances aggravantes (liste non exhaustive ici) :",
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Victime mineure de 15 ans."),
              _BulletPoint(
                text:
                    "Victime vulnérable (âge, maladie, infirmité, déficience physique/psychique, grossesse) apparente ou connue.",
              ),
              _BulletPoint(
                text:
                    "Personne dépositaire de l’autorité publique / mission de service public, dans l’exercice ou du fait des fonctions (qualité apparente ou connue).",
              ),
              _BulletPoint(
                text:
                    "Professionnels visés (ex. gardiennage/surveillance) au sens de l’article L. 271-1 du CSI.",
              ),
              _BulletPoint(
                text:
                    "Activité privée de sécurité au sens des articles L. 611-1 ou L. 621-1 du CSI.",
              ),
              _BulletPoint(text: "Conjoint/concubin/PACS."),
              _BulletPoint(
                text: "Réunion (plusieurs auteurs/complices).",
              ),
              _BulletPoint(text: "Préméditation / guet-apens."),
              _BulletPoint(text: "Usage ou menace d’une arme."),
              _BulletPoint(
                text:
                    "État d’ivresse manifeste ou sous l’emprise manifeste de stupéfiants.",
              ),
              _BulletPoint(
                text:
                    "Dissimulation volontaire du visage pour ne pas être identifié.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le texte prévoit aussi des degrés (2e et 3e) selon la combinaison de circonstances (deux ou trois).",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Violences (ITT > 8 jours)"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-12 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : prévoit trois degrés d’aggravation."),
              ]),

              SizedBox(height: 14),

              _SubTitle("C) Mutilation / infirmité permanente"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : prévoit deux degrés d’aggravation."),
              ]),

              SizedBox(height: 14),

              _SubTitle("D) Mort sans intention de la donner"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-8 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : prévoit deux degrés d’aggravation."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Repères (textes)"),
              _Paragraph.rich([
                TextSpan(text: "Contraventions : "),
                TextSpan(
                  text: "R. 624-1 et R. 625-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Délits : "),
                TextSpan(
                  text:
                      "articles 222-11, 222-12, 222-13, 222-9, 222-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Crimes : "),
                TextSpan(
                  text: "articles 222-7 et 222-8 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                title: "Personnes morales",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les personnes morales peuvent être déclarées pénalement responsables et encourent les peines prévues par ",
                  ),
                  TextSpan(
                    text: "l’article 222-16-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text:
                    "Tentative : NON (en matière contraventionnelle et délictuelle).",
              ),
              SizedBox(height: 6),
              _Paragraph(
                "En matière criminelle, la tentative est théoriquement punissable, mais peut être difficile à établir "
                "car l’infraction dépend en partie du résultat.",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Complicité : OUI."),
              _Paragraph.rich([
                TextSpan(text: "Punissable conformément aux "),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Contraventions (particularité)",
                bodySpans: [
                  TextSpan(
                    text:
                        "En principe, pas de complicité de contravention. Toutefois, les textes prévoient l’aide/assistance "
                        "punie des mêmes peines que la contravention elle-même : ",
                  ),
                  TextSpan(
                    text: "articles R. 624-1 et R. 625-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La complicité par provocation ou instructions reste punissable, y compris dans le domaine contraventionnel.",
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
