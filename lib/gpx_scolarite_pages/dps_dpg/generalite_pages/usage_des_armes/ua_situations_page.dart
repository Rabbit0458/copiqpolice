import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — USAGE DES ARMES
///
///  II. Les cinq situations d’usage des armes
///      prévues par l’article L. 435-1 du Code de la Sécurité Intérieure
///
///   - Rappel : conditions préalables obligatoires
///   - 1) Atteintes à la vie ou à l’intégrité physique / personnes armées
///   - 2) Défense des lieux occupés et des personnes confiées
///   - 3) Fuite d’un individu dangereux placé sous garde
///   - 4) Immobilisation d’un véhicule occupé par un ou plusieurs
///        individus dangereux (refus d’obtempérer)
///   - 5) Périple meurtrier
/// ===================================================================
class UaSituationsPage extends StatelessWidget {
  const UaSituationsPage({super.key});

  static const String routeName = '/gpx/generalites/usagedesarmes/situations';

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
    final Color dangerColor = const Color(0xFFFF3B30);

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
          'Les 5 situations d’usage des armes',
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
          // ================= TITRE + INTRO =================
          Text(
            'II. Les cinq situations prévues pour l’usage des armes\n'
            '(article L. 435-1 du Code de la Sécurité Intérieure)',
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
                  'Sous réserve que les trois conditions préalables à l’usage d’une arme soient réunies '
                  '(agir dans l’exercice de ses fonctions, être identifiable comme policier, respecter la nécessité absolue et la proportionnalité), '
                  'les policiers sont autorisés à faire usage de leur arme dans cinq situations précises définies par ',
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
                  ', hors les cas particuliers de dispersion d’un attroupement prévus par l’article L. 211-9 du même code '
                  'et hors le régime général de la légitime défense prévu par l’article 122-5 du Code pénal.',
            ),
          ]),
          const SizedBox(height: 14),
          _NotaBox(
            title: 'Principe essentiel',
            bodySpans: [
              TextSpan(
                text:
                    'Même lorsqu’une situation entre dans l’un des cas prévus par l’article L. 435-1 du Code de la Sécurité Intérieure, '
                    'l’usage de l’arme à feu reste une mesure de dernier recours. Le policier doit toujours vérifier que le tir est absolument nécessaire '
                    'et strictement proportionné au danger, et que les autres moyens de contrainte se révèlent insuffisants ou inadaptés.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // 1 — ATTEINTES À LA VIE / PERSONNES ARMÉES
          // =====================================================
          _HypoCard(
            title:
                '1. Atteintes à la vie ou à l’intégrité physique\n   / personnes armées menaçantes',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La première situation d’usage des armes est prévue par le ',
                  style: const TextStyle(),
                ),
                TextSpan(
                  text:
                      '1° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: ' et vise les cas où :'),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Des atteintes à la vie ou à l’intégrité physique sont portées contre les policiers eux-mêmes ou contre un tiers ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Des personnes armées menacent la vie ou l’intégrité physique des policiers ou d’un tiers.',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                'Cette situation est celle qui se rapproche le plus de la légitime défense classique prévue par le Code pénal. '
                'Compte tenu de l’imminence de l’atteinte à la vie ou à l’intégrité physique, il n’est pas prévu que les policiers procèdent à des sommations avant de faire usage de leur arme.',
              ),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemples typiques',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Un individu tire à balles réelles sur les policiers depuis la voie publique.\n',
                  ),
                  TextSpan(
                    text:
                        '• Une personne armée d’un couteau se rue sur un passant en menaçant de le tuer, '
                        'malgré les ordres de lâcher son arme.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 2 — DÉFENSE DES LIEUX OCCUPÉS / PERSONNES CONFIÉES
          // =====================================================
          _HypoCard(
            title: '2. Défense des lieux occupés\n   et des personnes confiées',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La deuxième situation d’usage des armes est prévue par le ',
                ),
                TextSpan(
                  text:
                      '2° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Elle concerne la défense des lieux que les policiers occupent ou des personnes qui leur sont confiées. '
                      'Dans cette hypothèse, les sommations sont obligatoires.',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'L’usage de l’arme est possible après avoir procédé à deux sommations faites à haute voix, '
                'lorsque les policiers ne peuvent défendre autrement :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les lieux qu’ils occupent à titre permanent, par exemple un poste de police, un centre de rétention administrative ou un local de service ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les personnes qui leur sont confiées, telles qu’une personne bénéficiant d’une protection rapprochée, '
                      'une personne placée en garde à vue ou en rétention, ou encore une personne interpellée ou victime se trouvant sur les lieux d’une infraction.',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Illustration',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une patrouille assure la protection d’un centre de rétention administrative. '
                        'Un groupe tente de forcer l’entrée avec des barres de fer pour libérer un retenu. '
                        'Après deux sommations restées sans effet et en l’absence d’autre moyen efficace, '
                        'l’usage de l’arme peut être envisagé dans le respect strict de la proportionnalité.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 3 — FUITE D’UN INDIVIDU DANGEREUX SOUS GARDE
          // =====================================================
          _HypoCard(
            title:
                '3. Fuite d’un individu dangereux\n   placé sous la garde des policiers',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La troisième situation d’usage des armes est prévue par le ',
                ),
                TextSpan(
                  text:
                      '3° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Elle vise la fuite d’un individu dangereux placé sous la garde des policiers. '
                      'Dans ce cas également, les sommations sont obligatoires.',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'L’usage de l’arme est possible après deux sommations faites à haute voix, '
                'lorsque les policiers ne peuvent autrement arrêter :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Une personne qui cherche à échapper à leur garde ou à leurs investigations ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Une personne qui prend la fuite alors qu’elle se trouve déjà sous leur garde, '
                      'par exemple une personne placée en garde à vue ou une personne conduite au tribunal.',
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'Mais cette possibilité n’existe que si les policiers disposent de ',
                  style: const TextStyle(),
                ),
                TextSpan(
                  text: 'raisons réelles et objectives ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
                const TextSpan(
                  text:
                      'de penser que, au moment où la personne prend la fuite, celle-ci va porter atteinte à la vie ou à l’intégrité physique '
                      'des policiers ou d’autrui, et qu’il n’existe pas d’autres moyens de l’empêcher.',
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Il peut s’agir, par exemple, d’un individu connu pour avoir déjà commis ou tenté de commettre des infractions violentes, '
                      'ou ayant proféré des menaces de passage à l’acte crédibles.',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'Même si l’individu en fuite pourrait être arrêté plus tard par d’autres moyens, '
                'l’usage de l’arme ne pourra être considéré comme légitime que si, au moment précis de la fuite, '
                'la personne représente encore une menace réelle. Une simple crainte ou un soupçon ne suffit pas.',
              ),
              const SizedBox(height: 12),

              const _NotaBox(
                title: 'Formule des sommations',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les sommations doivent être faites à haute voix, de manière claire, '
                        'pour que la personne prenne conscience du risque qu’elle encourt en refusant d’obtempérer. '
                        'Elles prennent traditionnellement la forme suivante :\n\n',
                  ),
                  TextSpan(
                    text: '• Première sommation : « Halte police ! »\n',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        '• Deuxième sommation : « Halte ou je fais feu ! »\n\n',
                  ),
                  TextSpan(
                    text:
                        'Ces sommations doivent se succéder dans un temps court, avant tout usage de l’arme, '
                        'sauf impossibilité liée à l’urgence absolue de la situation.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 4 — IMMOBILISATION D’UN VÉHICULE DANGEREUX
          // =====================================================
          _HypoCard(
            title:
                '4. Immobilisation d’un véhicule occupé\n   par un ou plusieurs individus dangereux',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La quatrième situation concerne l’immobilisation d’un véhicule (ou de tout autre moyen de transport) '
                      'occupé par un ou plusieurs individus dangereux. Elle est prévue par le ',
                ),
                TextSpan(
                  text:
                      '4° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' et s’applique notamment en cas de refus d’obtempérer à un ordre d’arrêt.',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'Les policiers peuvent faire usage de leur arme lorsqu’ils ne peuvent immobiliser autrement un véhicule, '
                'une embarcation ou tout autre moyen de transport et que les deux conditions suivantes sont réunies :',
              ),
              const SizedBox(height: 8),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le conducteur n’a pas obtempéré immédiatement à un ordre d’arrêt explicite. '
                      'Cet ordre peut résulter d’un dispositif lumineux ou sonore, d’un geste réglementaire, de l’usage d’un sifflet, '
                      'de la mise en place d’un barrage routier ou de tout autre moyen clairement identifiable.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les policiers disposent de raisons réelles et objectives de penser que les occupants du véhicule '
                      'sont susceptibles de porter atteinte, dans leur fuite, à la vie ou à l’intégrité physique des policiers ou d’autrui.',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'L’ordre d’arrêt doit être dépourvu d’ambiguïté et clairement compris par le conducteur. '
                'Il ne peut en aucun cas être fait usage de l’arme pour contraindre un véhicule à s’arrêter '
                'lorsqu’aucun danger grave et actuel n’est identifié concernant ses occupants ou leur comportement.',
              ),
              const SizedBox(height: 10),

              const _ExempleBox(
                title: 'Exemple opérationnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un véhicule, signalé comme pouvant transporter des individus armés ayant commis une agression violente, '
                        'force un contrôle routier et fonce vers une zone très fréquentée. Après un ordre d’arrêt très clairement donné et resté sans effet, '
                        'et en l’absence d’autre moyen pour stopper la progression du véhicule, l’usage de l’arme dirigée vers les éléments mécaniques '
                        'peut être envisagé pour l’immobiliser, sous réserve de la stricte proportionnalité.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 5 — PÉRIPLE MEURTRIER
          // =====================================================
          _HypoCard(
            title: '5. Le périple meurtrier',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La cinquième situation vise le cas du périple meurtrier, c’est-à-dire un individu qui vient de commettre ou de tenter de commettre '
                      'un ou plusieurs meurtres et qui semble déterminé à recommencer. Elle est prévue par le ',
                ),
                TextSpan(
                  text:
                      '5° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'Les policiers sont autorisés à faire usage de leur arme contre un individu dans cette situation lorsque les trois conditions suivantes sont réunies :',
              ),
              const SizedBox(height: 8),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’individu vient de commettre ou de tenter de commettre un ou plusieurs meurtres ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Au moment où il fait usage de son arme, le policier dispose de raisons réelles et objectives de penser, '
                      'au regard des informations dont il dispose à cet instant précis et du contexte, qu’une réitération de ces crimes est probable ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’usage de l’arme est le seul moyen et a pour but exclusif d’empêcher la réitération de ces crimes dans un temps rapproché.',
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                'Cette hypothèse correspond aux scénarios les plus graves (tueur itinérant, attaque armée en plusieurs lieux, etc.). '
                'Elle justifie un usage extrêmement déterminé de la force, mais toujours strictement encadré par l’exigence de nécessité absolue et de proportionnalité.',
              ),
              const SizedBox(height: 10),

              const _ExempleBox(
                title: 'Exemple de périple meurtrier',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un individu vient d’ouvrir le feu dans un lieu public, faisant plusieurs victimes, et prend la fuite en conservant son arme. '
                        'Les informations collectées par la police laissent penser qu’il se dirige vers un autre site très fréquenté pour recommencer. '
                        'Si aucun autre moyen ne permet de mettre fin à ce périple dans un temps très court, l’usage de l’arme visant à neutraliser l’individu '
                        'peut être autorisé dans le cadre du 5° de l’article L. 435-1 du Code de la Sécurité Intérieure.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ====================== SYNTHÈSE FINALE ======================
          _HypoCard(
            title: 'Synthèse : lire la situation AVANT de tirer',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'Avant tout usage de l’arme, le policier doit se poser deux séries de questions :',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les trois conditions préalables sont-elles remplies ? '
                      '(exercice des fonctions, identification policière, nécessité absolue et proportionnalité).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La situation que je suis en train de gérer correspond-elle clairement à l’un des cinq cas prévus par l’article L. 435-1 du Code de la Sécurité Intérieure ?',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                'Si l’une de ces réponses est négative, l’usage de l’arme doit être écarté ou réexaminé. '
                'Dans certains cas, le policier pourra éventuellement invoquer le régime général de la légitime défense prévu par le Code pénal, '
                'mais toujours sous le contrôle strict de la nécessité et de la proportionnalité.',
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
