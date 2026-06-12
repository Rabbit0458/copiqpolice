import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPPlacementDetentionProvisoirePage extends StatelessWidget {
  const PaPPPlacementDetentionProvisoirePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_placement_detention_provisoire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

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
          'Placement en détention provisoire',
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
          // ====================== CHAPITRE & TITRE ==========================
          Text(
            'CHAPITRE 1',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Le placement en détention provisoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ==================== INTRO GÉNÉRALE ==============================
          const _Paragraph(
            'La détention provisoire est une mesure d’incarcération dans une maison '
            'd’arrêt, prise à l’égard d’une personne mise en examen avant tout '
            'jugement. Elle répond à certaines nécessités de l’instruction.',
          ),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Cette mesure est difficilement compatible avec le principe de la '
                  'présomption d’innocence : elle cause un préjudice grave à la '
                  'personne détenue, qui subit le choc de l’incarcération et la '
                  'réprobation de l’opinion publique pour laquelle la détention '
                  'provisoire est souvent perçue comme synonyme de culpabilité. '
                  'De ce fait, ',
            ),
            TextSpan(
              text: 'l’article 137 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' dispose que la détention provisoire doit être exceptionnelle.',
            ),
          ]),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(text: 'La détention provisoire est régie par les '),
            TextSpan(
              text:
                  'articles 137, 137-4 et 143-1 à 150 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 22),

          // ===================== 1.1 – CONDITIONS DU PLACEMENT =============
          const _SubTitle('1.1 – Conditions du placement'),

          // 1.1.1
          const _SubTitle('1.1.1 – Conditions tenant à la personne'),
          const _Paragraph(
            'Seule la personne mise en examen peut être soumise à la détention '
            'provisoire : le témoin assisté ne peut pas faire l’objet de cette mesure. '
            'En principe, toute personne régulièrement mise en examen peut être '
            'placée en détention provisoire si les autres conditions légales sont réunies.',
          ),

          const SizedBox(height: 10),

          // 1.1.2
          const _SubTitle(
            '1.1.2 – Conditions tenant à la nature de l’infraction',
          ),
          const _Paragraph(
            'La détention provisoire ne peut être décidée que pour :',
          ),
          const _IntroBullet(text: 'un crime ;'),
          const _IntroBullet(
            text: 'un délit puni d’au moins trois ans d’emprisonnement.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'Elle peut également être décidée en cas de soustraction volontaire aux '
            'obligations du contrôle judiciaire ou d’une assignation à résidence avec '
            'surveillance électronique.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'Dans cette dernière hypothèse, la détention peut s’appliquer même pour '
            'des délits punis d’une peine d’emprisonnement inférieure aux seuils '
            'indiqués, dès lors que le contrôle judiciaire peut concerner tous les délits '
            'punis d’emprisonnement.',
          ),

          const SizedBox(height: 14),

          // 1.1.3
          const _SubTitle(
            '1.1.3 – Situations dans lesquelles la détention provisoire est envisageable',
          ),
          _ConditionCard(
            title:
                'Finalités de la détention provisoire\n(art. 137 et 144 C. proc. pén.)',
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark
                ? const Color(0xFFBBDEFB)
                : const Color(0xFF0D47A1),
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les circonstances justifiant la détention provisoire sont prévues '
                      'par ',
                ),
                TextSpan(
                  text: 'les articles 137 et 144 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. La mesure doit être justifiée soit par les nécessités de '
                      'l’instruction, soit comme mesure de sûreté, mais toujours en '
                      'raison de l’insuffisance d’un contrôle judiciaire ou d’une '
                      'assignation à résidence avec surveillance électronique.',
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                'La nécessité de la détention se mesure au regard d’éléments précis '
                'et circonstanciés résultant de la procédure. Elle ne peut être ordonnée '
                'ou prolongée que si elle constitue l’unique moyen de :',
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    'conserver les preuves ou les indices matériels nécessaires à la '
                    'manifestation de la vérité (art. 144, 1° C. proc. pén.) ;',
              ),
              _IntroBullet(
                text:
                    'empêcher une pression sur les témoins ou les victimes ainsi que '
                    'sur leur famille (art. 144, 2° C. proc. pén.) ;',
              ),
              _IntroBullet(
                text:
                    'empêcher une concertation frauduleuse entre la personne mise en '
                    'examen et ses coauteurs ou complices (art. 144, 3° C. proc. pén.) ;',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Elle peut également constituer une mesure de sûreté, notamment pour :',
              ),
              SizedBox(height: 4),
              _IntroBullet(
                text:
                    'protéger la personne mise en examen (art. 144, 4° C. proc. pén.), '
                    'par exemple en cas de crime odieux nécessitant de la soustraire '
                    'à des réactions violentes ;',
              ),
              _IntroBullet(
                text:
                    'garantir le maintien de la personne à la disposition de la justice '
                    '(art. 144, 5° C. proc. pén.), en particulier lorsqu’elle n’a pas de '
                    'domicile stable ou présente un risque de fuite ;',
              ),
              _IntroBullet(
                text:
                    'mettre fin à une infraction ou prévenir son renouvellement '
                    '(art. 144, 6° C. proc. pén.) ;',
              ),
              _IntroBullet(
                text:
                    'mettre fin à un trouble exceptionnel et persistant à l’ordre public, '
                    'résultant de la gravité de l’infraction, de ses circonstances ou de '
                    'l’importance du préjudice causé (art. 144, 7° C. proc. pén.). '
                    'Ce trouble ne peut résulter du seul retentissement médiatique et '
                    'ne peut justifier une détention que pour les infractions criminelles.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ===================== 1.2 – PLACEMENT PAR LE JLD =================
          const _SubTitle(
            '1.2 – Placement en détention provisoire par le juge des libertés et de la détention',
          ),

          // 1.2.1
          const _SubTitle('1.2.1 – Le juge des libertés et de la détention'),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'La décision de placement en détention provisoire est confiée au juge '
                  'des libertés et de la détention (J.L.D.), conformément à ',
            ),
            TextSpan(
              text: 'l’article 137-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  '. Le J.L.D. ne peut jamais se saisir d’office : il doit toujours être '
                  'saisi par le juge d’instruction ou par le procureur de la République.',
            ),
          ]),
          const SizedBox(height: 8),
          const _Paragraph(
            'Le J.L.D. intervient lors du placement initial en détention, lors des '
            'prolongations de cette mesure ou lorsque le juge d’instruction refuse de '
            'donner une suite favorable à une demande ou réquisition de mise en liberté.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'À peine de nullité, le J.L.D. ne peut participer au jugement des affaires '
            'dont il a connu en matière de détention provisoire.',
          ),

          const SizedBox(height: 18),

          // 1.2.2
          const _SubTitle(
            '1.2.2 – Modalités du placement en détention provisoire',
          ),

          // 1.2.2.1 – Saisine
          const _SubTitle('1.2.2.1 – Saisine du J.L.D.'),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'En principe, le juge d’instruction saisit le J.L.D. par une ordonnance '
                  'motivée et lui transmet le dossier accompagné des réquisitions du '
                  'procureur de la République, conformément à ',
            ),
            TextSpan(
              text: 'l’article 137-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),
          const SizedBox(height: 6),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'En matière criminelle ou pour les délits punis de dix ans '
                  'd’emprisonnement, le procureur de la République peut, malgré le '
                  'refus du juge d’instruction de transmettre le dossier, saisir '
                  'directement le J.L.D. et doit alors déférer sans délai la personne '
                  'devant lui, en application de ',
            ),
            TextSpan(
              text: 'l’article 137-4 alinéa 2 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 14),

          // 1.2.2.2 – Procédure devant le JLD
          const _SubTitle('1.2.2.2 – Procédure devant le J.L.D.'),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Saisi par le juge d’instruction, le J.L.D. fait comparaître devant lui '
                  'la personne mise en examen, assistée de son avocat s’il en a déjà '
                  'désigné un. Au vu des éléments du dossier et après avoir recueilli '
                  'les observations de l’intéressé, il lui fait connaître s’il envisage '
                  'un placement en détention provisoire, conformément à ',
            ),
            TextSpan(
              text: 'l’article 145 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),
          const SizedBox(height: 6),
          const _Paragraph(
            'S’il n’envisage pas la détention provisoire, le J.L.D. peut placer la '
            'personne sous contrôle judiciaire ou, le cas échéant, sous assignation '
            'à résidence avec surveillance électronique.',
          ),

          const SizedBox(height: 18),

          // 1.2.3 – Ordonnance de placement
          const _SubTitle(
            '1.2.3 – L’ordonnance de placement en détention provisoire',
          ),
          const _Paragraph.rich([
            TextSpan(text: 'En application de '),
            TextSpan(
              text: 'l’article 137-3 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ', le placement en détention provisoire doit être prescrit par une '
                  'ordonnance motivée du J.L.D. Cette ordonnance doit énoncer avec '
                  'précision les conditions de droit et de fait justifiant la détention '
                  'et indiquer en quoi les obligations d’un contrôle judiciaire ou d’une '
                  'assignation à résidence avec surveillance électronique sont '
                  'insuffisantes.',
            ),
          ]),

          const SizedBox(height: 22),

          // ===================== 1.3 – CHAMBRE DE L’INSTRUCTION ============
          const _SubTitle(
            '1.3 – Placement en détention provisoire par la chambre de l’instruction',
          ),
          const _Paragraph.rich([
            TextSpan(text: 'En vertu de '),
            TextSpan(
              text: 'l’article 201 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ', la chambre de l’instruction peut ordonner tout acte '
                  'd’information qu’elle juge utile ou prononcer d’office la mise en '
                  'liberté de la personne mise en examen. Elle peut également ordonner '
                  'son placement en détention provisoire ou sous contrôle judiciaire.',
            ),
          ]),
          const SizedBox(height: 10),
          const _Paragraph(
            'La chambre de l’instruction intervient en tant que juridiction d’instruction '
            'du second degré, notamment lorsqu’elle est saisie par appel d’une '
            'ordonnance du juge d’instruction ou du J.L.D., ou par requête directe.',
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
