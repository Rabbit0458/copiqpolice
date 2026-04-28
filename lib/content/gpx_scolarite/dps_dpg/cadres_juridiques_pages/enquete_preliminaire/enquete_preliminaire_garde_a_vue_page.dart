import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnquetePrelimGardeAVuePage extends StatelessWidget {
  const EnquetePrelimGardeAVuePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/enquete_preliminaire/actes/garde_a_vue';

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
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    // Couleur spécifique pour les articles de loi
    final Color lawColor = isDark
        ? const Color(0xFF90CAF9)
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
          'La garde à vue',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------- TITRE GLOBAL ----------------
          Text(
            'La garde à vue en enquête préliminaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // ---------------- INTRO -----------------------
          _Paragraph.rich([
            TextSpan(text: 'L’'),
            TextSpan(
              text: 'article 77 du Code de procédure pénale',
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text:
                  ' se rapporte à la garde à vue au cours de l’enquête préliminaire. '
                  'Il précise que les dispositions relatives à la garde à vue prévues aux ',
            ),
            TextSpan(
              text: 'articles 62-2 à 64-1 du Code de procédure pénale',
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text: ' sont applicables à la phase d’enquête préliminaire.',
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph(
            'Une personne peut être placée en garde à vue lorsqu’il existe à son encontre '
            'une ou plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté '
            'de commettre un crime ou un délit puni d’une peine d’emprisonnement, '
            'et uniquement si cette mesure constitue le seul moyen de parvenir à l’un '
            'des six objectifs légaux de la garde à vue.',
          ),
          const SizedBox(height: 6),

          _Paragraph.rich([
            const TextSpan(text: 'Ces objectifs sont définis par l’'),
            TextSpan(
              text: 'article 62-2 du Code de procédure pénale',
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text:
                  ' (préservation des preuves, prévention des pressions sur les témoins, '
                  'empêchement d’une concertation frauduleuse, protection de la personne, '
                  'garantie de sa présentation devant le magistrat, etc.).',
            ),
          ]),

          const SizedBox(height: 22),

          // =====================================================
          // A. CONDITIONS DE PLACEMENT EN GARDE À VUE
          // =====================================================
          _ConditionCard(
            title: 'A. Conditions de placement en garde à vue',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                'Le placement en garde à vue en enquête préliminaire suppose donc :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Des raisons plausibles de soupçonner la commission ou la tentative '
                    'de commission d’un crime ou d’un délit puni d’emprisonnement ;',
              ),
              const _BulletPoint(
                text:
                    'La nécessité de la mesure pour atteindre l’un des objectifs fixés '
                    'par la loi (notamment la poursuite des investigations, la garantie de '
                    'la présentation de la personne devant le magistrat, la prévention '
                    'des pressions ou concertations).',
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        'En enquête préliminaire, la garde à vue conserve la même nature '
                        'coercitive qu’en enquête de flagrance. Elle doit toujours demeurer '
                        'strictement nécessaire et proportionnée à l’objectif recherché.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // B. LES DIFFÉRENTES HYPOTHÈSES DE MISE EN GARDE À VUE
          // =====================================================
          _ConditionCard(
            title: 'B. Les hypothèses de mise en garde à vue',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle(
                '1. Présentation volontaire au service de police ou de gendarmerie',
              ),
              const _Paragraph(
                'La personne peut se présenter librement (spontanément ou sur convocation) '
                'dans un service de police ou de gendarmerie. '
                'Si, au cours de son audition, apparaissent une ou plusieurs raisons '
                'plausibles de soupçonner qu’elle a commis ou tenté de commettre un crime '
                'ou un délit puni d’emprisonnement, l’officier de police judiciaire peut '
                'décider de son placement en garde à vue, à condition que cette mesure soit '
                'le seul moyen de parvenir à l’un des objectifs de l’article 62-2 du Code de '
                'procédure pénale. Le point de départ du délai maximal de 24 heures est alors '
                'l’heure du début de l’audition.',
              ),

              const SizedBox(height: 14),
              const _SubTitle(
                '2. Conduite sous l’effet d’un titre de contrainte ou d’une vérification d’identité',
              ),

              const _Paragraph(
                'La personne peut également être conduite dans les locaux de police '
                'en vertu d’un titre de contrainte (ordre de comparution délivré par le '
                'procureur de la République) ou à l’issue d’une rétention pour vérification '
                'd’identité.',
              ),
              const SizedBox(height: 8),

              const _IntroBullet(
                text:
                    'Titre de contrainte sans raison plausible initiale de soupçon :',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque la personne est contrainte à comparaître par la force publique, '
                      'sans qu’il n’existe initialement de raison plausible de la soupçonner, '
                      'et que, au cours de son audition, apparaissent une ou plusieurs raisons '
                      'plausibles de soupçonner qu’elle a commis ou tenté de commettre une infraction, '
                      'le placement en garde à vue devient possible. La notification de la mesure '
                      'doit alors intervenir immédiatement, le point de départ du délai de garde à vue '
                      'étant fixé au début de la contrainte. ',
                ),
                TextSpan(
                  text:
                      'Voir notamment l’article 78, alinéa 1 du Code de procédure pénale.',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              const _IntroBullet(
                text: 'Titre de contrainte sur une personne déjà soupçonnée :',
              ),
              const _Paragraph(
                'Lorsque des raisons plausibles de soupçonner la personne existent déjà au moment '
                'où elle est contrainte à comparaître, elle est placée en garde à vue dès son arrivée '
                'dans le service si l’officier de police judiciaire souhaite la maintenir à sa disposition '
                'et que l’un des six objectifs légaux est retenu.',
              ),
              const SizedBox(height: 10),

              const _IntroBullet(
                text: 'Rétention pour vérification d’identité :',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Si la personne a été retenue pour vérification d’identité et qu’à l’issue de cette '
                      'vérification il apparaît qu’une garde à vue doit être décidée, la durée de la rétention '
                      'aux fins de vérification d’identité s’impute sur la durée totale de la garde à vue. ',
                ),
                TextSpan(
                  text:
                      'Cette règle résulte de l’article 78-4 du Code de procédure pénale.',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),

              const SizedBox(height: 16),
              const _SubTitle(
                '3. Découverte d’indices au cours d’une perquisition',
              ),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lors d’une perquisition, une ou plusieurs raisons plausibles de soupçonner '
                      'qu’une personne a commis ou tenté de commettre une infraction peuvent apparaître '
                      'à l’égard d’une personne présente sur les lieux. Si les conditions prévues par l’',
                ),
                TextSpan(
                  text: 'article 62-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' sont réunies, cette personne peut alors être placée en garde à vue dans le cadre '
                      'de la procédure initiale ou d’une procédure incidente, y compris en enquête '
                      'préliminaire.',
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque la personne présente lors de la perquisition est un témoin retenu sur le '
                      'fondement de l’',
                ),
                TextSpan(
                  text: 'article 76, alinéa 3 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' (renvoyant à l’'),
                TextSpan(
                  text: 'article 56, alinéa 11 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '), des règles particulières s’appliquent : si une garde à vue devient nécessaire, '
                      'le temps de rétention lors de la perquisition est déduit de la durée de la garde à vue.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // C. DURÉE, PROLONGATION ET COMPÉTENCE
          // =====================================================
          _ConditionCard(
            title: 'C. Durée, prolongation et compétence du parquet',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'L’'),
                TextSpan(
                  text: 'article 63 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' fixe les conditions et la durée de la garde à vue. En enquête préliminaire, comme '
                      'en flagrance, la durée initiale maximale est de 24 heures, renouvelable une fois '
                      'pour 24 heures supplémentaires, sur décision du procureur de la République.',
                ),
              ]),
              const SizedBox(height: 8),

              const _Paragraph(
                'La prolongation doit intervenir avant l’expiration du premier délai de 24 heures. '
                'Il appartient aux magistrats d’apprécier, en fonction des circonstances de l’espèce, '
                's’il est opportun de présenter la personne avant de décider de la prolongation. '
                'Cette présentation peut, le cas échéant, être réalisée par visioconférence conformément '
                'à l’article 706-71 du Code de procédure pénale. La décision de prolongation n’a pas à '
                'être spécialement motivée.',
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En cas d’extension de compétence, le procureur de la République du lieu '
                      'd’exécution de la mesure peut ordonner la prolongation de la garde à vue en '
                      'application de l’',
                ),
                TextSpan(
                  text: 'article 63-9 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Toutefois, l’officier de police judiciaire doit préalablement référer au '
                      'procureur de la République directeur d’enquête pour justifier la nécessité de '
                      'prolonger la mesure.',
                ),
              ]),
              const SizedBox(height: 10),

              const _Paragraph(
                'À l’issue de la garde à vue, en enquête préliminaire comme en enquête de '
                'flagrance, lorsque des éléments suffisants existent à l’encontre des personnes '
                'gardées à vue pour envisager des poursuites, celles-ci sont soit remises en liberté, '
                'éventuellement avec une convocation ultérieure, soit déférées devant le procureur '
                'de la République.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // D. DROITS DE LA PERSONNE GARDÉE À VUE
          // =====================================================
          _ConditionCard(
            title: 'D. Droits de la personne gardée à vue',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'L’'),
                TextSpan(
                  text: 'article 77 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' renvoie expressément aux droits de la personne gardée à vue prévus '
                      'par plusieurs dispositions spécifiques du Code de procédure pénale :',
                ),
              ]),
              const SizedBox(height: 10),

              _BulletPoint(
                text:
                    'Droit d’être immédiatement informée de la nature de l’infraction et de ses droits '
                    '(information prévue par l’'
                    'article 63-1 du Code de procédure pénale'
                    ').',
              ),
              _BulletPoint(
                text:
                    'Droits prévus à l’'
                    'article 63-2 du Code de procédure pénale'
                    ' : faire prévenir une personne avec laquelle elle vit habituellement, '
                    'un parent en ligne directe, un frère ou une sœur ou toute autre personne qu’elle '
                    'désigne, ainsi que son employeur et, le cas échéant, les autorités consulaires de '
                    'son pays ; droit également de communiquer avec l’une de ces personnes.',
              ),
              _BulletPoint(
                text:
                    'Droit à un examen médical, prévu à l’'
                    'article 63-3 du Code de procédure pénale'
                    '.',
              ),
              _BulletPoint(
                text:
                    'Droit à l’assistance d’un avocat, en application de l’'
                    'article 63-3-1 du Code de procédure pénale'
                    '.',
              ),
              _BulletPoint(
                text:
                    'Respect des formalités prévues par l’'
                    'article 64 du Code de procédure pénale'
                    ' (procès-verbal de garde à vue) et par l’'
                    'article 64-1 du Code de procédure pénale'
                    ' (enregistrement audiovisuel des auditions en matière criminelle).',
              ),

              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'En matière de criminalité organisée, les régimes dérogatoires de garde à vue '
                        'prévus aux ',
                  ),
                  TextSpan(
                    text:
                        'articles 706-88 et suivants du Code de procédure pénale',
                    style: TextStyle(
                      color: lawColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' sont étudiés dans la partie consacrée à la délinquance et à la criminalité '
                        'organisées. Les dispositions spécifiques applicables aux mineurs (garde à vue, '
                        'retenue, défèrement) s’appliquent en enquête préliminaire dans les mêmes '
                        'conditions qu’en cas de flagrant délit.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
