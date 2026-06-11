import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPpAssignationResidenceConditionsPage extends StatelessWidget {
  const PaPpAssignationResidenceConditionsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_assignation_residence_conditions';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    const Color articleRed = Color(0xFFD32F2F);

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
          "ARSE — Conditions de mise en œuvre",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "L’assignation à résidence avec surveillance électronique (ARSE)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              letterSpacing: .2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'La loi n° 2009-1436 du 24 novembre 2009 a instauré l’assignation à résidence avec surveillance électronique (ARSE). '
                  'Cette mesure peut être prononcée à l’encontre d’une personne mise en examen lorsque les obligations du contrôle '
                  'judiciaire apparaissent insuffisantes pour garantir le bon déroulement de la procédure.',
            ),
          ]),

          const SizedBox(height: 14),

          _ConditionCard(
            title:
                'Chapitre 1 — Conditions de mise en œuvre de l’assignation à résidence',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              // 1.1 DEFINITION
              _SubTitle('1.1 — Définition'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’assignation à résidence avec surveillance électronique est une mesure de contrainte permettant de maintenir en liberté '
                      'une personne mise en examen tout en la soumettant à des obligations très strictes quant à ses déplacements. '
                      'Elle s’inscrit dans l’échelle des mesures alternatives à la détention provisoire et est prévue par ',
                ),
                TextSpan(
                  text: 'l’Article 137 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. Elle peut être décidée lorsque le simple contrôle judiciaire ne suffit plus.',
                ),
              ]),

              SizedBox(height: 10),

              // 1.1.1 Conditions de mise en œuvre
              _SubTitle('1.1.1 — Conditions de mise en œuvre'),
              _Paragraph.rich([
                TextSpan(text: 'Selon '),
                TextSpan(
                  text: 'l’Article 142-5 alinéa 1 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', l’assignation à résidence avec surveillance électronique n’est possible que si la personne encourt '
                      'une peine d’emprisonnement correctionnel d’au moins deux ans ou une peine plus grave. '
                      'Elle est donc exclue pour les infractions ne comportant pas un tel niveau de peine.',
                ),
              ]),

              SizedBox(height: 10),

              // 1.1.2 Prononcé de la mesure
              _SubTitle('1.1.2 — Prononcé de la mesure'),
              _Paragraph(
                'L’assignation à résidence avec surveillance électronique peut être ordonnée :',
              ),
              SizedBox(height: 4),
              _BulletPoint(text: 'par le juge d’instruction ;'),
              _BulletPoint(
                text: 'par le juge des libertés et de la détention ;',
              ),
              _BulletPoint(
                text:
                    'par toute autre juridiction disposant du pouvoir de prononcer cette mesure (y compris en l’absence de demande de la personne et sans recueil préalable de son accord).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'La personne placée sous ARSE doit être informée que l’installation du dispositif de surveillance ne peut être effectuée sans son consentement. '
                'Elle doit également être avisée que le refus de cette installation peut conduire à son placement en détention provisoire.',
              ),

              SizedBox(height: 14),

              // 1.2 OBJET DE LA MESURE
              _SubTitle('1.2 — Objet de la mesure'),
              _Paragraph(
                'L’assignation à résidence avec surveillance électronique consiste essentiellement à obliger la personne à demeurer à son domicile '
                'ou dans une résidence déterminée. Elle ne peut s’absenter de ce lieu qu’aux conditions et pour les motifs précisément fixés par le juge '
                '(activité professionnelle, soins, obligations familiales, convocations judiciaires, etc.).',
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La mesure peut être complétée par une ou plusieurs des obligations et interdictions prévues pour le contrôle judiciaire, '
                      'notamment celles énumérées aux ',
                ),
                TextSpan(
                  text: 'Articles 138 et 138-3 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' (interdiction de paraître dans certains lieux, d’entrer en relation avec certaines personnes, obligation de soins, etc.).',
                ),
              ]),

              SizedBox(height: 14),

              // 1.3 VERIFICATION FAISABILITE
              _SubTitle(
                '1.3 — Vérification de la faisabilité de la mesure',
              ),
              _Paragraph(
                'Avant de statuer sur la mise en place d’une ARSE, le juge doit s’assurer de sa faisabilité technique et matérielle.',
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge statue après avoir fait vérifier la faisabilité de la mesure par le service pénitentiaire d’insertion et de probation (SPIP), '
                      'qui apprécie notamment :',
                ),
              ]),
              SizedBox(height: 4),
              _BulletPoint(
                text: 'la configuration du domicile ou du lieu d’assignation ;',
              ),
              _BulletPoint(
                text:
                    'les possibilités techniques de pose et de fonctionnement du dispositif électronique ;',
              ),
              _BulletPoint(
                text:
                    'les conditions de vie de la personne et de son entourage (présence d’enfants, activité professionnelle, etc.).',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque la peine encourue est égale ou supérieure à trois ans et que la vérification n’a pu être réalisée ou achevée, '
                      'le juge des libertés et de la détention peut ordonner un placement conditionnel sous ARSE. Il décide alors de '
                      'l’incarcération provisoire de la personne mise en examen pour une durée maximale de quinze jours, le temps que '
                      'l’assignation puisse être mise en œuvre, et saisit immédiatement le SPIP aux fins d’un rapport sur la faisabilité de la mesure. '
                      'Ce mécanisme résulte de ',
                ),
                TextSpan(
                  text: 'l’Article 142-6-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' et de '),
                TextSpan(
                  text: 'l’Article D 32-4-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'L’assignation à résidence avec surveillance électronique constitue une mesure intermédiaire entre le contrôle '
                        'judiciaire et la détention provisoire. Elle doit être préférée à l’incarcération chaque fois que sa mise en œuvre '
                        'permet d’atteindre les objectifs de la procédure (garantir la représentation de la personne, prévenir la réitération '
                        'des infractions, protéger les victimes) tout en respectant davantage la liberté individuelle.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
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
