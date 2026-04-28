import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — RECOURS DEVANT LES ORGANES INTERNATIONAUX
///
///  Synthèse des principaux mécanismes ouverts aux ressortissants
///  français en cas d’atteinte aux droits fondamentaux :
///    • Comité pour l’élimination de la discrimination raciale (ONU)
///    • Cour européenne des droits de l’Homme (CEDH)
///    • Cour de justice de l’Union européenne (CJUE)
/// ===================================================================
class RecoursOrganesInternationauxPage extends StatelessWidget {
  const RecoursOrganesInternationauxPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/garanties/recours_organes_internationaux';

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
        ? const Color(0xFF1565C0)
        : const Color(0xFF0D47A1);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
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
          'Recours devant les organes internationaux',
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
          // ================= TITRE + INTRO =================
          Text(
            'Les recours devant les organes internationaux',
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
                  'Au-delà des juridictions françaises, certains organes internationaux peuvent être saisis par les ressortissants français lorsqu’ils estiment que leurs droits fondamentaux ont été violés. ',
            ),
            TextSpan(
              text:
                  'Ces mécanismes complètent la protection interne : ils jouent un rôle de “filet de sécurité” lorsque les recours nationaux ont été épuisés.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 14),
          const _NotaBox(
            title: 'Principe de subsidiarité',
            bodySpans: [
              TextSpan(
                text:
                    'D’une manière générale, un recours international n’est recevable que si la personne a d’abord utilisé les voies de recours internes (tribunaux français) sans obtenir satisfaction. '
                    'Les organes internationaux n’interviennent donc qu’en dernier ressort, pour contrôler le respect des engagements pris par la France.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — COMITÉ POUR L’ÉLIMINATION DE LA DISCRIMINATION RACIALE
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 1 — Le comité pour l’élimination de la discrimination raciale',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Ce comité est un organe des Nations Unies créé en 1969, à la suite de l’entrée en vigueur de la ',
                ),
                TextSpan(
                  text:
                      'Convention internationale sur l’élimination de toutes les formes de discrimination raciale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', ratifiée par la France en 1971. Sa mission est de veiller à l’application effective des droits garantis par cette convention.',
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Composition : 18 experts indépendants, élus pour quatre ans par les États parties à la convention. Le comité siège à Genève, environ deux mois par an (sessions au printemps et en été).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Contrôle de la mise en œuvre : les États doivent présenter régulièrement des rapports sur la lutte contre les discriminations raciales sur leur territoire. Le comité formule des recommandations.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Recours individuel : depuis 1982, toute personne s’estimant victime, de la part de l’État français, d’une discrimination raciale peut saisir le comité, ',
                ),
                TextSpan(
                  text:
                      'à condition d’avoir au préalable épuisé les recours juridictionnels internes.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ]),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Exemple de situation',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une personne dénonce un traitement discriminatoire fondé sur l’origine ou la couleur de peau dans l’accès à un service public. '
                        'Après avoir porté l’affaire devant les juridictions françaises sans résultat satisfaisant, elle peut déposer une communication individuelle devant le comité, qui examinera la conformité de la pratique avec la convention.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — COUR EUROPÉENNE DES DROITS DE L’HOMME
          // =====================================================
          _HypoCard(
            title: 'Chapitre 2 — La Cour européenne des droits de l’Homme',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Depuis sa création en 1959, la Cour européenne des droits de l’Homme (CEDH) n’a cessé de prendre de l’ampleur. Elle veille au respect de la ',
                ),
                TextSpan(
                  text: 'Convention européenne des droits de l’Homme de 1950',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' dans les États membres du Conseil de l’Europe. Son siège est à Strasbourg et elle compte autant de juges que d’États parties.',
                ),
              ]),
              const SizedBox(height: 8),
              const Text(
                '2.1 — Qui peut saisir la CEDH ?',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Un État contre un autre État (requête étatique) ; ce type de recours demeure rare.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toute personne physique, ONG ou groupe de particuliers (requête individuelle) s’estimant victime d’une violation de la Convention par un État partie, après épuisement des recours internes.',
                ),
              ]),
              const SizedBox(height: 8),
              const Text(
                '2.2 — Effets des décisions',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Lorsque la Cour constate une violation, elle peut accorder une satisfaction équitable à la victime (dommages-intérêts) et, surtout, '
                'oblige l’État condamné à modifier sa législation ou ses pratiques pour se conformer à la Convention. Les arrêts ont donc un impact direct sur le droit français.',
              ),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Condamnations de la France',
                bodySpans: [
                  TextSpan(
                    text:
                        'La France a déjà été condamnée à plusieurs reprises pour des atteintes aux droits fondamentaux : '
                        'conditions de détention et surpopulation carcérale, réglementation des étrangers, protection de la vie familiale, etc. '
                        'Ces condamnations ont conduit à des réformes importantes du droit interne.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 3 — COUR DE JUSTICE DE L’UNION EUROPÉENNE
          // =====================================================
          _HypoCard(
            title: 'Chapitre 3 — La Cour de justice de l’Union européenne',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La Cour de justice de l’Union européenne (CJUE) est l’institution juridictionnelle de l’UE, chargée d’assurer le respect du ',
                ),
                TextSpan(
                  text: 'droit de l’Union',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' dans l’interprétation et l’application des traités. Son siège est établi à Luxembourg.',
                ),
              ]),
              const SizedBox(height: 8),
              const Text(
                '3.1 — Compétences principales',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Trancher les litiges entre les institutions de l’UE et les États membres (recours en manquement, annulation d’actes, etc.) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Interpréter le droit de l’Union à la demande des juridictions nationales via le ',
                ),
                TextSpan(
                  text: 'renvoi préjudiciel',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ' : une question posée par un juge français sur la signification d’une règle européenne ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Connaître de certains recours introduits par des particuliers ou des entreprises contre les institutions de l’UE (notamment devant le Tribunal).',
                ),
              ]),
              const SizedBox(height: 8),
              const Text(
                '3.2 — Organisation',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'La Cour de justice de l’Union européenne comprend deux juridictions : '
                'la Cour de justice (formation la plus solennelle) et le Tribunal. '
                'En pratique, de nombreuses questions relatives aux libertés publiques (protection des données, non-discrimination, droits des travailleurs, etc.) '
                'passent par la CJUE via les renvois préjudiciels formés par les juges nationaux.',
              ),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Intérêt pour le policier',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les règles européennes sur la protection des données personnelles, la non-discrimination ou la libre circulation influencent directement les pratiques policières (fichiers, contrôles, coopération européenne). '
                        'Les arrêts de la CJUE peuvent donc conduire à adapter la réglementation française et les instructions données aux services.',
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

/// ------------------------------------------------------------------
/// CARTE DE CONTENU (bloc structuré)
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
        child: DefaultTextStyle(
          style: GoogleFonts.fustat(
            fontSize: 14,
            height: 1.4,
            color: textColor,
          ),
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
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES (texte simple ou riche)
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
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans, {super.key});

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✓ ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
/// BLOC NOTA / MISE EN GARDE
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
