// lib/gpx_scolarite_pages/cadres_juridiques/entraide_judiciaire_contenu_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EurojustPage extends StatelessWidget {
  const EurojustPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/eurojust';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.82);

    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Retour',
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Agence Eurojust',
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
          // =================================================================
          // EN-TÊTE GENERAL
          // =================================================================
          Text(
            'L’entraide judiciaire internationale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chapitre 1 — La coopération pénale policière',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),
          const _Paragraph(
            'C’est par le biais des conventions internationales que se développe la '
            'coopération policière internationale, comme les accords de 1989 et 1991 '
            'entre la France et le Royaume-Uni ou encore les accords de Schengen entre '
            'certains États de l’Union européenne. Cette coopération consiste soit en '
            'l’échange de renseignements (Interpol, Europol), soit en la recherche de '
            'renseignements sur le territoire d’un autre État, par exemple dans le cadre '
            'de la Convention de Vienne de 1988 contre le trafic de stupéfiants.',
          ),
          const SizedBox(height: 16),

          // =================================================================
          // 1.1  L’AGENCE EUROJUST
          // =================================================================
          const _SubTitle('1.1 — L’Agence Eurojust'),
          const SizedBox(height: 4),

          _Paragraph.rich([
            const TextSpan(text: 'Les '),
            TextSpan(
              text: 'Articles 695-4 à 695-7 du Code de procédure pénale',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w800,
              ),
            ),
            const TextSpan(
              text:
                  ' définissent la nature, la mission et les compétences de l’Agence Eurojust.',
            ),
          ]),
          const SizedBox(height: 6),
          const _Paragraph(
            'L’Agence Eurojust est un organe de l’Union européenne chargé de favoriser '
            'et de renforcer la coopération judiciaire entre les États membres en matière '
            'pénale.',
          ),
          const SizedBox(height: 14),

          // =================================================================
          // 1.1.1  LES MISSIONS
          // =================================================================
          const _SubTitle('1.1.1 — Les missions'),
          const SizedBox(height: 8),

          // 1.1.1.1  En tant que collège ou par l’intermédiaire du membre national
          _ConditionCard(
            title:
                '1.1.1.1 — En tant que collège ou par l’intermédiaire du membre national',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'L’Agence Eurojust est chargée de promouvoir et d’améliorer la coordination '
                'et la coopération entre les autorités compétentes des États membres de '
                'l’Union européenne dans toutes les enquêtes et poursuites relevant de sa '
                'compétence.',
              ),
              SizedBox(height: 10),
              _Paragraph('L’Agence peut notamment :'),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Informer le procureur général des infractions dont elle a connaissance '
                    'et lui demander de faire procéder à une enquête ou de faire engager des poursuites ;',
              ),
              _BulletPoint(
                text:
                    'Demander au procureur général de dénoncer ou de faire dénoncer des infractions '
                    'aux autorités compétentes d’un autre État membre de l’Union européenne ;',
              ),
              _BulletPoint(
                text:
                    'Demander au procureur général de faire mettre en place une équipe commune d’enquête ;',
              ),
              _BulletPoint(
                text:
                    'Demander au procureur général ou au juge d’instruction de lui communiquer les '
                    'informations issues de procédures judiciaires qui sont nécessaires à '
                    'l’accomplissement de ses tâches ;',
              ),
              _BulletPoint(
                text:
                    'Agissant par l’intermédiaire du membre national, demander en outre au procureur '
                    'général de faire prendre toute mesure d’investigation particulière ou toute '
                    'autre mesure justifiée par les investigations ou les poursuites.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1.1.1.2  Avec l’accord des États membres concernés
          _ConditionCard(
            title: '1.1.1.2 — Avec l’accord des États membres concernés',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Avec l’accord des États membres concernés, l’Agence Eurojust peut également :',
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Coordonner l’exécution des demandes d’entraide judiciaire émises par un État '
                    'non membre de l’Union européenne lorsque ces demandes se rattachent à des '
                    'investigations portant sur les mêmes faits et doivent être exécutées dans '
                    'au moins deux États membres ;',
              ),
              _BulletPoint(
                text:
                    'Faciliter l’exécution des demandes d’entraide judiciaire devant être exécutées '
                    'dans un État non membre de l’Union européenne lorsqu’elles se rattachent à '
                    'des investigations portant sur les mêmes faits et émanent d’au moins deux '
                    'États membres.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1.1.1.3  Agissant en tant que collège
          _ConditionCard(
            title: '1.1.1.3 — Agissant en tant que collège',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Agissant en tant que collège, l’Agence Eurojust peut adresser au procureur général '
                'ou au juge d’instruction un avis écrit et motivé sur :',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'La manière de résoudre un conflit de compétences entre autorités judiciaires ;',
              ),
              _BulletPoint(
                text:
                    'Les difficultés ou refus récurrents rencontrés dans l’exécution de demandes '
                    'présentées ou de décisions prises en matière de coopération judiciaire, '
                    'notamment lorsque ces instruments reposent sur le principe de reconnaissance mutuelle.',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1.1.1.4  En cas d’urgence
          const _NotaBox(
            title: 'En cas d’urgence',
            bodySpans: [
              TextSpan(
                text:
                    'Une demande de coopération peut être adressée au dispositif permanent de '
                    'coordination d’Eurojust, afin d’assurer une réponse rapide et coordonnée '
                    'entre les autorités concernées.',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // =================================================================
          // 1.1.2  LE MEMBRE NATIONAL D’EUROJUST
          // =================================================================
          _SubTitle('1.1.2 — Le membre national d’Eurojust'),
          const SizedBox(height: 4),
          _Paragraph.rich([
            const TextSpan(
              text: 'Le membre national d’Eurojust est régi par les ',
            ),
            TextSpan(
              text: 'Articles 695-8 à 695-9 du Code de procédure pénale',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
            const TextSpan(text: '.'),
          ]),
          const SizedBox(height: 10),

          _ConditionCard(
            title: 'Statut et mandat du membre national',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Le membre national est un magistrat hors hiérarchie qui peut recevoir des '
                'instructions du ministre de la Justice. La durée de son mandat est de cinq ans, '
                'renouvelable une fois.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          _ConditionCard(
            title: 'Compétences et pouvoirs du membre national',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              const _BulletPoint(
                text:
                    'Il a accès, dans les mêmes conditions que les magistrats du ministère public, '
                    'à l’ensemble des informations contenues dans les traitements de données à '
                    'caractère personnel pertinents (casier judiciaire, fichiers de police, etc.).',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text: 'Une obligation d’information est instaurée par l’',
                ),
                TextSpan(
                  text: 'article 695-8-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Il est ainsi informé par le procureur général, le procureur de la République '
                      'ou le juge d’instruction des investigations ou procédures en cours ainsi que '
                      'des condamnations relatives à des affaires susceptibles d’entrer dans le champ '
                      'de compétence d’Eurojust ayant donné lieu à des demandes de coopération à au '
                      'moins deux États membres et :',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text: 'Portant sur certaines infractions listées ;',
              ),
              const _BulletPoint(
                text:
                    'Faisant apparaître l’implication d’une organisation criminelle ;',
              ),
              const _BulletPoint(
                text:
                    'Portant sur des faits susceptibles d’affecter gravement l’Union européenne.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Il est également informé des procédures et condamnations relatives aux infractions '
                    'terroristes, à l’exception de celles qui ne concernent manifestement pas les autres États.',
              ),
              const _BulletPoint(
                text:
                    'L’information porte aussi sur la mise en place d’équipes communes d’enquête ainsi '
                    'que sur la mise en œuvre de mesures de surveillance de l’acheminement ou du transport '
                    'd’objets, de biens ou de produits tirés de la commission d’infractions lorsque au moins '
                    'trois États sont concernés.',
              ),
              const _BulletPoint(
                text:
                    'Il est avisé des conflits de compétences avec un autre État membre ainsi que des '
                    'difficultés ou refus d’exécution de demandes.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'L’obligation d’information est écartée lorsque la communication serait de nature '
                        'à porter atteinte à la sécurité de la Nation, à compromettre la sécurité d’une '
                        'personne ou, pour les infractions terroristes, à compromettre une enquête en cours.',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    'Il reçoit et transmet au procureur général les informations relatives aux enquêtes '
                    'de l’Office européen de lutte antifraude dont il est destinataire.',
              ),
              const _BulletPoint(
                text:
                    'En sa qualité d’autorité nationale compétente, il est habilité à recevoir les demandes '
                    'de coopération judiciaire et à les transmettre. Il en assure le suivi et en facilite '
                    'l’exécution.',
              ),
              const _BulletPoint(
                text:
                    'En cas d’exécution partielle ou insuffisante par les autorités nationales, il peut '
                    'demander la mise en œuvre de mesures complémentaires.',
              ),
              const _BulletPoint(
                text:
                    'Il peut participer, en tant que représentant d’Eurojust, à la mise en place et au '
                    'fonctionnement des équipes communes d’enquête.',
              ),
              const _BulletPoint(
                text:
                    'Il peut enfin proposer au procureur général ou au procureur de la République de '
                    'procéder à certains actes ou de requérir qu’il y soit procédé.',
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
