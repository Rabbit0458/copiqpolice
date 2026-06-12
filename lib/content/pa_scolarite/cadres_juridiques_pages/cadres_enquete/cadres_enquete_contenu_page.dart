import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCadresEnqueteContenuPage extends StatelessWidget {
  const PaCadresEnqueteContenuPage({super.key});

  static const String routeName = '/pa/dps_dpg/cadres_juridiques/cadres_enquete';

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
          'Les cadres d’enquête',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== EN-TÊTE ==========================
          Text(
            'Les cadres d’enquête',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Les actes de police judiciaire qui consistent à constater les infractions, '
                  'à en rassembler les preuves et à en rechercher les auteurs s’accomplissent '
                  'au cours de la phase dite policière, désignée par le code de procédure pénale '
                  'sous le nom d’enquêtes. ',
            ),
            TextSpan(
              text:
                  'Les articles 14 et 17 du code de procédure pénale prévoient plusieurs cadres juridiques '
                  'dans lesquels s’exerce la mission de police judiciaire.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 10),

          // =======================================================
          // A. NOTION GÉNÉRALE
          // =======================================================
          _ConditionCard(
            title: 'A. Notion générale des cadres d’enquête',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le cadre d’enquête détermine l’étendue des pouvoirs de la police judiciaire, '
                'la durée des investigations, les conditions de contrainte possibles et le niveau de contrôle '
                'exercé par l’autorité judiciaire (procureur de la République ou juge d’instruction).',
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    'Un même fait peut successivement relever de plusieurs cadres (flagrance, puis enquête préliminaire, puis information judiciaire avec commissions rogatoires).',
              ),
              _IntroBullet(
                text:
                    'Le respect du bon cadre d’enquête conditionne la régularité des actes et donc la validité de la procédure.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =======================================================
          // B. LES TROIS CADRES PRINCIPAUX
          // =======================================================
          _ConditionCard(
            title:
                'B. Les trois cadres principaux prévus par le code de procédure pénale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les articles 14 et 17 du code de procédure pénale distinguent trois grands cadres d’enquête : '
                'l’enquête de police sur infraction flagrante, l’enquête préliminaire et les enquêtes réalisées '
                'sur commission rogatoire d’un juge d’instruction.',
              ),
              SizedBox(height: 12),

              // 1. Enquête de police sur infraction flagrante
              _SubTitle(
                '1. L’enquête de police sur infraction flagrante (articles 53 à 73 du code de procédure pénale)',
              ),
              _Paragraph(
                'Elle s’applique lorsque l’infraction vient de se commettre ou se commet encore. '
                'C’est le cadre le plus puissant : perquisitions de jour et de nuit dans certains cas, '
                'saisies, garde à vue, auditions, avec des pouvoirs étendus pour l’officier de police judiciaire.',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Vol avec effraction constaté par la patrouille, auteur encore sur les lieux, '
                        'ou course-poursuite après un cambriolage : les actes sont réalisés dans le cadre '
                        'de l’enquête de flagrant délit.',
                  ),
                ],
              ),

              SizedBox(height: 14),

              // 2. Enquête préliminaire
              _SubTitle(
                '2. L’enquête préliminaire (articles 75 à 78 du code de procédure pénale)',
              ),
              _Paragraph(
                'Elle est ouverte en l’absence de flagrance, souvent à partir d’un dépôt de plainte, '
                'd’un renseignement ou d’un signalement. Les pouvoirs de contrainte sont plus limités et '
                's’exercent sous le contrôle du procureur de la République (perquisitions avec accord écrit, etc.).',
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Plainte déposée plusieurs semaines après des faits d’escroquerie, soupçons de harcèlement '
                        'au travail, enquête sur des détournements commis depuis plusieurs mois : le plus souvent, '
                        'les investigations sont menées dans le cadre de l’enquête préliminaire.',
                  ),
                ],
              ),

              SizedBox(height: 14),

              // 3. Commission rogatoire
              _SubTitle(
                '3. La commission rogatoire (articles 81 et 151 à 154-2 du code de procédure pénale)',
              ),
              _Paragraph(
                'Dans le cadre d’une information judiciaire, le juge d’instruction peut déléguer certains actes '
                'à un officier de police judiciaire par commission rogatoire. Les policiers agissent alors au nom '
                'et pour le compte du juge, dans les limites strictes fixées par le mandat.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'La commission rogatoire doit être écrite, datée, signée et préciser les actes à accomplir.',
              ),
              _BulletPoint(
                text:
                    'Les procès-verbaux mentionnent qu’ils sont réalisés “en exécution de la commission rogatoire du juge d’instruction…”.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =======================================================
          // C. LES AUTRES CADRES SPÉCIFIQUES DE L’ENQUÊTE
          // =======================================================
          _ConditionCard(
            title: 'C. Les autres cadres spécifiques de l’enquête',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'En plus de ces trois cadres principaux, le code de procédure pénale prévoit des cadres particuliers '
                'adaptés à des situations sensibles (mort suspecte, disparition, criminalité organisée, etc.). '
                'Ils complètent les enquêtes classiques et peuvent servir de point de départ à une procédure plus large.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                '1. La découverte d’une personne grièvement blessée (article 74 alinéa 6 du code de procédure pénale)',
              ),
              _Paragraph(
                'Lorsque la cause de la blessure est inconnue ou suspecte, un cadre d’enquête spécifique permet '
                'de procéder aux premières constatations, d’entendre les témoins et de saisir les éléments utiles, '
                'afin de déterminer s’il y a infraction et laquelle.',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '2. La mort de cause inconnue ou suspecte (articles 74 et 80-4 du code de procédure pénale)',
              ),
              _Paragraph(
                'En cas de décès dont la cause n’est pas certaine, l’enquête permet de vérifier l’origine de la mort '
                '(naturelle, accidentelle, suicidaire ou criminelle), avec des actes de constatation, d’autopsie, '
                'd’auditions et de recueil des preuves.',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '3. Les disparitions inquiétantes (articles 74-1 et 80-4 du code de procédure pénale)',
              ),
              _Paragraph(
                'Ce cadre permet de déclencher des recherches renforcées lorsqu’une disparition fait craindre '
                'un danger grave pour la personne (mineur, personne vulnérable, menace ou contexte alarmant).',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '4. La recherche des personnes en fuite (article 74-2 du code de procédure pénale)',
              ),
              _Paragraph(
                'Il s’applique pour organiser les opérations de recherche d’un mis en cause évadé, en fuite ou '
                'soustrait à l’exécution d’une peine ou d’une mesure privative de liberté.',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '5. La procédure applicable à la délinquance et à la criminalité organisées',
              ),
              _Paragraph(
                'Pour certaines infractions graves (trafics, criminalité organisée, terrorisme…), la loi prévoit des '
                'pouvoirs d’enquête renforcés : surveillances, infiltrations, sonorisations, interceptions de '
                'correspondances, prolongations exceptionnelles de garde à vue, etc., sous contrôle étroit du juge.',
              ),

              SizedBox(height: 10),

              _SubTitle('6. L’entraide judiciaire internationale'),
              _Paragraph(
                'Lorsque l’enquête présente un élément d’extranéité (auteurs, victimes, comptes bancaires, '
                'serveurs informatiques à l’étranger…), les autorités françaises peuvent solliciter ou exécuter '
                'des demandes d’entraide internationale pour réaliser des actes à l’étranger ou pour le compte d’un État tiers.',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '7. Les contrôles, relevés et vérifications d’identité',
              ),
              _Paragraph(
                'Les contrôles d’identité, les relevés signalétiques et les vérifications d’identité sont encadrés '
                'par le code de procédure pénale et le code de la sécurité intérieure. Ils peuvent être réalisés '
                'dans un cadre préventif ou en lien avec un cadre d’enquête déjà ouvert.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =======================================================
          // D. SECRET DE L’ENQUÊTE
          // =======================================================
          _ConditionCard(
            title: 'D. Secret de l’enquête et de l’instruction',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le cadre d’enquête s’accompagne d’une obligation de secret : la divulgation '
                'd’éléments d’une enquête ou d’une instruction portant sur un crime ou un délit est pénalement réprimée.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Seuls peuvent communiquer sur une enquête, dans les limites fixées par la loi, ',
                  ),
                  TextSpan(
                    text: 'le procureur de la République ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        'et, avec son accord et sous son contrôle, l’officier de police judiciaire. '
                        'Le respect du secret protège la présomption d’innocence, l’efficacité des investigations '
                        'et la sécurité des personnes mises en cause ou des témoins.',
                  ),
                ],
                title: 'Secret professionnel & communication',
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE CONDITION (A / B / C)
/// ------------------------------------------------------------------
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
