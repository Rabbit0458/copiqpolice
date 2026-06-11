import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPpBraceletModalitesPlacementPage extends StatelessWidget {
  const PaPpBraceletModalitesPlacementPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_bracelet_modalites_placement';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

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
          'Surveillance électronique — Modalités',
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
            'CHAPITRE 2\nMODALITÉS DU PLACEMENT SOUS SURVEILLANCE ÉLECTRONIQUE',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              letterSpacing: .3,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          const _Paragraph(
            'Ce chapitre présente les conditions concrètes de mise en œuvre de la surveillance électronique, '
            'qu’il s’agisse d’un dispositif fixe lié à une assignation à résidence ou d’un dispositif mobile utilisé '
            'dans des hypothèses particulières (infractions graves, violences intrafamiliales, coopération pénale internationale).',
          ),

          const SizedBox(height: 16),

          // ====================== 2.1 PRINCIPE ==============================
          _ConditionCard(
            title: '2.1 — Principe de la surveillance électronique',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La surveillance électronique s’exerce conformément aux dispositions de ',
                ),
                TextSpan(
                  text: 'l’Article 723-8 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', qui prévoient la mise en place d’un procédé permettant de détecter à distance la présence '
                      'ou l’absence de la personne à son domicile ou dans le lieu d’assignation fixé par le juge.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Concrètement, la personne porte un bracelet ou un autre dispositif électronique relié à un système de contrôle, '
                'qui vérifie le respect des horaires et des lieux imposés par la décision judiciaire. Toute sortie non autorisée '
                'ou non-respect des plages horaires peut être immédiatement signalé à l’autorité judiciaire.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========== 2.2 ARSE AVEC SURVEILLANCE MOBILE ===================
          _ConditionCard(
            title:
                '2.2 — Assignation à résidence avec mise sous surveillance électronique mobile',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'Dans certains cas prévus par la loi, il peut être recouru à une surveillance électronique « mobile », '
                'permettant de suivre les déplacements de la personne au-delà de son domicile. Ce dispositif renforce le contrôle '
                'exercé sur les personnes particulièrement dangereuses ou impliquées dans des procédures sensibles.',
              ),

              SizedBox(height: 12),

              // ---------- 2.2.1 INFRACTIONS PUNIES DE +7 ANS ----------------
              _SubTitle(
                '2.2.1 — Infraction punie de plus de 7 ans et suivi socio-judiciaire',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque l’infraction ayant motivé la mise en examen est punie de plus de sept ans d’emprisonnement et que le suivi '
                      'socio-judiciaire est encouru, il peut être fait recours au procédé de surveillance mobile prévu par ',
                ),
                TextSpan(
                  text: 'l’Article 763-12 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. Dans cette hypothèse, le juge d’instruction exerce les prérogatives habituellement dévolues au juge de '
                      'l’application des peines pour ce qui concerne la mise en œuvre du dispositif.',
                ),
              ]),

              SizedBox(height: 12),

              // ---------- 2.2.2 VIOLENCES / MENACES INTRAFAMILIALES ----------
              _SubTitle(
                '2.2.2 — Violences ou menaces au sein du couple ou de la famille',
              ),
              _Paragraph(
                'L’assignation à résidence avec surveillance électronique mobile peut également être mise en œuvre lorsque la personne '
                'est mise en examen pour certaines violences ou menaces graves commises dans le cadre familial.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Les faits doivent être punis d’au moins cinq ans d’emprisonnement et être commis :',
              ),
              SizedBox(height: 4),
              _BulletPoint(text: 'contre son conjoint ou son concubin ;'),
              _BulletPoint(
                text:
                    'contre son partenaire lié par un pacte civil de solidarité (PACS) ;',
              ),
              _BulletPoint(
                text:
                    'contre ses enfants ou ceux de son conjoint, de son concubin ou de son partenaire.',
              ),
              SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(text: 'Ce dispositif spécifique est prévu par '),
                TextSpan(
                  text: 'l’Article 142-12-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' et s’inscrit dans le renforcement de la lutte contre les violences intrafamiliales.',
                ),
              ]),

              SizedBox(height: 12),

              // ---------- 2.2.3 COOPÉRATION PÉNALE INTERNATIONALE ----------
              _SubTitle(
                '2.2.3 — Demandes d’extradition et coopérations pénales internationales',
              ),
              _Paragraph(
                'La surveillance électronique mobile peut enfin être utilisée lorsque la personne fait l’objet d’une procédure '
                'de remise ou de coopération pénale internationale. Elle permet alors de garantir la disponibilité de l’intéressé '
                'sans recourir systématiquement à la détention provisoire.',
              ),
              SizedBox(height: 8),

              // Demande d'extradition
              _BulletPoint(
                text: 'dans le cadre d’une demande d’extradition ;',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Le fondement juridique est alors donné par ',
                ),
                TextSpan(
                  text: 'l’Article 696-11 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),

              // Mandat d'arrêt européen
              _BulletPoint(
                text: 'pour l’exécution d’un mandat d’arrêt européen ;',
              ),
              _Paragraph.rich([
                TextSpan(text: 'La mesure est prévue par '),
                TextSpan(
                  text: 'l’Article 695-28 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),

              // Demande CPI
              _BulletPoint(
                text:
                    'lorsqu’il existe une demande d’arrestation provisoire aux fins de remise à la Cour pénale internationale ;',
              ),
              _Paragraph.rich([
                TextSpan(text: 'Ce cas de figure est visé par '),
                TextSpan(
                  text: 'l’Article 627-5 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),

              // Demande d'arrestation provisoire d'un État étranger
              _BulletPoint(
                text:
                    'ou encore dans le cadre d’une demande d’arrestation provisoire présentée par un État étranger ;',
              ),
              _Paragraph.rich([
                TextSpan(text: 'dans ce cas, le texte applicable est '),
                TextSpan(
                  text: 'l’Article 696-23 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'La surveillance électronique mobile demeure une mesure fortement attentatoire à la liberté d’aller et venir. '
                        'Elle ne doit être mise en œuvre que lorsque les nécessités de la procédure et la gravité des faits le justifient, '
                        'et lorsqu’aucune autre mesure moins restrictive (contrôle judiciaire simple, ARSE fixe) n’apparaît suffisante.',
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
