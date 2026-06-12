import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteLocauxGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteLocauxGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/locaux_professionnels';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F5F5);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color articleColor = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFC62828);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Locaux professionnels',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== TITRE & INTRO ============================
          Text(
            'Les contrôles dans les locaux professionnels',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Contrôles d’identité et visites de locaux professionnels pour la lutte contre le '
            'travail dissimulé : autorités compétentes, conditions d’entrée, personnes '
            'concernées et suites de la visite.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.4 – CONTROLES DANS LES LOCAUX =======
          _ConditionCard(
            title: '1.2.4 – Des contrôles dans les locaux professionnels',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'L’outil principal est prévu par l’'),
                TextSpan(
                  text: 'article 78-2-1 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', qui permet aux policiers de pénétrer dans les locaux professionnels afin de '
                      'vérifier qu’il ne s’y commet pas de travail dissimulé ou d’emploi de travailleurs '
                      'dépourvus de titre de travail.',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.4.1 – AUTORITÉS COMPÉTENTES =========
          _ConditionCard(
            title: '1.2.4.1 – Les autorités compétentes',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Sont compétents pour mettre en œuvre ces contrôles : les officiers de police '
                      'judiciaire et, sur ordre et sous la responsabilité de ceux-ci, les agents de police '
                      'judiciaire et agents de police judiciaire adjoints mentionnés aux ',
                ),
                TextSpan(
                  text: 'articles 20 et 21, 1° du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.4.2 – CONDITIONS DES CONTRÔLES ======
          _ConditionCard(
            title:
                '1.2.4.2 – Conditions dans lesquelles peuvent s’opérer ces contrôles',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle('1.2.4.2.1 – L’entrée dans les locaux'),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'L’entrée dans les locaux professionnels suppose des réquisitions écrites du '
                      'procureur de la République. Ces réquisitions doivent :\n',
                ),
              ]),
              const _BulletPoint(
                text:
                    'préciser le ou les lieux dans lesquels l’opération de contrôle se déroulera ;',
              ),
              const _BulletPoint(
                text:
                    'indiquer les infractions devant être recherchées (travail dissimulé, emploi de '
                    'travailleurs dépourvus de titre de travail) ;',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La durée de validité des réquisitions, fixée par le procureur de la République, '
                      'ne peut excéder un mois, conformément à l’',
                ),
                TextSpan(
                  text: 'article 78-2-1 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('1.2.4.2.2 – La présentation de la réquisition'),
              const _Paragraph(
                'Les réquisitions doivent être présentées à la personne qui a la responsabilité des '
                'lieux. Lorsque cette formalité est impossible (par exemple si personne ne se '
                'prépare ou ne se déclare responsable), la procédure issue du contrôle n’est pas '
                'pour autant nulle. Il est toutefois recommandé de consacrer suffisamment de temps '
                'à l’identification du maître des lieux afin d’éviter toute ambiguïté ou contestation '
                'ultérieure.',
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le procureur de la République, qui suit le cours de ces opérations, peut y mettre fin '
                'à tout moment.',
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                '1.2.4.2.3 – Les locaux pouvant donner lieu à visite',
              ),
              const _Paragraph(
                'Les réquisitions ne peuvent viser que les lieux à usage exclusivement professionnel '
                'ainsi que leurs annexes et dépendances. Sont exclus :',
              ),
              const _BulletPoint(text: 'les domiciles des personnes ;'),
              const _BulletPoint(
                text:
                    'les lieux à usage mixte servant à la fois de local de travail et de domicile.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.4.3 – PERSONNES CONTRÔLÉES ==========
          _ConditionCard(
            title:
                '1.2.4.3 – Les personnes pouvant faire l’objet d’un contrôle',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Sont contrôlées les personnes occupées dans l’entreprise au moment de la visite. '
                'Leur identité permet de procéder à des rapprochements avec :',
              ),
              _BulletPoint(text: 'le registre unique du personnel ;'),
              _BulletPoint(
                text:
                    'les documents relatifs aux déclarations préalables à l’embauche (déclaration '
                    'unique d’embauche, déclaration préalable à l’embauche, etc.).',
              ),
              _Paragraph(
                'Ce contrôle d’identité permettra également, le cas échéant, d’engager des '
                'procédures judiciaires incidentes si des infractions sont constatées.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.4.4 – SUITES DE LA VISITE ============
          _ConditionCard(
            title: '1.2.4.4 – Les suites de la visite',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le contrôle donne lieu à l’établissement d’un procès-verbal qui doit mentionner :',
              ),
              _BulletPoint(
                text:
                    'les réquisitions du procureur de la République (date, référence, objet) ;',
              ),
              _BulletPoint(
                text:
                    'l’ensemble des diligences effectuées pendant l’opération de contrôle ;',
              ),
              _BulletPoint(
                text:
                    'l’heure de début et l’heure de fin de la visite des locaux professionnels.',
              ),
              _Paragraph(
                'Un double du procès-verbal est remis au responsable du local visité, afin d’assurer '
                'la traçabilité et l’information de l’entreprise sur le déroulement de l’opération.',
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
}
