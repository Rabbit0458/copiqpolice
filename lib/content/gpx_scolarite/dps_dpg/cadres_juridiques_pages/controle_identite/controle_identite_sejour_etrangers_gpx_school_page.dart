import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConntroleIdentiteSejourGpxSchool extends StatelessWidget {
  const ConntroleIdentiteSejourGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/controle_identite/chapitre1/sejour_etrangers';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.72);

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
          'Séjour des étrangers',
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
            'Contrôle de la régularité du séjour des étrangers',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Champ d’application du contrôle des titres de séjour, critères d’extranéité et limites '
            'légales posées par le code de l’entrée et du séjour des étrangers et du droit d’asile.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title:
                '1.3.2 – Le contrôle de la régularité du séjour des étrangers',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              // ===================== INTRO – CADRE JURIDIQUE =============
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le contrôle des documents autorisant la circulation et le séjour sur le territoire français '
                      'est encadré par les ',
                ),
                TextSpan(
                  text:
                      'articles L. 812-1 et L. 812-2 du code de l’entrée et du séjour des étrangers et du droit d’asile (CESEDA)',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Ces dispositions précisent dans quelles conditions les étrangers doivent être en mesure de '
                      'présenter les pièces ou documents sous le couvert desquels ils sont autorisés à circuler ou à '
                      'séjourner en France.',
                ),
              ]),
              const SizedBox(height: 14),

              // ===================== 1.3.2.1 – CHAMP D’APPLICATION =======
              const _SubTitle('1.3.2.1 – Champ d’application'),
              _Paragraph.rich([
                const TextSpan(text: 'L’'),
                TextSpan(
                  text:
                      'article L. 812-2, 2° du code de l’entrée et du séjour des étrangers et du droit d’asile',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' prévoit qu’à la suite d’un contrôle d’identité effectué en application des ',
                ),
                TextSpan(
                  text: 'articles 78-1 à 78-2-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', les personnes de nationalité étrangère doivent être en mesure de présenter les pièces ou '
                      'documents sous le couvert desquels elles sont autorisées à circuler ou à séjourner en France.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Il s’agit donc d’un contrôle qui intervient en second temps : d’abord un contrôle d’identité régulier '
                'au titre du code de procédure pénale, puis, si la personne est étrangère, un contrôle de la régularité '
                'de sa situation au regard du code de l’entrée et du séjour des étrangers et du droit d’asile.',
              ),
              const SizedBox(height: 14),

              // ===================== 1.3.2.2 – CRITERES D’EXTRANEITE =====
              const _SubTitle('1.3.2.2 – Critères d’extranéité'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’article L. 812-2, 1° du code de l’entrée et du séjour des étrangers et du droit d’asile ',
                  style: TextStyle(color: textSoft),
                ),
                TextSpan(
                  text:
                      'prévoit que le contrôle de situation administrative ne peut être pratiqué que si des « éléments objectifs déduits de circonstances extérieures à la personne même de l’intéressé sont de nature à faire apparaître sa qualité d’étranger ». ',
                  style: TextStyle(color: textSoft),
                ),
              ]),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le recours à ces éléments objectifs exclut toute discrimination fondée, par exemple, sur la couleur '
                'de peau, la morphologie, la tenue vestimentaire, l’usage d’une langue étrangère, le nom ou le lieu '
                'de naissance déclaré. Ce sont les circonstances extérieures de la situation qui doivent révéler la '
                'qualité d’étranger.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Il n’existe pas de liste légale exhaustive de ces critères objectifs : ils ont été dégagés par la '
                'jurisprudence. À titre d’illustration, peuvent constituer de tels éléments :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'La circulation à bord d’un véhicule immatriculé à l’étranger ;',
              ),
              const _BulletPoint(
                text:
                    'La participation à une manifestation avec port de banderoles rédigées en langue étrangère ;',
              ),
              const _BulletPoint(
                text:
                    'La distribution de tracts ou l’apposition d’affiches rédigées en langue étrangère ;',
              ),
              const _BulletPoint(
                text:
                    'L’occupation sans titre de bâtiments en revendiquant publiquement une situation irrégulière.',
              ),
              const SizedBox(height: 14),

              // ===================== 1.3.2.3 – DISPOSITIONS DU CONTROLE ===
              const _SubTitle('1.3.2.3 – Dispositions du contrôle'),
              const _Paragraph(
                'L’article L. 812-2, 1° du code de l’entrée et du séjour des étrangers et du droit d’asile fixe des '
                'limites précises à ces contrôles afin de garantir le respect des libertés individuelles et d’éviter '
                'les contrôles généralisés ou systématiques.',
              ),
              const SizedBox(height: 8),
              const _IntroBullet(
                text:
                    'Le contrôle ne peut être pratiqué que pour une durée n’excédant pas six heures consécutives dans un même lieu.',
              ),
              const _IntroBullet(
                text:
                    'Le contrôle ne peut pas consister en un contrôle systématique de toutes les personnes présentes ou circulant dans les zones ou lieux concernés.',
              ),
              const SizedBox(height: 14),

              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        'En pratique, le policier doit pouvoir justifier, dans la procédure, des éléments objectifs '
                        'ayant permis d’identifier la qualité d’étranger de la personne contrôlée et des limites de lieu '
                        'et de temps dans lesquelles le contrôle de situation administrative a été réalisé.',
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
