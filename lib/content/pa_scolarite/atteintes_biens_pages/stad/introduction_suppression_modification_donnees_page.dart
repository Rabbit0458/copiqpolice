import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaIntroductionSuppressionModificationDonneesPage extends StatelessWidget {
  const PaIntroductionSuppressionModificationDonneesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/stad/introduction_suppression_modification_donnees';

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

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Atteintes aux STAD",
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
            "Introduction, suppression ou modification frauduleuse de données",
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
                "Le fait d’introduire frauduleusement des données dans un système de traitement automatisé, "
                "d’extraire, de détenir, de reproduire, de transmettre, de supprimer ou de modifier frauduleusement "
                "les données qu’il contient constitue une infraction.",
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
                  text: "Article 323-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime l’introduction, l’extraction, la détention, la reproduction, la transmission, "
                      "la suppression ou la modification frauduleuse de données contenues dans un système de traitement automatisé de données.",
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
                "A) Une action sur des données contenues dans le système",
              ),
              _Paragraph(
                "L’action doit porter sur les données contenues dans le système. "
                "Peu importe que le système soit finalisé ou en cours d’élaboration.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Jurisprudence : système en cours d’élaboration — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 05 janvier 1994",
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
                "L’auteur peut avoir eu un accès licite ou non au système. "
                "Il importe peu également que l’action ne crée aucune perturbation apparente ou immédiate du fonctionnement.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Terme courant",
                bodySpans: [
                  TextSpan(
                    text:
                        "Dans la pratique, cette forme de piratage informatique est souvent appelée « cracking ».",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Il est admis que l’action sur des données sorties d’un système ne tombe pas sous le coup de la loi "
                "(ex. manipulation de données sur un support externe : clé USB, disque dur, CD-ROM…). "
                "En revanche, si ces données sont réintroduites dans le système, l’incrimination peut s’appliquer.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Les pratiques incriminées"),
              _Paragraph(
                "L’article 323-3 vise plusieurs comportements distincts. "
                "La jurisprudence incrimine l’action illicite qui porte directement sur les données, ou qui les atteint "
                "à travers leur mode de traitement ou de transmission.",
              ),
              SizedBox(height: 10),

              _SubTitle("1) Introduction de données"),
              _Paragraph(
                "L’introduction peut être comprise comme l’incorporation de caractères informatiques nouveaux sur un support du système. "
                "Dans la pratique, l’insertion d’un programme peut impliquer suppression/modification des données traitées, "
                "et tombe alors dans le champ de l’article 323-3.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’introduction d’un logiciel espion entre dans le champ de l’incrimination (souvent appelée « sniffing »). "
                        "Ce programme peut permettre une attaque ultérieure du système.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Cartes bancaires : insertion de nouvelles données destinées à tromper un terminal de paiement — ",
                  ),
                  TextSpan(
                    text: "TGI Paris, 25 février 2000",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("2) Extraction de données"),
              _Paragraph(
                "L’extraction assure une protection spécifique aux données elles-mêmes : elle permet de réprimer celui "
                "qui effectue une simple copie tout en laissant les données à la disposition du propriétaire légitime. "
                "L’incrimination de vol est souvent inadaptée car les données ne sont pas « soustraites ».",
              ),

              SizedBox(height: 14),

              _SubTitle("3) Détention — Reproduction — Transmission"),
              _Paragraph(
                "• La détention peut s’apparenter à un recel de données extraites, reproduites ou transmises frauduleusement.\n"
                "• La reproduction vise les actes de copie de données obtenues frauduleusement, quel qu’en soit le support.\n"
                "• La transmission vise toute diffusion de données à un tiers, quel qu’en soit le moyen ou le support.",
              ),

              SizedBox(height: 14),

              _SubTitle("4) Suppression — Modification"),
              _Paragraph(
                "Supprimer des données peut consister en une atteinte à l’intégrité des données (effacement, « écrasement »), "
                "ou encore un déplacement hors du système / vers une zone réservée.\n\n"
                "La modification correspond à une altération de l’information portée par les données.\n\n"
                "En pratique, il est difficile de séparer radicalement introduction, modification et suppression : "
                "modifier suppose souvent d’ajouter, retrancher ou déplacer des données.",
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Comptable ayant modifié des données enregistrées définitivement dans le système automatisé de comptabilité — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 08 décembre 1999",
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
              _Paragraph(
                "L’élément moral réside dans la violation délibérée d’un interdit : "
                "l’auteur agit en sachant que ce n’est pas autorisé et en voulant néanmoins le résultat "
                "(introduire, extraire, détenir, reproduire, transmettre, supprimer ou modifier frauduleusement).",
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
                  text: "Article 323-3 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque l’infraction est commise à l’encontre d’un système de traitement automatisé de données "
                      "à caractère personnel mis en œuvre par l’État.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 323-4-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque l’infraction est commise en bande organisée.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 323-4-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque l’infraction expose autrui à un risque immédiat de mort ou de blessures graves, "
                      "ou fait obstacle aux secours destinés à faire échapper une personne à un péril imminent "
                      "ou à combattre un sinistre présentant un danger pour la sécurité des personnes.",
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
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 150 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 323-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Aggravée (STAD personnel mis en œuvre par l’État) : ",
                ),
                TextSpan(
                  text: "7 ans d’emprisonnement et 300 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 323-3 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (bande organisée) : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 300 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 323-4-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Aggravée (risque immédiat / obstacle aux secours) : ",
                ),
                TextSpan(
                  text: "10 ans d’emprisonnement et 300 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 323-4-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 323-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", avec amende selon "),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et peines prévues par "),
                TextSpan(
                  text: "l’article 131-39 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’interdiction mentionnée au 2° de l’article 131-39 porte sur l’activité dans l’exercice ou à l’occasion "
                        "de l’exercice de laquelle l’infraction a été commise.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text:
                    "Tentative : OUI — spécialement prévue et réprimée par l’article 323-7 du Code pénal.",
              ),
              SizedBox(height: 6),
              _Paragraph(
                "Comme pour toute tentative : commencement d’exécution et absence de résultat en raison de circonstances "
                "indépendantes de la volonté de l’auteur.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI — conformément à "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide et assistance, provocation ou instructions données).",
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
