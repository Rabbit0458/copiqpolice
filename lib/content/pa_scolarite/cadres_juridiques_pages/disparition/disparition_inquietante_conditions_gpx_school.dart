import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDisparitionInquietanteConditionsGpxSchool extends StatelessWidget {
  const PaDisparitionInquietanteConditionsGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF111111) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF1F1F1F).withValues(alpha: .95);

    final Color cardColor = isDark
? const Color(0xFF1E272E)
: const Color(0xFFE3F2FD);
    const accent = Color(0xFF1565C0);

    // Couleur pour les références d’articles
    const Color articleRed = Color(0xFFC62828);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
        title: Text(
          'Disparitions inquiétantes — Chapitre 1',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ---------------------------------------------------------------
          // Titre principal
          // ---------------------------------------------------------------
          Text(
            'Conditions d’application des articles 74-1 et 80-4 du Code de procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              color: titleColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          const _Paragraph(
            'Deux conditions doivent être réunies pour mettre en œuvre le cadre '
            'juridique des disparitions inquiétantes :',
          ),
          const SizedBox(height: 8),
          const _IntroBullet(text: 'La disparition doit être flagrante.'),
          const _IntroBullet(
            text: 'La disparition doit présenter un caractère inquiétant.',
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // 1.1 La disparition flagrante
          // ---------------------------------------------------------------
          const _SubTitle('1.1 — La disparition « flagrante »'),
          const _Paragraph.rich([
            TextSpan(text: 'L’'),
            TextSpan(
              text: 'article 74-1 du Code de procédure pénale',
              style: TextStyle(fontWeight: FontWeight.w800, color: articleRed),
            ),
            TextSpan(
              text:
                  ' exige le caractère flagrant de la disparition d’un mineur ou d’un '
                  'majeur protégé. Il est précisé que la disparition « vient '
                  'd’intervenir ou d’être constatée ». Cette exigence vaut également '
                  'pour la disparition inquiétante d’un majeur.',
            ),
          ]),
          const SizedBox(height: 8),
          const _Paragraph(
            'En l’absence de flagrance, le procureur de la République conserve la '
            'possibilité soit d’ordonner une enquête préliminaire, soit de requérir '
            'l’ouverture d’une information pour recherche des causes de la disparition.',
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // 1.2 La disparition est inquiétante
          // ---------------------------------------------------------------
          const _SubTitle('1.2 — La disparition est inquiétante'),
          const _Paragraph.rich([
            TextSpan(
              text: 'Les articles 74-1 et 80-4 du Code de procédure pénale',
              style: TextStyle(fontWeight: FontWeight.w800, color: articleRed),
            ),
            TextSpan(
              text:
                  ' instaurent un cadre spécifique d’enquête reposant sur la notion '
                  'de disparition inquiétante. Ce cadre peut être mis en œuvre dans '
                  'deux grandes hypothèses : les disparitions obligatoirement '
                  'inquiétantes et les disparitions inquiétantes en raison des '
                  'circonstances.',
            ),
          ]),

          const SizedBox(height: 14),

          // ---------------------------------------------------------------
          // Carte 1 : disparitions obligatoirement inquiétantes
          // ---------------------------------------------------------------
          _ConditionCard(
            title: '1.2.1 — Les disparitions obligatoirement inquiétantes',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _BulletPoint(text: 'Toute disparition de mineur.'),
              _BulletPoint(text: 'Toute disparition de majeur protégé.'),
              SizedBox(height: 6),
              _Paragraph(
                'Les majeurs protégés sont les personnes placées sous sauvegarde '
                'de justice, sous tutelle ou sous curatelle. ',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'À ce stade, toute disparition doit être considérée comme inquiétante, '
                'même si l’intéressé a l’habitude de fuguer ou s’il apparaît '
                'clairement qu’il s’agit d’une disparition volontaire.',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------------------------------------------------------
          // Carte 2 : disparitions inquiétantes en raison des circonstances
          // ---------------------------------------------------------------
          _ConditionCard(
            title:
                '1.2.2 — Les disparitions inquiétantes en raison des circonstances',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'Une disparition peut être qualifiée d’inquiétante ou suspecte lorsqu’elle '
                'fait craindre que la personne disparue est en danger, en fonction '
                'de plusieurs critères.',
              ),
              SizedBox(height: 8),
              _SubTitle('Critères liés à la personne'),
              _BulletPoint(
                text:
                    'Son âge (très jeune, personne âgée, personne vulnérable…).',
              ),
              _BulletPoint(text: 'Son état de santé :'),
              _IntroBullet(
                text:
                    'Personne sous traitement médical lourd ou atteinte d’une grave maladie.',
              ),
              _IntroBullet(
                text:
                    'Personne en situation de handicap ou ayant subi un accident récent.',
              ),
              _IntroBullet(
                text:
                    'Personne dépressive ou présentant des tendances suicidaires.',
              ),
              SizedBox(height: 8),
              _SubTitle('Critères liés aux circonstances de la disparition'),
              _BulletPoint(
                text:
                    'Disparition survenue de manière subite et inexpliquée, sans '
                    'élément laissant penser à une simple volonté de rompre avec '
                    'l’entourage habituel.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ---------------------------------------------------------------
          // Nota + Rappel pénal
          // ---------------------------------------------------------------
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Chaque situation signalée doit faire l’objet d’un examen attentif. '
                    'En cas de doute, le fonctionnaire de police doit se rapprocher de '
                    'son supérieur hiérarchique et du procureur de la République.',
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _NotaBox(
            title: 'RAPPEL',
            bodySpans: [
              TextSpan(
                text:
                    'Le fait, pour une personne ayant connaissance de la disparition '
                    'd’un mineur de quinze ans, de ne pas informer les autorités '
                    'judiciaires ou administratives afin d’empêcher ou de retarder la '
                    'mise en œuvre des procédures de recherche prévues par l’article '
                    '74-1 du Code de procédure pénale, est puni de deux ans '
                    'd’emprisonnement et de 30 000 € d’amende (article 434-4-1 du '
                    'Code pénal).',
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
