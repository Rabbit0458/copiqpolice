import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConduiteStupefiantsPage extends StatelessWidget {
  const PaConduiteStupefiantsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/conduite_stupefiants';

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
          "Infraction circulation routière",
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
            "La conduite après usage de substances ou plantes classées comme stupéfiants",
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
                "Constitue une infraction le fait, pour toute personne, de conduire un véhicule ou d'accompagner "
                "un élève conducteur, alors qu’il résulte d’une analyse sanguine ou salivaire qu’elle a fait usage "
                "de substances ou plantes classées comme stupéfiants.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (comme tu veux)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 235-1 / I du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime le fait de conduire un véhicule ou d’accompagner un élève conducteur "
                      "en se trouvant sous l’influence de substances ou plantes classées comme stupéfiants.",
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
              _SubTitle("A) Une personne visée par le texte"),
              _SubTitle("1) Un conducteur de véhicule"),
              _Paragraph(
                "Sont visés les conducteurs de véhicules à moteur (voitures particulières, poids lourds, transports en commun, "
                "motocyclettes, cyclomoteurs, matériels agricoles/forestiers, engins de travaux publics, engins spéciaux, trolleybus), "
                "mais aussi les conducteurs des autres véhicules en circulation (cycles, véhicules à traction animale).",
              ),
              SizedBox(height: 12),

              _SubTitle("2) Un accompagnateur d’élève conducteur"),
              _Paragraph(
                "Sont également concernés les accompagnateurs des élèves conducteurs, qu’ils interviennent dans le cadre "
                "de l’enseignement de la conduite à titre gracieux, de la conduite accompagnée, ou en qualité de moniteur.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "B) Un cas permettant la recherche de stupéfiants",
              ),
              _SubTitle("1) Le dépistage"),
              _Paragraph(
                "Le dépistage consiste, à partir d’un recueil salivaire ou urinaire, à rechercher la présence d’une ou plusieurs "
                "substances témoignant de l’usage de stupéfiants (cannabiniques, amphétaminiques, cocaïniques, opiacés).",
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le refus de subir le test de dépistage ne constitue pas une infraction, mais entraîne l’obligation "
                        "pour l’intéressé de se soumettre aux vérifications. ",
                  ),
                  TextSpan(text: "Pour l’accompagnateur, "),
                  TextSpan(
                    text: "l’article L. 235-2 alinéa 5 du Code de la route",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " ne prévoit pas de vérifications en cas de refus ou d’impossibilité de dépistage.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(text: "Cas de dépistage ("),
                TextSpan(
                  text: "article L. 235-2 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ") :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Obligatoire : accident mortel de la circulation.",
              ),
              _BulletPoint(
                text: "Obligatoire : accident corporel de la circulation.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Facultatif : accident matériel de la circulation.",
              ),
              _BulletPoint(
                text: "Facultatif : infraction au code de la route.",
              ),
              _BulletPoint(
                text:
                    "Facultatif : raisons plausibles de soupçonner l’usage de stupéfiants.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Préventif : sur réquisition du procureur de la République.",
              ),
              _BulletPoint(
                text: "Préventif : à l’initiative de l’OPJ / APJ.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Impossible en cas de refus de se soumettre au dépistage, de blessures graves (contre-indication médicale) ou de décès.",
              ),

              SizedBox(height: 14),

              _SubTitle("2) La preuve : les vérifications"),
              _Paragraph(
                "Si le dépistage est positif, ou si le conducteur refuse / est dans l’impossibilité de le subir, "
                "les officiers ou agents de police judiciaire font procéder à des vérifications (analyses ou examens) "
                "pour établir si la personne conduisait après avoir fait usage de stupéfiants.",
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(text: "À cette fin, "),
                TextSpan(
                  text: "l’article L. 235-2 alinéa 5 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " permet à l’OPJ/APJ de requérir un médecin (ou assimilés) ou un infirmier pour effectuer notamment une prise de sang.",
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "La procédure est irrégulière si le conducteur n’a pas été informé (après dépistage positif) "
                        "de la possibilité de demander un examen technique/une expertise ou une recherche de médicaments psychoactifs, "
                        "ou si sa demande n’a pas été prise en compte ",
                  ),
                  TextSpan(
                    text: "(Conseil d’État, n°467841, 21/11/2023)",
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
                TextSpan(text: "Deux modalités possibles : "),
                TextSpan(
                  text: "article R. 235-6 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Prélèvement salivaire : réalisé par le conducteur lui-même, sous contrôle OPJ/APJ. Si le conducteur demande une expertise/examen technique, un prélèvement sanguin est réalisé au plus court délai.",
              ),
              _BulletPoint(
                text:
                    "Prélèvement sanguin : pratiqué par médecin/interne/étudiant autorisé/infirmier (ou biologiste requis). OPJ/APJ assiste au prélèvement ; examen clinique possible si l’état le permet.",
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(text: "En cas d’accident mortel, "),
                TextSpan(
                  text: "l’article R. 235-8 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " impose que seule l’analyse d’un prélèvement sanguin puisse être réalisée.",
                ),
              ]),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le refus de se soumettre aux vérifications constitue le délit prévu par ",
                ),
                TextSpan(
                  text: "l’article L. 235-3 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "La recherche est organisée notamment par ",
                ),
                TextSpan(
                  text: "l’article R. 235-10 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : le prélèvement est transmis pour analyse (laboratoire, expert). Il n’est plus question de dosage : "
                      "l’expert confirme ou infirme la présence des substances détectées.",
                ),
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
              _Paragraph(
                "Il s’agit d’une infraction intentionnelle : la personne doit avoir la volonté de conduire "
                "(ou d’accompagner un élève conducteur) après avoir fait usage de substances ou plantes classées comme stupéfiants. "
                "Le comportement est volontaire et suppose la conscience des faits.",
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
                  text: "Article L. 235-1 / I (2ᵉ phrase) du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : circonstance aggravante lorsque la personne est également sous l’empire d’un état alcoolique "
                      "caractérisé (taux légalement fixé).",
                ),
              ]),
              SizedBox(height: 10),

              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        "La conduite sous stupéfiants peut aussi aggraver les peines en matière d’homicide involontaire "
                        "ou d’atteintes involontaires. ",
                  ),
                  TextSpan(
                    text:
                        "Articles 221-6-1, 222-19-1 et 222-20-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : le délit de conduite sous stupéfiants peut constituer une circonstance aggravante.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Conséquence opérationnelle : tout accident mortel ou corporel doit donner lieu à un dépistage.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité (rendu clean, pas répétitif)
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines principales"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "2 ans d’emprisonnement et 4 500 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 235-1 / I (1ʳᵉ phrase) du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Qualification aggravée (alcool + stupéfiants) : ",
                ),
                TextSpan(
                  text: "3 ans d’emprisonnement et 6 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article L. 235-1 / I (2ᵉ phrase) du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide ou assistance ayant facilité la préparation ou la commission de l’infraction).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Immunités (rappel)"),
              _BulletPoint(
                text:
                    "Diplomates : immunité (Convention de Vienne). Ils ne peuvent être soumis à aucune forme d’arrestation ; ne pas faire subir de dépistage.",
              ),
              _BulletPoint(
                text:
                    "Parlementaires : inviolabilité (Constitution de 1958, art. 26). Dépistage possible notamment en cas de flagrant délit ; informer le procureur si possible avant l’opération.",
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
