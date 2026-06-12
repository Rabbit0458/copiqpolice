import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaArmesAcquisitionDetentionABPage extends StatelessWidget {
  const PaArmesAcquisitionDetentionABPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab';

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
          "Armes & munitions",
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
            "Acquisition / détention / cession d’armes A ou B sans autorisation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (courte, sans répéter le titre)
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Constitue un délit le fait d’acquérir, de détenir ou de céder des matériels de guerre, armes, éléments d’armes "
                      "ou munitions des catégories A ou B ",
                ),
                TextSpan(
                  text: "sans l’autorisation requise",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF050505),
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(text: "⚠️ À ne pas confondre : "),
                  TextSpan(
                    text: "détention",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text:
                        " ≠ port/transport (qui nécessitent des règles/autorisations spécifiques).",
                  ),
                ],
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
                  text: "Article 222-52 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : réprime le fait d’acquérir, de détenir ou de céder sans autorisation des matériels de guerre, armes, éléments d’armes ou munitions des catégories A ou B.",
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Autorisation de principe (cadre général) : ",
                ),
                TextSpan(
                  text: "article L. 2332-1 I du Code de la défense",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Règles CSI visées : "),
                TextSpan(
                  text:
                      "articles L. 312-1 à L. 312-4, L. 312-4-3, L. 314-2 et L. 314-3 du C.S.I.",
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

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Les actes incriminés"),
              _Paragraph(
                "Le délit peut être constitué par l’un des trois comportements suivants : acquisition, cession ou détention.",
              ),
              SizedBox(height: 10),

              _SubTitle("1) L’acquisition"),
              _Paragraph(
                "L’acquisition correspond au fait d’acheter une arme ou des munitions (chez un commerçant ou un particulier), "
                "ou de la recevoir sous forme de don ou de legs. "
                "Pour acquérir une arme, une autorisation préalable d’acquisition doit être obtenue.",
              ),
              SizedBox(height: 12),

              _SubTitle("2) La cession"),
              _Paragraph(
                "On parle de cession lorsque l’arme ou les munitions sont transmises à un tiers : vente, don ou legs.",
              ),
              SizedBox(height: 12),

              _SubTitle("3) La détention"),
              _Paragraph(
                "La détention vise tous les actes par lesquels une personne exerce une maîtrise de fait sur une arme ou des munitions "
                "(mainmise matérielle), quelle que soit la situation juridique.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Le détenteur n’est pas nécessairement le propriétaire : il peut n’avoir que la jouissance (ex. agent de sécurité).",
              ),
              _BulletPoint(
                text:
                    "L’arme/munition est conservée au domicile ou dans un lieu assimilé.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La détention doit être distinguée du port/transport : une autorisation de détention ne vaut pas autorisation de porter ou transporter.",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Les armes ou munitions concernées"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-52 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : incrimine uniquement les matériels de guerre, armes, éléments d’armes ou munitions relevant des catégories A ou B.",
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Catégorie A : matériels de guerre et armes interdits à l’acquisition et à la détention.",
              ),
              _BulletPoint(
                text: "Catégorie B : armes soumises à autorisation.",
              ),

              SizedBox(height: 14),

              _SubTitle("C) L’absence d’autorisation"),
              _Paragraph.rich([
                TextSpan(text: "Principe : "),
                TextSpan(
                  text: "interdiction",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ". L’autorisation est une "),
                TextSpan(
                  text: "dérogation",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", pas un droit."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Nota (entreprises) : "),
                  TextSpan(
                    text: "article L. 2332-1 I du Code de la défense",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " — les entreprises de fabrication ou de commerce (cat. A/B) doivent disposer d’une autorisation expresse de l’État et sont contrôlées.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Concernant les particuliers, l’État conserve un contrôle strict : sans autorisation expresse, "
                "l’acquisition et la détention des armes et munitions des catégories A ou B sont interdites.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Obligations CSI à respecter : "),
                TextSpan(
                  text:
                      "L. 312-1 à L. 312-4, L. 312-4-3, L. 314-2 et L. 314-3 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Ces textes rappellent que l’acquisition et la détention des catégories A/B sont interdites sauf autorisation délivrée par l’État.",
              ),
              _BulletPoint(
                text:
                    "L’autorisation est généralement accordée aux tireurs sportifs et aux personnes exposées à des risques sérieux pour leur sécurité (nature/lieu d’activité).",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Les conditions (nombre d’armes/munitions, âge, modalités) varient selon la qualité du détenteur (mineur, tireur sportif, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Cession/transfert entre particuliers : "),
                TextSpan(
                  text: "articles L. 314-2 et L. 314-3 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " — possible uniquement si le cessionnaire/transféreur dispose lui-même d’une autorisation conforme.",
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
              _SubTitle("A) Volonté de détenir (ou d’acquérir / céder)"),
              _Paragraph(
                "L’auteur doit avoir la volonté de réaliser l’acte (acquérir, détenir ou céder) : "
                "il s’agit d’un comportement intentionnel.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Conscience de ne pas disposer de l’autorisation"),
              _Paragraph(
                "L’auteur doit savoir qu’il n’est pas en possession de l’autorisation correspondante "
                "exigée pour des armes/munitions de catégories A ou B.",
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
                  text: "Article 222-52 alinéa 2 du Code pénal",
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
                    "Lorsque l’auteur a été antérieurement condamné pour une ou plusieurs infractions mentionnées aux articles 706-73 et 706-73-1 du Code de procédure pénale, "
                    "à une peine égale ou supérieure à un an d’emprisonnement ferme.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-52 alinéa 3 du Code pénal",
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
                    "Lorsque l’infraction est commise par au moins deux personnes agissant en qualité d’auteur ou de complice.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Référence aggravation (CPP) : "),
                  TextSpan(
                    text: "articles 706-73 et 706-73-1 du C.P.P.",
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

          // Répression
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification : "),
                TextSpan(
                  text: "Délit",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(text: "• Forme simple : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-52 alinéa 1 du C.P.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(text: "• Aggravée (condamnation antérieure) : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-52 alinéa 2 du C.P.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(text: "• Aggravée (au moins deux personnes) : "),
                TextSpan(
                  text: "10 ans d’emprisonnement et 500 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-52 alinéa 3 du C.P.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle("B) Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 222-61 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Amende selon "),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et peines complémentaires selon "),
                TextSpan(
                  text: "l’article 131-39 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("C) Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : "),
                TextSpan(
                  text: "OUI",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " — prévue spécialement par "),
                TextSpan(
                  text: "l’article 222-60 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Complicité : "),
                TextSpan(
                  text: "OUI",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("D) Exemption & réduction de peine"),
              _Paragraph.rich([
                TextSpan(text: "Exemption de peine : "),
                TextSpan(
                  text: "article 222-67-1 alinéa 1 du Code pénal",
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
                        "Toute personne qui a tenté de commettre les infractions de la section est exempte de peine si, "
                        "ayant averti l’autorité administrative ou judiciaire, elle a permis d’éviter leur réalisation.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(text: "Réduction de peine : "),
                TextSpan(
                  text: "article 222-67-1 alinéa 2 du Code pénal",
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
                        "La peine privative de liberté est réduite des deux tiers si, ayant averti l’autorité administrative ou judiciaire, "
                        "l’auteur/complice a permis de faire cesser l’infraction ou d’identifier les autres auteurs/complices.",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
