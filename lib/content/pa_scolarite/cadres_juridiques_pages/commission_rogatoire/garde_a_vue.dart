import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaGardeAVuePage extends StatelessWidget {
  const PaGardeAVuePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/garde_a_vue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    // Couleur utilisée pour tous les articles de loi
    const Color lawColor = Color(0xFFD32F2F);

    TextSpan lawSpan(String text) => TextSpan(
      text: text,
      style: const TextStyle(color: lawColor, fontWeight: FontWeight.w700),
    );

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
          'Garde à vue',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            '3.7 — La garde à vue',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Garde à vue dans le cadre de l’exécution d’une commission rogatoire, "
            "régie par les dispositions du Code de procédure pénale et soumise à "
            "des règles de fond et de forme proches de celles de l’enquête de "
            "flagrance ou de l’enquête préliminaire.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 10),

          const _IntroBullet(
            text:
                "La garde à vue sur commission rogatoire reste une mesure privative "
                "de liberté exceptionnelle, strictement encadrée et réservée aux "
                "personnes soupçonnées d’avoir commis un crime ou un délit puni "
                "d’une peine d’emprisonnement.",
          ),
          const _IntroBullet(
            text:
                "Le juge d’instruction contrôle directement la mesure et ses "
                "prolongations, tout en partageant certains pouvoirs avec le "
                "procureur de la République et le juge des libertés et de la "
                "détention.",
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.7 — LA GARDE À VUE
          // ================================================================
          _ConditionCard(
            title: '3.7 — La garde à vue',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La garde à vue dans le cadre de l’exécution d’une commission "
                      "rogatoire est prévue par ",
                ),
                lawSpan("l’article 154 du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Même lors de l’exécution d’une commission rogatoire, ne peuvent "
                "être placées en garde à vue que les personnes à l’encontre desquelles "
                "il existe une ou plusieurs raisons de soupçonner qu’elles ont commis "
                "ou tenté de commettre un crime ou un délit puni d’une peine "
                "d’emprisonnement.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En vertu de l’article 153 alinéa 1, les personnes à l’encontre "
                      "desquelles il n’existe aucune raison plausible de soupçonner "
                      "qu’elles ont commis ou tenté de commettre une infraction ne "
                      "peuvent pas être placées en garde à vue : elles ne peuvent être "
                      "retenues que le temps strictement nécessaire à leur audition, ",
                ),
                lawSpan(
                  "conformément à l’article 153 alinéa 1 du Code de procédure pénale",
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _Paragraph(
                "Lors de l’exécution d’une commission rogatoire, la garde à vue est "
                "soumise, en principe, aux mêmes règles de fond et de forme qu’au "
                "cours d’une enquête de flagrance ou d’une enquête préliminaire, à "
                "l’exception des particularités suivantes :",
              ),
              const SizedBox(height: 14),

              // ------------------------------------------------------------
              // Particularité : contrôle par le juge d’instruction
              // ------------------------------------------------------------
              const _SubTitle("Contrôle de la garde à vue par le juge d’instruction"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "✓ La garde à vue est directement contrôlée par le juge "
                      "d’instruction (",
                ),
                lawSpan("article 154 alinéa 2 du Code de procédure pénale"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Ce magistrat doit être avisé dès le début de la mesure. L’officier "
                      "de police judiciaire doit l’informer du ou des motifs figurant à ",
                ),
                lawSpan("l’article 62-2 du Code de procédure pénale"),
                const TextSpan(
                  text: " justifiant le placement en garde à vue.",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le juge d’instruction exerce les pouvoirs conférés au procureur de "
                      "la République en matière d’avis aux personnes à prévenir (",
                ),
                lawSpan("article 63-2 du Code de procédure pénale"),
                const TextSpan(text: "), d’examen médical du gardé à vue ("),
                lawSpan("article 63-3 du Code de procédure pénale"),
                const TextSpan(
                  text: ") et d’enregistrement des interrogatoires en ",
                ),
                lawSpan(
                  "matière criminelle au sens de l’article 64-1 du Code "
                  "de procédure pénale",
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le contrôle du juge d’instruction n’est pas exclusif du pouvoir "
                      "général de contrôle exercé par le procureur de la République en "
                      "vertu de ",
                ),
                lawSpan("l’article 41 du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),

              // ------------------------------------------------------------
              // Prolongation de la garde à vue
              // ------------------------------------------------------------
              const _SubTitle("Prolongation de la garde à vue"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "✓ L’autorisation de prolongation de la garde à vue relève du juge "
                      "d’instruction. La prolongation ne peut être décidée que si elle "
                      "constitue l’unique moyen de parvenir à l’un des six objectifs "
                      "visés par ",
                ),
                lawSpan("l’article 62-2 du Code de procédure pénale"),
                const TextSpan(
                  text:
                      " ou de permettre, lorsque le tribunal ne dispose pas de locaux "
                      "adaptés, ",
                ),
                lawSpan(
                  "au sens de l’article 803-3 du Code de procédure pénale",
                ),
                const TextSpan(
                  text:
                      ", la présentation de la personne devant l’autorité judiciaire.",
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                "Le juge d’instruction peut subordonner son autorisation à la "
                "présentation de la personne devant lui, y compris par l’utilisation "
                "d’un moyen de télécommunication audiovisuelle.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "S’il accorde la prolongation, le juge d’instruction doit préciser, "
                "dans une décision écrite, le ou les motifs retenus et, le cas "
                "échéant, les éléments de l’espèce justifiant la mesure.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                lawSpan("L’article 152 alinéa 3 du Code de procédure pénale"),
                const TextSpan(
                  text:
                      " autorise le juge d’instruction à se transporter, sans son "
                      "greffier, pour diriger et contrôler l’exécution de la "
                      "commission rogatoire. À l’occasion de ce transport, il peut "
                      "ordonner la prolongation des gardes à vue prononcées dans le "
                      "cadre de la commission rogatoire.",
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                "Le juge d’instruction mandant est compétent en principe pour "
                "ordonner la prolongation de la garde à vue, car il est le mieux "
                "placé pour apprécier la nécessité de la mesure.",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "Une compétence concurrente est toutefois reconnue au juge "
                "d’instruction du lieu d’exécution de la mesure lorsque la garde à "
                "vue se déroule dans un ressort différent de celui du siège du juge "
                "d’instruction mandant.",
              ),
              const SizedBox(height: 14),

              // ------------------------------------------------------------
              // Droits de la défense et avocat
              // ------------------------------------------------------------
              const _SubTitle("Assistance de l’avocat"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "✓ L’avocat assistant la personne lors de sa garde à vue doit être "
                      "informé, en plus des mentions prévues dans les autres cadres "
                      "juridiques d’enquête, que la mesure intervient dans le cadre de "
                      "l’exécution d’une commission rogatoire (",
                ),
                lawSpan("article 154 alinéa 2 du Code de procédure pénale"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                "Les règles relatives au report de l’assistance de l’avocat sont "
                "également applicables en matière d’information judiciaire.",
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                "Le report jusqu’à la douzième heure de garde à vue relève de la "
                "compétence du juge d’instruction.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Lorsque l’officier de police judiciaire sollicite le report jusqu’à la "
                "vingt-quatrième heure de garde à vue, le juge d’instruction saisit le "
                "juge des libertés et de la détention, qui décide d’accorder ou non la "
                "prolongation du report.",
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque l’infraction ayant justifié le placement en garde à vue "
                      "relève de la criminalité organisée, seul le juge d’instruction "
                      "est compétent pour autoriser le report de l’intervention de "
                      "l’avocat, conformément aux dispositions de ",
                ),
                lawSpan("l’article 706-88 du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
            ],
          ),
          const SizedBox(height: 26),
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