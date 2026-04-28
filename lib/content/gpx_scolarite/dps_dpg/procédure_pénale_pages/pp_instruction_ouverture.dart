import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPInstructionOuverturePage extends StatelessWidget {
  const PPInstructionOuverturePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_ouverture';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          "Ouverture d'une information",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // =====================================================
          // TITRE PRINCIPAL
          // =====================================================
          Text(
            "Chapitre 2 :\nL'ouverture d'une information",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 14),

          // =====================================================
          // SECTION 2.1 — CAS D’OUVERTURE D’UNE INFORMATION
          // =====================================================
          const _SubTitle(
            "2.1 – Cas dans lesquels une information est ouverte",
          ),

          _Paragraph.rich([
            const TextSpan(
              text:
                  "L’information est obligatoire en matière criminelle, en raison de la gravité des infractions. "
                  "Elle est prévue par ",
            ),
            TextSpan(
              text: "l’Article 79 du Code de procédure pénale",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
            const TextSpan(
              text:
                  ", car il est nécessaire de réunir les preuves les plus complètes, non seulement sur les faits mais également sur la personnalité de l’auteur.",
            ),
          ]),

          const SizedBox(height: 8),

          const _Paragraph(
            "En matière délictuelle, l’information est facultative sauf lorsqu’un texte spécial l’impose. Elle est notamment ouverte lorsque les faits sont complexes, lorsque l’auteur est inconnu ou en fuite.",
          ),

          const SizedBox(height: 8),

          const _Paragraph(
            "Une plainte avec constitution de partie civile peut également entraîner l’ouverture d’une information en cas de crime ou de délit.",
          ),

          const SizedBox(height: 8),

          _Paragraph.rich([
            const TextSpan(
              text:
                  "Pour les contraventions, l’information n’est ouverte que sur réquisition du procureur de la République, conformément à ",
            ),
            TextSpan(
              text: "l’Article 79 du Code de procédure pénale",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: "."),
          ]),

          const SizedBox(height: 8),

          const _Paragraph(
            "Le juge d’instruction ne peut jamais se saisir lui-même. Il ne peut être saisi que par un acte du ministère public ou par une plainte de la victime.",
          ),

          const SizedBox(height: 20),

          // =====================================================
          // CARD — LA SAISINE DU JUGE D’INSTRUCTION
          // =====================================================
          _ConditionCard(
            title: "2.2 – La saisine du juge d’instruction",
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _Paragraph(
                "Le juge d’instruction est un magistrat du siège nommé par décret du Président de la République, "
                "sur proposition du ministre de la Justice, après avis du Conseil supérieur de la magistrature.",
              ),

              // ---------------------------------------------
              const _SubTitle("2.2.1 – Par le ministère public"),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque le procureur de la République utilise le procédé de l’information, il rédige un réquisitoire afin d’informer "
                      "(ou réquisitoire introductif d’instance). C’est un acte écrit, daté et motivé. ",
                ),
                TextSpan(
                  text: "L’Article 83-1 du Code de procédure pénale",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      " fixe les pôles de l’instruction compétents pour les affaires criminelles ou complexes.",
                ),
              ]),

              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La liste des tribunaux judiciaires dotés d’un pôle de l’instruction est fixée par ",
                ),
                TextSpan(
                  text: "l’Article D.15-4-4 du Code de procédure pénale",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Ces pôles connaissent des crimes et des informations complexes.",
                ),
              ]),

              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque des faits susceptibles de relever du pôle sont portés à la connaissance d’un tribunal où il n’en existe pas, "
                      "le procureur du tribunal judiciaire avise le procureur de la République du tribunal siège du pôle conformément à ",
                ),
                TextSpan(
                  text: "l’Article D.15-4-1 du Code de procédure pénale",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Les magistrats du pôle déterminent alors qui dirigera l’enquête.",
                ),
              ]),

              const SizedBox(height: 14),

              // ---------------------------------------------
              const _SubTitle("2.2.2 – Par la victime"),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La victime peut saisir le juge d’instruction par une plainte avec constitution de partie civile conformément à ",
                ),
                TextSpan(
                  text: "l’Article 85 du Code de procédure pénale",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const _Paragraph(
                "La plainte doit être régulière, motivée, accompagnée de pièces justificatives, "
                "et déclenche automatiquement l’action publique si elle est recevable.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "2.3 – Les conséquences de la saisine du juge d’instruction",
              ),

              const _Paragraph(
                "Le juge saisi ne peut instruire que les faits visés dans le réquisitoire ou la plainte. "
                "Il est dit qu’il est saisi « in rem » et non « in personam ». "
                "S’il découvre de nouveaux faits au cours de son enquête, il doit les dénoncer au procureur de la République.",
              ),

              _Paragraph.rich([
                const TextSpan(text: "Cette obligation résulte de "),
                TextSpan(
                  text: "l’Article 80 du Code de procédure pénale",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 8),

              const _Paragraph(
                "Le procureur peut alors :\n"
                "✓ Rédiger un réquisitoire supplétif ;\n"
                "✓ Requérir l’ouverture d’une information distincte ;\n"
                "✓ Décider d’un classement sans suite ;\n"
                "✓ Ordonner une enquête ;\n"
                "✓ Envisager une mesure alternative aux poursuites ou une composition pénale ;\n"
                "✓ Transmettre les plaintes ou procès-verbaux au procureur territorialement compétent.",
              ),

              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Concernant les personnes mises en cause, le juge d’instruction n’est pas lié par les réquisitions du procureur. "
                      "À peine de nullité, il ne peut mettre en examen qu’une personne contre laquelle existent des indices graves ou concordants. "
                      "Ce principe provient de ",
                ),
                TextSpan(
                  text: "l’Article 80-1 du Code de procédure pénale",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 8),

              const _Paragraph(
                "Dès l’ouverture de l’information, le juge procède à tous les actes utiles à la manifestation de la vérité. "
                "Cette mission est définie par l’Article 81 du Code de procédure pénale et donne au juge un large pouvoir d’initiative.",
              ),
            ],
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
//                   TES WIDGETS PERSONNALISÉS EXACTS                       ///
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
