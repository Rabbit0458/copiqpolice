import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — RÉTENTION DANS LES LOCAUX DE POLICE
///
///  Mesures à caractère judiciaire
///   - Garde à vue
///   - Retenue des mineurs 10–13 ans
///   - Vérification d’identité
///   - Mandats (amener / arrêt / recherche)
///   - Retenue judiciaire (contrainte / obligations)
/// ===================================================================
class RetentionMesuresJudiciairesPage extends StatelessWidget {
  const RetentionMesuresJudiciairesPage({super.key});

  static const String routeName =
      '/gpx/generalites/retention_locaux_police/mesures_judiciaires';

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
          'Mesures à caractère judiciaire',
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
            'II. Mesures à caractère judiciaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            'Les mesures judiciaires de rétention sont décidées dans le cadre d’une procédure pénale. '
            'Elles permettent de maintenir une personne à la disposition de la justice pendant un temps limité, '
            'sous le contrôle de l’autorité judiciaire.',
          ),
          const SizedBox(height: 10),
          _NotaBox(
            title: 'Fil conducteur',
            bodySpans: [
              TextSpan(
                text:
                    'Pour chaque mesure, le policier doit connaître : le texte applicable, qui décide, la durée maximale '
                    'et les droits de la personne retenue (avocat, médecin, tiers, interprète, etc.).',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 1 — GARDE À VUE
          // =====================================================
          _HypoCard(
            title: '1. La garde à vue',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La garde à vue (GAV) est la mesure de rétention judiciaire de référence. '
                'Elle permet de maintenir à la disposition de l’enquête une personne soupçonnée d’avoir commis une infraction.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Décision par un O.P.J.',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : dans le cadre d’une procédure judiciaire (enquête de flagrance, préliminaire, commission rogatoire).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée initiale : ',
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
                      ', pouvant être prolongée de 24 heures supplémentaires sur décision du procureur ou du juge.',
                ),
              ]),
              _BulletPoint.rich([
                const TextSpan(
                  text:
                      'Durée globale pouvant atteindre : 96 h pour certaines infractions liées à la criminalité organisée et au trafic de stupéfiants, '
                      'et jusqu’à 144 h pour les affaires de terrorisme, sous contrôle strict du magistrat (JLD / juge d’instruction).',
                ),
              ]),
              _BulletPoint.rich([
                const TextSpan(
                  text:
                      'La GAV s’accompagne de droits immédiats : notification des faits, droit à un avocat, à un médecin, à prévenir un proche, '
                      'droit à l’interprète, information sur la durée et les prolongations possibles.',
                ),
              ]),

              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Un auteur présumé de vol à main armée est interpellé en flagrant délit. Il est placé en garde à vue pour 24 h, '
                        'puis la mesure est prolongée de 24 h après accord du parquet compte tenu des investigations à mener (auditions, perquisitions, etc.).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 2 — RETENUE DES MINEURS DE 10 À 13 ANS
          // =====================================================
          _HypoCard(
            title: '2. Retenue des mineurs de 10 à 13 ans',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Pour les mineurs de 10 à 13 ans, la garde à vue n’est pas possible. '
                'Une mesure spécifique de retenue peut toutefois être décidée pour les besoins de l’enquête.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Décision par un O.P.J.',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : lorsqu’il existe des raisons plausibles de présumer que le mineur a commis un crime ou un délit puni d’au moins 5 ans d’emprisonnement.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée maximale : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '12 heures',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(text: ', prolongeable exceptionnellement de '),
                TextSpan(
                  text: '12 heures supplémentaires',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les titulaires de l’autorité parentale doivent être informés. L’assistance d’un avocat et l’intervention d’un médecin '
                      'sont adaptées à l’âge et à la vulnérabilité du mineur.',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Spécificité mineurs',
                bodySpans: [
                  TextSpan(
                    text:
                        'Les conditions d’audition (durée des entretiens, pauses, présence d’un adulte) doivent respecter l’intérêt supérieur de l’enfant. '
                        'Toute violence ou pression est proscrite.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 3 — VÉRIFICATION D’IDENTITÉ
          // =====================================================
          _HypoCard(
            title: '3. La vérification d’identité',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lors d’un contrôle, si une personne refuse ou est dans l’impossibilité de justifier de son identité, elle peut, en cas de nécessité, '
                      'être conduite au commissariat pour vérification. L’article ',
                ),
                TextSpan(
                  text: '78-3 du Code de procédure pénale',
                  style: TextStyle(fontWeight: FontWeight.w700, color: accent),
                ),
                const TextSpan(text: ' encadre cette mesure.'),
              ]),
              const SizedBox(height: 10),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La personne doit être présentée immédiatement à un O.P.J., qui décide des suites.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée maximale de rétention : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '4 heures',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' à compter du début du contrôle (8 heures à Mayotte). Au-delà, la personne doit être laissée libre ou placée sous un autre régime légal (ex. GAV).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La mesure doit être proportionnée : pas de recours automatique à la vérification d’identité en local lorsque des pièces peuvent être présentées sur place.',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lors d’un contrôle de nuit, une personne prétend avoir oublié ses papiers et donne un état civil incertain. '
                        'L’OPJ décide de la retenir pour vérification d’identité : la durée ne peut pas dépasser 4 h à compter du début du contrôle.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 4 — MANDAT D’AMENER / MANDAT D’ARRÊT
          // =====================================================
          _HypoCard(
            title: '4. Exécution d’un mandat d’amener ou d’arrêt',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Le mandat est un ordre écrit donné par l’autorité judiciaire à la force publique. '
                'Il impose l’arrestation d’une personne et sa présentation devant le magistrat qui l’a délivré.',
              ),
              const SizedBox(height: 10),

              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Mandat d’amener : ordre de conduire la personne devant le magistrat, qui décidera des suites (mise en examen, contrôle judiciaire, détention…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Mandat d’arrêt : ordre de rechercher et d’arrêter la personne pour la présenter au magistrat ou la placer en détention.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée de rétention en locaux de police : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'limitée au temps strictement nécessaire à la notification du mandat, aux formalités d’identification et à l’avis au magistrat.',
                ),
              ]),

              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Traçabilité',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’heure d’arrivée, de notification du mandat et de départ vers la juridiction ou l’établissement pénitentiaire doit être rigoureusement consignée (main courante, registre).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 5 — MANDAT DE RECHERCHE
          // =====================================================
          _HypoCard(
            title: '5. Exécution d’un mandat de recherche',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Le mandat de recherche est un ordre donné par l’autorité judiciaire à la force publique de rechercher une personne déterminée.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                const TextSpan(
                  text:
                      'Lorsqu’elle est trouvée, la personne est interpellée et placée en garde à vue, sur la base du mandat de recherche.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'La rétention en locaux de police',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' se fait donc sous le régime de la GAV, avec l’ensemble des droits afférents (information, avocat, médecin, etc.).',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une personne visée par un mandat de recherche pour non-présentation à convocation d’instruction est contrôlée en rue. '
                        'Elle est interpellée, placée en garde à vue puis conduite devant le juge.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 6 — RETENUE JUDICIAIRE (CONTRAINTE / OBLIGATIONS)
          // =====================================================
          _HypoCard(
            title: '6. Retenue judiciaire (domaine de l’O.P.J.)',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Certaines situations permettent à l’OPJ d’exécuter une retenue judiciaire particulière, en dehors de la GAV classique.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Contrainte judiciaire',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : mesure visant à incarcérer une personne qui ne s’est pas acquittée volontairement d’une amende pour un délit puni d’emprisonnement.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Retenue pour vérification du respect des obligations judiciaires',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : vise une personne condamnée ou placée sous contrôle judiciaire, pour vérifier qu’elle respecte ses obligations (pointages, interdictions, etc.).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Durée : ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'limitée au temps strictement nécessaire à l’exécution de la mesure (incarcération, présentation au magistrat, vérification des obligations).',
                ),
              ]),

              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Réflexe pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Pour ces retenues particulières, les agents doivent toujours vérifier l’existence d’un titre exécutoire (contrainte, décision judiciaire, contrôle judiciaire) '
                        'et consigner précisément les horaires et les diligences accomplies.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // SYNTHÈSE OPÉRATIONNELLE
          // =====================================================
          _HypoCard(
            title: 'Synthèse : les bons réflexes en locaux de police',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Toutes ces mesures ont un point commun : elles portent une atteinte particulièrement forte à la liberté d’aller et venir. '
                'Elles sont donc regardées de très près par les magistrats et les juridictions.',
              ),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toujours identifier clairement le régime utilisé (GAV, retenue mineur, vérification d’identité, mandat…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Noter avec précision l’horaire de début et de fin de la mesure, les prolongations et les décisions du magistrat.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Veiller au respect effectif des droits (avocat, médecin, tiers, interprète) et à la dignité de la personne.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'En cas de doute, saisir le gradé ou le parquet : mieux vaut une question de plus qu’une rétention irrégulière.',
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
//  WIDGETS TEMPLATE (copiés de ta LdPersonnesPage)
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
