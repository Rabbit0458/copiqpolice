import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConduiteVehiculesPolicePage extends StatelessWidget {
  const ConduiteVehiculesPolicePage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/conduite-vehicules';

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
    final Color cardPrincipe = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUrgence = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNecessite = isDark
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
            "La conduite des véhicules de police",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Références (élément légal en haut)
          _ConditionCard(
            title: "I — Références & cadre légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Souvent dans le cadre de l’urgence, les policiers ont un souci légitime d’intervenir vite. "
                "Le Code de la route prévoit un droit de priorité spécial pour les véhicules de police, mais "
                "ce droit est strictement encadré, limité et toujours soumis à la prudence.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 415-12 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : tout conducteur doit céder le passage aux véhicules d’intérêt général prioritaires annonçant leur approche par les avertisseurs spéciaux.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 311-1 (6.5) du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : liste des véhicules prioritaires, incluant les véhicules de police.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Avertisseurs spéciaux : "),
                TextSpan(
                  text: "articles R. 313-27 et R. 313-34 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Policiers adjoints : la conduite n’est possible que si ",
                  ),
                  TextSpan(
                    text: "l’article 134-1 du R.G.E.P.N.",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " est respecté (permis adapté + aptitudes testées par le service d’emploi).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principe
          _ConditionCard(
            title: "II — Principe : priorité, mais sous conditions",
            cardColor: cardPrincipe,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’urgence n’est pas la norme : la majorité des déplacements (liaisons, transports, patrouilles, "
                "rondes, escortes) s’effectue à allure normale.\n\n"
                "La priorité n’est justifiée que par la nécessité de répondre à une situation déterminée et "
                "elle est limitée dans le temps.",
              ),
              SizedBox(height: 10),
              _SubTitle("Conditions cumulatives du droit de priorité"),
              _BulletPoint(text: "Urgence caractérisée de la mission."),
              _BulletPoint(
                text:
                    "Utilisation des avertisseurs sonores et lumineux spéciaux (pas un gyrophare « tableau de bord »).",
              ),
              _BulletPoint(
                text:
                    "Respect des règles élémentaires de prudence (ex : marquer un temps d’arrêt avant un feu rouge).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Attention",
                bodySpans: [
                  TextSpan(
                    text:
                        "La responsabilité individuelle du conducteur peut être retenue en cas d’inobservation des règles de prudence, avec sanctions possibles.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Ceinture
          _ConditionCard(
            title: "III — Ceinture de sécurité : règle + exception",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Principe : port obligatoire de la ceinture pour tout conducteur ou passager. — ",
                ),
                TextSpan(
                  text: "article R. 412-1 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Exception : l’obligation disparaît en intervention d’urgence. — ",
                ),
                TextSpan(
                  text: "article R. 412-1 (I, 3°) du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Recommandation",
                bodySpans: [
                  TextSpan(
                    text:
                        "Même en intervention, il est recommandé de respecter autant que possible le principe général du port de la ceinture.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Urgence
          _ConditionCard(
            title: "IV — La notion d’urgence (appréciation terrain)",
            cardColor: cardUrgence,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention en urgence ne se justifie que si elle est susceptible d’apporter une réponse "
                "efficace à un danger ou à une menace pesant sur la vie ou sur les biens d’autrui.\n\n"
                "Le policier doit apprécier, au cas par cas, le caractère d’urgence et le degré de gravité.",
              ),
              SizedBox(height: 10),
              _SubTitle("Exemples d’urgence"),
              _BulletPoint(
                text: "Personne en péril (ex : tentative de suicide).",
              ),
              _BulletPoint(
                text:
                    "Accident de la circulation nécessitant un balisage rapide pour la sécurité des usagers.",
              ),
              SizedBox(height: 12),
              _SubTitle("Exemple sans urgence (principe)"),
              _Paragraph(
                "Il n’y a pas urgence à se rendre sur les lieux d’un cambriolage aux seules fins de constatations.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Conduite à tenir",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le franchissement d’un feu rouge fixe ou d’un STOP doit se faire avec la plus grande précaution, "
                        "à une vitesse permettant l’arrêt immédiat en cas de danger.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // État de nécessité
          _ConditionCard(
            title: "V — L’état de nécessité (fait justificatif)",
            cardColor: cardNecessite,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’état de nécessité, défini en droit pénal, peut justifier une infraction au Code de la route : ",
                ),
                TextSpan(
                  text: "article 122-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Il entraîne l’irresponsabilité pénale si les conditions sont réunies.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Conditions à réunir"),
              const _BulletPoint(
                text:
                    "Danger actuel ou imminent menaçant une personne ou un bien.",
              ),
              const _BulletPoint(
                text:
                    "Nécessité, pour sauvegarder la personne/le bien, de commettre une infraction.",
              ),
              const _BulletPoint(
                text:
                    "Proportion entre les moyens employés et la gravité de la menace.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Point de vigilance",
                bodySpans: [
                  TextSpan(
                    text:
                        "Il ne doit pas exister de faute antérieure de l’agent (ex : retard volontaire préalable).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Même si l’état de nécessité exonère pénalement, la responsabilité civile de l’administration "
                "reste engagée pour les dommages. Sur le plan administratif, une sanction peut aussi être envisagée.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Règle d’or",
                bodySpans: [
                  TextSpan(
                    text:
                        "Même en urgence, éviter les risques inconsidérés : la progression doit rester compatible avec la sécurité des occupants et des autres usagers.",
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
