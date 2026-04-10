import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — USAGE DES ARMES
///
///  I. Les trois conditions préalables à l’usage d’une arme
///     - Cadre général de l’art. L. 435-1 C.S.I.
///     - 1) Agir dans l’exercice de ses fonctions
///     - 2) Être en uniforme ou avec des insignes apparents
///     - 3) Absolue nécessité et stricte proportionnalité
/// ===================================================================
class UaConditionsPrealablesPage extends StatelessWidget {
  const UaConditionsPrealablesPage({super.key});

  static const String routeName =
      '/gpx/generalites/usagedesarmes/conditions_prealables';

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
          'Les 3 conditions préalables',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE PRINCIPAL =================
          Text(
            'LE CADRE LÉGAL D’USAGE DES ARMES\n'
            'I. Les trois conditions préalables (article L. 435-1 du Code de la Sécurité Intérieure)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),

          // ================= INTRO GÉNÉRALE =================
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Un cadre légal d’usage des armes commun aux agents de la Police nationale et de la Gendarmerie nationale est prévu par ',
            ),
            TextSpan(
              text: 'l’article L. 435-1 du Code de la Sécurité Intérieure',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  '. Ce cadre s’applique à tous les policiers régulièrement armés '
                  '(fonctionnaires actifs, policiers adjoints et réservistes) lorsqu’ils font usage de leur arme, '
                  'dans l’exercice de leurs fonctions.',
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            const TextSpan(
              text: 'Cet article constitue un cadre juridique spécifique. ',
            ),
            TextSpan(
              text: 'L’article L. 435-1 du Code de la Sécurité Intérieure',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  ' impose en effet trois conditions préalables à l’usage d’une arme par un policier et définit cinq situations dans lesquelles un tel usage peut intervenir. '
                  'Tant que ces trois conditions ne sont pas réunies, les règles particulières d’usage des armes issues de cet article ne sont pas applicables.',
            ),
          ]),
          const SizedBox(height: 18),

          // =====================================================
          // 1 — AGIR DANS L’EXERCICE DE SES FONCTIONS
          // =====================================================
          _HypoCard(
            title: '1. Le policier doit agir dans l’exercice de ses fonctions',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Pour que les règles de l’usage des armes puissent être invoquées, '
                'le policier doit d’abord agir dans l’exercice de ses fonctions. '
                'Cette exigence permet de distinguer les interventions professionnelles des situations purement privées.',
              ),
              const SizedBox(height: 8),

              // a) Pendant le service
              _Paragraph.rich([
                const TextSpan(
                  text: 'Le policier agit dans l’exercice de ses fonctions : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'lorsqu’il intervient pendant son temps de service et dans le cadre de ses missions habituelles '
                      '(interpellations, contrôles, sécurisation de lieux, protection de personnes, etc.).',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Il intervient alors sur instruction de sa hiérarchie ou dans le cadre d’une mission de police judiciaire ou de police administrative, '
                      'liée directement à ses attributions.',
                ),
              ]),

              const SizedBox(height: 8),

              // b) Hors service mais au titre des textes qui l’y obligent
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le policier peut également agir dans l’exercice de ses fonctions lorsqu’il est hors service, ',
                ),
                const TextSpan(
                  text:
                      'à la condition expresse d’intervenir en application de textes particuliers : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les articles R. 434-19 du Code de la Sécurité Intérieure et 113-3 du Règlement Général d’Emploi de la Police Nationale ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'imposent au policier, même lorsqu’il n’est pas en service, d’intervenir de sa propre initiative '
                      'pour porter assistance à toute personne en danger, lorsqu’il peut agir sans risque disproportionné pour lui-même ou pour autrui.',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Dans ce cadre, l’usage de l’arme reste strictement encadré : l’agent demeure soumis aux mêmes obligations '
                      'de nécessité, de proportionnalité et de maîtrise de la force que lorsqu’il est en service.',
                ),
              ]),
              const SizedBox(height: 10),

              // NOTA sur les policiers adjoints
              const _NotaBox(
                title: 'NOTA – Situation des policiers adjoints',
                bodySpans: [
                  TextSpan(
                    text:
                        'Contrairement aux fonctionnaires de la Police nationale titulaires, les policiers adjoints ne peuvent pas, en pratique, '
                        'se prévaloir de ce cadre hors service pour le port de leur arme. En effet, les dispositions de ',
                  ),
                  TextSpan(
                    text:
                        'l’article L. 435-1 du Code de la Sécurité Intérieure',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        ' ne peuvent être mises en œuvre en dehors du service pour eux, '
                        'car ils ne sont pas autorisés à conserver leur arme individuelle en dehors des heures de service, '
                        'conformément aux articles R. 411-7 du Code de la Sécurité Intérieure et 134-4 du Règlement Général d’Emploi de la Police Nationale.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 2 — UNIFORME OU INSIGNES EXTÉRIEURS ET APPARENTS
          // =====================================================
          _HypoCard(
            title:
                '2. Le policier doit être revêtu de son uniforme ou d’insignes extérieurs et apparents de sa qualité',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'La deuxième condition préalable impose que le policier soit clairement identifiable comme représentant de la force publique. '
                'L’usage d’une arme par un agent de police est en effet un acte d’autorité qui doit pouvoir être rattaché, sans ambiguïté, '
                'à l’exercice de ses fonctions officielles.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Cette condition est remplie lorsque le policier est revêtu de son uniforme réglementaire ou lorsqu’il porte des insignes extérieurs et apparents de sa qualité, ',
                ),
                const TextSpan(
                  text:
                      'par exemple un brassard « POLICE », une chasuble ou tout autre signe distinctif immédiatement reconnaissable par la population.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le port d’insignes apparents permet de garantir la lisibilité de l’action policière, de limiter les risques de confusion avec un particulier armé et de renforcer la confiance du public.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'NOTA – Spécificité pour les policiers adjoints',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les policiers adjoints ne peuvent être porteurs de leur arme de service qu’en tenue d’uniforme. '
                        'Ils ne sont pas autorisés à porter leur arme en civil, même avec un simple brassard. '
                        'Cette obligation découle notamment des articles R. 411-7 du Code de la Sécurité Intérieure '
                        'et 134-4 du Règlement Général d’Emploi de la Police Nationale.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 3 — ABSOLUE NÉCESSITÉ ET STRICTE PROPORTIONNALITÉ
          // =====================================================
          _HypoCard(
            title:
                '3. L’usage de l’arme n’est possible qu’en cas d’absolue nécessité\n   et de manière strictement proportionnée',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'La troisième condition préalable est au cœur du contrôle exercé par les juges sur l’usage des armes : '
                'le recours à l’arme doit être à la fois absolument nécessaire et strictement proportionné. '
                'Il s’agit d’une exigence très forte, qui conditionne la légalité de l’acte.',
              ),
              const SizedBox(height: 8),

              // Absolue nécessité
              _Paragraph.rich([
                TextSpan(
                  text: 'L’« absolue nécessité » ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'suppose l’existence d’une menace grave, actuelle ou imminente, '
                      'pesant sur la vie ou l’intégrité physique du policier lui-même ou d’une ou plusieurs autres personnes. '
                      'Au moment précis où il fait usage de son arme, le policier doit disposer de raisons réelles, sérieuses et objectivement vérifiables '
                      'de penser que l’individu est dangereux et susceptible de porter une telle atteinte.',
                ),
              ]),
              const SizedBox(height: 8),

              // Proportionnalité
              _Paragraph.rich([
                TextSpan(
                  text: 'La « stricte proportionnalité » ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'implique que l’usage de l’arme soit le moyen le moins dangereux disponible pour écarter la menace. '
                      'La riposte doit être mesurée : le type d’arme utilisé, le nombre de tirs, la zone visée et le contexte '
                      'doivent rester en rapport avec la gravité de la menace. Toute réaction manifestement excessive peut être pénalement sanctionnée.',
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph(
                'En pratique, les magistrats examinent toujours si d’autres moyens de contrainte (ordre verbal, usage de la force physique, '
                'emploi d’armes intermédiaires, appel de renforts, mise à distance, etc.) auraient permis de gérer la situation sans recourir au tir. '
                'L’usage de l’arme à feu doit donc rester une ultime solution.',
              ),
              const SizedBox(height: 12),

              // Lien avec la légitime défense (Code pénal)
              const _NotaBox(
                title: 'Lien avec la légitime défense prévue par le Code pénal',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les critères de nécessité et de proportionnalité sont également ceux qui gouvernent la légitime défense en droit pénal. '
                        'Lorsque l’une des trois conditions préalables posées par l’article L. 435-1 du Code de la Sécurité Intérieure n’est pas remplie '
                        '(par exemple, un policier intervient dans l’exercice de ses fonctions sans porter d’insignes extérieurs et apparents de sa qualité), ',
                  ),
                  TextSpan(
                    text: 'l’article 122-5 du Code pénal',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        ' peut toutefois être invoqué si l’ensemble des conditions de la légitime défense sont réunies. '
                        'Dans ce cas, l’usage de l’arme sera apprécié selon le régime général de la légitime défense '
                        '(atteinte injustifiée, actuelle et réelle, acte de défense nécessaire et proportionné à cette atteinte).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ================= SYNTHÈSE OPÉRATIONNELLE =================
          _HypoCard(
            title: 'Synthèse opérationnelle des trois conditions',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Avant tout usage de l’arme, le policier doit, autant que possible, vérifier mentalement ces trois points :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Suis-je bien dans l’exercice de mes fonctions (en service ou, le cas échéant, en intervention hors service prévue par les textes) ?',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Suis-je identifiable comme policier par mon uniforme ou par des insignes extérieurs et apparents de ma qualité ?',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’usage de l’arme est-il réellement la seule solution pour écarter une menace grave sur la vie ou l’intégrité physique, '
                      'et ma réaction est-elle strictement proportionnée à cette menace ?',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                'Si l’une de ces réponses est négative, le policier doit privilégier d’autres moyens d’action et, le cas échéant, '
                's’interroger sur l’application éventuelle du régime général de la légitime défense prévu par le Code pénal.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//
// ================== WIDGETS UTILITAIRES (inchangés) ==================
//

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

class _BulletPoint extends StatelessWidget {
  final List<InlineSpan> spans;

  const _BulletPoint.rich(this.spans, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

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
