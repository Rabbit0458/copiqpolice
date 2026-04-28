import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationMesuresSuretePage extends StatelessWidget {
  const ClassificationMesuresSuretePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/classification_peines/classification_mesures_surete';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color lawRed = const Color(0xFFE53935);

    Color cardBg(Color light, Color dark) => isDark ? dark : light;

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
          "Mesures de sûreté",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          Text(
            "La classification des mesures de sûreté",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Définition et logique générale",
            cardColor: cardBg(const Color(0xFFF6F7FB), const Color(0xFF2B2B2B)),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                "La mesure de sûreté a un but préventif : elle cherche à éviter la survenance "
                "d’infractions en neutralisant, surveillant ou traitant les individus susceptibles "
                "d’être dangereux.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Les mesures de sûreté ne font pas l’objet d’un titre unique du code pénal. "
                "Elles sont éparses, et il paraît difficile d’en faire un véritable inventaire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Chapitre 1 — Les mesures de sûreté curatives",
            cardColor: cardBg(const Color(0xFFEFF7FF), const Color(0xFF263244)),
            accent: const Color(0xFF42A5F5),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _Paragraph(
                "Elles concernent essentiellement les alcooliques et toxicomanes.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("1.1 — Le contrôle judiciaire"),
              _Paragraph.rich([
                const TextSpan(text: "Seul "),
                TextSpan(
                  text: "l’article 138 10° du C.P.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " prévoit, dans le cadre du contrôle judiciaire, l’obligation pour la personne "
                      "de se soumettre à des mesures de traitement ou de soins, notamment aux fins "
                      "de désintoxication.",
                ),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("1.2 — Les mesures thérapeutiques"),
              const _Paragraph(
                "Le législateur a mis en place un système qui donne la priorité aux mesures "
                "thérapeutiques sur les sanctions pénales. Une injonction thérapeutique est prévue.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Chapitre 2 — Les mesures de surveillance",
            cardColor: cardBg(const Color(0xFFFFF8E1), const Color(0xFF2F2A1B)),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              const _SubTitle("2.1 — Le suivi socio-judiciaire"),
              _Paragraph.rich([
                const TextSpan(text: "Le suivi socio-judiciaire ("),
                TextSpan(
                  text: "art. 131-36-1 à 131-36-8 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ") oblige le condamné, majeur ou mineur ayant commis des infractions de nature "
                      "sexuelle ou des violences, à se soumettre, sous le contrôle du juge de "
                      "l’application des peines, à des mesures de surveillance et d’assistance pendant "
                      "une durée fixée par la juridiction de jugement.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Peut être assorti d’une injonction de soins si cela est bénéfique au condamné.",
              ),
              const _BulletPoint(
                text:
                    "Peut être assorti d’un placement sous surveillance électronique mobile (décidé par la juridiction ou ultérieurement par le JAP).",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "2.2 — La surveillance judiciaire des personnes dangereuses",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Cette mesure prévue à "),
                TextSpan(
                  text: "l’article 723-29 du C.P.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " vise à prévenir la récidive lorsque le risque paraît avéré. Elle peut être "
                      "prononcée notamment pour des auteurs condamnés à une peine privative de liberté "
                      "d’une durée égale ou supérieure à sept ans (si le suivi socio-judiciaire était encouru "
                      "mais n’a pas été prononcé) ou d’une durée supérieure ou égale à cinq ans en cas de "
                      "récidive légale. Dans son contenu, elle ressemble au suivi socio-judiciaire.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title:
                "Chapitre 3 — Mesures de sûreté portant atteinte à la liberté",
            cardColor: cardBg(const Color(0xFFF3E5F5), const Color(0xFF2D2230)),
            accent: const Color(0xFF8E24AA),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              const _SubTitle("3.1 — Mesures applicables aux mineurs"),
              const _Paragraph(
                "Le code de la justice pénale des mineurs érige en principe fondamental la primauté "
                "de la réponse éducative sur la réponse répressive.",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "3.1.1 — La mesure éducative judiciaire provisoire (M.E.J.P.)",
              ),
              _Paragraph.rich([
                const TextSpan(text: "La M.E.J.P. ("),
                TextSpan(
                  text: "art. L323-1 à L323-3 du C.J.P.M.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      ") peut être prise à tout moment au cours de la procédure, avant le prononcé de la "
                      "sanction, pour une durée d’un an renouvelable (",
                ),
                TextSpan(
                  text: "art. L432-2 du C.J.P.M.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      "). Elle est modulable selon les besoins et l’évolution du mineur.",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("3.1.2 — Mesures d’investigation et de sûreté"),
              const _BulletPoint(
                text:
                    "La M.E.J.P. peut s’accompagner d’une mesure judiciaire d’investigation éducative (M.J.I.E.) : évaluation approfondie et interdisciplinaire de la personnalité et de la situation du mineur.",
              ),
              const _BulletPoint(
                text:
                    "Placement sous contrôle judiciaire possible avec obligations/interdictions (lieux, contacts…).",
              ),
              const _BulletPoint(
                text:
                    "Avant jugement : assignation à résidence avec surveillance électronique ou détention provisoire (sous conditions).",
              ),

              const SizedBox(height: 12),
              const _SubTitle("3.1.3 — Rétention et surveillance de sûreté"),
              const _Paragraph(
                "La loi du 25 février 2008 n’exclut pas les mineurs du dispositif de protection "
                "contre les criminels dangereux.",
              ),

              const SizedBox(height: 14),
              const _SubTitle("3.2 — Mesures applicables aux majeurs"),

              const _SubTitle("3.2.1 — Interdiction de séjour"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Défense de paraître dans certains lieux, avec mesures de surveillance et d’assistance (",
                ),
                TextSpan(
                  text: "art. 131-31 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("3.2.2 — Interdiction de manifester"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Défense de manifester sur la voie publique dans certains lieux, pour une durée ≤ 3 ans (",
                ),
                TextSpan(
                  text: "art. 131-32-1 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("3.2.3 — Mesures concernant les étrangers"),
              const _BulletPoint(text: "Interdiction du territoire"),
              const _BulletPoint(text: "Expulsion"),
              const _BulletPoint(text: "Assignation à résidence"),
              const _BulletPoint(
                text:
                    "Assignation à résidence avec surveillance électronique mobile",
              ),
              const _BulletPoint(text: "Obligation de quitter le territoire"),
              const _BulletPoint(text: "Rétention administrative"),

              const SizedBox(height: 12),
              const _SubTitle("3.2.4 — Obligation d’accomplir un stage"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "But : prévenir la réitération des comportements dangereux ou inciviques (",
                ),
                TextSpan(
                  text: "art. 131-5-1 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Stage de citoyenneté"),
              const _BulletPoint(
                text: "Stage de sensibilisation à la sécurité routière",
              ),
              const _BulletPoint(
                text:
                    "Stage de sensibilisation aux dangers de l’usage de stupéfiants",
              ),
              const _BulletPoint(
                text:
                    "Stage de responsabilisation pour la prévention et la lutte contre les violences au sein du couple et sexistes",
              ),
              const _BulletPoint(
                text:
                    "Stage de sensibilisation à la lutte contre l’achat d’actes sexuels",
              ),
              const _BulletPoint(text: "Stage de responsabilité parentale"),
              const _BulletPoint(
                text:
                    "Stage de lutte contre le sexisme et sensibilisation à l’égalité femmes-hommes",
              ),
              const _BulletPoint(
                text:
                    "Stage de sensibilisation à la prévention et à la lutte contre la maltraitance animale",
              ),
              const _BulletPoint(
                text:
                    "Stage de sensibilisation au respect des personnes dans l’espace numérique et à la prévention des infractions commises en ligne (dont cyberharcèlement)",
              ),

              const SizedBox(height: 12),
              const _SubTitle("3.2.5 — Interdictions et restrictions"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Ensemble d’interdictions pouvant être prononcées (",
                ),
                TextSpan(
                  text: "art. 131-6 C.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(text: "). Exemples :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Interdictions professionnelles / d’exercer des fonctions publiques",
              ),
              const _BulletPoint(
                text: "Suspension / annulation du permis de conduire",
              ),
              const _BulletPoint(
                text: "Interdiction de conduire certains véhicules",
              ),
              const _BulletPoint(
                text: "Confiscation / immobilisation de véhicules",
              ),
              const _BulletPoint(
                text:
                    "Confiscation / interdiction de port et détention d’armes",
              ),
              const _BulletPoint(text: "Retrait du permis de chasser"),
              const _BulletPoint(
                text:
                    "Interdiction d’émettre des chèques / d’utiliser des cartes de paiement",
              ),
              const _BulletPoint(
                text:
                    "Confiscation de la chose ayant servi / destinée / produit",
              ),
              const _BulletPoint(
                text: "Interdiction de paraître en certains lieux",
              ),
              const _BulletPoint(
                text:
                    "Interdiction de fréquenter ou d’entrer en relation avec certaines personnes",
              ),

              const SizedBox(height: 12),
              const _SubTitle(
                "3.2.6 — Hospitalisation complète pour trouble mental",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Admission en soins psychiatriques sous forme d’hospitalisation complète possible (",
                ),
                TextSpan(
                  text: "art. 706-135 C.P.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      "). D’autres mesures peuvent être prononcées : interdiction de rencontrer la victime, interdiction de porter une arme…",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("3.2.7 — Rétention et surveillance de sûreté"),
              _Paragraph.rich([
                const TextSpan(text: "Prévue aux "),
                TextSpan(
                  text: "art. 706-53-13 à 706-53-22 C.P.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " : placement dans un centre socio-médico-judiciaire de sûreté où des soins médicaux sont proposés.",
                ),
              ]),
              const SizedBox(height: 8),
              const _IntroBullet(
                text: "Peine prononcée ≥ 15 ans de réclusion criminelle",
              ),
              const _IntroBullet(
                text: "Condamnation portant sur des crimes précis",
              ),
              const _IntroBullet(
                text: "Dangerosité : probabilité très élevée de récidive",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "À l’issue de la rétention, la personne peut faire l’objet d’une surveillance de sûreté "
                "renouvelable (injonction de soins, surveillance électronique, etc.).",
              ),

              const SizedBox(height: 12),
              const _SubTitle(
                "3.2.8 — Placement sous surveillance électronique",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Mesure prévue aux "),
                TextSpan(
                  text: "art. 763-10 à 763-14 C.P.P.",
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                const TextSpan(
                  text:
                      " : bracelet GPS après libération pour renforcer la prévention de la récidive. "
                      "Constitue une obligation possible du suivi socio-judiciaire, et peut aussi "
                      "être prononcé dans la libération conditionnelle ou la surveillance judiciaire.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _NotaBox(
            bodySpans: [
              const TextSpan(
                text:
                    "Les mesures de sûreté poursuivent un objectif de prévention. Elles visent la dangerosité "
                    "et s’additionnent souvent à des mécanismes de suivi et d’assistance (JAP, injonction de soins, "
                    "bracelet électronique), selon les textes applicables.",
              ),
            ],
          ),

          const SizedBox(height: 22),
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
