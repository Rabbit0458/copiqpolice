import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiffusionMessageViolentMineurPage extends StatelessWidget {
  const DiffusionMessageViolentMineurPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur';

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
            "La diffusion d’un message violent / terroriste / pornographique ou dangereux susceptible d’être vu ou perçu par un mineur",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait soit de fabriquer, de transporter, de diffuser par quelque moyen que ce soit et quel qu’en soit le support "
                "un message à caractère violent, incitant au terrorisme, pornographique (y compris des images pornographiques impliquant "
                "un ou plusieurs animaux), ou de nature à porter gravement atteinte à la dignité humaine, ou à inciter des mineurs à se livrer "
                "à des jeux les mettant physiquement en danger, soit de faire commerce d’un tel message, lorsque ce message est susceptible "
                "d’être vu ou perçu par un mineur, constitue une infraction.",
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
                  text: "Article 227-24 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : prévoit et réprime la diffusion de ce type de message lorsqu’il est susceptible d’être vu ou perçu par un mineur.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (3 éléments pédagogiques + actes incriminés)
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Un message (notion large)"),
              const _Paragraph(
                "Le terme « message » s’entend au sens le plus large : il peut s’agir d’une communication au sens strict "
                "(lettre, appel, message, etc.) mais aussi d’un contenu transmis par une œuvre (fiction, peinture, représentation, etc.).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Le support est indifférent : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      "la loi vise la diffusion « par quelque moyen que ce soit et quel qu’en soit le support » (écrits, œuvres audio/vidéo, représentations matérielles, productions télématiques, etc.). — ",
                ),
                const TextSpan(
                  text: "article 227-24 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("B) Le caractère du message"),
              const _Paragraph(
                "Le message doit présenter l’un des caractères suivants : violent, incitant au terrorisme, pornographique "
                "(y compris des images pornographiques impliquant un ou plusieurs animaux), portant gravement atteinte à la dignité humaine, "
                "ou incitant les mineurs à se livrer à des jeux les mettant physiquement en danger.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ces notions peuvent viser des actes dégradants ou d’une grande violence, susceptibles de provoquer des effets traumatisants "
                "sur la jeunesse.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Sont notamment visées des pratiques comme le « jeu du foulard » : compétition consistant à résister le plus longtemps possible à une strangulation.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Les actes incriminés"),
              _Paragraph.rich([
                const TextSpan(text: "Sont réprimés : "),
                const TextSpan(
                  text:
                      "la fabrication, le transport, la diffusion, ou le commerce d’un tel message. — ",
                ),
                const TextSpan(
                  text: "article 227-24 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ces actes visent tous ceux qui interviennent dans l’exploitation des messages interdits : "
                "fabrication, diffusion, ou profit. Le commerce peut inclure les financeurs en amont et les bénéficiaires en aval, "
                "même s’ils n’ont pas participé matériellement à la diffusion.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Un mineur susceptible de voir / percevoir le message",
              ),
              const _Paragraph(
                "L’infraction est constituée dès lors que le message est « susceptible d’être vu ou perçu par un mineur ». "
                "Il n’est pas nécessaire qu’un mineur (ou même le public) ait effectivement été atteint par le message.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La diffusion sciemment réalisée est sanctionnée, mais aussi l’imprudence ou la négligence "
                "permettant l’accès des mineurs à des messages réservés aux majeurs (absence de précautions suffisantes).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’infraction peut être constituée même si l’accès du mineur résulte d’une simple déclaration de celui-ci "
                "affirmant avoir au moins 18 ans.",
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
                "Conscience de la possible diffusion à des mineurs",
              ),
              const _Paragraph(
                "L’élément moral est caractérisé dès lors que l’auteur a conscience que le message est susceptible d’être vu ou perçu par un mineur.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il est réalisé si la diffusion est délibérément effectuée à destination de mineurs, "
                "mais aussi lorsque l’accès des mineurs résulte d’un manque de précautions suffisantes.",
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
              _Paragraph("Aucune circonstance aggravante prévue."),
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
                  text: "Délit — qualification simple : ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                const TextSpan(
                  text: "article 227-24 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Lorsque le délit est commis par voie de presse écrite/audiovisuelle ou communication au public en ligne, des règles spécifiques déterminent les responsables : ",
                  ),
                  const TextSpan(
                    text: "article 227-24 alinéa 2 du Code pénal",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Lorsque l’infraction est commise à l’étranger par un Français (ou une personne résidant habituellement en France), la loi française peut s’appliquer même sans plainte ni dénonciation : ",
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
                const TextSpan(text: "Responsabilité pénale prévue par "),
                const TextSpan(
                  text: "l’article 227-28-1 du Code pénal",
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
