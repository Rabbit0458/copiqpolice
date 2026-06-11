import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPControleMissionPJInspectionGeneraleJusticePage extends StatelessWidget {
  const PaPPControleMissionPJInspectionGeneraleJusticePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_controle_mission_pj_inspection_generale_justice';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF0D47A1); // bleu foncé
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);
    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspection générale de la justice',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================== TITRE PRINCIPAL =======================
              Text(
                'Chapitre 2 – Le rôle de l’Inspection\ngénérale de la justice',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  height: 1.15,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 8),

              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’Inspection générale de la justice intervient comme acteur clé du contrôle '
                      'de la police judiciaire lorsqu’il s’agit d’enquêtes administratives portant sur le comportement '
                      'd’un officier ou d’un agent de police judiciaire. ',
                ),
                TextSpan(
                  text: 'L’Article 15-2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' dispose que ces enquêtes administratives associent l’Inspection générale de la justice au service d’enquête compétent.',
                ),
              ]),
              const SizedBox(height: 10),

              const _IntroBullet(
                text:
                    'Renforcement du contrôle de l’autorité judiciaire sur la police judiciaire.',
              ),
              const _IntroBullet(
                text:
                    'Association systématique de l’Inspection générale de la justice aux enquêtes administratives sensibles.',
              ),
              const _IntroBullet(
                text:
                    'Objectif : garantir le respect des règles déontologiques et des libertés individuelles lors des missions de police judiciaire.',
              ),

              const SizedBox(height: 20),

              // ==================== 2.1 CONDITIONS D'APPLICATION ============
              _ConditionCard(
                title: '2.1 Les conditions d’application',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'La procédure prévue par l’Article 15-2 du Code de Procédure Pénale vise à renforcer le contrôle '
                          'de l’autorité judiciaire sur la police judiciaire. Elle ne peut être mise en œuvre que si trois conditions sont réunies :',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        'La procédure ne concerne que les enquêtes administratives (et non les procédures pénales stricto sensu).',
                  ),
                  _BulletPoint(
                    text:
                        'Elle n’est applicable qu’aux officiers de police judiciaire (O.P.J.) et aux agents de police judiciaire (A.P.J.) : '
                        'les agents seulement chargés de certaines fonctions de police judiciaire ne sont pas visés.',
                  ),
                  _BulletPoint(
                    text:
                        'L’enquête administrative doit se rapporter à un comportement individuel pouvant révéler un manquement, '
                        'par exemple au regard des règles déontologiques ou de l’exécution d’une mission de police judiciaire au sens de l’Article 14 du Code de Procédure Pénale.',
                  ),
                  SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'L’objectif est de vérifier si le comportement de l’officier ou de l’agent est compatible avec les exigences de probité, '
                            'de loyauté, de respect des droits fondamentaux et des règles procédurales attachées à la police judiciaire.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ==================== 2.2 PROCÉDURE ===========================
              _ConditionCard(
                title: '2.2 La procédure d’enquête administrative',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’enquête administrative peut être déclenchée selon plusieurs modalités, suivant l’autorité à l’initiative du contrôle :',
                    ),
                  ]),
                  SizedBox(height: 10),

                  _SubTitle(
                    'Enquête ordonnée par le ministre dont relève l’O.P.J. ou l’A.P.J.',
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Lorsque le ministre dont dépend l’officier ou l’agent de police judiciaire ordonne une enquête administrative, '
                          'l’Inspection générale de la justice est saisie par une lettre de mission du garde des Sceaux, ministre de la Justice. '
                          'Dans ce cas, elle participe de façon directe aux investigations menées par le service d’enquête compétent.',
                    ),
                  ]),
                  SizedBox(height: 8),

                  _SubTitle(
                    'Enquête ordonnée conjointement par le ministre compétent et le garde des Sceaux',
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’enquête peut également être ordonnée par une lettre de mission conjointe du ministre dont relève l’O.P.J. ou l’A.P.J. et du garde des Sceaux. '
                          'Dans cette configuration, le service d’enquête compétent est saisi et l’Inspection générale de la justice assure la codirection de l’enquête. '
                          'Elle partage ainsi la conduite des investigations avec le service administratif ou d’inspection concerné.',
                    ),
                  ]),
                  SizedBox(height: 10),

                  _SubTitle(
                    'Signalement des situations et retour d’information',
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Toute situation imposant la mise en œuvre d’une enquête administrative doit faire l’objet d’un signalement détaillé. '
                          'Ce signalement prend la forme d’un rapport adressé à la direction des affaires criminelles et des grâces. '
                          'Ce canal de transmission permet au garde des Sceaux de suivre les dossiers sensibles et d’envisager d’éventuelles suites disciplinaires ou pénales.',
                    ),
                  ]),
                  SizedBox(height: 10),

                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En retour, le garde des Sceaux communique aux procureurs généraux, par l’intermédiaire de la direction des affaires criminelles et des grâces, '
                          'les éléments de l’enquête qui font apparaître des comportements pénalement qualifiables ou susceptibles de justifier la mise en œuvre de sanctions. '
                          'Ces éléments peuvent notamment conduire à l’exercice des pouvoirs disciplinaires prévus au dernier alinéa de ',
                    ),
                    TextSpan(
                      text: 'l’Article 16 du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ou à la saisine de la chambre de l’instruction sur le fondement des ',
                    ),
                    TextSpan(
                      text:
                          'Articles 224 et suivants du Code de Procédure Pénale',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ', lorsque la gravité des faits le justifie.',
                    ),
                  ]),
                  SizedBox(height: 12),

                  _NotaBox(
                    title: 'Articulation disciplinaire et pénale',
                    bodySpans: [
                      TextSpan(
                        text:
                            'L’enquête administrative conduite avec l’Inspection générale de la justice ne se substitue pas à la procédure pénale. '
                            'Elle peut cependant révéler des infractions, conduire à l’engagement de poursuites pénales, à la saisine de la chambre de l’instruction, '
                            'ou à des mesures disciplinaires (avertissement, suspension, retrait d’habilitation, mutation, etc.). '
                            'Le contrôle exercé vise à garantir l’exemplarité des officiers et agents de police judiciaire et à préserver la confiance du public dans l’institution judiciaire.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
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
