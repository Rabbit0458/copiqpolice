import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRefusObtempererPage extends StatelessWidget {
  const PaRefusObtempererPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/refus_obtemperer';

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
        ? const Color(0xFF1E1F22)
        : const Color(0xFFF2F2F2);

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
          "Infractions circulation routière",
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
            "Le refus d’obtempérer",
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
                "Le fait, pour tout conducteur, d’omettre d’obtempérer à une sommation de s’arrêter "
                "émanant d’un fonctionnaire ou agent chargé de constater les infractions, "
                "et muni des insignes extérieurs et apparents de sa qualité, constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal EN HAUT
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 233-1 I du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : définit et réprime le refus d’obtempérer.",
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
              _SubTitle("A) Agents habilités et identifiables"),
              _Paragraph(
                "Les termes « fonctionnaire ou agent chargé de constater les infractions » englobent "
                "les agents énumérés par le Code de la route. Ces personnes doivent être clairement identifiables "
                "par le port d’insignes extérieurs et apparents de leur qualité.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Références : "),
                TextSpan(
                  text: "articles L. 130-1 à L. 130-4 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text:
                        "• Tenue spéciale de sécurité pouvant induire en erreur sur la qualité des agents (confusion possible) ",
                  ),
                  TextSpan(
                    text: "(TGI Brive, 6 février 1981)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "• Gyrophare + avertisseur sonore : marques distinctives tenant lieu d’identification d’un véhicule de police ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 23 février 1987)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) La sommation de s’arrêter"),
              _Paragraph(
                "Elle doit désigner clairement le conducteur (gestes réglementaires d’arrêt, coups de sifflet, "
                "signalisations lumineuses…). Le conducteur ne doit avoir aucun doute sur la nature de l’ordre "
                "qui lui est destiné. La forme de l’ordre importe peu.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text:
                        "• La connaissance non équivoque de l’obligation de s’arrêter est établie si un gendarme/policier invite à immobiliser le véhicule par projecteur + sifflet ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 11 mai 1989)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "• L’ordre peut résulter d’un geste ou de toute attitude significative d’une obligation de s’arrêter ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 20 février 2007)",
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
                title: "Attention",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le délit ne saurait être retenu si une action violente ou dangereuse absorbe l’abstention/le refus de s’arrêter.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Exemple : foncer sur des gendarmes avec le véhicule = violences volontaires aggravées ",
                ),
                TextSpan(
                  text: "(Cass. crim., 2 mai 2002)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("C) Le refus d’obtempérer (fait du conducteur)"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le refus d’obtempérer est le fait du conducteur de tout véhicule ou ensemble de véhicules. ",
                ),
                TextSpan(
                  text: "Article R. 412-6 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Seul le conducteur peut être poursuivi comme auteur. Toutefois, la responsabilité des passagers "
                "peut être retenue pour complicité, notamment selon leur comportement (ou celui du conducteur) "
                "pendant la commission des faits.",
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
              _SubTitle("Volonté de ne pas obéir à une sommation de s’arrêter"),
              _Paragraph(
                "Le délit est constitué par le refus intentionnel du conducteur de s’arrêter. "
                "Cela suppose que l’ordre ait été clairement perçu.",
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
                  text: "Article L. 233-1-1 I alinéa 1 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque les faits sont commis dans des circonstances exposant directement autrui à un risque "
                      "de mort ou de blessures de nature à entraîner une mutilation ou une infirmité permanente.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Il s’agit d’un refus d’obtempérer commis par un conducteur qui conduit en violation d’une règle "
                "du Code de la route. La violation doit, en soi, entraîner une probabilité très importante d’accident "
                "corporel et le risque doit être causé à autrui (présence de personnes susceptibles d’être victimes).",
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Poursuivre sa route à très grande vitesse sur autoroute pour échapper au contrôle a exposé gendarmes et usagers à un risque de mort/blessures graves ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 21 mai 2008, n° 08-80.017)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 14),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 233-1-1 I alinéa 2 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque les faits exposent directement les agents/fonctionnaires mentionnés au I "
                      "de l’article L. 233-1 à un risque de mort ou de blessures graves (mutilation/infirmité permanente).",
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
              _SubTitle("Peines encourues — forme simple"),
              _Paragraph.rich([
                TextSpan(text: "Qualification : "),
                TextSpan(text: "délit. "),
                TextSpan(text: "— Peines principales : "),
                TextSpan(
                  text: "2 ans d’emprisonnement et 15 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "Article L. 233-1 I du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle("Peines encourues — formes aggravées"),
              _Paragraph.rich([
                TextSpan(text: "Aggravation (risque pour autrui) : "),
                TextSpan(
                  text: "article L. 233-1-1 I alinéa 1 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " — "),
                TextSpan(text: "75 000 € d’amende."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravation (risque pour les agents) : "),
                TextSpan(
                  text: "article L. 233-1-1 I alinéa 2 du Code de la route",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " — "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 1 000 000 € d’amende.",
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text: "Article L. 233-1 II du Code de la route",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : les peines prononcées pour le délit prévu au I se cumulent, sans possibilité de confusion, "
                        "avec celles prononcées pour les autres infractions commises à l’occasion de la conduite du véhicule "
                        "(nonobstant les articles 132-2 à 132-5 du Code pénal).",
                  ),
                ],
              ),

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
                TextSpan(text: "."),
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
