import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPNullitesSubstantiellesPage extends StatelessWidget {
  const PPNullitesSubstantiellesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_nullites_substantielles';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
          'Les nullités substantielles',
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
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            'Les nullités substantielles en procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Comprendre la nullité lorsqu’aucun texte ne la prévoit expressément, mais que '
            'la violation d’une garantie essentielle a porté atteinte aux droits des parties.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          const _SubTitle('1.2 – Les nullités substantielles'),

          _Paragraph.rich([
            const TextSpan(
              text:
                  'Les nullités substantielles interviennent lorsque la méconnaissance d’une formalité importante, '
                  'prévue par une disposition de procédure pénale, porte atteinte aux intérêts de la partie qu’elle concerne. '
                  'À la différence des nullités textuelles, aucun texte ne prévoit nécessairement, de manière expresse, la nullité pour l’acte vicié.',
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph.rich([
            const TextSpan(text: 'L’'),
            TextSpan(
              text: 'Article 171 du Code de Procédure Pénale',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.red.shade700,
              ),
            ),
            const TextSpan(
              text:
                  ' donne une définition centrale de cette notion : « Il y a nullité lorsque la méconnaissance d’une formalité substantielle, '
                  'prévue par une disposition du présent code ou par toute autre disposition de procédure pénale, a porté atteinte aux intérêts de la partie qu’elle concerne. »',
            ),
          ]),

          const SizedBox(height: 18),

          // ============= CARD 1 — DÉFINITION & CRITÈRE =====================
          _ConditionCard(
            title: 'Définition et critère de la nullité substantielle',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _Paragraph(
                'Selon le système des nullités substantielles, la nullité peut être prononcée même si la loi est silencieuse sur la sanction. '
                'L’irrégularité n’est pas forcément assortie d’une mention « à peine de nullité », mais son importance impose qu’elle soit sanctionnée '
                'lorsqu’elle porte atteinte aux droits fondamentaux des parties.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La jurisprudence de la chambre criminelle de la Cour de cassation exige, pour prononcer une nullité substantielle, '
                      'qu’il y ait : ',
                ),
              ]),
              const _IntroBullet(
                text:
                    'Une atteinte grave aux droits de la défense (droit à un avocat, droit de se taire, droit à l’information, etc.).',
              ),
              const _IntroBullet(
                text:
                    'Ou un vice fondamental dans la recherche et l’établissement de la vérité (actes d’enquête ou d’instruction déloyaux, irréguliers ou trompeurs).',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ============= CARD 2 — EXEMPLES PRATIQUES =======================
          _ConditionCard(
            title: 'Exemples typiques de nullités substantielles',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La circulaire du ministre de la Justice du 24 août 1991 rappelle que la suppression de certaines nullités textuelles, '
                      'notamment en matière de garde à vue, ne signifie pas que les garanties prévues par la loi sont dépourvues de sanction. '
                      'Elles peuvent être protégées par la nullité substantielle lorsque leur violation porte atteinte aux droits de la défense.',
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle('Garde à vue irrégulière'),
              _BulletPoint(
                text:
                    'Une garde à vue ordonnée par un agent de police judiciaire ou par un officier de police judiciaire territorialement incompétent '
                    'est annulée pour violation d’une règle d’ordre public. L’irrégularité affecte la légalité même de la mesure privative de liberté.',
              ),

              SizedBox(height: 8),
              _SubTitle('Non-respect du droit à l’avocat'),
              _BulletPoint(
                text:
                    'Le non-respect de la notification du droit à être assisté par un avocat justifie la nullité, en raison de l’atteinte directe aux droits de la défense. '
                    'La personne n’a pas pu exercer pleinement ses prérogatives pendant la mesure.',
              ),

              SizedBox(height: 8),
              _SubTitle('Commission rogatoire et apparition d’indices graves'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque, au cours d’une commission rogatoire, apparaissent des indices graves et concordants à l’encontre d’une personne, '
                      'l’officier de police judiciaire ne peut pas poursuivre son audition comme simple témoin. '
                      'S’il ne modifie pas le cadre juridique de l’audition pour respecter les droits de la défense, il s’expose à une nullité pour avoir fait échec à ces droits, '
                      'conformément à l’',
                ),
                TextSpan(
                  text: 'Article 105 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // =============== NOTA — CONSEIL CONSTITUTIONNEL ==================
          _NotaBox(
            title: 'POINT CLÉ – CRIMINALITÉ ORGANISÉE',
            bodySpans: [
              const TextSpan(
                text:
                    'Le Conseil constitutionnel, dans la décision n° 2004-492 du 2 mars 2004, a censuré une disposition qui tendait à valider a posteriori, '
                    'de manière automatique, toute procédure menée selon le régime de la criminalité organisée alors qu’en définitive la circonstance aggravante '
                    'de bande organisée ne pouvait pas être retenue.',
              ),
              const TextSpan(text: ' '),
              const TextSpan(
                text:
                    'Cette décision implique que l’autorité judiciaire ne peut autoriser le recours aux procédures spéciales de criminalité organisée que lorsqu’elle dispose '
                    'd’une ou plusieurs raisons plausibles de soupçonner que les faits constituent l’une des infractions énumérées à l’',
              ),
              TextSpan(
                text: 'Article 706-73 du Code de Procédure Pénale',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent,
                ),
              ),
              const TextSpan(
                text:
                    '. Les actes d’enquête ou d’instruction peuvent être exonérés de nullité si, au jour où ils ont été autorisés, la circonstance aggravante de bande organisée '
                    'paraissait caractérisée.',
              ),
              const TextSpan(text: ' '),
              const TextSpan(
                text:
                    'En revanche, les actes autorisés sans circonstance de bande organisée, ou sans raisons plausibles de soupçonner l’une des infractions concernées, '
                    'peuvent faire l’objet d’une annulation au titre des nullités substantielles.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ============== CARD 3 — ENREGISTREMENT AUDITION MINEUR ==========
          _ConditionCard(
            title:
                'Enregistrement vidéo de l’audition d’un mineur placé en garde à vue',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _Paragraph(
                'Lorsque la loi impose l’enregistrement audiovisuel de l’audition d’un mineur placé en garde à vue, une impossibilité technique peut être rencontrée. '
                'Dans ce cas, il doit en être fait mention dans un procès-verbal d’interrogatoire qui précise la nature de cette impossibilité, et le procureur de la République '
                'ou le juge d’instruction doit être immédiatement avisé.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le non-respect de ces modalités a été jugé comme une cause de nullité par la chambre criminelle de la Cour de cassation (arrêt du 26 mars 2008). ',
                ),
                const TextSpan(
                  text:
                      'Bien que cette nullité ne relève pas à proprement parler d’un texte mentionnant une sanction expresse, la Cour n’a pas exigé la démonstration d’une atteinte grave '
                      'aux intérêts de l’enfant pour annuler : le défaut d’enregistrement semble alors relever d’une nullité d’ordre public, tant la garantie est jugée essentielle.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ============== CONCLUSION GÉNÉRALE ==============================
          const _SubTitle('Conclusion : rôle des nullités substantielles'),
          const _Paragraph(
            'Les nullités substantielles jouent un rôle essentiel de protection des droits fondamentaux des parties lorsqu’aucun texte ne prévoit explicitement '
            'la nullité. Elles permettent au juge d’écarter des actes accomplis en violation de formalités essentielles ayant porté atteinte aux droits de la défense '
            'ou à la loyauté de la recherche de la vérité.',
          ),
          const SizedBox(height: 6),
          const _Paragraph(
            'Qu’elle soit textuelle ou substantielle, la nullité obéit dans tous les cas à une procédure spécifique d’invocation et de jugement. '
            'Ces modalités relèvent du régime général de l’action en nullité, distinctement étudié dans une autre partie.',
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
