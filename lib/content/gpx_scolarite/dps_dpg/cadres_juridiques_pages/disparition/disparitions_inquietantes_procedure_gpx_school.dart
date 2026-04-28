import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisparitionInquietanteProcedureGpxSchool extends StatelessWidget {
  const DisparitionInquietanteProcedureGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/disparitions_inquietantes/chapitre2';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF303030)
        : const Color(0xFFF3F4F6);
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF374151).withOpacity(.88);

    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFFFFFFF);
    final Color accent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
        title: Text(
          'Disparitions inquiétantes',
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
            'Chapitre 2 – Procédures des articles 74-1 et 80-4 du code de procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 19,
              height: 1.25,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Autorités compétentes et actes d’enquête mis en œuvre dans le cadre spécifique '
            'des disparitions inquiétantes (articles 74-1 et 80-4 du code de procédure pénale).',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.4,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= 2.1 - AUTORITÉS =========================
          _ConditionCard(
            title: '2.1 – Les autorités habilitées',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle('2.1.1 – Les magistrats'),
              const _SubTitle('2.1.1.1 – Le procureur de la République'),
              const _Paragraph(
                'Aux termes de l’article 74-1 alinéa 1 du code de procédure pénale, ce cadre '
                'spécifique d’enquête ne peut être mis en œuvre que sur instructions du '
                'procureur de la République. Ce magistrat doit donc être avisé de la '
                'disparition dès que les enquêteurs estiment nécessaire de recourir aux '
                'dispositions prévues par les articles 74-1 ou 80-4 du code de procédure pénale.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Une fois avisé par l’officier de police judiciaire ou l’agent de police '
                'judiciaire, le procureur de la République peut :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Décider de ne pas ouvrir l’une des procédures judiciaires de l’article 74-1 '
                    'et privilégier la procédure administrative de recherches prévue par '
                    'l’article 26 de la loi n° 95-73 du 21 janvier 1995.',
              ),
              const _BulletPoint(
                text:
                    'Ordonner la poursuite des investigations dans le cadre de l’article 74-1 '
                    'du code de procédure pénale.',
              ),
              const _BulletPoint(
                text:
                    'Demander la poursuite des investigations dans les formes de l’enquête '
                    'préliminaire, par exemple en l’absence de caractère flagrant de la '
                    'disparition ou lorsque les recherches menées au titre de l’article 74-1 '
                    'n’ont pas abouti dans les huit jours.',
              ),
              const _BulletPoint(
                text:
                    'Requérir l’ouverture d’une information pour recherche des causes de la '
                    'disparition.',
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: 'NOTA',
                bodySpans: const [
                  TextSpan(
                    text:
                        'Lors de l’enlèvement avéré d’un mineur, le procureur de la République, '
                        'sur le ressort duquel a eu lieu l’enlèvement, apprécie l’opportunité de '
                        'déclencher le plan d’alerte de la population « ALERTE ENLÈVEMENT », '
                        'conformément aux circulaires et notes ministérielles en vigueur.',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const _SubTitle('2.1.1.2 – Le juge d’instruction'),
              const _Paragraph(
                'L’ouverture d’une information est prévue par l’article 74-1 alinéa 2 du code '
                'de procédure pénale : le procureur de la République peut requérir l’ouverture '
                'd’une information pour recherche des causes de la disparition.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le deuxième alinéa de l’article 80-4 du code de procédure pénale prévoit que '
                'les membres de la famille ou les proches de la personne disparue peuvent se '
                'constituer partie civile à titre incident. Ils ne peuvent pas, en revanche, '
                'provoquer directement l’ouverture d’une information pour recherche des '
                'causes de la disparition, qui reste une prérogative exclusive du procureur de '
                'la République. En cas d’inaction du parquet, la famille peut toutefois déposer '
                'plainte avec constitution de partie civile en invoquant la commission d’une '
                'infraction.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’information ouverte dans le cadre des articles 74-1 et 80-4 du code de '
                'procédure pénale est dite exorbitante du droit commun car :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Elle a pour seul objet la recherche des causes de la disparition, le juge '
                    'd’instruction n’étant pas saisi de l’ensemble des faits.',
              ),
              const _BulletPoint(
                text:
                    'Elle ne met pas, à ce stade, en mouvement l’action publique.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le juge d’instruction dispose de tous les pouvoirs de l’instruction '
                'préparatoire (article 80-4 du code de procédure pénale). Les interceptions de '
                'correspondances émises par voie de télécommunications ne peuvent toutefois '
                'excéder une durée de deux mois renouvelable.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Il peut, par commission rogatoire, déléguer un officier de police judiciaire '
                'pour la recherche des causes de la disparition.',
              ),
              const SizedBox(height: 14),

              const _SubTitle(
                '2.1.2 – L’officier ou l’agent de police judiciaire',
              ),
              const _Paragraph(
                'Lorsque la disparition d’une personne est portée à sa connaissance, '
                'l’officier de police judiciaire, ou l’agent de police judiciaire agissant sous '
                'son contrôle, doit apprécier le caractère inquiétant de la disparition. Si les '
                'conditions sont réunies pour appliquer les articles 74-1 ou 80-4 du code de '
                'procédure pénale, il avise le procureur de la République, qui décide de '
                'l’opportunité d’organiser les recherches dans un cadre juridique ou '
                'administratif.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’officier de police judiciaire ou l’agent, agissant sous son contrôle, peut se '
                'voir déléguer les pouvoirs visant à déterminer les causes de la disparition. '
                'L’officier de police judiciaire peut également se voir déléguer les pouvoirs du '
                'juge d’instruction par commission rogatoire.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ========================= 2.2 - ACTES D'ENQUÊTE ===================
          _ConditionCard(
            title: '2.2 – Les actes de l’enquête',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle(
                '2.2.1 – Les actes délégués par le procureur de la République',
              ),
              const _SubTitle(
                '2.2.1.1 – Les actes prévus par les articles 56 à 62 du code de procédure pénale',
              ),
              const _Paragraph(
                'Les officiers de police judiciaire ou les agents de police judiciaire, agissant '
                'sous leur contrôle, peuvent procéder, chacun dans la limite de ses '
                'prérogatives, à tous les actes de l’enquête de flagrance prévus aux articles 56 '
                'à 62 du code de procédure pénale. Il s’agit notamment :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Des perquisitions (y compris sans l’accord de l’intéressé) et des saisies.',
              ),
              const _BulletPoint(
                text:
                    'Des réquisitions diverses et des interdictions de s’éloigner des lieux.',
              ),
              const _BulletPoint(
                text: 'Des convocations, comparutions forcées et auditions.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Dans ce cadre, aucune mesure de garde à vue ne peut être prise, car il n’existe '
                'pas encore de suspicion suffisamment caractérisée de crime ou de délit.',
              ),
              const SizedBox(height: 10),
              const _SubTitle('2.2.1.2 – La poursuite des investigations'),
              const _Paragraph(
                'Après l’expiration du délai de huit jours suivant les instructions du procureur '
                'de la République, les investigations peuvent se poursuivre, sans limitation de '
                'durée, dans les formes de l’enquête préliminaire (article 75 du code de '
                'procédure pénale).',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Il en va de même lorsque l’enquête est ouverte un certain temps après la '
                'disparition, alors que le caractère flagrant de celle-ci n’est plus constitué.',
              ),
              const SizedBox(height: 16),

              const _SubTitle(
                '2.2.2 – Les actes délégués par le juge d’instruction',
              ),
              const _Paragraph(
                'Dans le cadre d’une information judiciaire pour recherche des causes de la '
                'disparition (article 80-4 du code de procédure pénale), le juge d’instruction '
                'peut charger l’officier de police judiciaire, par commission rogatoire, '
                'd’exécuter les actes nécessaires à la recherche des causes de la disparition.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’officier de police judiciaire peut alors réaliser des constatations, saisies et '
                'scellés, réquisitions, auditions et perquisitions. Sous l’autorité et le contrôle '
                'du juge d’instruction, les interceptions de correspondances émises par voie '
                'de télécommunications peuvent être réalisées pour une durée maximale de '
                'deux mois renouvelable.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Le placement en garde à vue est possible à l’encontre des personnes contre '
                'lesquelles il existe une ou plusieurs raisons plausibles de soupçonner qu’elles '
                'ont commis une infraction. Ce placement peut ensuite justifier la délivrance '
                'd’un réquisitoire introductif ouvrant une information relative à l’infraction '
                'ainsi découverte, permettant, le cas échéant, des mises en examen et des '
                'placements en détention provisoire.',
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                'Dans ce contexte, les officiers de police judiciaire, sous le contrôle du juge '
                'd’instruction, peuvent notamment :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Au cours d’une perquisition, accéder à des données informatiques stockées '
                    'sur des serveurs distants (articles 97-1 et 57-1 alinéa 1 du code de '
                    'procédure pénale).',
              ),
              const _BulletPoint(
                text:
                    'Requérir toute personne susceptible d’avoir connaissance des mesures '
                    'appliquées pour protéger ces données, ou susceptible de remettre des '
                    'informations permettant d’y accéder (articles 97-1 et 57-1 alinéa 5 du code '
                    'de procédure pénale).',
              ),
              const _BulletPoint(
                text:
                    'Requérir les opérateurs de télécommunications afin de prendre, sans délai, '
                    'toutes mesures propres à assurer la préservation du contenu des '
                    'informations consultées par les utilisateurs de leurs services '
                    '(articles 99-4 et 60-2 alinéa 2 du code de procédure pénale).',
              ),
              const _BulletPoint(
                text:
                    'Procéder à des réquisitions pour l’installation d’un dispositif d’interception '
                    'des communications électroniques et pour la transcription des '
                    'correspondances utiles à la manifestation de la vérité '
                    '(articles 100-3 à 100-5 du code de procédure pénale).',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Dans le cadre des interceptions de correspondances émises par la voie des '
                'communications électroniques, les assistants d’enquête peuvent, à la demande '
                'expresse et sous le contrôle de l’officier de police judiciaire commis par le '
                'juge d’instruction, procéder à la transcription de la correspondance utile à la '
                'manifestation de la vérité (article 100-5 du code de procédure pénale).',
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
