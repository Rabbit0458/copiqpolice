import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CorruptionMineurPage extends StatelessWidget {
  const CorruptionMineurPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/corruption_mineur';

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
            "La corruption de mineur",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / infractions
          _ConditionCard(
            title: "Constituent des infractions",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Le fait de favoriser ou de tenter de favoriser la corruption d’un mineur.",
              ),
              _IntroBullet(
                text:
                    "Le fait, commis par un majeur, d’organiser des réunions comportant des exhibitions ou des relations sexuelles auxquelles un mineur assiste ou participe, ou d’assister en connaissance de cause à de telles réunions.",
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
                  text: "Article 227-22 alinéas 1 et 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " : prévoit et réprime la corruption de mineur.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel : rendu pédagogique en 3 éléments + structure clean
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Un auteur des faits"),
              const _Paragraph(
                "L’alinéa 2 vise expressément un auteur majeur dans un cas particulier. "
                "Mais l’alinéa 1, qui pose l’incrimination de façon générale, ne fixe aucune condition d’âge : "
                "l’auteur peut donc être un majeur comme un mineur.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) Une victime mineure"),
              const _Paragraph(
                "La victime doit être un mineur de moins de 18 ans, de l’un ou l’autre sexe, "
                "quelle que soit sa moralité. Le consentement du mineur est indifférent.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "La minorité de 15 ans constitue une circonstance aggravante.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("C) Un acte de corruption"),
              const _Paragraph(
                "Il s’agit de tout acte visant à éveiller ou exciter la dépravation sexuelle chez un mineur, "
                "ou à l’aider à se procurer les moyens de satisfaire ses pulsions dépravées.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "De simples propos obscènes ou de simples conseils sont insuffisants : "
                "il faut des conseils persistants et précis, ou un acte matériel à caractère obscène. "
                "Si le caractère obscène fait défaut, l’infraction n’est pas caractérisée.",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un photographe se masturbant devant une jeune fille censée poser pour lui ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., février 1995)",
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
                        "Envoi de textes et dessins pornographiques à un mineur afin de provoquer sa libido ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 25 janvier 1983)",
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
                "Il n’est pas nécessaire d’établir que l’attitude de l’auteur a effectivement troublé le mineur, "
                "ni que celui-ci se soit livré ensuite à un acte sexuel ou à connotation sexuelle.",
              ),

              const SizedBox(height: 14),

              _Paragraph.rich([
                const TextSpan(
                  text: "Focus : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      "l’alinéa 2 prévoit expressément un cas de corruption : pour un majeur, le fait ",
                ),
                const TextSpan(text: "d’organiser"),
                const TextSpan(
                  text:
                      " des réunions comportant des exhibitions ou des relations sexuelles auxquelles un mineur assiste/participe, ou ",
                ),
                const TextSpan(text: "d’assister"),
                const TextSpan(
                  text: " en connaissance de cause à de telles réunions.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il s’agit de « parties » d’un genre particulier (sexualité de groupe, spectacles pornographiques). "
                "Le caractère dépravant est constant : ces faits entrent dans le champ de la corruption de mineur.",
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
              const _SubTitle(
                "Conscience de l’obscénité et connaissance de l’âge",
              ),
              const _Paragraph(
                "Il s’agit d’une infraction intentionnelle : l’auteur doit avoir conscience du caractère obscène "
                "de son acte et connaître l’âge (minorité) de la victime.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Volonté de corrompre la victime"),
              const _Paragraph(
                "L’auteur doit avoir eu la volonté de corrompre le mineur, de l’inciter à se dépraver. "
                "Cette intention se déduit des circonstances.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Si l’auteur n’avait pour but que d’assouvir ses pulsions personnelles sans chercher à dépraver le mineur, "
                "l’infraction n’est pas constituée (d’autres qualifications peuvent s’appliquer : viol, agressions sexuelles, "
                "atteinte sexuelle, etc.).",
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
                  text: "Article 227-22 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsque le mineur a été mis en contact avec l’auteur grâce à l’utilisation, pour la diffusion de messages à destination d’un public non déterminé, d’un réseau de communications électroniques.",
              ),
              const _BulletPoint(
                text:
                    "Lorsque les faits sont commis dans un établissement d’enseignement/d’éducation ou dans les locaux de l’administration (ou aux abords lors des entrées/sorties, dans un temps très voisin).",
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 227-22 alinéa 3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Lorsque le mineur est âgé de moins de quinze ans.",
              ),
              const _BulletPoint(
                text: "Lorsque les faits sont commis en bande organisée.",
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
                  text: "Qualification simple : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-22 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Cas visé (réunions sexuelles) : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-22 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (alinéa 1) : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 150 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-22 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (moins de 15 ans / bande organisée) : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 1 000 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-22 alinéa 3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Lorsque l’infraction est commise à l’étranger par un Français (ou une personne résidant habituellement en France), la loi française peut s’appliquer sans plainte de la victime ni dénonciation officielle : ",
                  ),
                  const TextSpan(
                    text: "article 227-27-1 du Code pénal",
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
                const TextSpan(
                  text: "Responsabilité pénale prévue expressément : ",
                ),
                const TextSpan(
                  text: "article 227-28-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (amende selon l’article 131-38 et peines complémentaires visées à l’article 131-39).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Tentative : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "OUI — prévue expressément à l’alinéa 1 de ",
                ),
                const TextSpan(
                  text: "l’article 227-22 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Complicité : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "OUI — conformément à "),
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
