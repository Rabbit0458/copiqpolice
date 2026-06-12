import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaeDefinitionPage extends StatelessWidget {
  const MaeDefinitionPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/mae_definition';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    Color lawRed() => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Retour',
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mandat d’arrêt européen — Définition',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===============================================================
          // EN-TÊTE GÉNÉRAL
          // ===============================================================
          Text(
            'Le mandat d’arrêt européen',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '2.1 — Définition',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'Le mandat d’arrêt européen s’inscrit dans le mouvement de renforcement de la '
            'coopération judiciaire pénale au sein de l’Union européenne. Il remplace, entre '
            'États membres, les procédures classiques d’extradition pour la remise des '
            'personnes recherchées.',
          ),
          const SizedBox(height: 16),

          // ===============================================================
          // SUBSTITUTION À L’EXTRADITION
          // ===============================================================
          _ConditionCard(
            title:
                'Le mandat d’arrêt européen et la substitution à la procédure d’extradition',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Pour les États membres de l’Union européenne ayant transposé la décision-cadre '
                'relative au mandat d’arrêt européen en droit interne, ce mécanisme se substitue '
                'à la procédure classique d’extradition. La remise de la personne recherchée '
                'repose sur le principe de reconnaissance mutuelle des décisions judiciaires, '
                'ce qui permet une procédure plus rapide et plus simplifiée entre autorités '
                'judiciaires.',
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Le mandat d’arrêt européen ne supprime pas l’extradition de manière générale : '
                        'il la remplace uniquement dans les relations entre les États membres de '
                        'l’Union européenne qui ont intégré ce dispositif dans leur ordre juridique interne.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // DÉFINITION JURIDIQUE (ARTICLE 695-11)
          // ===============================================================
          const _SubTitle(
            '2.1 — Définition juridique du mandat d’arrêt européen',
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: 'Texte de référence et définition légale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La définition du mandat d’arrêt européen est donnée par ',
                ),
                TextSpan(
                  text: 'l’article 695-11 du Code de procédure pénale',
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Le mandat d’arrêt européen est une décision judiciaire émise par un État membre '
                'de l’Union européenne, appelé État membre d’émission, en vue de l’arrestation '
                'et de la remise, par un autre État membre, appelé État membre d’exécution, '
                'd’une personne recherchée :',
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text: 'soit pour l’exercice de poursuites pénales ;',
              ),
              const _IntroBullet(
                text:
                    'soit pour l’exécution d’une peine ou d’une mesure de sûreté privative de liberté.',
              ),
              const SizedBox(height: 12),
              const _ConditionCard(
                title: 'Les acteurs principaux de la procédure',
                cardColor: Colors.transparent,
                accent: Colors.transparent,
                titleColor: Colors.transparent,
                children: [
                  _BulletPoint(
                    text:
                        'L’« État membre d’émission » : l’État de l’Union européenne dont l’autorité '
                        'judiciaire émet le mandat d’arrêt européen pour une personne déterminée ;',
                  ),
                  _BulletPoint(
                    text:
                        'L’« État membre d’exécution » : l’État de l’Union européenne dans lequel la '
                        'personne recherchée est localisée et dont l’autorité judiciaire est saisie '
                        'pour procéder à son arrestation et à sa remise.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // SYNTHÈSE OPÉRATIONNELLE POUR L’ENQUÊTEUR
          // ===============================================================
          _ConditionCard(
            title: 'À retenir pour l’enquêteur',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _BulletPoint(
                text:
                    'Le mandat d’arrêt européen est une décision judiciaire, et non un simple acte de police : '
                    'il est émis et exécuté par des autorités judiciaires (parquet, juge, juridiction) ;',
              ),
              _BulletPoint(
                text:
                    'Il vise la remise rapide d’une personne entre deux États membres de l’Union européenne, '
                    'pour l’exercice de poursuites ou l’exécution d’une peine ou d’une mesure de sûreté ;',
              ),
              _BulletPoint(
                text:
                    'Dans les relations entre États membres qui ont transposé la décision-cadre, il remplace '
                    'la procédure d’extradition, permettant ainsi une coopération plus fluide et plus efficace ;',
              ),
              _BulletPoint(
                text:
                    'Sur le terrain, l’exécution d’un mandat d’arrêt européen suppose les mêmes exigences '
                    'de sécurité et de respect des droits fondamentaux qu’une interpellation classique, '
                    'avec une information précise de la personne sur la nature du mandat et sur ses droits.',
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
                    : const Color(0xFF1F1F1F).withOpacity(.92),
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
        color: bgColor.withOpacity(isDark ? .7 : .95),
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
