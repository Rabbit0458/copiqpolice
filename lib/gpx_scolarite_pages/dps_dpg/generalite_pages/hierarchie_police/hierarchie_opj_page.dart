import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — HIÉRARCHIE : OFFICIERS DE POLICE JUDICIAIRE (OPJ)
///
///  Structure identique à ta page CompliciteConditionPage :
/*
    - Intro générale
    - A. Qualité d'officier de police judiciaire
    - B. Conditions d'exercice
    - C. Modes de désignation (1. De plein droit / 2. Avec habilitation)
    - Encadrés NOTA + explications juridiques
*/
/// ===================================================================
class HierarchieOpjPage extends StatelessWidget {
  const HierarchieOpjPage({super.key});

  static const String routeName = '/gpx/generalites/hierarchie/opj';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.90);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: 'Retour',
        ),
        title: Text(
          'Officiers de police judiciaire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            'Les officiers de police judiciaire (OPJ)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
          _Paragraph.rich([
            const TextSpan(
              text:
                  'La police judiciaire est exercée sous la direction du procureur de la République, conformément à l’article 12 du Code de Procédure Pénale. ',
            ),
            const TextSpan(
              text:
                  'Elle est placée sous la surveillance du procureur général et le contrôle de la chambre de l’instruction, selon l’article 13 du Code de Procédure Pénale. ',
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph(
            'Pour exercer les missions de police judiciaire, les personnels de la police nationale doivent recevoir la qualification suivante : officier de police judiciaire, agent de police judiciaire ou agent de police judiciaire adjoint.',
          ),
          const SizedBox(height: 14),

          const _IntroBullet(
            text:
                'Les officiers de police judiciaire disposent de pouvoirs d’enquête renforcés.',
          ),
          const _IntroBullet(
            text:
                'Ils sont strictement encadrés par le Code de Procédure Pénale et par l’habilitation délivrée par le procureur général.',
          ),
          const SizedBox(height: 18),

          // =======================================================
          // A. QUALITÉ D’OPJ
          // =======================================================
          _ConditionCard(
            title: 'A. Qualité d’officier de police judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’article 16 du Code de Procédure Pénale énumère les personnes ayant la qualité d’officier de police judiciaire.',
              ),
              SizedBox(height: 10),

              _SubTitle('Personnes ayant la qualité d’OPJ'),
              _BulletPoint(text: 'Les maires et leurs adjoints.'),
              _BulletPoint(
                text:
                    'Les officiers et gradés de la gendarmerie ainsi que les gendarmes désignés par arrêtés ministériels après avis conforme d’une commission.',
              ),
              _BulletPoint(
                text:
                    'Les inspecteurs généraux, sous-directeurs de police active, contrôleurs généraux, commissaires de police et officiers de police.',
              ),
              _BulletPoint(
                text:
                    'Les fonctionnaires du corps d’encadrement et d’application de la police nationale, désignés par arrêtés des ministres de la justice et de l’intérieur après avis conforme d’une commission.',
              ),
              _BulletPoint(
                text:
                    'Les directeurs et sous-directeurs de la police judiciaire et de la gendarmerie.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // B. CONDITIONS D’EXERCICE
          // =======================================================
          _ConditionCard(
            title: 'B. Conditions d’exercice de la qualité d’OPJ',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Même s’ils possèdent la qualité d’officier de police judiciaire, les personnels ne peuvent exercer les pouvoirs attachés à cette fonction que s’ils remplissent des conditions cumulatives strictes.',
              ),
              SizedBox(height: 12),

              _BulletPoint(
                text:
                    'Être affecté à un emploi comportant l’exercice de la police judiciaire.',
              ),
              _BulletPoint(
                text:
                    'Avoir reçu une habilitation personnelle du procureur général.',
              ),
              _BulletPoint(
                text:
                    'Ne pas participer, en unité constituée, à une opération de maintien de l’ordre.',
              ),

              SizedBox(height: 14),

              _NotaBox(
                title: 'Important',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les fonctionnaires du corps d’encadrement et d’application ne peuvent recevoir l’habilitation que s’ils sont affectés dans un service déterminé par l’autorité judiciaire.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // C. MODES DE DÉSIGNATION
          // =======================================================
          _ConditionCard(
            title: 'C. Modes de désignation',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _SubTitle('1. De plein droit'),
              _Paragraph(
                'Les maires, les adjoints au maire, ainsi que les directeurs et sous-directeurs de la police judiciaire et de la gendarmerie exercent automatiquement les fonctions d’officier de police judiciaire, sans habilitation préalable.',
              ),
              SizedBox(height: 12),

              _SubTitle('2. Avec habilitation'),
              _Paragraph(
                'Pour les autres personnels, l’exercice effectif des attributions d’officier de police judiciaire nécessite une habilitation individuelle délivrée par le procureur général territorialement compétent.',
              ),
              SizedBox(height: 8),

              _BulletPoint(
                text:
                    'Sont concernés : gendarmes (à l’exception des directeurs et sous-directeurs), inspecteurs généraux, commissaires, officiers de police, ainsi que les fonctionnaires du corps de commandement et d’encadrement.',
              ),
              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'La première habilitation reste valable pour toute la durée des fonctions, même en cas de changement d’affectation, à condition que le fonctionnaire continue à travailler dans un service de police judiciaire.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // NOTE FINALE
          // =======================================================
          const _NotaBox(
            title: 'À noter',
            bodySpans: [
              TextSpan(
                text:
                    'Certains réservistes opérationnels peuvent conserver la qualité d’officier de police judiciaire conformément aux articles 16-1 A et R. 15-2-1 à R. 15-6-6 du Code de Procédure Pénale.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================================
//  Rappel : Les widgets utilisés (_Paragraph, _ConditionCard, etc.)
//  sont IDENTIQUES à ceux de ta page Complicité — réutilise-les.
// ======================================================================

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE CONDITION (A / B / C)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO (les 3 conditions au début)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE (dans les sections B et C)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withOpacity(.95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
