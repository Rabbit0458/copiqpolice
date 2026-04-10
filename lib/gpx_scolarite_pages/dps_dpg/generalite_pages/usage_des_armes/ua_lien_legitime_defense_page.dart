import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UaLienLegitimeDefensePage extends StatelessWidget {
  const UaLienLegitimeDefensePage({super.key});

  static const String routeName =
      '/gpx/generalites/usagedesarmes/lien_legitime_defense';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
    final Color accentColor = isDark
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color warningColor = isDark
        ? const Color(0xFFFFD54F)
        : const Color(0xFFF9A825);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'Usage des armes & légitime défense',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE & RAPPEL TEXTES =================
          Text(
            'Textes de référence',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Trois grands ensembles de textes encadrent l’usage de la force armée par les policiers :\n\n',
            ),
            TextSpan(
              text: '• Article L. 435-1 du Code de la Sécurité Intérieure',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  ' : cadre spécifique de l’usage des armes par les agents de la Police nationale et de la Gendarmerie nationale.\n',
            ),
            TextSpan(
              text: '• Article 122-5 du Code pénal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  ' : régime général de la légitime défense des personnes et des biens, applicable à tout justiciable, '
                  'y compris aux policiers lorsqu’ils ne peuvent pas se placer dans le cadre de l’article L. 435-1.\n',
            ),
            TextSpan(
              text: '• Article L. 211-9 du Code de la Sécurité Intérieure',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  ' : règles particulières d’usage des armes pour la dispersion d’un attroupement, distinctes des cinq situations de l’article L. 435-1.',
            ),
          ]),
          const SizedBox(height: 18),

          // =====================================================
          // 1 — CADRE SPÉCIFIQUE DE L’ARTICLE L. 435-1
          // =====================================================
          _HypoCard(
            title:
                '1. Le cadre spécifique de l’article L. 435-1 du Code de la Sécurité Intérieure',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'L’article L. 435-1 du Code de la Sécurité Intérieure fixe un régime spécial pour l’usage des armes '
                'par les agents de la Police nationale et de la Gendarmerie nationale. '
                'Ce texte ne s’applique pas à tout le monde, mais uniquement aux forces de sécurité intérieure régulièrement armées.',
              ),
              const SizedBox(height: 8),
              _Paragraph('Ce régime repose sur deux étages :'),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Trois conditions préalables obligatoires : agir dans l’exercice de ses fonctions, '
                      'être identifiable comme policier (uniforme ou insignes apparents), '
                      'et ne faire usage de l’arme qu’en cas de nécessité absolue et de manière strictement proportionnée.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Cinq situations limitativement énumérées dans lesquelles l’usage de l’arme peut être envisagé '
                      '(atteintes à la vie, défense de lieux et de personnes confiées, fuite d’un individu dangereux, '
                      'immobilisation d’un véhicule dangereux, périple meurtrier).',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'Lorsque ces conditions sont réunies, l’usage de l’arme est apprécié principalement au regard de ce texte spécial. '
                'Les magistrats contrôlent alors si le policier était bien dans l’une des cinq situations prévues et si son tir répondait '
                'aux exigences de nécessité absolue et de proportionnalité.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Attention au champ d’application',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’article L. 435-1 du Code de la Sécurité Intérieure ne régit pas tous les cas d’usage des armes. '
                        'Il ne couvre pas, par exemple, les opérations de maintien de l’ordre en attroupement (régi par l’article L. 211-9) '
                        'ni toutes les situations de légitime défense classique qui peuvent survenir dans la vie quotidienne d’un policier.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 2 — RÉGIME GÉNÉRAL DE LA LÉGITIME DÉFENSE (CODE PÉNAL)
          // =====================================================
          _HypoCard(
            title:
                '2. La légitime défense de droit commun (article 122-5 du Code pénal)',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article 122-5 du Code pénal pose le principe général de la légitime défense. '
                      'Il s’applique à toute personne, simple citoyen ou policier, lorsque celle-ci réagit à une atteinte injustifiée. '
                      'Ce texte couvre à la fois :\n',
                ),
                TextSpan(
                  text: '• la légitime défense des personnes ;\n',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '• la légitime défense des biens.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Pour la défense des personnes : nécessité d’une atteinte injustifiée, actuelle et réelle, '
                      'et d’un acte de défense simultané, nécessaire et proportionné à la gravité de l’attaque.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Pour la défense des biens : nécessité d’interrompre l’exécution d’un crime ou d’un délit contre un bien, '
                      'par un acte de défense autre qu’un homicide volontaire, strictement nécessaire au but poursuivi '
                      'et proportionné à la gravité de l’infraction.',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'Lorsque toutes ces conditions sont réunies, la personne n’est pas pénalement responsable : '
                'la légitime défense efface l’infraction. Cela vaut également pour un policier, même s’il n’entre pas dans le cadre de l’article L. 435-1.',
              ),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemple simple de légitime défense',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un policier en repos, non porteur d’insignes, est témoin d’une agression au couteau dans la rue. '
                        'Il utilise son arme, de manière mesurée, pour neutraliser l’agresseur qui allait tuer la victime. '
                        'Même si les conditions de l’article L. 435-1 ne sont pas réunies (absence d’uniforme, pas en service), '
                        'la situation peut être appréciée au regard de l’article 122-5 du Code pénal : '
                        'atteinte injustifiée, actuelle et réelle, défense nécessaire et proportionnée.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 3 — ARTICULATION CONCRÈTE DES DEUX RÉGIMES
          // =====================================================
          _HypoCard(
            title:
                '3. Comment articuler l’article L. 435-1\n   et l’article 122-5 du Code pénal ?',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Dans la pratique, le policier doit savoir dans quel régime il se situe au moment où il fait usage de son arme. '
                'Les deux textes ne s’opposent pas : ils se complètent.',
              ),
              const SizedBox(height: 8),

              // ---- Hypothèse 1
              Text(
                'Hypothèse 1 : toutes les conditions de l’article L. 435-1 sont remplies',
                style: GoogleFonts.fustat(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le policier est dans l’exercice de ses fonctions, identifiable par son uniforme ou des insignes apparents, '
                      'et il se trouve dans l’une des cinq situations prévues par le texte. '
                      'L’usage de l’arme est alors apprécié prioritairement au regard de l’article L. 435-1 du Code de la Sécurité Intérieure.',
                ),
              ]),
              const SizedBox(height: 8),

              // ---- Hypothèse 2
              Text(
                'Hypothèse 2 : une condition préalable manque',
                style: GoogleFonts.fustat(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Par exemple, le policier intervient sans uniforme ni insignes, ou dans un cadre privé, '
                      'ou encore alors qu’il n’est pas clairement dans l’une des cinq situations prévues. '
                      'Dans ce cas, l’article L. 435-1 ne peut pas, à lui seul, justifier l’usage de l’arme.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Cependant, si toutes les conditions de la légitime défense sont remplies '
                      '(atteinte injustifiée, actuelle et réelle ; défense nécessaire et proportionnée), '
                      'l’article 122-5 du Code pénal peut être invoqué pour fonder la non-responsabilité pénale du policier.',
                ),
              ]),
              const SizedBox(height: 8),

              // ---- Hypothèse 3
              Text(
                'Hypothèse 3 : situation couverte par les deux textes',
                style: GoogleFonts.fustat(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Certaines scènes d’attaque armée répondent à la fois aux critères de l’article L. 435-1 '
                      'et à ceux de la légitime défense pénale (article 122-5). '
                      'Dans ce cas, les magistrats peuvent se référer aux deux textes, mais le contrôle de nécessité et de proportionnalité reste identique.',
                ),
              ]),
              const SizedBox(height: 10),

              _NotaBox(
                title: 'Point commun central',
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans tous les cas, qu’il s’agisse de l’article L. 435-1 du Code de la Sécurité Intérieure '
                        'ou de l’article 122-5 du Code pénal, les juges vérifient rigoureusement deux éléments communs :\n\n',
                  ),
                  const TextSpan(
                    text: '• la nécessité réelle de l’usage de l’arme ;\n',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text:
                        '• la stricte proportionnalité entre la riposte et la gravité de la menace.\n\n',
                  ),
                  TextSpan(
                    text:
                        'Le vocabulaire peut varier (nécessité absolue, moyens strictement proportionnés), '
                        'mais l’esprit est le même : l’arme à feu doit rester un ultime recours, mesuré et contrôlé.',
                    style: TextStyle(color: warningColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 4 — PLACE PARTICULIÈRE DE L’ARTICLE L. 211-9
          // =====================================================
          _HypoCard(
            title:
                '4. Dispersion d’un attroupement :\n   l’article L. 211-9 du Code de la Sécurité Intérieure',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'L’article L. 211-9 du Code de la Sécurité Intérieure prévoit un régime spécifique '
                'pour l’usage des armes dans la dispersion d’un attroupement. '
                'Il s’agit principalement de maintien de l’ordre, avec des règles propres sur les sommations, '
                'la gradation des moyens employés et l’autorité habilitée à ordonner le tir.',
              ),
              const SizedBox(height: 8),
              _Paragraph(
                'Ce régime se situe à côté de l’article L. 435-1 et de la légitime défense classique : '
                'il ne se confond pas avec eux. Toutefois, même en maintien de l’ordre, des cas individuels de légitime défense '
                'peuvent survenir (par exemple, un manifestant qui attaque un policier avec une arme blanche). '
                'Dans cette hypothèse, l’article 122-5 du Code pénal peut de nouveau être invoqué.',
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'À retenir en maintien de l’ordre',
                bodySpans: [
                  TextSpan(
                    text:
                        'Le tir ordonné dans le cadre de la dispersion d’un attroupement répond aux règles de l’article L. 211-9. '
                        'Le tir de légitime défense d’un policier agressé individuellement sera, lui, appréciée à la lumière de l’article 122-5 du Code pénal, '
                        'éventuellement combiné avec l’article L. 435-1 si les conditions de ce dernier sont également réunies.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 5 — SYNTHÈSE OPÉRATIONNELLE POUR LE POLICIER
          // =====================================================
          _HypoCard(
            title: '5. Synthèse opérationnelle : le réflexe en 3 questions',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Avant de faire usage de son arme, le policier doit, autant que possible, passer mentalement par trois questions rapides :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      '1) Suis-je dans le champ de l’article L. 435-1 du Code de la Sécurité Intérieure ? '
                      '(exercice de mes fonctions, uniforme ou insignes, menace grave) et dans l’une des cinq situations prévues ?',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      '2) Si une condition manque ou si la situation ne correspond pas aux cinq cas, '
                      'les critères de la légitime défense de l’article 122-5 du Code pénal sont-ils réunis '
                      '(atteinte injustifiée, actuelle et réelle ; défense nécessaire, simultanée et proportionnée) ?',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      '3) En maintien de l’ordre, suis-je dans un tir d’attroupement relevant de l’article L. 211-9, '
                      'ou dans un cas individuel de légitime défense au sens du Code pénal ?',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'Ce raisonnement n’a pas vocation à ralentir l’action, mais à structurer le réflexe professionnel. '
                'Plus le policier connaît ces régimes et leurs articulations, plus il sera capable de prendre, en situation de stress, '
                'une décision juridiquement solide et opérationnellement maîtrisée.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE DE CONTENU
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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

/// ------------------------------------------------------------------
/// PARAGRAPHE SIMPLE / RICH
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
/// PUCE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans, {super.key});

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
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
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withOpacity(isDark ? .65 : .9),
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
                    : const Color(0xFF102027).withOpacity(.95),
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
/// BLOC NOTA
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
