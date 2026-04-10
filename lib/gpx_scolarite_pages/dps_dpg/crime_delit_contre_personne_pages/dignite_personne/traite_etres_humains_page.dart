import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TraiteEtresHumainsPage extends StatelessWidget {
  const TraiteEtresHumainsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains';

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
            "La traite des êtres humains",
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
                "La traite des êtres humains est le fait de recruter une personne, de la transporter, de la transférer, "
                "de l’héberger ou de l’accueillir à des fins d’exploitation, notamment lorsqu’elle est obtenue par menace, "
                "contrainte, violence, manœuvre dolosive, abus d’autorité, ou abus d’une situation de vulnérabilité, "
                "ou encore en échange d’une rémunération/avantage (ou promesse).",
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
                  text: "Article 225-4-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " : définit et réprime la traite des êtres humains.",
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
              const _SubTitle("A) Un acte positif envers une personne"),
              const _Paragraph(
                "La traite suppose un acte positif de l’auteur : recruter, transporter, transférer, accueillir ou héberger.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Recruter : démarches pour convaincre/forcer une personne à être mise à disposition d’un tiers dans un but criminel.",
              ),
              const _BulletPoint(
                text:
                    "Transporter : assurer effectivement le déplacement de la victime d’un point à un autre.",
              ),
              const _BulletPoint(
                text:
                    "Transférer : faire en sorte que le déplacement s’effectue sans intervenir directement.",
              ),
              const _BulletPoint(
                text:
                    "Accueillir : être présent lors de l’arrivée de la victime ; Héberger : loger la victime.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Une circonstance de commission (pour un majeur)",
              ),
              const _Paragraph(
                "À l’égard d’un majeur, la traite est constituée si l’acte est commis dans au moins l’une des circonstances suivantes :",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "1) Menace, contrainte, violence ou manœuvre dolosive",
              ),
              const _BulletPoint(
                text:
                    "Menace / contrainte : moyens visant à supprimer le consentement (violences morales assimilées à des violences physiques).",
              ),
              const _BulletPoint(
                text:
                    "Violence : violence physique exercée sur la victime (ou sa famille / proche).",
              ),
              const _BulletPoint(
                text:
                    "La menace/la contrainte doit inspirer une crainte sérieuse et immédiate (pour la victime ou un proche).",
              ),
              const _BulletPoint(
                text:
                    "Manœuvre dolosive : agissements trompeurs amenant la victime à être abusée (ruse).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Ascendant / autorité / abus d’autorité"),
              const _Paragraph(
                "Sont visées les personnes disposant :\n"
                "• d’une autorité de droit (ex. tuteur)\n"
                "• d’une autorité de fait (permanente ou discontinue) liée aux circonstances\n"
                "• d’une autorité conférée par les fonctions (publiques : professeur… / privées : médecin…).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) Abus d’une situation de vulnérabilité"),
              const _Paragraph(
                "La vulnérabilité doit être due à des causes limitativement prévues (âge, maladie, infirmité, déficience physique/psychique, grossesse) "
                "et résulter d’un état préexistant (non créé par l’infraction). Elle doit être apparente ou connue de l’auteur.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("4) Rémunération / avantage / promesse"),
              const _Paragraph(
                "Cette circonstance suppose une forme de négociation : l’échange doit être convenu initialement (avant la remise/mise à disposition). "
                "La rémunération peut être en numéraire ou en nature. L’avantage doit être tangible. La promesse est une anticipation et n’a pas besoin d’être contractualisée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si une « contrepartie » intervient seulement après la remise, l’infraction n’est pas constituée au titre de cette circonstance.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _NotaBox(
                title: "Mineur",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La traite à l’égard d’un mineur est constituée même si elle n’est commise dans aucune des circonstances 1° à 4°.",
                  ),
                  const TextSpan(text: " — "),
                  const TextSpan(
                    text: "article 225-4-1 II du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Une mise à disposition"),
              const _Paragraph(
                "La victime doit être mise à la disposition de l’auteur ou d’un tiers (même non identifié). "
                "La mise à disposition est sanctionnée même si elle n’a pas été effectivement réalisée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Point clé",
                bodySpans: const [
                  TextSpan(
                    text:
                        "L’intervention d’un tiers n’est pas nécessaire : la traite peut être retenue si l’auteur agit pour mettre la victime à sa propre disposition.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Un objectif criminel d’exploitation"),
              const _Paragraph(
                "L’exploitation consiste à mettre la victime à disposition afin de permettre notamment : proxénétisme, agressions/atteintes sexuelles, "
                "réduction en esclavage, travail ou services forcés, servitude, prélèvement d’organe, exploitation de la mendicité, "
                "conditions de travail/hébergement contraires à la dignité, ou à contraindre la victime à commettre un crime ou un délit.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Il n’est pas nécessaire que les infractions d’exploitation soient effectivement commises pour que la traite soit constituée.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Lorsque l’objectif est de contraindre la victime à commettre un crime/délit, la contrainte doit être ressentie comme irrésistible "
                "(impossibilité absolue de respecter la loi).",
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
              const _SubTitle("Conscience du devenir de la victime"),
              const _Paragraph(
                "L’infraction étant intentionnelle, il faut établir que l’auteur savait à quoi la victime était destinée : "
                "il doit connaître les infractions auxquelles elle devait être soumise, ou la contrainte exercée sur elle pour la déterminer à en commettre.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Consentement",
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette incrimination ne repose pas sur la notion de consentement : l’existence ou l’absence de consentement de la victime n’a pas à être démontrée.",
                  ),
                ],
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
              const _SubTitle("Traite aggravée délictuelle"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-4-1 II du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsqu’elle est commise à l’égard d’un mineur, même sans les circonstances 1° à 4°.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-4-2 I du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsqu’elle est commise dans deux des circonstances 1° à 4° de l’article 225-4-1 I.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Ou avec l’une des circonstances supplémentaires : plusieurs victimes ; victime hors du territoire / à l’arrivée ; contact via réseau de communication électronique ; "
                    "exposition à un risque immédiat de mort ou de mutilation/infirmité permanente ; violences avec ITT > 8 jours ; "
                    "auteur participant par ses fonctions à la lutte contre la traite ou au maintien de l’ordre public ; "
                    "victime placée dans une situation matérielle ou psychologique grave.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("Traite aggravée criminelle"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-4-2 II du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsqu’elle est commise à l’égard d’un mineur + l’une des circonstances de l’article 225-4-1 I ou de l’article 225-4-2 I.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-4-3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " : bande organisée."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 225-4-4 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " : tortures ou actes de barbarie."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + exemption/réduction
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Simple : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 150 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-1 I du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (mineur) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 1 500 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-1 II du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (225-4-2 I) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 1 500 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-2 I du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Criminelle (225-4-2 II) : "),
                const TextSpan(
                  text: "15 ans de réclusion et 1 500 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-2 II du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Bande organisée : "),
                const TextSpan(
                  text: "20 ans de réclusion et 3 000 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Tortures / barbarie : "),
                const TextSpan(
                  text:
                      "réclusion criminelle à perpétuité et 4 500 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 225-4-4 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Nota",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si le crime ou délit commis (ou devant être commis) contre la victime est puni d’une peine privative de liberté supérieure, "
                        "la traite est punie des peines attachées à ce crime/délit (et à ses circonstances aggravantes connues de l’auteur). ",
                  ),
                  const TextSpan(text: "— "),
                  const TextSpan(
                    text: "article 225-4-5 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité prévue par "),
                const TextSpan(
                  text: "l’article 225-4-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " ; amende selon "),
                const TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " + peines des "),
                const TextSpan(
                  text: "articles 131-39, 225-24 et 225-25 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " (dissolution, interdictions, confiscations…).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — "),
                const TextSpan(
                  text: "article 225-4-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI — "),
                const TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " (aide/assistance, provocation, instructions).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Exemption & réduction de peine"),
              _Paragraph.rich([
                const TextSpan(text: "Exemption de peine : "),
                const TextSpan(
                  text: "article 225-4-9 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (auteur au stade de la tentative qui avertit l’autorité et permet d’éviter la réalisation de l’infraction).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Réduction de peine : "),
                const TextSpan(
                  text: "article 225-4-9 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (peine réduite des 2/3 si l’auteur/complice avertit et permet de faire cesser l’infraction, d’éviter une mort/infirmité permanente, "
                      "ou d’identifier les autres auteurs/complices ; perpétuité ramenée à 20 ans).",
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
