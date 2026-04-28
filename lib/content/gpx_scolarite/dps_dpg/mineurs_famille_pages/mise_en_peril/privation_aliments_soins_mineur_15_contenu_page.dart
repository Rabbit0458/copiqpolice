import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivationAlimentsSoinsMineur15Page extends StatelessWidget {
  const PrivationAlimentsSoinsMineur15Page({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15';

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
          "Mise en péril",
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
            "La privation d’aliments ou de soins à mineur de quinze ans",
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
                "Le fait, par un ascendant ou toute autre personne exerçant à l’égard d’un mineur de quinze ans "
                "l’autorité parentale ou une autorité, de priver celui-ci d’aliments ou de soins au point de compromettre sa santé, "
                "constitue une infraction.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Constitue notamment une privation de soins le fait de maintenir un enfant de moins de six ans sur la voie publique "
                "ou dans un espace affecté au transport collectif de voyageurs, dans le but de solliciter la générosité des passants.",
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
                  text: "Article 227-15 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime la privation d’aliments ou de soins à mineur de quinze ans.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel — 3 blocs pédagogiques
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Une victime mineure de moins de quinze ans"),
              const _Paragraph(
                "L’infraction n’est constituée que si la victime est un mineur âgé de moins de quinze ans. "
                "La loi pénale étant d’interprétation stricte, l’article 227-15 ne s’applique pas à un mineur de plus de quinze ans.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "À retenir",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si la victime a plus de quinze ans, d’autres qualifications peuvent être envisagées (ex. séquestration : ",
                  ),
                  const TextSpan(
                    text: "articles 224-1 et suivants du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ", ou soustraction d’un parent à ses obligations légales : ",
                  ),
                  const TextSpan(
                    text: "article 227-17 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) La qualité de l’auteur"),
              const _Paragraph("Le texte vise trois catégories d’auteurs :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Les ascendants : père, mère, grands-parents, arrière-grands-parents.",
              ),
              const _BulletPoint(
                text:
                    "Les personnes exerçant l’autorité parentale : peut inclure le tuteur, et les personnes ayant reçu une délégation d’autorité parentale (code civil).",
              ),
              const _BulletPoint(
                text:
                    "Les personnes exerçant une autorité de fait : nouveau conjoint/concubin, personne à qui l’enfant est confié, responsables/employés de l’aide sociale à l’enfance, etc.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Une privation d’aliments ou de soins + compromission de la santé",
              ),
              const _Paragraph(
                "La privation d’aliments consiste à ne pas fournir une nourriture en quantité ou en qualité suffisante.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La privation de soins est constituée lorsqu’on ne s’occupe pas matériellement de l’enfant au quotidien "
                "et qu’on ne lui fournit pas les soins nécessaires (hygiène, soins médicaux, prise en charge adaptée).",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Infraction retenue : laisser deux enfants seuls à la maison, sans gaz, ni eau, ni électricité, avec un réfrigérateur rempli parfois de nourriture qu’ils ne pouvaient pas cuire ; voisins les nourrissant ",
                  ),
                  const TextSpan(
                    text: "(C.A. Douai, 15 février 2006)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Une présomption de privation de soins figure au 2ᵉ alinéa : est notamment visé le fait de maintenir un enfant de moins de six ans sur la voie publique / transport collectif pour solliciter la générosité. — ",
                ),
                const TextSpan(
                  text: "article 227-15 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 10),

              _NotaBox(
                title: "Attention",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le simple fait de mendier avec un enfant en bas âge n’est pas, en soi, constitutif du délit ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 12 octobre 2005)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La privation doit être « au point de compromettre la santé » du mineur : exigence confirmée par la jurisprudence. — ",
                ),
                const TextSpan(
                  text: "(T.G.I. Paris, 13 janvier 2004)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il n’est pas nécessaire que l’atteinte soit grave ni que le dommage soit effectif : il suffit que les privations "
                "soient susceptibles d’altérer la santé du mineur. Les juges apprécient au cas par cas l’impact réel ou potentiel.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Dans l’arrêt du 12 octobre 2005, la Cour de cassation a validé une relaxe : l’enfant était en bonne santé au vu des pièces produites, malgré le maintien sur la voie publique. — ",
                ),
                const TextSpan(
                  text: "(Cass. crim., 12 octobre 2005)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
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
              const _SubTitle(
                "Conscience que les privations risquent de causer un dommage",
              ),
              const _Paragraph(
                "La privation d’aliments ou de soins est une infraction intentionnelle : "
                "elle nécessite la conscience, la connaissance ou la prévision qu’il en résulterait un mal pour l’enfant.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                const TextSpan(
                  text: "(Cass. crim., 11 mars 1975)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La volonté de nuire ou de causer un dommage n’est pas exigée. "
                "Les convictions religieuses ou le souci d’éducation ne justifient pas les privations dès lors que "
                "l’auteur a conscience que la santé du mineur risque d’être altérée.",
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
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 227-15 alinéa 3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsque la personne visée à l’alinéa 1 s’est rendue coupable, sur le même mineur, du délit de non-déclaration de naissance.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                const TextSpan(
                  text: "article 433-18-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 227-16 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsque la privation d’aliments ou de soins a entraîné la mort de la victime.",
              ),
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
                const TextSpan(
                  text: "Qualification simple (délit) : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-15 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (délit — al. 3) : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 300 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-15 alinéa 3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Si la mort de la victime est entraînée (crime) : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "30 ans de réclusion criminelle — "),
                const TextSpan(
                  text: "article 227-16 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale possible : "),
                const TextSpan(
                  text: "article 227-17-2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (amende selon l’article 131-38 et peines complémentaires de l’article 131-39).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Références : "),
                const TextSpan(
                  text: "article 131-38 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " et "),
                const TextSpan(
                  text: "article 131-39 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                const TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " (aide/assistance, provocation, instructions).",
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
