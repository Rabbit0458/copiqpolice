import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoumissionConditionsTravailHebergementIncompatiblesDignitePage
    extends StatelessWidget {
  const SoumissionConditionsTravailHebergementIncompatiblesDignitePage({
    super.key,
  });

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite';

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
          "Atteintes à la dignité",
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
            "La soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait de soumettre une personne, dont la vulnérabilité ou l’état de dépendance sont apparents "
                "ou connus de l’auteur, à des conditions de travail ou d’hébergement incompatibles avec la dignité "
                "humaine constitue une infraction.",
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
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-14 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime la soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine.",
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
            children: [
              const _SubTitle(
                "A) Conditions de travail ou d’hébergement incompatibles avec la dignité humaine",
              ),
              const _SubTitle("Notion d’atteinte à la dignité humaine"),
              const _Paragraph(
                "La dignité humaine est proclamée par de nombreux textes internationaux (Déclaration des Droits de l’Homme, "
                "Convention européenne de sauvegarde des droits de l’Homme…).\n\n"
                "En 1994, le Conseil constitutionnel affirme que la sauvegarde de la dignité de la personne humaine contre "
                "toute forme d’asservissement et de dégradation est un principe à valeur constitutionnelle.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Référence",
                bodySpans: [
                  const TextSpan(text: "Décision du Conseil constitutionnel "),
                  const TextSpan(
                    text: "(27 juillet 1994)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: " : principe à valeur constitutionnelle.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "Le Code pénal ne définit pas précisément la dignité humaine : il appartient aux juges du fond d’en fixer "
                "les contours.\n\n"
                "Est généralement incompatible avec la dignité humaine ce qui abaisse ou avilit l’être humain en bafouant "
                "ses droits essentiels. C’est une notion évolutive, dépendante des idées morales communément admises.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Conditions de travail incompatibles avec la dignité humaine",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: "À la différence de l’infraction prévue à l’",
                ),
                const TextSpan(
                  text: "article 225-13 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ", l’article 225-14 n’exige pas l’absence ou l’insuffisance de rémunération : "
                      "le délit peut être constitué dès lors que les conditions de travail sont incompatibles avec la dignité humaine.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’atteinte peut résulter :\n"
                "• de la nature des locaux (insalubrité, manque d’aération…)\n"
                "• de cadences intolérables ou d’une durée excessive de travail\n"
                "• des relations de travail (insultes, brimades, comportements vexatoires), assimilables à des violences morales.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Infraction retenue contre un directeur d’atelier interdisant de parler/lever la tête/sourire, "
                        "criant et insultant en public, privant de pauses, imposant des humiliations (toilettes souillées…) ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 04 mars 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "L’atteinte peut aussi résulter du travail lui-même, lorsqu’il est intrinsèquement incompatible avec la dignité humaine "
                "(ex. certaines situations du monde du spectacle).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Travail forcé",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le travail forcé étant incompatible avec la dignité humaine, le délit est constitué si les circonstances factuelles "
                        "permettent d’établir l’existence d’un travail forcé ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 13 janvier 2009)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Définition OIT (Convention du 28 juin 1930) : ",
                ),
                const TextSpan(
                  text:
                      "« tout travail ou service exigé d’un individu sous la menace d’une peine quelconque et pour lequel ledit individu ne s’est pas offert de plein gré »",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Conditions d’hébergement incompatibles avec la dignité humaine",
              ),
              const _Paragraph(
                "La notion d’hébergement au sens de l’article 225-14 suppose :\n"
                "• une contrepartie (loyer ou avantages en nature : travail, mise en valeur des lieux…)\n"
                "• une durée : l’hébergement doit viser à fournir un logement pour y vivre.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’incompatibilité avec la dignité humaine peut résulter :\n"
                "• de l’absence de conditions d’hygiène minimales\n"
                "• de l’absence de chauffage/éclairage\n"
                "• d’une inadéquation du logement au nombre d’occupants (sur-occupation).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Délit constitué : location à une famille de 3 personnes (enfant en bas âge + femme enceinte) d’un logement de 20 m², "
                        "humidité, chauffage mettant en péril la santé ",
                  ),
                  const TextSpan(
                    text: "(C.A. Paris, 26 juin 1996)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Infraction retenue : hébergement d’une gardienne (60 ans) et de sa fille dans une loge servant aussi de lieu de travail "
                        "(réception/tri courrier), sans chauffage, installation électrique dangereuse, fenêtre bloquée, traces d’écoulement, "
                        "cuisine délabrée, WC à la turque servant aussi de douche ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 23 avril 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Une victime vulnérable ou en état de dépendance",
              ),
              const _Paragraph(
                "La vulnérabilité ou la dépendance doivent être entendues largement, et doivent être apparentes ou connues de l’auteur.\n\n"
                "• Vulnérabilité : état physique/mental (grossesse, âge, maladie, handicap…), ou environnement économique/social/culturel "
                "(personnes immigrées, chômeurs, sans-abri…).\n"
                "• Dépendance : économique (précarité) ou morale (ascendant : maître/domestique, parents/enfants…).\n\n"
                "L’une ou l’autre doit exister (elles peuvent se confondre).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Présomption : "),
                const TextSpan(
                  text: "article 225-15-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : présomption de vulnérabilité/dépendance concernant les mineurs et certaines victimes à leur arrivée sur le territoire français.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les deux délits visés par l’article 225-14 (travail et hébergement) peuvent être caractérisés simultanément, "
                        "et peuvent aussi se cumuler avec d’autres infractions (ex. exploitation de travailleurs étrangers en situation irrégulière).",
                  ),
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
            children: [
              const _SubTitle("A) Conscience de la vulnérabilité / dépendance"),
              const _Paragraph(
                "L’auteur doit mesurer la vulnérabilité ou l’état de dépendance de la victime. "
                "Cet état doit être apparent ou connu.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Conscience de l’incompatibilité avec la dignité humaine",
              ),
              const _Paragraph(
                "L’auteur a pleinement conscience du caractère incompatible avec la dignité humaine des conditions "
                "de travail ou d’hébergement auxquelles il soumet la personne.",
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
            children: [
              const _SubTitle("Premier degré d’aggravation"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-15 I 2° du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : lorsqu’elle est commise à l’égard de plusieurs personnes.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-15 II 2° du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " : lorsqu’elle est commise à l’égard d’un mineur.",
                ),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Second degré d’aggravation"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-15 III 2° du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : lorsqu’elle est commise à l’égard de plusieurs personnes parmi lesquelles figurent un ou plusieurs mineurs.",
                ),
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
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Qualification simple (délit) : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 200 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-14 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (1er degré) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 300 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "articles 225-15 I 2° et 225-15 II 2° du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (2nd degré — crime) : "),
                const TextSpan(
                  text:
                      "15 ans de réclusion criminelle et 400 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-15 III 2° du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité expressément prévue par "),
                const TextSpan(
                  text: "l’article 225-16 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: ". Peine d’amende selon "),
                const TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " + peines complémentaires "),
                const TextSpan(
                  text: "article 131-39 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (dissolution, interdictions, confiscations…), notamment la confiscation du fonds de commerce ayant servi à commettre l’infraction.",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément aux "),
                const TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (aide/assistance, provocation, instructions données).",
                ),
              ]),
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
