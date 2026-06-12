import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaReleveIdentiteGpxSchool extends StatelessWidget {
  const PaReleveIdentiteGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre2';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F5F5);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color articleColor = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFC62828);

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
          'Chapitre 2 — Relevé d’identité',
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
          // ===================== TITRE & INTRO ============================
          Text(
            'Le relevé d’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rôle du relevé d’identité, agents habilités, infractions concernées et articulation avec le contrôle '
            'et la vérification d’identité.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title: 'Chapitre 2 — Le relevé d’identité',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              // ===================== EN-TÊTE CHAPITRE ====================
              const _SubTitle('Fondement juridique'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le relevé d’identité trouve son fondement dans les dispositions de ',
                ),
                TextSpan(
                  text: 'l’article 78-6 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Ce texte permet aux volontaires servant en qualité de militaire dans la gendarmerie et aux '
                      'militaires de la réserve opérationnelle de la gendarmerie (',
                ),
                TextSpan(
                  text: 'article 21, 1° bis du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '), aux policiers adjoints et aux membres de la réserve opérationnelle de la police nationale (',
                ),
                TextSpan(
                  text: 'article 21, 1° ter du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '), aux contrôleurs des administrations parisiennes exerçant leurs fonctions dans la spécialité '
                      'voie publique et aux agents de surveillance de Paris (',
                ),
                TextSpan(
                  text: 'article 21, 1° quater du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text: ') ainsi qu’aux agents de police municipale (',
                ),
                TextSpan(
                  text: 'article 21, 2° du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ') de relever l’identité des contrevenants pour dresser les procès-verbaux de certaines '
                      'contraventions.',
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle('Infractions concernées'),
              const _Paragraph(
                'Le relevé d’identité peut être effectué à l’encontre des contrevenants aux arrêtés de police du maire, '
                'aux dispositions du code de la route dont la liste est fixée par décret en Conseil d’État, ou encore '
                'en vertu d’une disposition législative expresse (par exemple en matière de publicité, d’enseignes et '
                'de pré-enseignes, article L. 581-40 du code de l’environnement).',
              ),
              const SizedBox(height: 12),

              const _SubTitle('Nature du relevé d’identité'),
              const _Paragraph(
                'Le relevé d’identité d’une personne est une opération de nature judiciaire : une infraction doit avoir '
                'été préalablement commise pour pouvoir y procéder. Il s’agit d’une procédure intermédiaire entre le '
                'recueil d’identité et le contrôle d’identité.',
              ),
              const SizedBox(height: 8),

              const _Paragraph(
                'Le recueil d’identité permet de demander l’identité à un contrevenant sans pouvoir exiger de celui-ci '
                'un document justificatif. Dans ce cas, l’agent verbalisateur se fonde sur la bonne foi du contrevenant, '
                'sauf à requérir l’assistance d’un agent de police judiciaire ou d’un officier de police judiciaire.',
              ),
              const SizedBox(height: 12),

              const _SubTitle('Pouvoirs des agents de police judiciaire adjoints'),
              const _Paragraph(
                'Les agents de police judiciaire adjoints précités peuvent, quant à eux, exiger du contrevenant la '
                'présentation d’une pièce d’identité afin d’en relever les mentions. Le plus souvent, le relevé d’identité '
                's’effectue au moyen des pièces administratives relatives à la conduite et à la circulation des véhicules.',
              ),
              const SizedBox(height: 12),

              const _SubTitle('Refus ou impossibilité de justifier de son identité'),
              const _Paragraph(
                'En cas de refus ou d’impossibilité pour le contrevenant de justifier de son identité, l’agent de police '
                'judiciaire adjoint en rend compte à l’officier de police judiciaire territorialement compétent, qui peut '
                'ordonner que la personne lui soit immédiatement présentée aux fins de vérification d’identité ou de '
                'retenir celle-ci pendant le temps nécessaire à son arrivée ou à celle d’un agent de police judiciaire '
                'agissant sous son contrôle. À défaut d’un tel ordre, l’agent de police judiciaire adjoint ne peut retenir '
                'le contrevenant.',
              ),
              const SizedBox(height: 8),

              const _Paragraph(
                'Pendant le temps nécessaire à l’information et à la décision de l’officier de police judiciaire, l’agent de '
                'police judiciaire adjoint peut maintenir le contrevenant sur place et faire usage de la coercition si ce '
                'dernier refuse. La violation de cette obligation est punie de deux mois d’emprisonnement et de 7 500 euros '
                'd’amende. La rétention sur la voie publique ne doit pas excéder le temps rigoureusement nécessaire pour '
                'joindre l’officier de police judiciaire et recueillir ses instructions.',
              ),
              const SizedBox(height: 12),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Outre les agents de police judiciaire adjoints précités, le législateur a autorisé, pour certains '
                        'domaines de réglementation particuliers, d’autres agents de contrôle à relever l’identité des '
                        'contrevenants. ',
                  ),
                  TextSpan(
                    text:
                        'Ainsi, les agents de l’exploitant d’un service public de transports terrestres',
                  ),
                  TextSpan(
                    text:
                        ' (SNCF, RATP, etc.) sont habilités par l’article L. 2241-2 du code des transports, dans les '
                        'conditions prévues par l’article 529-4 du code de procédure pénale, à relever l’identité et '
                        'l’adresse des contrevenants, lorsque plusieurs conditions sont réunies :',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    'Ils ont été agréés par le procureur de la République et assermentés.',
              ),
              const _BulletPoint(
                text:
                    'Le relevé concerne des contraventions des quatre premières classes à la police des services publics '
                    'de transports terrestres pouvant donner lieu à transaction, ou la contravention prévue à l’article '
                    'R. 625-8-3 du code pénal (outrage sexiste et sexuel).',
              ),
              const _BulletPoint(
                text:
                    'Ils n’ont pas reçu immédiatement paiement entre leurs mains.',
              ),
              const SizedBox(height: 10),

              const _Paragraph(
                'Si le contrevenant refuse ou se déclare dans l’impossibilité de justifier de son identité, ces agents '
                'avisent sans délai un officier de police judiciaire. Ils peuvent garder à disposition la personne auteur '
                'de l’infraction, qui fait alors l’objet d’une rétention jusqu’à l’arrivée sur place de l’officier de police '
                'judiciaire ou de l’agent de police judiciaire agissant sous son contrôle. L’officier de police judiciaire '
                'peut également demander à ce que la personne soit conduite devant lui.',
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
