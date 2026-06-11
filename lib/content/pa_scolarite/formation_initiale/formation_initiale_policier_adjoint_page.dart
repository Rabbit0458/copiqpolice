import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormationInitialePolicierAdjointPage extends StatelessWidget {
  const FormationInitialePolicierAdjointPage({super.key});

  static const String routeName =
      '/pa/institution/formation_initiale/formation';

  // Rouge pour les articles/codes (CPP/CP/CSI/etc.)
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
    final Color cardOrg = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPhases = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardEval = isDark
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
          "Formation initiale",
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
            "La formation initiale des policiers adjoints",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Élément légal (rappel déontologique)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Prestation de serment : "),
                TextSpan(
                  text: "article L 434-1 A du code de déontologie",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — « Préalablement à sa prise de fonctions, tout agent de la police nationale ou de la gendarmerie nationale "
                      "déclare solennellement servir avec dignité et loyauté la République… »",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Lors d’une cérémonie, le directeur de l’école nationale de police (ou son représentant) "
                "remet à l’élève policier adjoint le code de déontologie à l’issue de la prestation de serment.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Organisation (format PA)
          _ConditionCard(
            title: "I — L’organisation de la formation",
            cardColor: cardOrg,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La formation initiale des policiers adjoints est structurée autour d’un socle commun de 16 semaines, "
                "partagé avec les élèves gardiens de la paix.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Ces 16 semaines sont consacrées à l’étude des fondamentaux (institution policière, valeurs, bases juridiques, "
                "dimension humaine) et à des situations professionnelles (relation police/population, interpellation, VIF, "
                "sécurité routière), ainsi qu’à l’apprentissage des T.S.I., du secourisme et des outils numériques.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Socle initial (16 semaines) détaillé
          _ConditionCard(
            title: "Socle initial — 16 semaines",
            cardColor: cardPhases,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Axes pédagogiques"),
              _BulletPoint(text: "Institution policière & ses valeurs."),
              _BulletPoint(text: "Bases juridiques & dimension humaine."),
              _BulletPoint(
                text:
                    "Situations professionnelles : interpellation, VIF, sécurité routière, relation police/population.",
              ),
              _BulletPoint(
                text:
                    "Techniques de Sécurité et d’Intervention (T.S.I.) + secourisme.",
              ),
              _BulletPoint(
                text:
                    "Aptitude à l’usage du P.A. SIG SAUER + habilitation bâtons de police.",
              ),
              _BulletPoint(text: "Outils numériques."),
            ],
          ),

          const SizedBox(height: 14),

          // Fin des 16 semaines (affectation PA)
          _ConditionCard(
            title: "À l’issue des 16 semaines",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "À l’issue des 16 premières semaines, les policiers adjoints rejoignent leur service d’affectation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Évaluation (ce que tu as fourni)
          _ConditionCard(
            title: "II — L’évaluation (socle initial)",
            cardColor: cardEval,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pendant le socle initial, une évaluation de compétences est prévue en « acquis / non acquis » :",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Compétences numériques."),
              _BulletPoint(
                text: "TECR1 (Test d’Endurance Cardio-Respiratoire 1).",
              ),
              _BulletPoint(text: "Aptitude SIG."),
              _BulletPoint(text: "CEE1 (Contrôle Écrit École 1)."),
              _BulletPoint(text: "MCPN (Main Courante Police Nationale)."),
              _BulletPoint(text: "CES (Contrôle École de Simulation)."),
              SizedBox(height: 10),
              _Paragraph(
                "La validation de cinq compétences est nécessaire à l’acquisition de l’unité de valeur (commune aux deux publics).",
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
