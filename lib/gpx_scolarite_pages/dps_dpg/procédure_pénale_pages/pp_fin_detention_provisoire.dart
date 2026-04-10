import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPFinDetentionProvisoirePage extends StatelessWidget {
  const PPFinDetentionProvisoirePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_fin_detention_provisoire';

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
          'Fin de la détention provisoire',
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
            'CHAPITRE 3',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fin de la détention provisoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Règlement de la procédure, demandes de mise en liberté, mises en '
            'liberté de plein droit, d’office, sur réquisitions ou pour raisons '
            'de santé.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ====================== 3.1 – RÈGLEMENT DE LA PROCÉDURE ==========
          const _SubTitle('3.1 – Le règlement de la procédure'),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'La détention provisoire prend fin notamment en cas de non-lieu ou '
                  'lorsque les faits sont requalifiés en contravention ou en délit '
                  'n’entrant plus dans les prévisions de ',
            ),
            TextSpan(
              text: 'l’article 144 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  '. De plus, le juge d’instruction ou, s’il est saisi, le juge des '
                  'libertés et de la détention doit ordonner la mise en liberté '
                  'immédiate de la personne détenue dès que les conditions de ',
            ),
            TextSpan(
              text: 'l’article 144 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' ne sont plus réunies, conformément à '),
            TextSpan(
              text: 'l’article 144-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 16),

          const _SubTitle(
            '3.1.1 – En cas de renvoi devant le tribunal correctionnel\n(art. 179 C. proc. pén.)',
          ),

          const _Paragraph.rich([
            TextSpan(
              text: 'En cas de renvoi devant le tribunal correctionnel, ',
            ),
            TextSpan(
              text: 'l’article 179 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' prévoit que l’ordonnance de renvoi met normalement fin à la '
                  'détention provisoire. Toutefois, le juge d’instruction peut, '
                  'par ordonnance distincte spécialement motivée, maintenir la '
                  'personne en détention jusqu’à sa comparution devant le tribunal.',
            ),
          ]),

          const SizedBox(height: 12),

          const _SubTitle(
            '3.1.2 – En cas de renvoi devant la cour d’assises\n(art. 181 C. proc. pén.)',
          ),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Lorsque le juge d’instruction ou la chambre de l’instruction estime '
                  'que les faits retenus à la charge de la personne mise en examen '
                  'constituent un crime, ils prononcent une mise en accusation devant '
                  'la cour d’assises, en application de ',
            ),
            TextSpan(
              text: 'l’article 181 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  '. La détention provisoire se poursuit alors selon le régime des '
                  'accusés détenus en attente de jugement par la cour d’assises, '
                  'sous le contrôle des juridictions compétentes.',
            ),
          ]),

          const SizedBox(height: 22),

          // ====================== 3.2 – DEMANDE DE MISE EN LIBERTÉ =========
          const _SubTitle('3.2 – La demande de mise en liberté'),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'La mise en liberté peut être demandée à tout moment au juge '
                  'd’instruction par la personne mise en examen ou par son avocat, '
                  'en application de ',
            ),
            TextSpan(
              text: 'l’article 148 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  '. De même, tout prévenu ou accusé peut demander sa mise en liberté, '
                  'conformément à ',
            ),
            TextSpan(
              text: 'l’article 148-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 14),

          const _SubTitle('3.2.1 – Procédure devant le juge d’instruction'),

          const _Paragraph(
            'Le juge d’instruction communique immédiatement la demande de mise en '
            'liberté au procureur de la République pour réquisitions. Il dispose '
            'ensuite de deux options :',
          ),
          const SizedBox(height: 6),
          const _IntroBullet(
            text:
                'S’il accepte de faire droit à la demande, il rend lui-même une '
                'ordonnance de mise en liberté, éventuellement assortie d’un '
                'contrôle judiciaire.',
          ),
          const _IntroBullet(
            text:
                'S’il n’entend pas y faire droit, il ne peut pas rejeter lui-même la '
                'demande : il transmet celle-ci, avec son avis motivé, au juge des '
                'libertés et de la détention dans les dix jours suivant la '
                'communication au procureur de la République.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'Saisi, le juge des libertés et de la détention peut soit accorder la '
            'mise en liberté, avec ou sans contrôle judiciaire, soit rejeter la '
            'demande.',
          ),

          const SizedBox(height: 16),

          const _SubTitle('3.2.2 – Saisine de la chambre de l’instruction'),

          _ConditionCard(
            title:
                'Saisine de la chambre de l’instruction\n(contentieux de la détention)',
            cardColor: isDark
                ? const Color(0xFF263238)
                : const Color(0xFFE3F2F1),
            accent: const Color(0xFF00838F),
            titleColor: isDark
                ? const Color(0xFFB2EBF2)
                : const Color(0xFF004D40),
            children: const [
              _IntroBullet(
                text:
                    'En cas de carence du juge des libertés et de la détention : '
                    'l’intéressé peut saisir la chambre lorsque le J.L.D. n’a pas '
                    'statué dans les cinq jours ouvrables sur une demande de mise '
                    'en liberté.',
              ),
              _IntroBullet(
                text:
                    'En cas de carence du juge d’instruction : l’intéressé ou son '
                    'avocat peut saisir la chambre à l’expiration d’un délai de '
                    'six mois depuis la dernière comparution, conformément à '
                    'l’article 148-4 du Code de procédure pénale.',
              ),
              _IntroBullet(
                text:
                    'Lorsque la chambre de l’instruction s’est réservée le '
                    'contentieux de la détention, elle demeure seule compétente '
                    'pour statuer sur les demandes de mise en liberté.',
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'La chambre de l’instruction dispose d’un délai de 30 jours à compter '
            'de la réception de la demande de mise en liberté pour rendre sa '
            'décision.',
          ),

          const SizedBox(height: 16),

          const _SubTitle('3.2.3 – Saisine de la juridiction de jugement'),

          const _Paragraph(
            'Après le renvoi devant une juridiction de jugement (tribunal '
            'correctionnel ou cour d’assises), la personne peut demander sa mise '
            'en liberté à tout moment de la procédure. C’est alors la juridiction '
            'de jugement saisie qui statue sur cette demande, selon les textes qui '
            'lui sont applicables.',
          ),

          const SizedBox(height: 22),

          // ====================== 3.3 – MISE EN LIBERTÉ DE PLEIN DROIT =====
          const _SubTitle('3.3 – La mise en liberté de plein droit'),

          const _SubTitle(
            '3.3.1 – À la fin de la durée de la détention provisoire',
          ),
          const _Paragraph(
            'Lorsque la durée légale maximale de la détention provisoire est '
            'atteinte, prolongations éventuelles comprises, la mise en liberté de '
            'la personne est automatique : la juridiction n’a plus la faculté de '
            'maintenir la détention au-delà des limites fixées par la loi.',
          ),

          const SizedBox(height: 10),

          const _SubTitle('3.3.2 – Inobservation des délais'),
          const _Paragraph(
            'L’inobservation par les juridictions des délais légaux pour statuer sur '
            'les demandes de mise en liberté entraîne également la mise en liberté '
            'de plein droit de la personne détenue.',
          ),

          const SizedBox(height: 16),

          const _NotaBox(
            title: 'Conséquence pratique',
            bodySpans: [
              TextSpan(
                text:
                    'La maîtrise des délais (durée de la détention, délais pour '
                    'statuer sur les demandes, délais de recours) est essentielle : '
                    'leur non-respect se traduit par la remise en liberté de la '
                    'personne, indépendamment du fond du dossier.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ====================== 3.4 – MISE EN LIBERTÉ D’OFFICE ===========
          const _SubTitle('3.4 – La mise en liberté d’office'),

          const _Paragraph(
            'La mise en liberté d’office est prononcée sans qu’elle ait été '
            'demandée par la personne détenue ou requise par le ministère public. '
            'Elle doit être ordonnée lorsque la mise en liberté est de droit, mais '
            'aussi lorsque la juridiction estime que la détention n’est plus utile '
            'à la bonne marche de l’instruction ou à la protection de l’ordre public.',
          ),

          const SizedBox(height: 10),

          const _SubTitle('3.4.1 – Décision du juge d’instruction'),
          const _Paragraph(
            'Avant d’ordonner une mise en liberté d’office, le juge d’instruction '
            'sollicite l’avis du procureur de la République. Il prend ensuite sa '
            'décision sans débat contradictoire. La personne mise en examen doit '
            's’engager à se présenter à tous les actes de la procédure et à tenir '
            'le juge informé de ses changements de domicile ou de déplacements '
            'importants.',
          ),

          const SizedBox(height: 10),

          const _SubTitle('3.4.2 – Décision de la chambre de l’instruction'),
          const _Paragraph(
            'La chambre de l’instruction peut, quel que soit son mode de saisine, '
            'décider la mise en liberté d’office lorsqu’elle estime que les '
            'conditions d’un maintien en détention ne sont plus remplies.',
          ),

          const SizedBox(height: 22),

          // ====================== 3.5 – SUR RÉQUISITIONS DU PARQUET ========
          const _SubTitle(
            '3.5 – La mise en liberté sur réquisitions du parquet',
          ),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Le procureur de la République peut, à tout moment, requérir auprès '
                  'du juge d’instruction la mise en liberté d’une personne placée en '
                  'détention provisoire, en application de ',
            ),
            TextSpan(
              text: 'l’article 147 alinéa 2 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 22),

          // ====================== 3.6 – POUR RAISON DE SANTÉ ===============
          const _SubTitle('3.6 – La mise en liberté pour raison de santé'),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Sauf s’il existe un risque grave de renouvellement de l’infraction, '
                  'la mise en liberté d’une personne placée en détention provisoire '
                  'peut être ordonnée, d’office ou à la demande de l’intéressé, '
                  'lorsqu’une expertise médicale établit que cette personne est '
                  'atteinte d’une pathologie engageant le pronostic vital ou que son '
                  'état de santé physique ou mentale est incompatible avec le maintien '
                  'en détention, conformément à ',
            ),
            TextSpan(
              text: 'l’article 147-1 du Code de procédure pénale',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

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
