import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonnesFuiteIntroGpxSchool extends StatelessWidget {
  const PersonnesFuiteIntroGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/recherche_personnes_fuite/intro';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF111218)
        : const Color(0xFFFDFDFE);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Recherche des personnes en fuite',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                'La recherche des personnes en fuite\n(Article 74-2 du Code de procédure pénale)',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Créé par la loi n°2004-204 du 9 mars 2004 portant adaptation '
                'aux évolutions de la criminalité, le dispositif de recherche des '
                'personnes en fuite permet de poursuivre efficacement une personne '
                'qui tente d’échapper à l’exécution d’une décision judiciaire.',
              ),
              const SizedBox(height: 10),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’Article 74-2 du Code de procédure pénale est ainsi rédigé : ',
                  style: TextStyle(color: Colors.red),
                ),
              ]),

              const SizedBox(height: 18),
              _ConditionCard(
                title:
                    '1 – Les hypothèses dans lesquelles la personne est dite « en fuite »',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Les officiers de police judiciaire, assistés le cas échéant des '
                    'agents de police judiciaire, peuvent, sur instructions du procureur '
                    'de la République, procéder aux actes prévus par les articles 56 à 62 '
                    'afin de rechercher et de découvrir une personne en fuite dans les cas '
                    'suivants :',
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        '1° Personne faisant l’objet d’un mandat d’arrêt délivré par le '
                        'juge d’instruction, le juge des libertés et de la détention, la '
                        'chambre de l’instruction ou son président, ou le président de la '
                        'cour d’assises, alors qu’elle est renvoyée devant une juridiction '
                        'de jugement ;',
                  ),
                  _BulletPoint(
                    text:
                        '2° Personne faisant l’objet d’un mandat d’arrêt délivré par une '
                        'juridiction de jugement ou par le juge de l’application des peines ;',
                  ),
                  _BulletPoint(
                    text:
                        '3° Personne condamnée à une peine privative de liberté sans sursis '
                        'supérieure ou égale à un an, ou à une peine privative de liberté '
                        'supérieure ou égale à un an résultant de la révocation d’un sursis '
                        'assorti ou non d’une probation, lorsque cette condamnation est '
                        'exécutoire ou passée en force de chose jugée ;',
                  ),
                  _BulletPoint(
                    text:
                        '4° Personne inscrite au fichier judiciaire national automatisé des '
                        'auteurs d’infractions terroristes ayant manqué aux obligations '
                        'prévues à l’Article 706-25-7 du Code de procédure pénale ;',
                  ),
                  _BulletPoint(
                    text:
                        '5° Personne inscrite au fichier judiciaire national automatisé des '
                        'auteurs d’infractions sexuelles ou violentes ayant manqué aux '
                        'obligations prévues à l’Article 706-53-5 du Code de procédure '
                        'pénale ;',
                  ),
                  _BulletPoint(
                    text:
                        '6° Personne ayant fait l’objet d’une décision de retrait ou de '
                        'révocation d’un aménagement de peine ou d’une libération sous '
                        'contrainte, ou d’une décision de mise à exécution de '
                        'l’emprisonnement prévu par la juridiction de jugement en cas de '
                        'violation des obligations ou interdictions résultant d’une peine, '
                        'lorsque cette décision a pour conséquence la mise à exécution '
                        'd’un quantum ou d’un reliquat de peine d’emprisonnement '
                        'supérieur à un an.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title:
                    '2 – Interceptions de télécommunications pour retrouver la personne en fuite',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Lorsque les nécessités de l’enquête pour rechercher la personne '
                          'en fuite l’exigent, le juge des libertés et de la détention du '
                          'tribunal de grande instance peut, à la requête du procureur de la '
                          'République, autoriser l’interception, l’enregistrement et la '
                          'transcription de correspondances émises par la voie des '
                          'télécommunications, selon les modalités prévues par les Articles '
                          '100, 100-1 et 100-3 à 100-7 du Code de procédure pénale, pour '
                          'une durée maximale de deux mois, renouvelable dans les mêmes '
                          'conditions de forme et de durée, dans la limite de six mois en '
                          'matière correctionnelle. Ces opérations sont réalisées sous '
                          'l’autorité et le contrôle du juge des libertés et de la détention.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph('Concrètement :'),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'le procureur de la République saisit le juge des libertés et de la '
                        'détention pour mettre en place les écoutes nécessaires à la '
                        'localisation de la personne en fuite ;',
                  ),
                  _BulletPoint(
                    text:
                        'les interceptions sont strictement limitées dans le temps et '
                        'renouvelables seulement dans les conditions prévues par la loi ;',
                  ),
                  _BulletPoint(
                    text:
                        'toute la mesure reste sous le contrôle du juge des libertés et de '
                        'la détention, qui vérifie la légalité des actes.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title:
                    '3 – Rôle du procureur de la République et de l’officier de police judiciaire',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Pour l’application des dispositions des Articles 100-3 à 100-5 du '
                          'Code de procédure pénale, les attributions normalement confiées '
                          'au juge d’instruction ou à l’officier de police judiciaire, commis '
                          'par lui, sont exercées par le procureur de la République ou par '
                          'l’officier de police judiciaire requis par ce magistrat. Le juge des '
                          'libertés et de la détention est informé sans délai des actes '
                          'accomplis en application de ces dispositions.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph('En pratique :'),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text:
                        'le procureur de la République dirige les opérations de recherche '
                        'de la personne en fuite ;',
                  ),
                  _IntroBullet(
                    text:
                        'l’officier de police judiciaire exécute les actes d’enquête (perquisitions, '
                        'interceptions, surveillances) sur instructions du procureur ;',
                  ),
                  _IntroBullet(
                    text:
                        'le juge des libertés et de la détention reste le garant du respect '
                        'des libertés individuelles.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '4 – Techniques spéciales d’enquête mobilisables',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Si les nécessités de l’enquête pour rechercher la personne en '
                          'fuite l’exigent, les sections 1, 2 et 4 à 6 du chapitre II du titre '
                          'XXV du livre IV du Code de procédure pénale sont applicables '
                          'lorsque la personne concernée a fait l’objet de l’une des '
                          'décisions mentionnées aux 1° à 3° et 6° du présent article pour '
                          'l’une des infractions mentionnées aux Articles 706-73 et '
                          '706-73-1 du Code de procédure pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph(
                    'Autrement dit, lorsque la personne en fuite est impliquée dans des '
                    'faits de criminalité organisée, les techniques spéciales d’enquête '
                    '(interceptions, sonorisations, IMSI-catcher, etc.) peuvent être '
                    'mobilisées pour la localiser et l’interpeller, sous contrôle du juge '
                    'des libertés et de la détention.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '5 – Portée du dispositif',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’Article 74-2 du Code de procédure pénale crée ainsi un cadre '
                          'juridique spécifique permettant de rechercher de manière '
                          'effective une personne faisant l’objet d’un mandat d’arrêt après '
                          'la clôture de l’information.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Ce cadre permet de prolonger l’action de la justice au-delà de la '
                    'phase d’instruction, lorsque la personne tente d’échapper à '
                    'l’exécution des décisions la concernant.',
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours '
                        'vérifier les références actualisées du Code de procédure pénale '
                        '(Article 74-2 et Articles 706-73 et 706-73-1 notamment) avant de '
                        'mettre en œuvre une procédure de recherche de personne en fuite.',
                  ),
                ],
              ),
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
