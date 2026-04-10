import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaquesInscriptionsPage extends StatelessWidget {
  const PlaquesInscriptionsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions';

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
            "Délits relatifs aux plaques et inscriptions",
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
              _Paragraph("Constitue une infraction le fait :"),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    "d’utiliser une plaque ou une inscription exigée, apposée sur un véhicule à moteur ou une remorque, portant un numéro, un nom ou un domicile faux ou supposé.",
              ),
              _IntroBullet(
                text:
                    "de faire circuler un véhicule à moteur ou une remorque, sur voie ouverte à la circulation publique, sans plaques/inscriptions exigées et, en outre, de déclarer un numéro, un nom ou un domicile autre que le sien ou celui du propriétaire.",
              ),
              _IntroBullet(
                text:
                    "de mettre en circulation un véhicule muni d’une plaque ou d’une inscription ne correspondant pas à la qualité du véhicule ou à celle de l’utilisateur.",
              ),
              _IntroBullet(
                text:
                    "de mettre en circulation ou de faire circuler un véhicule muni d’une plaque portant un numéro attribué à un autre véhicule, dans des circonstances ayant déterminé ou pouvant déterminer des poursuites pénales contre un tiers.",
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
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Les articles "),
                TextSpan(
                  text:
                      "L. 317-2 I, L. 317-3 I, L. 317-4 I et L. 317-4-1 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " définissent et répriment les délits relatifs aux plaques et inscriptions apposées sur les véhicules.",
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
              const _Paragraph(
                "Tout véhicule, au moment de sa fabrication, est doté de plaques et inscriptions apposées par le constructeur "
                "(marque, type, cylindrée, numéro de série, poids, etc.).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dès la première mise en circulation, l’acquéreur doit faire installer des plaques reproduisant le numéro "
                "d’immatriculation inscrit sur le certificat d’immatriculation.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Références réglementaires : "),
                TextSpan(
                  text:
                      "articles R. 317-8, R. 317-12 et R. 322-1 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "A) Usage de plaque/inscription fausse (fausses plaques)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 317-2 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : faire usage d’une plaque ou d’une inscription exigée portant un numéro, un nom ou un domicile faux ou supposé.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il s’agit de l’utilisation de « fausses plaques » : apposition ou usage de plaques/inscriptions comportant des indications "
                "ne correspondant pas au certificat d’immatriculation.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Circuler sans plaques + fausse déclaration"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 317-3 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : faire circuler un véhicule sans plaques/inscriptions exigées et, en outre, déclarer un numéro/nom/domicile autre que le sien ou celui du propriétaire.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Sont visés les véhicules démunis de plaques pour lesquels le conducteur déclare de fausses informations "
                "concernant l’identification du véhicule ou du propriétaire.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Plaque/inscription ne correspondant pas à la qualité du véhicule ou de l’utilisateur",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 317-4 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : mettre en circulation un véhicule muni d’une plaque ou d’une inscription ne correspondant pas à la qualité du véhicule ou à celle de l’utilisateur.",
                ),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Utilisation de plaques et documents administratifs d’un véhicule accidenté pour mettre en service un autre véhicule non assuré ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 15 février 1978)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Usurpation de plaque (numéro attribué à un autre véhicule)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 317-4-1 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : mettre en circulation ou faire circuler un véhicule muni d’une plaque portant un numéro attribué à un autre véhicule, "
                      "dans des circonstances ayant déterminé ou pouvant déterminer des poursuites pénales contre un tiers.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il s’agit notamment d’utiliser un numéro d’immatriculation que l’on sait déjà attribué à un autre véhicule, "
                "afin de commettre une ou plusieurs infractions susceptibles d’entraîner des poursuites à l’encontre du titulaire "
                "du certificat d’immatriculation correspondant à ce numéro.",
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
              _SubTitle("Intention"),
              _Paragraph(
                "L’auteur agit intentionnellement et en toute connaissance de cause : "
                "conscience et volonté de ne pas respecter les règles prescrites en matière d’immatriculation, "
                "de plaques et d’inscriptions.",
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
              _BulletPoint(
                text: "Aucune circonstance aggravante prévue par ces textes.",
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
              const _SubTitle("Peines encourues"),
              _Paragraph.rich([
                const TextSpan(text: "Délits prévus par "),
                TextSpan(
                  text:
                      "L. 317-2 I, L. 317-3 I et L. 317-4 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 3 750 € d’amende.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Délit prévu par "),
                TextSpan(
                  text: "L. 317-4-1 I du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 30 000 € d’amende.",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La complicité est punissable au regard de l’infraction consommée, comme au regard de l’infraction tentée. "
                        "Elle suppose un fait matériel de complicité prévu par la loi et l’intention de s’associer à l’action de l’auteur principal.",
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
