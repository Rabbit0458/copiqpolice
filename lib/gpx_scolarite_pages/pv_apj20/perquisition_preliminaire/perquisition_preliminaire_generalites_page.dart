import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerquisitionPreliminaireGeneralitesPage extends StatelessWidget {
  const PerquisitionPreliminaireGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/perquisition_preliminaire/generalites';

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
    final Color cardCaution = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardFouilles = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
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
          "Perquisition (préliminaire)",
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
            "La perquisition en enquête préliminaire\nGénéralités",
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
                "La perquisition est la recherche, dans tout lieu normalement clos, d’indices, de documents "
                "ou d’objets confiscables relatifs aux faits incriminés.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "La remise spontanée de documents ne constitue pas une perquisition.",
              ),
              _IntroBullet(
                text:
                    "En enquête de flagrance, l’APJ n’est pas habilité à procéder à une perquisition : il assiste l’OPJ.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (les références CPP/CP en rouge)
          _ConditionCard(
            title: "I — Élément légal (références essentielles)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Perquisition préliminaire : "),
                const TextSpan(
                  text: "article 76 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (assentiment / autorisation JLD et règles spécifiques, notamment pour majeurs protégés).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Heures légales : "),
                const TextSpan(
                  text: "article 59 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " (6h à 21h)."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Biens confiscables : "),
                const TextSpan(
                  text: "article 131-21 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (confiscation — pièces/biens pouvant faire l’objet d’une saisie).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I. Perquisitions / saisies / scellés
          _ConditionCard(
            title: "II — Perquisitions, saisies, scellés",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Lieu & temps de la perquisition"),

              const _SubTitle("1) Lieu de la perquisition"),
              const _Paragraph(
                "Une perquisition peut être réalisée :\n"
                "• au domicile de toute personne susceptible d’avoir participé à l’infraction ;\n"
                "• au domicile de toute personne susceptible de détenir des pièces, objets ou documents relatifs aux faits.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Définition du domicile : tout lieu où une personne a son principal établissement, ainsi que tout lieu où, "
                        "qu’elle y habite ou non, elle a le droit de se dire chez elle (peu importe le titre d’occupation et l’affectation des locaux).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Peut inclure : résidence, lieu de séjour occasionnel (propriétaire ou occupant précaire), "
                "dépendances et annexes indissociables proches du lieu principal. Sont assimilés : box/garage, parking souterrain, cave privative.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Lieux protégés / règles particulières"),
              const _Paragraph(
                "Certains lieux privés sont protégés :\n"
                "• certains n’autorisent aucune perquisition (ex. locaux diplomatiques/consulaires) ;\n"
                "• d’autres imposent des règles spécifiques (ex. cabinet/domicile d’un avocat, entreprise de presse, "
                "cabinet d’un médecin, notaire/huissier, lieux couverts par le secret défense, locaux d’une juridiction, "
                "ou domicile d’une personne exerçant des fonctions juridictionnelles).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Majeur protégé"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si la perquisition doit avoir lieu au domicile d’un majeur protégé qui ne peut pas exercer seul son droit de s’opposer : l’OPJ avise au préalable le tuteur/curateur. "
                      "L’assentiment ne peut être donné qu’après entretien tuteur/curateur ↔ majeur protégé. À défaut : autorisation JLD. — ",
                ),
                const TextSpan(
                  text: "article 76 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("2) Temps de la perquisition"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les perquisitions se déroulent entre 6h00 et 21h00. Une perquisition débutée avant 21h00 peut se poursuivre au-delà. — ",
                ),
                const TextSpan(
                  text: "article 59 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("B) Assentiment préalable"),

              const _SubTitle("1) Assentiment exprès et écrit"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En enquête préliminaire, les perquisitions/saisies/scellés de pièces à conviction ou de biens confiscables nécessitent l’assentiment exprès et écrit du maître des lieux. — ",
                ),
                const TextSpan(
                  text: "article 76 alinéa 1 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’autorisation doit être :\n"
                "• rédigée avant la perquisition,\n"
                "• manuscrite,\n"
                "• expresse.\n"
                "Elle est personnelle et irrévocable.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Absence d’assentiment"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Si l’infraction est un crime ou un délit puni d’une peine d’emprisonnement égale ou supérieure à 3 ans, "
                      "la perquisition peut avoir lieu sans assentiment, sur autorisation du juge des libertés et de la détention, à la requête du procureur. — ",
                ),
                const TextSpan(
                  text: "article 76 alinéa 4 du Code de procédure pénale",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’autorisation doit être écrite et motivée. Elle doit préciser, à peine de nullité :\n"
                "• la qualification de l’infraction,\n"
                "• l’adresse des lieux où les opérations peuvent être effectuées.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Déroulement de la perquisition"),
              const _Paragraph(
                "Dès l’entrée dans les lieux : inspection rapide de sécurité de toutes les pièces.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Présence de l’occupant"),
              const _Paragraph(
                "La perquisition doit être effectuée en présence de la personne chez qui elle a lieu, "
                "qui doit assister personnellement et de manière constante à l’opération.\n"
                "En cas de refus ou d’impossibilité : elle peut désigner une personne pour la représenter.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("2) Rétention sur place"),
              const _Paragraph(
                "Toute personne présente (autre que le maître des lieux) peut être retenue sur place si elle est susceptible "
                "de fournir des renseignements sur les objets/documents saisis, uniquement le temps strictement nécessaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II. Fouilles
          _ConditionCard(
            title: "III — Les fouilles",
            cardColor: cardFouilles,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La fouille est la recherche, dans tous autres endroits qu’un lieu immobilier clos, d’indices ou d’objets confiscables "
                "utiles à la manifestation de la vérité et intéressant l’enquête.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) La fouille intégrale"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Elle ne peut être pratiquée que sur une personne gardée à vue, pour les nécessités de l’enquête, décidée par un OPJ. — ",
                ),
                const TextSpan(
                  text: "article 63-7 du C.P.P.",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il ne peut y être recouru que si une palpation ou l’utilisation de moyens électroniques de détection ne peuvent être réalisées.\n"
                "Assimilée à une perquisition : soumise à l’assentiment de la personne, mais sans contrainte des heures légales.\n"
                "Elle doit être réalisée dans un espace fermé et par une personne du même sexe.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) La fouille de véhicule"),
              const _Paragraph(
                "Le véhicule n’est pas considéré comme un domicile (ni le prolongement du domicile).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La fouille de véhicule obéit aux mêmes règles que la perquisition :\n"
                "• réalisée en présence de la personne trouvée en possession du véhicule,\n"
                "• après autorisation délivrée par celle-ci dans des formes identiques à l’assentiment de perquisition.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Heures légales :\n"
                "• pas d’obligation si le véhicule n’a jamais constitué un domicile,\n"
                "• MAIS si le véhicule est dans l’enceinte du domicile perquisitionné (garage/cour), la fouille suit le régime du domicile (respect des heures légales).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bloc mémo
          _ConditionCard(
            title: "Mémo opérationnel",
            cardColor: cardCaution,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _BulletPoint(
                text:
                    "Toujours qualifier le cadre : préliminaire = assentiment écrit (sauf autorisation JLD).",
              ),
              const _BulletPoint(
                text:
                    "Respecter les heures légales 6h–21h (sauf cas particulier prévu).",
              ),
              const _BulletPoint(
                text:
                    "Présence du maître des lieux (ou représentant) + inspection de sécurité dès l’entrée.",
              ),
              const _BulletPoint(
                text:
                    "Attention aux lieux protégés et aux majeurs protégés (avis tuteur/curateur ou JLD).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Astuce rédaction : toujours faire apparaître clairement le fondement (CPP/CP), "
                        "l’assentiment (ou l’autorisation JLD) et les horaires, pour sécuriser la procédure.",
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
