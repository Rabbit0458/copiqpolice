import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaVerificationIdentiteProcesVerbalGpxSchool extends StatelessWidget {
  const PaVerificationIdentiteProcesVerbalGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/pv_verification_identite';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF5F7FF);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

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
          'PV de vérification d’identité',
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
          // ===================== TITRE PRINCIPAL ===========================
          Text(
            '3.4 — Le procès-verbal de vérification',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Contenu obligatoire du procès-verbal de vérification d’identité, destination '
            'du document, interdiction de conserver des éléments d’identification en '
            'l’absence de poursuites et conséquences juridiques en cas de non-respect '
            'des prescriptions légales.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CARTE CONTENU =============================
          _ConditionCard(
            title: '3.4 — Le procès-verbal de vérification',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              // ---------- 3.4.1 Contenu du PV --------------------------------
              _SubTitle('Le contenu du procès-verbal'),
              _Paragraph(
                'Le procès-verbal de vérification d’identité n’est établi que lorsqu’une mesure '
                'de rétention a effectivement été prononcée, c’est-à-dire uniquement en cas '
                'd’exécution d’une vérification d’identité. Il répond à un formalisme proche de '
                'celui utilisé pour la garde à vue, même si les heures de rétention ne sont pas '
                'portées sur un registre spécial.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le procès-verbal est présenté à la signature de l’intéressé. En cas de refus '
                      'de signer, ce refus et les motifs invoqués doivent être mentionnés (',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 7, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Afin de permettre un contrôle sérieux par la personne concernée, son défenseur '
                'et le procureur de la République, le procès-verbal doit comporter un certain '
                'nombre de mentions obligatoires :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Les motifs précis justifiant le contrôle et la vérification, en démontrant de '
                    'façon concrète la légalité du contrôle initial et de la vérification d’identité.',
              ),
              _BulletPoint(
                text:
                    'Les conditions dans lesquelles la personne a été présentée devant l’officier '
                    'de police judiciaire, informée de ses droits et mise en mesure de les exercer, '
                    'ainsi que l’identification des personnes contactées par téléphone.',
              ),
              _BulletPoint(
                text:
                    'Le jour et l’heure à partir desquels le contrôle d’identité ou le relevé '
                    'd’identité a été effectué.',
              ),
              _BulletPoint(
                text:
                    'Le jour et l’heure de la fin de la rétention, ainsi que la durée totale de celle-ci.',
              ),
              _BulletPoint(
                text:
                    'Le recours éventuel à une prise d’empreintes digitales ou de photographies, '
                    'avec les raisons concrètes ayant justifié l’utilisation de ces moyens, en '
                    'précisant qu’il n’était pas possible d’établir l’identité autrement.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Cette motivation doit apparaître de manière claire dans le procès-verbal, '
                      'conformément à l’',
                ),
                TextSpan(
                  text: 'article 78-3, alinéa 6, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              SizedBox(height: 16),

              // ---------- 3.4.2 Destination du PV ----------------------------
              _SubTitle('La destination du procès-verbal'),
              _Paragraph(
                'Le procès-verbal de vérification d’identité est systématiquement transmis au '
                'procureur de la République. Une copie peut, dans certains cas, être remise à '
                'l’intéressé.',
              ),
              _Paragraph('Deux hypothèses doivent être distinguées :'),
              _IntroBullet(
                text:
                    'La vérification est suivie d’une procédure d’enquête ou d’exécution :',
              ),
              _Paragraph(
                'Lorsque la vérification d’identité aboutit à la constatation d’une infraction, à '
                'l’arrestation d’une personne faisant l’objet d’un mandat d’arrêt ou s’inscrit dans '
                'l’exécution d’une commission rogatoire, le procès-verbal est versé à la procédure. '
                'Il suit alors le sort du dossier pénal et aucune copie n’est remise à l’intéressé à '
                'ce stade.',
              ),
              _IntroBullet(
                text:
                    'La vérification n’est suivie d’aucune procédure d’enquête ou d’exécution :',
              ),
              _Paragraph(
                'Si la vérification d’identité ne débouche sur aucune enquête, ni sur aucune '
                'mesure d’exécution, l’original du procès-verbal est transmis au parquet et une '
                'copie est remise à la personne ayant fait l’objet de la rétention.',
              ),

              SizedBox(height: 16),

              // ---------- 3.4.3 Interdiction de mise en mémoire -------------
              _SubTitle(
                'L’interdiction de mettre en mémoire les éléments d’identification',
              ),
              _Paragraph(
                'Lorsque la vérification d’identité n’est suivie d’aucune enquête ni d’aucune '
                'mesure d’exécution, elle ne peut pas donner lieu à une mise en mémoire des '
                'éléments d’identification recueillis pendant la rétention.',
              ),
              _Paragraph(
                'Cette interdiction vise à empêcher que les contrôles d’identité ne soient '
                'détournés de leur finalité légale. Tout fichage, archivage ou conservation durable '
                'des données d’identification obtenues dans ce cadre est donc prohibé.',
              ),
              _Paragraph(
                'En conséquence, le procès-verbal et toutes les pièces relatives à la vérification '
                'doivent être détruits dans un délai de six mois, sous le contrôle du procureur de '
                'la République.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'L’ensemble des prescriptions prévues par l’article 78-3 du code de '
                        'procédure pénale (durée, mentions obligatoires, information de la '
                        'personne, contrôle du procureur, destruction des pièces en l’absence '
                        'de suites) est imposé à peine de nullité. En pratique, tout manquement '
                        'substantiel peut entraîner l’annulation de la procédure de vérification '
                        'd’identité et des actes subséquents.',
                  ),
                ],
                title: 'IMPORTANT',
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
}
