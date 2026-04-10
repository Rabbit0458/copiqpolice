import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExhibitionSexuellePage extends StatelessWidget {
  const ExhibitionSexuellePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/exhibition_sexuelle';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

    // Palette cohérente (comme tes autres pages)
    final Color cIntro = isDark
        ? const Color(0xFF101A2B)
        : const Color(0xFFEAF2FF);
    final Color cIntroAccent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    final Color cLegal = isDark
        ? const Color(0xFF1B1420)
        : const Color(0xFFFFEBEE);
    final Color cLegalAccent = isDark
        ? const Color(0xFFE57373)
        : const Color(0xFFC62828);

    final Color cMat = isDark
        ? const Color(0xFF0F1E19)
        : const Color(0xFFE8F5E9);
    final Color cMatAccent = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    final Color cMoral = isDark
        ? const Color(0xFF1A1A11)
        : const Color(0xFFFFF8E1);
    final Color cMoralAccent = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    final Color cAggr = isDark
        ? const Color(0xFF1A1411)
        : const Color(0xFFFFF3E0);
    final Color cAggrAccent = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);

    final Color cRepr = isDark
        ? const Color(0xFF121821)
        : const Color(0xFFE8EAF6);
    final Color cReprAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF283593);

    // Helpers TextSpan (articles en rouge)
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          "Exhibition sexuelle",
          style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0D1B2A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ EXIGENCE : élément légal en premier
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-32 du Code pénal"),
                    normal(" : prévoit et réprime l’exhibition sexuelle."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "Définition",
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    "L’exhibition sexuelle imposée à la vue d’autrui, dans un lieu accessible aux regards du public, "
                    "constitue une infraction.",
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    "Même en l’absence d’exposition d’une partie dénudée du corps, l’infraction est constituée si est imposée "
                    "à la vue d’autrui, dans un lieu accessible aux regards du public, la commission explicite d’un acte sexuel "
                    "réel ou simulé.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Pas de contact physique : c’est l’exposition / le spectacle imposé qui est sanctionné.",
                  ),
                  _IntroBullet(
                    text:
                        "Un acte sexuel explicite réel ou simulé suffit (même sous les vêtements).",
                  ),
                  _IntroBullet(
                    text:
                        "Condition essentielle : publicité (lieu accessible aux regards du public).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "I — Élément légal",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-32 du C.P."),
                    normal(" : incrimine l’exhibition sexuelle."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "II — Élément matériel",
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle("1) Pas de contact physique"),
                  const _Paragraph(
                    "Il n’y a pas de contact physique entre la victime et l’auteur. "
                    "L’exhibition sexuelle s’entend d’un acte (et non de simples paroles, écrits, dessins, photos, affiches…).",
                  ),
                  const SizedBox(height: 12),

                  const _SubTitle(
                    "2) Comportements voisins : autres qualifications",
                  ),
                  _Paragraph.rich([
                    normal("• Messages contraires à la décence : "),
                    lawRef("article R. 624-2 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    normal(
                      "• Diffusion de messages à caractère pornographique : ",
                    ),
                    lawRef("articles 227-23 et suivants du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 14),

                  const _SubTitle("3) Un acte matériel impudique"),
                  const _Paragraph(
                    "Avant la loi du 21 avril 2021, la Cour de cassation exigeait que le corps ou la partie du corps "
                    "volontairement exposé « soit ou paraisse dénudé ».",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Règle de principe : "),
                      normal("Cass. crim., 4 janvier 2006"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Désormais, l’infraction vise aussi la « commission explicite d’un acte sexuel, réel ou simulé », "
                    "même si aucune partie dénudée n’est visible (ex. masturbation sous les vêtements).",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Sont visés les gestes attentatoires à la pudeur : relations sexuelles, comportements à caractère sexuel "
                    "nettement marqués (gestes, caresses, baisers…), que les juges doivent décrire pour condamner. "
                    "L’appréciation du caractère impudique dépend des mœurs et de leur évolution.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Description nécessaire des gestes : "),
                      normal("Cass. crim., 17 juin 1981"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Peu importe que les relations soient licites/illicites, homosexuelles/hétérosexuelles, entre majeurs consentants : "
                    "ce n’est pas l’acte en soi qui est puni, mais le spectacle imposé à autrui.",
                  ),

                  const SizedBox(height: 14),

                  _NotaBox(
                    title: "Jurisprudences",
                    bodySpans: [
                      normal(
                        "Exhibe ses parties sexuelles au péage d’autoroute : ",
                      ),
                      normal("Cass. crim., 4 juin 1997"),
                      normal(".\n"),
                      normal(
                        "Personne assise nue face à des témoins, position permettant de voir le sexe, refus de se vêtir : ",
                      ),
                      normal("Cass. crim., 24 novembre 2021"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "4) La publicité de l’acte (condition essentielle)",
                  ),
                  const _Paragraph(
                    "L’acte doit être imposé à la vue d’autrui dans un lieu accessible aux regards du public. "
                    "Il s’agit de sanctionner une forme d’agression sexuelle subie par des témoins involontaires, "
                    "notamment lorsque des enfants y sont exposés.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Exhibition imposée à des témoins involontaires : ",
                      ),
                      normal("Cass. crim., 12 mai 2004"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• Lieux publics"),
                  const _Paragraph(
                    "La publicité peut résulter de la seule nature du lieu : dans un lieu public, la publicité est inhérente "
                    "au lieu. L’infraction peut être constituée même si, en fait, personne n’a vu l’acte : il suffisait qu’il "
                    "puisse être vu.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Publicité inhérente au lieu public : "),
                      normal("Cass. crim., 1er juin 1863"),
                      normal(". "),
                      normal("Constitué même si non vu (pouvait être vu) : "),
                      normal("Cass. crim., 16 janvier 1862"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Sont considérés comme lieux publics : lieux ouverts au public (rue, place, jardin, plage…) et lieux "
                    "où le public est admis sous conditions (école, hôpital, transports…).",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• Lieux privés visibles depuis l’extérieur"),
                  const _Paragraph(
                    "Les lieux privés peuvent aussi être concernés si l’acte est visible depuis un lieu public, faute "
                    "de précautions suffisantes. Le texte vise un « lieu accessible aux regards du public ».",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    "• Pas d’infraction si l’exhibition est recherchée",
                  ),
                  const _Paragraph(
                    "L’infraction n’est pas retenue si la « victime » a recherché l’exhibition (voyeurisme, plages/camps naturistes, "
                    "spectacles érotiques, etc.).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "III — Élément moral",
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: const [
                  _SubTitle("Conscience de l’impudicité"),
                  _Paragraph(
                    "L’intention coupable est exigée : l’auteur doit agir en ayant conscience du caractère impudique de l’acte.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "IV — Circonstances aggravantes",
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-32 alinéa 3 du C.P."),
                    normal(" : l’exhibition sexuelle est aggravée :"),
                  ]),
                  const SizedBox(height: 10),
                  const _BulletPoint(
                    text:
                        "Lorsque les faits sont commis au préjudice d’un mineur de quinze ans.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "V — Répression, tentative et complicité",
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle("Peines encourues (personnes physiques)"),
                  _Paragraph.rich([
                    normal("Forme simple ("),
                    lawRef("article 222-32 al. 1 du C.P."),
                    normal(") : 1 an d’emprisonnement et 15 000 € d’amende."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Forme aggravée ("),
                    lawRef("article 222-32 al. 3 du C.P."),
                    normal(") : 2 ans d’emprisonnement et 30 000 € d’amende."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Personnes morales"),
                  _Paragraph.rich([
                    normal("Responsabilité pénale prévue par "),
                    lawRef("l’article 121-2 du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  const _Paragraph("Tentative : NON."),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — punissable selon "),
                    lawRef("les articles 121-6 et 121-7 du C.P."),
                    normal("."),
                  ]),
                ],
              ),
            ],
          ),
        ),
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
