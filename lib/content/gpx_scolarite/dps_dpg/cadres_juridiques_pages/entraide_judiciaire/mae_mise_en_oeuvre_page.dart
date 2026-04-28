import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaeMiseEnOeuvrePage extends StatelessWidget {
  const MaeMiseEnOeuvrePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/mae_mise_en_oeuvre';

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
          'Mandat d’arrêt européen — Mise en œuvre',
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
            '2.2 — Mise en œuvre',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'La mise en œuvre concrète du mandat d’arrêt européen repose sur des conditions '
            'liées à la gravité des faits et aux décisions déjà prononcées, ainsi que sur des '
            'délais stricts et des règles particulières en matière de double incrimination et '
            'de nationalité.',
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // FAITS POUVANT DONNER LIEU À MANDAT D’ARRÊT
          // ===============================================================
          _ConditionCard(
            title: 'Faits pouvant donner lieu à un mandat d’arrêt européen',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Un mandat d’arrêt européen ne peut être émis que pour des faits présentant un '
                'certain degré de gravité. Il peut être délivré lorsqu’il s’agit :',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'de faits punis d’une mesure de sûreté privative de liberté d’une durée égale '
                    'ou supérieure à un an ;',
              ),
              _BulletPoint(
                text:
                    'de faits punis d’une peine privative de liberté d’une durée égale ou supérieure '
                    'à un an ;',
              ),
              _BulletPoint(
                text:
                    'd’une peine d’emprisonnement déjà prononcée à l’encontre de la personne recherchée, '
                    'd’une durée égale ou supérieure à quatre mois ;',
              ),
              _BulletPoint(
                text:
                    'd’une mesure de sûreté privative de liberté déjà infligée, lorsque la durée restant '
                    'à subir est égale ou supérieure à quatre mois de privation de liberté.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Les mesures de sûreté privatives de liberté n’existent pas en droit français. '
                        'Cette catégorie vise néanmoins des situations pouvant exister dans d’autres '
                        'États membres de l’Union européenne.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // DÉLAIS DE DÉCISION
          // ===============================================================
          _ConditionCard(
            title:
                'Délais pour statuer sur la remise de la personne recherchée',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Une fois la personne arrêtée sur le fondement d’un mandat d’arrêt européen, '
                'la décision définitive autorisant ou refusant la remise doit être prise dans '
                'un délai maximum de trois mois à compter de la date de l’arrestation.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Ce délai impose une grande réactivité de l’ensemble des acteurs (autorités '
                'judiciaires, services d’enquête, administration pénitentiaire), afin de permettre '
                'une exécution rapide et efficace de la coopération judiciaire européenne.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // DOUBLE INCRIMINATION & LISTE DES 32 INFRACTIONS
          // ===============================================================
          _ConditionCard(
            title:
                'Double incrimination et liste des 32 catégories d’infractions',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En principe, l’exécution d’un mandat d’arrêt européen suppose que les faits soient '
                      'punissables dans les deux États (État membre d’émission et État membre d’exécution). '
                      'Cependant, il n’est pas nécessaire de vérifier la double incrimination lorsque les faits '
                      'entrent dans l’une des trente-deux catégories d’infractions visées par ',
                ),
                TextSpan(
                  text: 'l’article 694-32 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Dans ce cas, seule la peine encourue dans l’État d’émission est prise en compte.',
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Parmi ces trente-deux catégories d’infractions, on peut notamment citer :',
              ),
              const SizedBox(height: 6),
              const _IntroBullet(
                text: 'la participation à une organisation criminelle ;',
              ),
              const _IntroBullet(text: 'le terrorisme ;'),
              const _IntroBullet(text: 'la traite des êtres humains ;'),
              const _IntroBullet(
                text: 'l’aide à l’entrée et au séjour irréguliers ;',
              ),
              const _IntroBullet(
                text:
                    'ainsi que d’autres infractions graves, économiques, financières ou violentes, '
                    'expressément listées par le texte.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // NATIONALITÉ FRANÇAISE
          // ===============================================================
          _ConditionCard(
            title: 'Nationalité de la personne recherchée',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'La nationalité française de la personne réclamée ne constitue pas, en soi, '
                'un motif systématique de refus de remise dans le cadre d’un mandat d’arrêt '
                'européen. Le mécanisme repose sur la confiance mutuelle entre États membres '
                'et sur la reconnaissance des décisions judiciaires rendues dans l’Union européenne.',
              ),
              SizedBox(height: 8),
              _Paragraph(
                'Il appartient néanmoins aux autorités judiciaires françaises de vérifier que les '
                'conditions légales de la remise sont réunies, que les droits fondamentaux de la '
                'personne sont garantis et qu’aucun motif de refus prévu par les textes ne trouve '
                'à s’appliquer.',
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
