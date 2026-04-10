import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BruitsTapagesPage extends StatelessWidget {
  const BruitsTapagesPage({super.key});

  static const String routeName = '/gpx/intervention/domicile/bruits-tapages';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
          "Domicile",
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
            "Les bruits et tapages",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte / idée générale
          _ConditionCard(
            title: "Comprendre",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les bruits portant atteinte à la tranquillité publique peuvent avoir des origines très diverses "
                "(domestiques, chantiers, activités professionnelles, tapage nocturne, disputes bruyantes…). "
                "Selon la nature du bruit, les textes applicables et la procédure diffèrent : parfois sans mesure acoustique, "
                "parfois avec sonomètre.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal EN HAUT (textes principaux)
          _ConditionCard(
            title: "I — Élément légal (textes principaux)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 1336-5 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : bruits de voisinage d’origine domestique (durée, répétition ou intensité portant atteinte à la tranquillité).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 1336-10 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : bruits de chantier (travaux soumis à déclaration/autorisation) avec conditions spécifiques.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 1336-6 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : bruits excessifs relevant d’activités (professionnelles, sportives, culturelles, loisirs) pouvant nécessiter une mesure.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 623-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : bruits ou tapages injurieux ou nocturnes troublant la tranquillité d’autrui.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Selon le cadre (CSP / CP), la classe de contravention, la procédure (amende forfaitaire) et les peines complémentaires peuvent varier.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bruits de voisinage sans mesure
          _ConditionCard(
            title: "II — Bruits constatés sans mesure acoustique",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Bruits d’origine domestique"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 1336-5 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : s’applique aux bruits résultant du comportement d’une personne (ou d’une chose/animal dont elle a la garde) "
                      "dès lors qu’ils portent atteinte à la tranquillité du voisinage par leur durée, leur répétition ou leur intensité.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Exemples : cris d’animaux, musique, diffusion de son, jeux bruyants, fêtes familiales, travaux, outils, pièces d’artifice…",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Répression : amende 4e classe — "),
                TextSpan(
                  text: "article R. 1337-7 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Amende forfaitaire possible — "),
                TextSpan(
                  text: "article R. 48-1 du Code de procédure pénale",
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
                  text: "Peine complémentaire possible : confiscation — ",
                ),
                TextSpan(
                  text: "article R. 1337-8 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (sauf amende forfaitaire)."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Complicité (aide/assistance) : même peine — ",
                ),
                TextSpan(
                  text: "article R. 1337-9 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("B) Bruits de chantier"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 1336-10 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : vise les bruits provenant de chantiers (travaux publics/privés) soumis à déclaration ou autorisation, "
                      "lorsqu’ils troublent le voisinage.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le trouble est caractérisé notamment en cas de :\n"
                "• non-respect des conditions fixées par l’autorité compétente (réalisation des travaux, matériels, équipements)\n"
                "• insuffisance de précautions appropriées pour limiter le bruit\n"
                "• comportement anormalement bruyant",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Répression : amende 5e classe — "),
                TextSpan(
                  text: "article R. 1337-6 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Confiscation possible — "),
                TextSpan(
                  text: "article R. 1337-8 du Code de la santé publique",
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
                  text: "Complicité (aide/assistance) : même peine — ",
                ),
                TextSpan(
                  text: "article R. 1337-9 du Code de la santé publique",
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
                        "Le bricolage ou des travaux non soumis à déclaration/autorisation ne relèvent pas de ce régime spécifique : "
                        "ils sont en pratique traités via les textes des bruits domestiques.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mesure acoustique
          _ConditionCard(
            title: "III — Bruits nécessitant une mesure acoustique",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 1336-6 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : liste des bruits excessifs pouvant nécessiter un recours au sonomètre.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il s’agit notamment des bruits ayant pour origine :\n"
                "• une activité professionnelle (hors chantier)\n"
                "• une activité sportive\n"
                "• une activité culturelle ou de loisirs\n"
                "\nDans ces cas, l’activité est habituelle ou soumise à autorisation, et les conditions d’exercice relatives au bruit "
                "n’ont pas été fixées par l’autorité compétente.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Sont aussi concernés les établissements devant prévoir une isolation acoustique ou les locaux recevant du public diffusant habituellement de la musique amplifiée.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le non-respect des prescriptions applicables est susceptible d’être sanctionné par des contraventions de 5e classe.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Agents habilités
          _ConditionCard(
            title: "IV — Agents habilités à constater",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Sont notamment habilités à constater les infractions :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "O.P.J, A.P.J, A.P.J.A (dans le cadre des dispositions du Code de procédure pénale).",
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Agents des douanes, répression des fraudes, inspecteurs installations classées, agents commissionnés et assermentés "
                    "(environnement, agriculture, industrie, équipement, transports, mer, santé, jeunesse et sports), inspecteurs de salubrité, "
                    "agents des collectivités locales.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "article L. 571-18 du Code de l’environnement",
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
                        "Ces agents peuvent, après accord du procureur de la République, procéder à des constatations en matière de bruits de voisinage.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tapage CP : rendu pédagogique 3 éléments
          _ConditionCard(
            title: "V — Tapage (Code pénal) : les 3 éléments",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Élément légal"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 623-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : incrimine les bruits ou tapages injurieux ou nocturnes troublant la tranquillité d’autrui.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Élément matériel"),
              const _Paragraph(
                "Le tapage peut être compris comme une série de bruits tumultueux (vacarme, brouhaha), "
                "de nature à troubler la tranquillité publique.\n"
                "\n• Tapage nocturne : entre le coucher et le lever du soleil.\n"
                "• Tapage injurieux : disputes violentes et bruyantes, vociférations, invectives, grossièretés…\n"
                "\nLe bruit peut provenir d’une ou plusieurs personnes, d’un animal ou d’une chose (aboiements, musique, télévision…). "
                "Il suffit que le bruit soit perceptible à l’extérieur (voisins, passants), même si une seule personne est troublée.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Élément moral"),
              const _Paragraph(
                "L’infraction est constituée si le bruit résulte d’un fait volontaire et personnel. "
                "L’idée-clé : l’auteur a conscience du trouble causé et refuse ou néglige de faire cesser le tapage.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression / procédures
          _ConditionCard(
            title: "VI — Répression & procédure",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Tapage (Code pénal)"),
              _Paragraph.rich([
                const TextSpan(text: "Contravention 3e classe — "),
                TextSpan(
                  text: "article R. 623-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Amende forfaitaire applicable — "),
                TextSpan(
                  text: "article R. 48-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Une peine complémentaire de confiscation peut être prononcée (selon les cas, notamment hors amende forfaitaire).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Bruits domestiques / chantier (CSP)"),
              _Paragraph.rich([
                const TextSpan(text: "Bruits domestiques : 4e classe — "),
                TextSpan(
                  text: "article R. 1337-7 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Bruits de chantier : 5e classe — "),
                TextSpan(
                  text: "article R. 1337-6 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Confiscation (CSP) — "),
                TextSpan(
                  text: "article R. 1337-8 du Code de la santé publique",
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

          // Tentative & complicité (rendu clean)
          _ConditionCard(
            title: "VII — Tentative & complicité",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("Tentative"),
              const _BulletPoint(
                text:
                    "En matière de contraventions, la tentative n’est en principe pas punissable (sauf texte spécial).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Pour les bruits relevant du CSP : "),
                TextSpan(
                  text: "article R. 1337-9 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (aide ou assistance)."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Pour le tapage (CP) : la complicité est visée dans ",
                ),
                TextSpan(
                  text: "l’article R. 623-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (alinéa relatif à la complicité)."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse opérationnelle (codes)
          _ConditionCard(
            title: "VIII — Synthèse opérationnelle (rappels)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Repères utiles en intervention (sans mesure acoustique) :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Tapage injurieux diurne : bruits/tapage injurieux troublant la tranquillité d’autrui (contravention 3e classe).",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Tapage nocturne : bruits/tapage nocturne troublant la tranquillité d’autrui (contravention 3e classe).",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Bruits domestiques : atteinte à la tranquillité du voisinage par durée/répétition/intensité (contravention 4e classe).",
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Bruits de chantier (soumis à déclaration/autorisation) : conditions spécifiques + contravention 5e classe.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Toujours qualifier selon l’origine (domestique / chantier / activité / tapage CP). "
                        "C’est la qualification qui conditionne la procédure (forfaitaire ou non), la classe de contravention et les suites.",
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
