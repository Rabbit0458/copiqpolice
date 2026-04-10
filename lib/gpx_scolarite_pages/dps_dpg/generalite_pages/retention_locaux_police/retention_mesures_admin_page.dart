import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — RÉTENTION DANS LES LOCAUX DE POLICE
///
///  Mesures à caractère administratif
///   - Droit au séjour
///   - Hébergement avant reconduite
///   - Chambre de sûreté (ivresse)
///   - Recueil malades mentaux
///   - Mineurs en fugue
///   - Vérification de situation (terrorisme)
/// ===================================================================
class RetentionMesuresAdminPage extends StatelessWidget {
  const RetentionMesuresAdminPage({super.key});

  static const String routeName =
      '/gpx/generalites/retention_locaux_police/mesures_admin';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color card = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
    final Color accent = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF00897B);
    final Color redAccent = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFD32F2F);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'Mesures à caractère administratif',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'II. Mesures à caractère administratif',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            'Ces rétentions ne s’inscrivent pas directement dans une poursuite pénale. '
            'Elles répondent à des objectifs d’ordre public, de sûreté ou de protection des personnes. '
            'Elles restent toutefois encadrées par la loi, avec des durées maximales et des formalités précises.',
          ),
          const SizedBox(height: 10),
          const _NotaBox(
            title: 'Réflexe général',
            bodySpans: [
              TextSpan(
                text:
                    'Même en matière administrative, la rétention porte atteinte à la liberté d’aller et venir. '
                    'Elle doit donc toujours rester justifiée, nécessaire, proportionnée et limitée dans le temps.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 1 — DROIT AU SÉJOUR
          // =====================================================
          _HypoCard(
            title: '1. Retenue pour vérification du droit au séjour',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Il s’agit d’une mesure de rétention visant à vérifier le droit de circulation ou de séjour '
                'd’une personne de nationalité étrangère sur le territoire français.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Décision par un O.P.J.',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' dans le cadre d’une procédure administrative (droit des étrangers).',
                ),
              ]),
              _BulletPoint.rich([
                const TextSpan(
                  text:
                      'Finalité : vérification du droit au séjour ou à la circulation d’un étranger (titre, visa, situation).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée maximale : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '24 heures',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ', à compter du début de la retenue. Au-delà, une autre mesure doit être prise (ex. placement en rétention administrative, liberté…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Mesure placée sous le contrôle du parquet et/ou du juge compétent, avec respect des droits fondamentaux '
                      '(interprète, information sur la mesure, assistance d’un conseil selon la procédure mise en œuvre, etc.).',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 2 — HÉBERGEMENT AVANT RECONDUITE
          // =====================================================
          _HypoCard(
            title:
                '2. Hébergement des étrangers avant une reconduite à la frontière',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Avant la mise à exécution d’une mesure d’éloignement, certains étrangers peuvent être hébergés '
                'temporairement dans des locaux surveillés.',
              ),
              const SizedBox(height: 10),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La surveillance est assurée par les fonctionnaires de police (policiers de la paix).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La rétention dure uniquement jusqu’à ce que les conditions matérielles du transport soient réunies '
                      '(convocation du vol, escorte, documents de voyage…).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Principe directeur : ',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      'durée strictement limitée au temps nécessaire à l’exécution de la mesure d’éloignement (OQTF, reconduite, expulsion administrative…).',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Dignité',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les conditions matérielles de séjour (alimentation, hygiène, repos) doivent rester compatibles '
                        'avec le respect de la dignité humaine, même en l’absence de procédure pénale.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 3 — CHAMBRE DE SÛRETÉ (IVRESSE)
          // =====================================================
          _HypoCard(
            title: '3. Placement en chambre de sûreté (ivresse)',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La chambre de sûreté vise les personnes en état d’ivresse présentant un danger pour elles-mêmes '
                'ou pour l’ordre public.',
              ),
              const SizedBox(height: 10),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Personnes concernées : ivresse publique et manifeste (IPM), conducteurs en état d’ivresse, '
                      'ou auteurs d’un autre délit commis en état d’ivresse.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Finalité principale : protéger la personne et la collectivité (prévention des accidents, des violences, des troubles).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: 'jusqu’au complet dégrisement',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ', apprécié médicalement et/ou au vu du comportement. La mesure ne doit pas se prolonger plus que nécessaire.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les infractions commises pendant la rétention (dégradations, violences, outrages…) '
                      'restent pénalement poursuivables.',
                ),
              ]),

              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un individu en état d’ivresse publique est trouvé couché sur la chaussée. '
                        'Il est conduit en chambre de sûreté pour sa protection. Il est laissé libre après complet dégrisement et vérifications d’identité.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 4 — RECUEIL MALADES MENTAUX
          // =====================================================
          _HypoCard(
            title: '4. Recueil temporaire des malades mentaux',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Il s’agit d’une mesure exceptionnelle concernant une personne présentant des troubles mentaux '
                'et un danger grave pour elle-même ou pour autrui.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Caractère temporaire et exceptionnel : ',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      'le placement en locaux de police ne doit durer que le temps d’organiser la prise en charge médicale.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La mesure doit aboutir immédiatement au transfert médical dans un établissement spécialisé '
                      '(hospitalisation à la demande d’un tiers, sur décision préfectorale, etc.).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Travail en lien étroit avec les secours, le médecin régulateur SAMU / SMUR et éventuellement le maire ou le préfet.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Respect de la dignité',
                bodySpans: [
                  TextSpan(
                    text:
                        'Même en cas de crise aiguë, la personne doit être traitée avec humanité. '
                        'L’usage de la force (menottage, contention) doit rester strictement nécessaire et proportionné au danger.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 5 — MINEURS EN FUGUE
          // =====================================================
          _HypoCard(
            title: '5. Garde des mineurs en fugue',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Lorsqu’un mineur en fugue est retrouvé, il peut être retenu temporairement dans les locaux de police.',
              ),
              const SizedBox(height: 10),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Finalité : permettre aux personnes qui en ont la garde (parents, tuteurs, ASE…) de le retrouver.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'strictement limitée au temps nécessaire pour contacter la famille, les services sociaux ou le parquet des mineurs, '
                      'et organiser la remise du mineur.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les conditions matérielles doivent être adaptées à l’âge et à la vulnérabilité de l’enfant '
                      '(surveillance, isolement des majeurs, prise en charge bienveillante).',
                ),
              ]),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une adolescente en fugue est découverte dans un hall d’immeuble. '
                        'Elle est conduite au commissariat, prise en charge dans un espace séparé, puis remise à ses parents '
                        'sur instruction du parquet des mineurs.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 6 — VÉRIFICATION DE SITUATION (TERRORISME)
          // =====================================================
          _HypoCard(
            title: '6. Retenue pour vérification de situation – Terrorisme',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Cette mesure vise une personne à l’encontre de laquelle il existe des ',
                ),
                TextSpan(
                  text: 'raisons sérieuses de penser',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' que son comportement peut être lié à des activités à caractère terroriste.',
                ),
              ]),
              const SizedBox(height: 10),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La personne peut être retenue pour vérification de sa situation même si elle présente un document d’identité valable.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée maximale : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '4 heures',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(text: ', à compter du début du contrôle.'),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Mesure particulièrement sensible : elle nécessite une traçabilité complète, une information rapide du parquet '
                      'et un contrôle strict de la proportionnalité des moyens employés.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Traçabilité renforcée',
                bodySpans: [
                  TextSpan(
                    text:
                        'Horaires de début et de fin, motifs précis, éléments factuels justifiant les “raisons sérieuses de penser” '
                        'doivent être consignés avec soin dans les procédures.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // SYNTHÈSE / POINT DE VIGILANCE
          // =====================================================
          _HypoCard(
            title: 'Point de vigilance – Ne pas contourner le cadre judiciaire',
            cardColor: card,
            accent: redAccent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les mesures administratives ne doivent jamais servir à contourner le cadre de la ',
                ),
                TextSpan(
                  text: 'garde à vue',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' ou des autres procédures judiciaires. Un usage abusif peut entraîner la nullité de la procédure et engager la responsabilité de l’État.',
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toujours pouvoir expliquer : le fondement légal, la durée, la finalité de la rétention et les garanties offertes à la personne.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'En cas d’hésitation entre un cadre administratif et judiciaire, réflexe : appel au gradé, au parquet ou au COG.',
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

//
//  ===================================================================
//  WIDGETS TEMPLATE (identiques à LdPersonnesPage / mesures judiciaires)
//  ===================================================================

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
    final color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
