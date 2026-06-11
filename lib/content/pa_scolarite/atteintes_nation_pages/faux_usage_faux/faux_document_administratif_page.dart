import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaFauxDocumentAdministratifPage extends StatelessWidget {
  const PaFauxDocumentAdministratifPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_document_administratif';

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
    final Color cardRep = cardDef;

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
          "Faux & usage de faux",
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
            "Le faux commis dans un document administratif",
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
                "L’infraction consiste dans le fait de commettre un faux dans un document délivré "
                "par une administration publique aux fins de constater un droit, une identité ou une "
                "qualité, ou d’accorder une autorisation. L’usage de ce faux est également incriminé.",
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
                  text: "Article 441-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime le faux commis dans un document administratif ainsi que son usage.",
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
              _SubTitle(
                "A) Contrefaçon ou falsification d’un document administratif",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 441-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : concerne les faux matériels commis dans les documents délivrés par l’administration "
                      "établis aux fins de constater un droit, une identité ou une qualité, ou d’accorder une autorisation. "
                      "Le texte vise un écrit, mais aussi un document fixé sur un autre support que l’écrit.",
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle("• Une falsification matérielle"),
              _Paragraph(
                "Il y a faux matériel lorsque c’est le support qui est falsifié. La particularité du faux matériel "
                "est qu’il porte en lui-même la trace de sa falsification : elle peut se constater par l’examen "
                "du support. On distingue notamment :\n"
                "— le faux matériel par altération d’un document authentique ;\n"
                "— le faux matériel par des procédés donnant l’apparence de l’authenticité à un document qui ne l’est pas.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Point important",
                bodySpans: [
                  TextSpan(
                    text:
                        "La jurisprudence ne semble pas retenir ici le faux intellectuel (défaut de véridicité) : "
                        "il consiste, par exemple, à fournir de faux renseignements (identité), le mensonge atteignant le contenu de l’écrit et non le support.",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un document administratif"),
              _Paragraph(
                "Les documents administratifs sont des documents/formulaires normalisés, établis pour constater :\n"
                "— un droit ;\n"
                "— une identité (carte nationale d’identité, titre de séjour…) ;\n"
                "— une qualité (ex. certificat de nationalité) ;\n"
                "— ou accorder une autorisation (permis de construire, permis de chasser, etc.).",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(text: "Certificat de nationalité : "),
                  TextSpan(
                    text: "(Cass. crim., 19 mai 1981)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Permis de chasser : "),
                  TextSpan(
                    text: "(Cass. crim., 03 octobre 2000)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Permis de construire : "),
                  TextSpan(
                    text: "(Cass. crim., 15 mars 1995)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Certificat de mariage : "),
                  TextSpan(
                    text: "(Cass. crim., 22 octobre 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text:
                        "Faux ordres de mission établis par un président de conseil général à l’occasion de détournements de fonds publics ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 octobre 2000)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text:
                        "Bons de commande fictifs destinés à masquer l’objet exact d’une prestation relevant du droit des marchés publics ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 22 septembre 2004)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _Paragraph(
                "La falsification ne doit pas être immédiatement identifiable.",
              ),

              SizedBox(height: 14),

              _SubTitle("C) Un préjudice"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le texte ne précise pas l’existence ou l’éventualité d’un préjudice, mais la jurisprudence "
                      "retient que le préjudice découle de la nature de la pièce faussée ",
                ),
                TextSpan(
                  text: "(Cass. crim., 12 novembre 1998)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Le faux commis dans un document administratif peut également porter préjudice aux particuliers.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Fausse carte grise permettant au faussaire de s’approprier le véhicule d’autrui ou d’obtenir frauduleusement un crédit ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 07 décembre 1965)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("D) L’usage du faux"),
              _Paragraph(
                "L’usage du faux ne se conçoit que sur un document administratif falsifié.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Production, dans une instance en divorce en France, d’un certificat de mariage fabriqué (mariage coutumier au Sénégal non transcrit) ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 22 octobre 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "En revanche, l’usage d’un document administratif dont les mentions sont devenues incomplètes ou inexactes relève d’une contravention de 5e classe prévue par ",
                ),
                TextSpan(
                  text: "l’article R. 645-8 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
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
            children: const [
              _SubTitle("A) Concernant l’infraction de faux"),
              _BulletPoint(
                text: "Volonté de commettre la falsification.",
              ),
              _BulletPoint(
                text:
                    "Conscience de l’altération de la vérité dans le document (atteinte à l’authenticité / intégrité).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’acte de falsification matérielle révèle l’intention de l’auteur du fait même de son accomplissement "
                "(fabriquer un acte, apposer une fausse signature, etc.). Les mobiles sont indifférents.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Concernant l’infraction d’usage de faux"),
              _BulletPoint(text: "Volonté d’user de la pièce fausse."),
              _BulletPoint(
                text: "Connaissance de la fausseté de la pièce.",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 441-2 1° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lorsque le faux ou l’usage de faux est commis par une personne dépositaire de l’autorité publique "
                    "ou chargée d’une mission de service public agissant dans l’exercice de ses fonctions.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 441-2 2° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : (aggravation prévue par le texte)."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 441-2 3° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lorsque le faux ou l’usage de faux est commis dans le dessein de faciliter la commission d’un crime "
                    "ou de procurer l’impunité à son auteur.",
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
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 441-2 alinéas 1 et 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 441-2 1° à 3° du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text: "Article 441-3 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : réprime la détention d’un faux document administratif. Cette incrimination vise à lutter "
                        "contre le trafic de faux documents administratifs et présente un intérêt par rapport au recel "
                        "car elle permet de sanctionner le détenteur d’un document qu’il a lui-même falsifié.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 441-12 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 441-9 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (prévoit expressément la tentative des délits prévus à l’article 441-2).",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(text: "Complicité : OUI (règles générales)."),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le secrétaire de mairie qui fait procéder par un employé subalterne à la falsification des registres ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 octobre 2000)",
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
