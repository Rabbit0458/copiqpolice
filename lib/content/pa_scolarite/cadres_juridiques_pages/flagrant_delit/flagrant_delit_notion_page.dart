import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — CADRES JURIDIQUES : NOTION DE FLAGRANCE
///
///  CHAPITRE 1 : LA NOTION DE FLAGRANCE
///  - Intro : article 53 du code de procédure pénale
///  - A. La flagrance proprement dite
///       • 1.1.1 Le crime ou le délit se commettant actuellement
///       • 1.1.2 Le crime ou le délit venant de se commettre
///  - B. La flagrance par présomption
///       • 1.2.1 La clameur publique
///       • 1.2.2 La découverte d’objets, traces ou indices
/// ===================================================================
class PaFlagrantDelitNotionPage extends StatelessWidget {
  const PaFlagrantDelitNotionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .90);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: 'Retour',
        ),
        title: Text(
          'Chapitre 1 — Notion de flagrance',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            'La notion de flagrance',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Article 53 du code de procédure pénale.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'La flagrance recouvre deux grandes hypothèses, définies par l’article 53 du code de procédure pénale : '
            'la flagrance proprement dite et la flagrance par présomption. '
            'Dans ces situations, l’infraction est au cœur de l’actualité des faits et justifie des pouvoirs élargis pour la police judiciaire.',
          ),
          const SizedBox(height: 12),

          const _IntroBullet(
            text:
                'La flagrance proprement dite : le crime ou le délit se commet actuellement ou vient de se commettre.',
          ),
          const _IntroBullet(
            text:
                'La flagrance par présomption : la situation de flagrance est déduite d’éléments objectifs (clameur publique, objets ou indices sur la personne).',
          ),

          const SizedBox(height: 20),

          // =======================================================
          // A. LA FLAGRANCE PROPREMENT DITE
          // =======================================================
          _ConditionCard(
            title: 'A. La flagrance proprement dite',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: 'L’article 53 du code de procédure pénale précise que ',
                ),
                TextSpan(
                  text:
                      '“est qualifié crime ou délit flagrant le crime ou le délit qui se commet actuellement, ou qui vient de se commettre”. ',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.red, // 🔴 LA MISE EN ROUGE DEMANDÉE
                  ),
                ),
                TextSpan(
                  text:
                      'La flagrance proprement dite vise donc les situations où l’infraction est en cours de réalisation ou tout juste achevée.',
                ),
              ]),
              SizedBox(height: 12),

              // ---------------------------------------------------
              // 1.1.1 Le crime ou le délit se commettant actuellement
              // ---------------------------------------------------
              _SubTitle(
                '1.1.1 Le crime ou le délit se commettant actuellement',
              ),
              _Paragraph(
                'La commission de l’infraction peut être directement perçue, sans ambiguïté, par les membres de la police judiciaire ou par des tiers. '
                'C’est le cas, par exemple, lorsque l’auteur est vu en train de réaliser matériellement les actes constitutifs de l’infraction.',
              ),
              SizedBox(height: 8),

              _BulletPoint(
                text:
                    'La commission de l’infraction est perçue de façon évidente : voleur vu en train de s’emparer de la chose d’autrui, cambrioleur surpris en action, etc.',
              ),
              _BulletPoint(
                text:
                    'Les infractions continues (comme la séquestration ou le recel) peuvent également faire l’objet d’une enquête de flagrance pendant toute la durée de leur réalisation.',
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: 'Exemple de flagrance continue',
                bodySpans: [
                  TextSpan(
                    text:
                        'La séquestration d’une victime dans un lieu tenu secret en vue d’obtenir une rançon illustre une infraction dont la flagrance se prolonge tant que la situation perdure. '
                        'La jurisprudence a ainsi jugé que la flagrance se perpétue pendant toute la durée de la séquestration (cass. crim. n°78-92914 du 8 novembre 1979).',
                  ),
                ],
              ),
              SizedBox(height: 12),

              _Paragraph(
                'L’actualité de la commission de l’infraction peut aussi être révélée par des indices apparents : il n’est pas nécessaire que l’indice soit uniquement matériel. '
                'Il peut s’agir d’une attitude, d’un comportement, d’une dénonciation de la victime ou même d’un coauteur.',
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: 'Indice apparent de flagrance',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une victime qui désigne immédiatement son agresseur, un coauteur qui dénonce l’un de ses complices, ou encore une personne présentant une attitude suspecte '
                        'au plus près du lieu des faits peuvent révéler l’actualité d’une infraction en cours ou venant de se commettre.',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // ---------------------------------------------------
              // 1.1.2 Le crime ou le délit venant de se commettre
              // ---------------------------------------------------
              _SubTitle('1.1.2 Le crime ou le délit venant de se commettre'),
              _Paragraph(
                'La difficulté principale tient ici au délai écoulé entre la commission de l’infraction et sa découverte, ou entre cette découverte et la saisine de la police judiciaire. '
                'La loi ne fixe pas de délai précis au-delà duquel il n’y aurait plus flagrance : ce sont la jurisprudence et la pratique des parquets qui permettent d’apprécier le caractère d’actualité des faits.',
              ),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'À titre d’illustration, une cour d’appel a jugé qu’un crime dénoncé par la victime 13 heures après sa commission, et dont l’auteur avait été appréhendé 36 heures après les faits, '
                      'ne présentait plus de caractère de flagrance (cour d’appel de Douai, 8 septembre 1960, JCP 1960, éd. G, II, 11777). ',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Inversement, la Cour de cassation a admis qu’un délai de 28 heures séparant la commission d’un viol du dépôt de plainte par la victime restait “suffisamment bref” '
                      'pour ne pas faire disparaître le caractère d’actualité des faits (cass. crim. n°90-87.360 du 26 février 1991).',
                ),
              ]),
              SizedBox(height: 10),

              _NotaBox(
                title: 'En cas de doute sur la flagrance',
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans les situations limites, l’officier de police judiciaire doit systématiquement solliciter des instructions du parquet. '
                        'Cette consultation permet d’éviter les contestations ultérieures sur la validité du cadre de flagrance et sur la régularité des actes accomplis.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // B. LA FLAGRANCE PAR PRESOMPTION
          // =======================================================
          _ConditionCard(
            title: 'B. La flagrance par présomption',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'La flagrance par présomption regroupe deux situations de fait attachées à la personne soupçonnée : '
                'la clameur publique et la découverte d’objets, de traces ou d’indices laissant penser à sa participation au crime ou au délit.',
              ),
              SizedBox(height: 12),

              // 1.2.1 CLAMEUR PUBLIQUE
              _SubTitle('1.2.1 La clameur publique'),
              _Paragraph(
                'L’article 53 du code de procédure pénale vise l’hypothèse où, dans un temps très voisin de l’action, '
                'la personne soupçonnée est poursuivie par la clameur publique. Les textes ne définissent pas précisément ce qu’est une “clameur publique” '
                'ni ce qu’il faut entendre par “temps très voisin de l’action”.',
              ),
              SizedBox(height: 8),

              _BulletPoint(
                text:
                    'La clameur publique n’est pas une simple rumeur : il s’agit d’un cri ou d’une interpellation claire, pouvant être une accusation (“Au voleur !”) ou une injonction (“Arrêtez-le !”).',
              ),
              _BulletPoint(
                text:
                    'Ce cri peut émaner de la victime, d’un témoin ou de plusieurs personnes et désigne suffisamment la personne soupçonnée pour justifier son interpellation.',
              ),
              _BulletPoint(
                text:
                    'La clameur publique doit intervenir dans un temps très voisin de l’action : elle n’est pas forcément concomitante à l’infraction, mais elle doit en être la suite directe et le prolongement.',
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: 'Exemple de clameur publique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un individu s’enfuit en courant après avoir arraché le sac d’une passante. La victime et plusieurs témoins crient “Au voleur ! Attrapez-le !”. '
                        'Les fonctionnaires de police qui entendent ces cris et voient l’individu désigné peuvent légitimement intervenir dans le cadre de la flagrance par présomption.',
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 1.2.2 OBJETS, TRACES OU INDICES
              _SubTitle('1.2.2 La découverte d’objets, traces ou indices'),
              _Paragraph(
                'Toujours dans un temps très voisin de l’action, la flagrance peut être présumée lorsque la personne soupçonnée est trouvée en possession d’objets, '
                'ou présente des traces ou indices laissant penser qu’elle a participé au crime ou au délit. Ces éléments ont un double effet : ',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'révéler la commission d’une infraction qui vient de se commettre ;',
              ),
              _BulletPoint(
                text:
                    'imputer cette infraction à l’individu porteur de ces objets, traces ou indices “accusateurs”.',
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: 'Exemples d’indices matériels et d’attitude',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une patrouille de police découvre, de nuit, un individu qui tente de prendre la fuite à la vue des agents. Il est trouvé porteur d’instruments d’effraction '
                        'et d’un sac contenant des objets précieux : on se trouve à la fois en présence d’indices matériels et d’un indice-attitude (la tentative de fuite).\n\n',
                  ),
                  TextSpan(
                    text:
                        'Autre illustration : le fait pour un individu de se débarrasser, à la vue de la police, d’un poste de radio ou d’un objet manifestement volé constitue l’apparence d’une infraction flagrante, '
                        'justifiant le recours au cadre de la flagrance par présomption.',
                  ),
                ],
              ),

              SizedBox(height: 10),
              _NotaBox(
                title: 'Vigilance sur le lien avec l’infraction',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les objets, traces ou indices découverts doivent présenter un lien suffisamment direct avec l’infraction pour permettre de présumer la participation de la personne concernée. '
                        'Faute de ce lien, la qualification de flagrance par présomption pourrait être contestée et fragiliser la procédure.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO (les 3 conditions au début)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE (dans les sections B et C)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
