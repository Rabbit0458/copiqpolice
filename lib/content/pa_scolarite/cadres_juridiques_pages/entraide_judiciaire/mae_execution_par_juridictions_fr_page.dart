import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMaeExecutionParJuridictionsFrPage extends StatelessWidget {
  const PaMaeExecutionParJuridictionsFrPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/mae_execution_par_juridictions_fr';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    Color lawRed() => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Retour',
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'MAE — Exécution par les juridictions françaises',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===============================================================
          // EN-TÊTE GÉNÉRAL
          // ===============================================================
          Text(
            'Le mandat d’arrêt européen',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '2.4 — Exécution d’un mandat d’arrêt européen par les juridictions françaises',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'L’exécution, en France, d’un mandat d’arrêt européen émis par une autorité '
            'judiciaire étrangère obéit à des règles précises : modalités de diffusion, '
            'conditions d’interpellation et de présentation devant le procureur général, '
            'rôle de la chambre de l’instruction, motifs de refus d’exécution et organisation '
            'de la remise de la personne recherchée.',
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.1  DIFFUSION & TRANSMISSION
          // ===============================================================
          const _SubTitle('2.4.1 — Diffusion et transmission du mandat'),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Acheminement du mandat d’arrêt européen vers la France',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _BulletPoint(
                text:
                    'Lorsque l’autorité étrangère connaît l’endroit où la personne recherchée se '
                    'trouve sur le territoire français, elle peut adresser directement le mandat '
                    'au procureur général territorialement compétent. Elle peut également en '
                    'organiser la diffusion.',
              ),
              _BulletPoint(
                text:
                    'Lorsque l’autorité judiciaire étrangère ne connaît pas l’endroit où se trouve '
                    'la personne recherchée, elle procède à la diffusion du signalement dans les '
                    'systèmes appropriés (Système d’information Schengen, INTERPOL).',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.2  MODALITÉS D’EXÉCUTION
          // ===============================================================
          const _SubTitle('2.4.2 — Modalités d’exécution du mandat'),
          const SizedBox(height: 4),

          _ConditionCard(
            title:
                'Interpellation, présentation au procureur général et droits de la personne',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’agent chargé de l’exécution du mandat d’arrêt européen ne peut pénétrer dans '
                      'le domicile d’un citoyen que dans la plage horaire prévue par ',
                ),
                TextSpan(
                  text: 'l’article 134 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' (entre 6 heures et 21 heures).'),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La personne recherchée et appréhendée doit être conduite devant le procureur '
                      'général du lieu d’arrestation dans les 48 heures. Pendant ce délai, elle '
                      'bénéficie des droits prévus par ',
                ),
                TextSpan(
                  text: 'les articles 63-1 à 63-7 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text: ' relatifs à la garde à vue, en application de ',
                ),
                TextSpan(
                  text: 'l’article 695-27 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'La rétention de la personne sur le fondement du mandat d’arrêt européen n’a pas '
                'la même finalité qu’une mesure de garde à vue : la personne n’est pas entendue '
                'sur les faits. Les enquêteurs l’informent uniquement de ses droits et de '
                'l’existence du titre de recherche. L’article 695-27 du Code de Procédure Pénale '
                'lui confère toutefois les mêmes droits que ceux reconnus à une personne gardée à vue.',
              ),
              const SizedBox(height: 8),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En pratique, le droit à l’assistance d’un avocat au cours des auditions a '
                        'peu vocation à s’appliquer, la personne n’étant pas interrogée sur les faits '
                        'mais uniquement sur son identité avant la notification du titre de recherche '
                        '(circulaire CRIM 11-14/E8 du 31 mai 2011).',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                'Le procureur général vérifie l’identité de la personne, l’informe de l’existence '
                'et du contenu du mandat d’arrêt européen, de son droit d’être assistée d’un avocat, '
                'de la faculté qu’elle a de consentir ou de s’opposer à sa remise à l’autorité '
                'judiciaire étrangère, ainsi que des conséquences juridiques liées à ce consentement.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'S’il décide de ne pas laisser la personne en liberté, le procureur général la présente '
                'au premier président de la cour d’appel ou au magistrat du siège désigné par lui. '
                'Ce magistrat peut ordonner l’incarcération de la personne, à moins qu’il n’estime '
                'que sa représentation à tous les actes de la procédure est suffisamment garantie. '
                'La chambre de l’instruction est immédiatement saisie et la personne recherchée doit '
                'lui être présentée dans les cinq jours de sa présentation au procureur général.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 2.4.2.1 et 2.4.2.2
          _ConditionCard(
            title: '2.4.2.1 — La personne consent à sa remise',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'La chambre de l’instruction informe la personne recherchée des conséquences '
                'juridiques de son consentement et de son caractère irrévocable. Il lui est également '
                'demandé si elle renonce au principe de spécialité (limitation des poursuites aux faits '
                'visés par le mandat).',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Si la chambre de l’instruction constate que les conditions légales d’exécution du mandat '
                'sont réunies, elle rend un arrêt accordant la remise. Elle statue dans un délai de sept '
                'jours à compter de la comparution de la personne devant elle.',
              ),
            ],
          ),
          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.4.2.2 — La personne ne consent pas à sa remise',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Lorsque la personne ne consent pas à sa remise, la chambre de l’instruction statue '
                'par décision motivée dans un délai de vingt jours à compter de sa comparution. '
                'Ce délai impose une instruction rapide du dossier et un examen précis des motifs '
                'éventuels de refus d’exécution du mandat.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.3  MOTIFS DE REFUS
          // ===============================================================
          const _SubTitle(
            '2.4.3 — Motifs de refus d’exécution d’un mandat d’arrêt européen',
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: '2.4.3.1 — Les motifs de refus obligatoires',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _BulletPoint(
                text:
                    'Les faits auraient pu être poursuivis par les juridictions françaises et l’action '
                    'publique est éteinte par l’amnistie ;',
              ),
              _BulletPoint(
                text:
                    'La personne recherchée a déjà fait l’objet d’une décision définitive en France ou '
                    'dans un État membre pour les mêmes faits que ceux visés par le mandat d’arrêt, '
                    'à condition que la peine ait été exécutée ou soit en cours d’exécution ;',
              ),
              _BulletPoint(
                text:
                    'La personne recherchée était âgée de moins de 13 ans au moment des faits ;',
              ),
              _BulletPoint(
                text:
                    'Le mandat a été émis dans le but de poursuivre ou de condamner une personne en '
                    'raison de son sexe, de sa race, de sa religion, de son origine ethnique, de sa '
                    'nationalité, de sa langue, de ses opinions politiques, de son orientation sexuelle '
                    'ou de son identité sexuelle.',
              ),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: '2.4.3.2 — Les motifs de refus facultatif',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              const _BulletPoint(
                text:
                    'Les faits, qui ne relèvent pas des catégories d’infractions mentionnées à '
                    'l’article 694-32 du Code de Procédure Pénale, ne constituent pas une infraction '
                    'en droit français, conformément à ',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text: 'ce principe de double incrimination rappelé par ',
                ),
                TextSpan(
                  text: 'l’article 695-23 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les faits objet du mandat d’arrêt européen font déjà l’objet de poursuites devant '
                    'une juridiction française ou cette juridiction a décidé de ne pas engager les poursuites '
                    'ou d’y mettre fin ;',
              ),
              const _BulletPoint(
                text:
                    'La personne recherchée pour l’exécution d’une peine est de nationalité française et '
                    'les autorités françaises s’engagent à faire procéder à l’exécution de cette peine en France ;',
              ),
              const _BulletPoint(
                text:
                    'Les faits pour lesquels le mandat a été émis ont été commis, en tout ou partie, '
                    'sur le territoire français.',
              ),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title:
                '2.4.3.3 — Autre motif de refus facultatif : jugement rendu en l’absence de l’intéressé',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’exécution du mandat d’arrêt européen peut également être refusée lorsque le jugement '
                      'a été rendu en l’absence de la personne recherchée. ',
                ),
                TextSpan(
                  text: 'L’article 695-22-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      ' définit toutefois les situations dans lesquelles ce motif de refus ne peut pas '
                      'être opposé.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Il s’agit notamment des hypothèses suivantes :',
              ),
              const SizedBox(height: 6),
              const _IntroBullet(
                text:
                    'la personne a été informée officiellement et de manière non équivoque, en temps utile, '
                    'par citation ou par tout autre moyen, de la date et du lieu du procès ainsi que de la '
                    'possibilité qu’une décision soit rendue en son absence en cas de non-comparution ;',
              ),
              const _IntroBullet(
                text:
                    'ayant eu connaissance de la date et du lieu du procès, elle a été effectivement '
                    'défendue pendant celui-ci par un conseil ;',
              ),
              const _IntroBullet(
                text:
                    'ayant reçu signification de la décision et ayant été informée de son droit de former '
                    'un recours, elle a indiqué expressément ne pas contester la décision initiale ou n’a '
                    'pas exercé de recours dans le délai imparti ;',
              ),
              const _IntroBullet(
                text:
                    'la décision, qui n’a pas encore été notifiée, doit l’être dès la remise de la personne, '
                    'avec information explicite sur la possibilité d’exercer un recours.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.4  REMISE DE LA PERSONNE RECHERCHÉE
          // ===============================================================
          const _SubTitle('2.4.4 — Remise de la personne recherchée'),
          const SizedBox(height: 4),

          _ConditionCard(
            title:
                'Décision de la chambre de l’instruction et organisation pratique de la remise',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'La chambre de l’instruction statue par arrêt motivé. Sa décision peut consister en une '
                      'remise, un refus de remise ou une remise assortie de conditions particulières. Lorsque '
                      'la décision devient définitive, l’arrêt est notifié à la personne réclamée puis transmis '
                      'sans délai à l’autorité étrangère par le procureur général. ',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le procureur général prend ensuite les mesures nécessaires pour organiser matériellement '
                      'la remise. Celle-ci doit intervenir dans les dix jours suivant la date de la décision '
                      'définitive de la chambre de l’instruction, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 695-37 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Si la personne réclamée est en liberté au moment où la décision autorisant la remise est '
                'prononcée, elle peut être arrêtée et placée sous écrou en vue de l’organisation de sa remise.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'La remise peut être différée pour des raisons humanitaires sérieuses (état de santé, '
                'situation familiale particulière, etc.) ou lorsque la personne recherchée fait déjà '
                'l’objet de poursuites en France ou doit y purger une peine pour un autre fait que celui '
                'visé par le mandat d’arrêt européen.',
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
