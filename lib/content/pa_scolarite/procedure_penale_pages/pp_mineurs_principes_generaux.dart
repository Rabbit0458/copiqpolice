import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Texte rouge pour les articles de loi
TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PaPPMineursPrincipesGenerauxPage extends StatelessWidget {
  const PaPPMineursPrincipesGenerauxPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_mineurs_principes_generaux';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF10141A) : const Color(0xFFFFFFFF);

    final textMain = GoogleFonts.fustat(
      fontSize: 15.5,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    final textSoft = GoogleFonts.fustat(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : const Color(0xFF424242),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
          tooltip: 'Retour',
        ),
        title: Text(
          'Principe généraux — mineurs',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================= EN-TÊTE CHAPITRE =======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0D47A1), const Color(0xFF002171)]
                        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHAPITRE 1 : PRINCIPES GÉNÉRAUX DE LA JUSTICE PÉNALE DES MINEURS',
                      style: textMain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Le Code de la justice pénale des mineurs (C.J.P.M.) fixe trois principes fondamentaux :',
                      style: textSoft,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8),
                    const _IntroBullet(
                      text:
                          'l’atténuation de la responsabilité pénale du mineur ;',
                    ),
                    const _IntroBullet(
                      text:
                          'la primauté de la réponse éducative sur la réponse répressive ;',
                    ),
                    const _IntroBullet(
                      text: 'le jugement par une juridiction spécialisée.',
                    ),
                    const SizedBox(height: 8),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            'Le C.J.P.M. ajoute en liminaire que l’intérêt supérieur de l’enfant doit être pris en compte. '
                            'Cette notion, consacrée à ',
                      ),
                      _lawRef(
                        'l’article 3 de la Convention internationale des droits de l’enfant',
                      ),
                      const TextSpan(
                        text:
                            ' adoptée par les Nations unies le 20 novembre 1989, est érigée en principe directeur de l’ensemble '
                            'de la procédure pénale applicable aux mineurs.',
                      ),
                    ]),
                  ],
                ),
              ),

              ////////////////////////////////////////////////////////////////
              /// 1.1 — PRÉSOMPTION DE DISCERNEMENT
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title:
                    '1.1 — Présomption de discernement (art. L. 11-1 du C.J.P.M.)',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text: 'Le C.J.P.M. reprend le principe énoncé à ',
                    ),
                    _lawRef('l’article 122-8 du Code pénal'),
                    const TextSpan(
                      text:
                          '. Les mineurs capables de discernement sont pénalement responsables des faits (crimes, délits, '
                          'contraventions) dont ils sont reconnus coupables, leur responsabilité pénale étant subordonnée à leur '
                          'capacité de discernement.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Le seuil de capacité de discernement et, par voie de conséquence, de responsabilité pénale est fixé à l’âge de 13 ans.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph('Ainsi sont établies deux présomptions :'),
                  const _BulletPoint(
                    text:
                        'présomption de non discernement pour les mineurs âgés de moins de treize ans ;',
                  ),
                  const _BulletPoint(
                    text:
                        'présomption de discernement pour les mineurs âgés de treize ans et plus.',
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Ces présomptions peuvent être renversées. La capacité de discernement ou l’absence de discernement du mineur peut être établie '
                          'par les éléments issus de la procédure (',
                    ),
                    _lawRef(
                      'article R. 11-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ') :'),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'déclarations du mineur, de son entourage familial et scolaire ;',
                  ),
                  const _IntroBullet(text: 'éléments de l’enquête ;'),
                  const _IntroBullet(
                    text:
                        'circonstances dans lesquelles les faits ont été commis ;',
                  ),
                  const _IntroBullet(text: 'antécédents éventuels du mineur ;'),
                  const _IntroBullet(
                    text: 'expertise ou examen psychiatrique ou psychologique.',
                  ),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Cette capacité de discernement se définit comme étant le fait, pour le mineur :',
                  ),
                  const _IntroBullet(
                    text: 'de comprendre et vouloir l’acte reproché ;',
                  ),
                  const _IntroBullet(
                    text:
                        'et d’être apte à comprendre le sens de la procédure pénale dont il fait l’objet.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Elle relève de l’appréciation souveraine du magistrat.',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 1.2 — LES GRANDS PRINCIPES
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '1.2 — Les grands principes',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  // 1.2.1 Primauté de l’éducatif / atténuation
                  const _SubTitle(
                    '1.2.1 — Primauté de l’éducatif et atténuation de la responsabilité pénale',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text: 'Le C.J.P.M. consacre ces principes aux ',
                    ),
                    _lawRef(
                      'articles L. 11-2, L. 11-3, L. 11-4 et L. 11-5 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '. La réponse éducative doit être privilégiée, les peines n’intervenant qu’à titre subsidiaire et '
                          'toujours en tenant compte de l’âge, de la personnalité et de la situation du mineur.',
                    ),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle('1.2.1.1 — Mineur de moins de 13 ans'),
                  const _Paragraph(
                    'Les seuils de capacité de discernement et de responsabilité pénale étant fixés à l’âge de 13 ans, aucune peine ne peut être encourue '
                    'en dessous de cet âge. Des mesures éducatives peuvent toutefois être prononcées si, et seulement si, il est établi que le mineur était '
                    'capable de discernement au moment des faits.',
                  ),
                  const SizedBox(height: 8),

                  const _SubTitle('1.2.1.2 — Mineur âgé d’au moins 13 ans'),
                  const _Paragraph(
                    'À compter de 13 ans, des mesures éducatives et/ou des peines peuvent être prononcées à l’encontre du mineur. '
                    'L’atténuation de la responsabilité pénale implique cependant que la nature et le quantum des peines soient adaptés à son âge et à sa '
                    'personnalité, en tenant compte de son évolution.',
                  ),

                  const SizedBox(height: 14),

                  // 1.2.2 Spécialisation des acteurs
                  const _SubTitle(
                    '1.2.2 — La spécialisation des acteurs (art. L. 12-1 et suivants du C.J.P.M.)',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les crimes, délits et contraventions de la cinquième classe reprochés à un mineur sont instruits et jugés par des juridictions et '
                          'chambres spécialement compétentes, conformément aux ',
                    ),
                    _lawRef(
                      'articles L. 12-1 et suivants du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(text: 'le juge des enfants ;'),
                  const _IntroBullet(text: 'le tribunal pour enfants ;'),
                  const _IntroBullet(
                    text:
                        'le juge d’instruction chargé spécialement des affaires concernant les mineurs ;',
                  ),
                  const _IntroBullet(
                    text:
                        'le juge des libertés et de la détention chargé spécialement des affaires concernant les mineurs ;',
                  ),
                  const _IntroBullet(
                    text:
                        'la cour d’assises des mineurs (les assesseurs sont juges des enfants) ;',
                  ),
                  const _IntroBullet(text: 'la chambre spéciale des mineurs ;'),
                  const _IntroBullet(
                    text: 'la chambre de l’instruction spécialement composée.',
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les fonctions du ministère public, pour les crimes, délits et contraventions de cinquième classe, sont exercées par le procureur général '
                          'ou par un magistrat du ministère public spécialement chargé des affaires de mineurs (',
                    ),
                    _lawRef(
                      'article L. 12-2 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En cas d’urgence ou d’empêchement, tout magistrat du parquet peut exercer ces fonctions, conformément à ',
                    ),
                    _lawRef(
                      'l’article L. 211-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La mise en œuvre des décisions prises en application du C.J.P.M. est confiée aux services et établissements de la protection judiciaire '
                          'de la jeunesse (PJJ) et, dans les cas expressément prévus, au secteur associatif habilité (',
                    ),
                    _lawRef(
                      'article L. 241-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 14),

                  // 1.2.3 Droits spécifiques des mineurs
                  const _SubTitle(
                    '1.2.3 — Les droits spécifiques des mineurs (art. L. 12-4 et L. 12-5 du C.J.P.M.)',
                  ),
                  const _Paragraph(
                    'Aux différentes phases de la procédure, certaines garanties revêtent un caractère constant et sont érigées en principes généraux applicables '
                    'à tout mineur mis en cause.',
                  ),

                  const SizedBox(height: 10),

                  // 1.2.3.1 Assistance par un avocat
                  const _SubTitle(
                    '1.2.3.1 — Assistance du mineur par un avocat (art. L. 12-4 du C.J.P.M.)',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le mineur est assisté par un avocat à tous les stades de la procédure, en application de ',
                    ),
                    _lawRef(
                      'l’article L. 12-4 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '. Dans la mesure du possible, le même avocat doit poursuivre son intervention à chaque étape, notamment lorsqu’il est désigné d’office.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le mineur doit recevoir notification de ses droits dans des termes simples et accessibles (',
                    ),
                    _lawRef(
                      'article D. 12-2 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '). Lorsqu’une décision prise à son égard est susceptible de recours, il en est informé ainsi que ses représentants légaux (',
                    ),
                    _lawRef(
                      'article D. 12-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),

                  // 1.2.3.3 Information des représentants légaux
                  const _SubTitle(
                    '1.2.3.3 — Information des représentants légaux et accompagnement du mineur (art. L. 12-5 du C.J.P.M.)',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les représentants légaux, ou à défaut un adulte approprié, reçoivent les mêmes informations que celles communiquées au mineur, en vertu de ',
                    ),
                    _lawRef(
                      'l’article L. 12-5 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '. Le mineur a le droit d’être accompagné par ses représentants légaux ou, à défaut, par un adulte approprié tout au long de la procédure.',
                    ),
                  ]),

                  const SizedBox(height: 10),

                  // 1.2.3.4 Publicité restreinte
                  const _SubTitle(
                    '1.2.3.4 — Publicité restreinte (art. L. 13-3 du C.J.P.M.)',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’identité ou l’image d’un mineur mis en cause ne peut, en aucune circonstance, être directement ou indirectement rendue publique, conformément à ',
                    ),
                    _lawRef(
                      'l’article L. 13-3 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(
                      text:
                          '. Cette règle protège le mineur contre toute stigmatisation et garantit la confidentialité des procédures le concernant.',
                    ),
                  ]),
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