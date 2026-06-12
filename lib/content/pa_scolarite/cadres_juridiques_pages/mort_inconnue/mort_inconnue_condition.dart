// lib/pa/dps_dpg/cadres_juridiques/mort_inconnue/mort_inconnue_condition.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMortInconnueConditionPage extends StatelessWidget {
  const PaMortInconnueConditionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre1';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFFFFFFF);

    // Couleur pour mettre en évidence les références d’articles
    const Color lawColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mort de cause inconnue',
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
          // ====================== EN-TÊTE CHAPITRE =========================
          Text(
            'Chapitre 1\nConditions d’application\n'
            'des articles 74 et 80-4 du Code de procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Deux conditions doivent être réunies pour mettre en œuvre la '
                  'procédure de recherche des causes de la mort : ',
            ),
            TextSpan(
              text: 'la découverte d’un cadavre',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' et '),
            TextSpan(
              text:
                  'l’existence d’un mystère ou d’un doute sérieux sur les causes du décès',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ' (causes inconnues ou suspectes). Ces conditions fondent le recours '
                  'aux dispositions des articles 74 et 80-4 du Code de procédure pénale.',
            ),
          ]),
          const SizedBox(height: 18),

          // ====================== CARTE 1 : VUE D’ENSEMBLE =================
          _ConditionCard(
            title: '1. Conditions générales d’application',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle(
                'Découverte d’un cadavre et cause inconnue ou suspecte',
              ),
              _Paragraph(
                'La procédure de recherche des causes de la mort suppose à la fois '
                'l’existence matérielle d’un corps humain et une incertitude sur les '
                'circonstances du décès. À ce stade, il n’est pas encore établi que la mort '
                'soit naturelle, accidentelle ou liée à une infraction pénale.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 2 : 1.1 DÉCOUVERTE DE CADAVRE ======
          _ConditionCard(
            title: '1.1 — Une découverte de cadavre',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’expression « découverte de cadavre » peut sembler indiquer que le '
                      'corps aurait été dissimulé ou caché. En réalité, ',
                ),
                TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' s’applique également lorsque le corps se trouve dans un lieu '
                      'accessible et visible : ce qui importe est l’existence matérielle '
                      'd’un corps humain, non les conditions de sa découverte.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Ce qui est inconnu ou incertain, voire douteux, ce sont les causes '
                'de la mort. C’est précisément parce que ces causes ne sont pas '
                'immédiatement établies que la procédure de recherche des causes de '
                'la mort est déclenchée.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 3 : 1.2 MORT INCONNUE OU SUSPECTE ==
          _ConditionCard(
            title: '1.2 — Une mort dont la cause est inconnue ou suspecte',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph(
                'La loi distingue, selon leur cause, trois grandes catégories de décès : '
                'la mort dont la cause n’est pas criminelle ou délictuelle, la mort ayant '
                'une origine criminelle ou délictuelle et la mort de cause inconnue ou '
                'suspecte. C’est cette dernière catégorie qui justifie l’application de la '
                'procédure de l’article 74 du Code de procédure pénale.',
              ),
              SizedBox(height: 10),

              // ---------- 1.2.1 Mort dont la cause n’est pas criminelle -----
              _SubTitle(
                '1.2.1 — La mort dont la cause n’est pas criminelle ou délictuelle',
              ),
              _Paragraph(
                'Elle relève du droit civil et recouvre deux notions : la mort naturelle '
                'et la mort violente dont la cause n’est ni criminelle ni délictuelle. '
                'Dans ces hypothèses, la procédure pénale n’a pas vocation à être ouverte, '
                'sauf si des éléments nouveaux remettent en cause le caractère non pénal '
                'du décès.',
              ),
              SizedBox(height: 8),

              // ---------- 1.2.1.1 Mort naturelle ---------------------------
              _SubTitle(
                '1.2.1.1 — La mort naturelle (article 78 du code civil)',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La mort naturelle procède d’une cause interne (maladie, '
                      'vieillesse…). Elle reste en dehors du champ d’action de la police '
                      'judiciaire. Elle est constatée par un médecin qui remplit un '
                      'certificat de décès. Cette démarche est prévue par ',
                ),
                TextSpan(
                  text: 'l’article 78 du code civil',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', le certificat permettant ensuite à l’officier de l’état civil de '
                      'délivrer le permis d’inhumer.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Depuis la loi n° 2025-199 du 28 février 2025 de financement de la '
                      'sécurité sociale pour 2025 et les décrets n° 2025-370 et 2025-371 du '
                      '22 avril 2025, certains infirmiers volontaires peuvent, sous '
                      'conditions, établir et signer des certificats de décès. Ces '
                      'conditions sont précisées à ',
                ),
                TextSpan(
                  text:
                      'l’article D2213-1-1-4 du Code général des collectivités territoriales',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' : diplôme d’État depuis au moins trois ans, formation '
                      'spécifique validée, inscription sur la liste de l’ordre compétent. '
                      'Ils ne peuvent toutefois intervenir si le décès est survenu sur la '
                      'voie publique ou dans un lieu ouvert au public.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'En principe, l’inhumation ne peut avoir lieu qu’à l’expiration d’un '
                'délai de vingt-quatre heures après le décès, sauf exceptions (maladie '
                'contagieuse, situation particulière). L’officier de l’état civil du lieu '
                'du décès dresse l’acte de décès à partir des déclarations d’un parent ou '
                'd’une personne disposant des renseignements nécessaires sur l’état civil '
                'du défunt.',
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’inhumation irrégulière constitue une contravention de cinquième '
                      'classe, réprimée par ',
                ),
                TextSpan(
                  text: 'l’article R 645-6 du Code pénal',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 10),

              // ---------- 1.2.1.2 Mort violente non pénale -----------------
              _SubTitle(
                '1.2.1.2 — La mort violente (articles 81 et 82 du code civil)',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Il s’agit d’une mort violente dont la cause n’est ni criminelle ni '
                      'délictuelle (blessures, intoxication, brûlures, asphyxie…) de '
                      'caractère suicidaire ou accidentel. Dans cette situation, '
                      'l’officier de police judiciaire applique les dispositions de ',
                ),
                TextSpan(
                  text: 'l’article 81 du code civil',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' : aucune inhumation ne peut avoir lieu avant qu’un officier de '
                      'police, assisté d’un médecin, ait dressé procès-verbal décrivant '
                      'l’état du cadavre, les circonstances de la mort et les '
                      'renseignements relatifs à l’identité du défunt.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: 'Conformément à '),
                TextSpan(
                  text: 'l’article 82 du code civil',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ', l’officier de police judiciaire transmet ensuite sans délai à '
                      'l’officier de l’état civil du lieu du décès l’ensemble des '
                      'renseignements recueillis afin que l’acte de décès soit rédigé. Le '
                      'procès-verbal est également adressé au procureur de la République, '
                      'qui autorise l’inhumation en adressant un soit-transmis indiquant '
                      'que le parquet ne s’oppose pas à l’inhumation.',
                ),
              ]),
              SizedBox(height: 10),

              // ---------- 1.2.2 Origine criminelle ou délictuelle ----------
              _SubTitle(
                '1.2.2 — La mort ayant une origine criminelle ou délictuelle',
              ),
              _Paragraph(
                'Lorsque les constatations révèlent que la mort procède d’une infraction '
                'criminelle ou délictuelle (homicide volontaire, violences ayant entraîné '
                'la mort, etc.), l’officier de police judiciaire qui se transporte sur les '
                'lieux ouvre une enquête de police judiciaire dans l’un des cadres '
                'classiques (flagrance ou préliminaire) sous l’autorité du procureur de la '
                'République.',
              ),
              SizedBox(height: 10),

              // ---------- 1.2.3 Mort de cause inconnue ou suspecte ---------
              _SubTitle('1.2.3 — La mort de cause inconnue ou suspecte'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Il s’agit d’une mort, violente ou non, dont la cause ne peut être '
                      'immédiatement déterminée : elle ne paraît pas strictement naturelle, '
                      'sans que l’origine criminelle soit pour autant manifeste. Dans ce '
                      'contexte, la procédure de ',
                ),
                TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' s’impose afin de lever le doute et d’orienter la suite des '
                      'investigations.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph('La suspicion peut résulter :'),
              _BulletPoint(
                text:
                    'de traces ou lésions relevées sur le corps du défunt, lorsque leur '
                    'origine peut être équivoque ;',
              ),
              _BulletPoint(
                text:
                    'de circonstances de fait apparaissant inexplicables ou difficilement '
                    'compatibles avec une mort naturelle ou un simple accident ;',
              ),
              _BulletPoint(
                text:
                    'de renseignements ou témoignages recueillis par les enquêteurs et '
                    'de nature à éveiller les soupçons (conflits, menaces, contexte '
                    'familial ou professionnel tendu, etc.).',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== NOTA FINAL ===============================
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Si les éléments de suspicion apparaissent après l’inhumation du corps, '
                    'il appartient au procureur de la République d’apprécier '
                    'l’opportunité de requérir l’ouverture d’une information judiciaire. '
                    'Cette information permettra notamment l’exhumation du corps et la '
                    'réalisation d’une autopsie afin de déterminer, autant que possible, '
                    'les véritables causes du décès.',
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
