import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAppelsMessagesMalveillantsAgressionsSonoresPage extends StatelessWidget {
  const PaAppelsMessagesMalveillantsAgressionsSonoresPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores';

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
          "Atteintes volontaires à l’intégrité",
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
            "Les appels téléphoniques et les envois de messages malveillants, ou agressions sonores",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
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
                "Les appels téléphoniques malveillants réitérés, les envois réitérés de messages malveillants "
                "émis par la voie des communications électroniques, ou les agressions sonores commises en vue "
                "de troubler la tranquillité d’autrui, constituent des infractions.",
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
                  text: "Article 222-16 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : prévoit et réprime les appels téléphoniques malveillants, les envois réitérés de messages malveillants "
                      "émis par la voie des communications électroniques, ou les agressions sonores.",
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
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les appels téléphoniques malveillants ou les agressions sonores constituent une forme de violences "
                        "physiques ou psychologiques (référence utile : ",
                  ),
                  TextSpan(
                    text: "article 222-14-3 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
              const SizedBox(height: 14),

              const _SubTitle(
                "A) Des appels / messages émis par la voie des communications électroniques",
              ),
              const _Paragraph(
                "Les appels doivent provenir d’un appareil téléphonique (fixe ou mobile), y compris lorsqu’ils sont reçus "
                "sur répondeur ou boîte vocale.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : le trouble peut être caractérisé que les appels soient reçus directement ou sur boîte vocale ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 20 février 2002)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),
              const SizedBox(height: 12),

              const _Paragraph(
                "Sont également incriminés les envois réitérés de messages malveillants émis par la voie électronique "
                "(SMS, MMS, courriers électroniques, etc.).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : messages écrits et verbaux réitérés quasi quotidiennement ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 7 janvier 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : la réception d’un SMS se manifeste par un signal sonore émis par le téléphone du destinataire ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 30 septembre 2009)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Un caractère malveillant"),
              const _Paragraph(
                "La malveillance correspond à la volonté de faire le mal, de nuire à autrui. "
                "Elle ne se déduit pas uniquement du contenu de l’appel ou du message.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La jurisprudence admet que le caractère malveillant peut résulter :\n"
                "• du contenu du message,\n"
                "• mais aussi de la seule multiplication des appels.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le caractère malveillant peut être démontré par la fréquence des appels, notamment lorsque la victime a "
                        "clairement manifesté son désir de ne plus être importunée, et lorsque l’auteur continue malgré des mises en demeure.",
                  ),
                ],
                title: "Point clé",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Une réitération"),
              const _Paragraph(
                "La réitération suppose un renouvellement des appels ou messages. Le texte ne fixe pas de seuil chiffré.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "La Cour de cassation précise que "),
                TextSpan(
                  text: "deux appels successifs",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                const TextSpan(
                  text:
                      ", même adressés à des destinataires différents, suffisent. ",
                ),
                const TextSpan(
                  text: "(Cass. crim., 4 mars 2003, n°02-86.172)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : appels multipliés à un médecin jusqu’à troubler le fonctionnement du cabinet ",
                  ),
                  TextSpan(
                    text: "(C.A. Grenoble, 23 octobre 1998)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : harcèlement d’un couple (~20 appels/24h) + menaces/injures, obligeant à bloquer puis changer de numéro ",
                  ),
                  TextSpan(
                    text: "(C.A. Pau, 10 juillet 2002)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Les agressions sonores"),
              const _Paragraph(
                "L’agression sonore suppose un bruit d’une certaine importance. La source du bruit peut être multiple "
                "(radio, télévision, chaîne hi-fi, etc.).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le bruit peut être d’origine humaine ou animale, et se produire dans un lieu privé ou public. "
                "Il n’y a pas de condition de réitération pour les agressions sonores.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : en attisant les aboiements de ses chiens et en s’abstenant de limiter la nuisance, l’auteur a agi en vue de troubler la tranquillité publique ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 2 juin 2015)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : directeur de centre de vacances condamné pour répétition d’excès sonores (week-ends d’intégration) malgré interventions des forces de l’ordre ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 30 mars 2004)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
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
              _SubTitle("A) La malveillance"),
              _Paragraph(
                "La malveillance est la condition nécessaire et suffisante pour caractériser l’élément moral "
                "des appels téléphoniques malveillants et des envois réitérés de messages malveillants.",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "B) Volonté de troubler la tranquillité d’autrui (agressions sonores)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Pour les agressions sonores, l’élément intentionnel est la volonté de troubler la tranquillité d’autrui : "
                      "les faits doivent être commis « en vue de troubler ». (",
                ),
                TextSpan(
                  text: "article 222-16 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),
              _Paragraph("L’intention se déduit des actes matériels."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : jouer du tam-tam/tambour entre 3h et 4h du matin, empêchant la voisine (77 ans) de dormir ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 13 novembre 2002)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : aboiements nombreux et réitérés jour et nuit ",
                  ),
                  TextSpan(
                    text: "(C.A. Montpellier, 28 avril 1998)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Jurisprudence",
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Cet élément intentionnel permet de distinguer l’infraction des bruits/tapages injurieux ou nocturnes prévus à ",
                ),
                TextSpan(
                  text: "l’article R. 623-2 du Code pénal",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-16 alinéa 2 du Code pénal",
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
                    "Lorsque les faits sont commis par le conjoint, le concubin ou le partenaire lié à la victime par un pacte civil de solidarité.",
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
                TextSpan(
                  text: "Simple — ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                const TextSpan(
                  text: "1 an d’emprisonnement et 15 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 222-16 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Aggravée — ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 222-16 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              const _Paragraph.rich([
                TextSpan(text: "Peines applicables prévues par "),
                TextSpan(
                  text: "l’article 222-16-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON (non punissable)."),
              const _Paragraph.rich([
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
