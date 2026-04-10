import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPDeroulementDetentionProvisoirePage extends StatelessWidget {
  const PPDeroulementDetentionProvisoirePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_deroulement_detention_provisoire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

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
          'Déroulement de la détention provisoire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // ====================== CHAPITRE & TITRE ==========================
          Text(
            'CHAPITRE 2',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Déroulement de la détention provisoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Durée de la détention provisoire, contrôle par la chambre de '
            'l’instruction et prolongations de la mesure.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ====================== 2.1 – DURÉE ===============================
          const _SubTitle('2.1 – Durée de la détention provisoire'),

          const _Paragraph.rich([
            TextSpan(text: 'Selon '),
            TextSpan(
              text: 'l’article 144-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ', la détention provisoire ne peut excéder une durée raisonnable, '
                  'appréciée au regard de la gravité des faits reprochés à la '
                  'personne mise en examen et de la complexité des investigations '
                  'nécessaires à la manifestation de la vérité. Le magistrat doit '
                  'ordonner la mise en liberté dès que ces conditions et celles '
                  'prévues par ',
            ),
            TextSpan(
              text: 'l’article 144 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' ne sont plus remplies.'),
          ]),
          const SizedBox(height: 10),

          _ConditionCard(
            title: 'Durées maximales initiales de détention provisoire',
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark
                ? const Color(0xFFBBDEFB)
                : const Color(0xFF0D47A1),
            children: const [
              _Paragraph.rich([
                TextSpan(text: '• En matière correctionnelle : '),
                TextSpan(
                  text: 'l’article 145-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' fixe à quatre mois la durée maximale de la détention provisoire '
                      'pour un délit de droit commun.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: '• Pour certains délits aggravés : '),
                TextSpan(
                  text: 'l’article 145-1-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' permet une durée maximale initiale de six mois lorsque '
                      'l’instruction porte notamment sur un délit commis en bande '
                      'organisée puni de dix ans d’emprisonnement ou sur certains '
                      'délits particuliers tels que le trafic de stupéfiants '
                      '(art. 222-37 C. pén.), le proxénétisme (art. 225-5 C. pén.), '
                      'l’extorsion (art. 312-1 C. pén.) ou l’association de malfaiteurs '
                      '(art. 450-1 C. pén.).',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: '• En matière criminelle : '),
                TextSpan(
                  text: 'l’article 145-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit une durée maximale initiale d’un an de détention '
                      'provisoire.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 12),
          const _Paragraph(
            'À titre exceptionnel et sous les conditions fixées par les textes, ces '
            'durées peuvent être prolongées, notamment jusqu’à deux ans et quatre '
            'mois en matière correctionnelle et jusqu’à quatre ans et huit mois '
            'en matière criminelle. Le détail des rythmes et modalités de '
            'prolongation est présenté dans le tableau dédié.',
          ),

          const SizedBox(height: 22),

          // ====================== 2.2 – MISE EN ÉTAT =======================
          const _SubTitle('2.2 – Procédure de « mise en état »'),

          const _Paragraph.rich([
            TextSpan(text: 'La procédure de mise en état est organisée par '),
            TextSpan(
              text: 'l’article 221-3 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  '. Lorsque trois mois se sont écoulés depuis le placement en '
                  'détention provisoire, que cette détention est toujours en cours '
                  'et que l’avis de fin d’information prévu par ',
            ),
            TextSpan(
              text: 'l’article 175 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' n’a pas été délivré, le président de la chambre de l’instruction '
                  'peut décider de saisir cette chambre, d’office, à la demande du '
                  'ministère public ou de la personne mise en examen. La chambre '
                  'examine alors l’ensemble de la procédure.',
            ),
          ]),
          const SizedBox(height: 10),

          _ConditionCard(
            title:
                'Pouvoirs de la chambre de l’instruction\n(lors de la mise en état – art. 221-3 C. proc. pén.)',
            cardColor: isDark
                ? const Color(0xFF263238)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00796B),
            titleColor: isDark
                ? const Color(0xFFB2DFDB)
                : const Color(0xFF004D40),
            children: const [
              _IntroBullet(
                text:
                    'Ordonner la mise en liberté de la personne mise en examen, '
                    'assortie ou non d’un contrôle judiciaire.',
              ),
              _IntroBullet(
                text:
                    'Prononcer la nullité d’un ou de plusieurs actes de procédure.',
              ),
              _IntroBullet(
                text:
                    'Évoquer le dossier et procéder, le cas échéant, dans les '
                    'conditions prévues par les articles 201, 202, 204 et 205 '
                    'du Code de procédure pénale.',
              ),
              _IntroBullet(
                text:
                    'Procéder à une évocation partielle du dossier pour ne réaliser '
                    'que certains actes avant renvoi au juge d’instruction.',
              ),
              _IntroBullet(
                text:
                    'Renvoyer le dossier au juge d’instruction afin de poursuivre '
                    'l’information en lui prescrivant certains actes.',
              ),
              _IntroBullet(
                text:
                    'Désigner un ou plusieurs autres juges d’instruction pour '
                    'poursuivre la procédure.',
              ),
              _IntroBullet(
                text:
                    'Décider le dessaisissement du juge d’instruction lorsque cette '
                    'décision est indispensable à la manifestation de la vérité.',
              ),
              _IntroBullet(
                text:
                    'Ordonner le règlement, y compris partiel, de la procédure, '
                    'notamment en prononçant un ou plusieurs non-lieux.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ====================== 2.3 – PROLONGATION =======================
          const _SubTitle('2.3 – Prolongation de la détention provisoire'),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'La décision de prolonger une détention provisoire relève du juge '
                  'des libertés et de la détention, saisi à cette fin par une '
                  'ordonnance motivée du juge d’instruction, qui lui transmet le '
                  'dossier accompagné des réquisitions du procureur de la République, '
                  'conformément aux règles de ',
            ),
            TextSpan(
              text: 'l’article 145 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' et des articles suivants.'),
          ]),
          const SizedBox(height: 8),

          const _Paragraph(
            'Le juge des libertés et de la détention doit, à chaque prolongation, '
            'vérifier à nouveau la réunion des conditions légales de la détention '
            'provisoire, son caractère exceptionnel et l’insuffisance des mesures '
            'alternatives telles que le contrôle judiciaire ou l’assignation à '
            'résidence avec surveillance électronique.',
          ),
          const SizedBox(height: 10),

          const _NotaBox(
            title: 'Prolongations et tableau récapitulatif',
            bodySpans: [
              TextSpan(
                text:
                    'Les régimes de prolongation (délais, durée maximale, nombre de '
                    'prolongations, spécificités pour la criminalité organisée, les '
                    'délits punis de dix ans, etc.) sont détaillés dans le tableau '
                    'spécifique consacré à la détention provisoire. Il constitue un '
                    'outil de synthèse essentiel pour mémoriser les différents '
                    'cas de figure.',
              ),
            ],
          ),

          const SizedBox(height: 26),
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
