import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteFrontiereGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteFrontiereGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/zone_frontiere';

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
          'Contrôles en zone frontière',
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
          // ===================== TITRE & INTRO RAPIDE ======================
          Text(
            'Les contrôles d’identité en zone frontière',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Contrôles destinés à vérifier, dans certaines zones du territoire national, le respect '
            'des obligations de détention, de port et de présentation de titres et documents, '
            'dans un équilibre entre liberté de circulation et lutte contre la criminalité '
            'transfrontalière.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========== 1.2.3 – LES CONTRÔLES EN ZONE FRONTIÈRE ============
          _ConditionCard(
            title: '1.2.3 – Les contrôles en zone frontière',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Ces contrôles sont destinés à vérifier le respect des obligations de détention, '
                      'de port et de présentation des titres et documents prévus par les textes dans '
                      'certaines zones du territoire national. Ils sont encadrés par l’',
                ),
                TextSpan(
                  text:
                      'article 78-2 (alinéas 9 à 17) du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Ces dispositions sont notamment la conséquence :',
              ),
              const _BulletPoint(
                text:
                    'de la suppression des contrôles aux frontières intérieures, terrestres et aériennes, '
                    'entre la France et les États parties à la convention de Schengen, ce qui impose de '
                    'tenir compte des risques particuliers d’infractions et d’atteintes à l’ordre public '
                    'liés à la circulation internationale des personnes ;',
              ),
              const _BulletPoint(
                text:
                    'de la situation particulière du département de la Guyane face à l’immigration '
                    'clandestine. Ces règles ont ensuite été étendues à la Guadeloupe, à Mayotte, à '
                    'Saint-Barthélémy, à Saint-Martin et à la Martinique.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Le Conseil constitutionnel a rappelé que ces contrôles doivent assurer un équilibre '
                'entre les nécessités de l’ordre public et la sauvegarde de la liberté individuelle. Le '
                'législateur a donc fixé des conditions précises de mise en œuvre.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans sa précédente rédaction, l’article de référence permettait de pratiquer des '
                      'contrôles d’identité dans une zone de vingt kilomètres en deçà de la frontière '
                      'terrestre, en ne se fondant que sur le lieu du contrôle, sans autre justification. '
                      'Par un arrêt du 22 juin 2010, la Cour de justice de l’Union européenne a jugé ces '
                      'dispositions incompatibles avec l’',
                ),
                TextSpan(
                  text:
                      'article 67 du traité sur le fonctionnement de l’Union européenne',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', qui consacre l’absence de contrôle des personnes aux frontières intérieures.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Pour se conformer à ces exigences, la loi du 14 mars 2011 d’orientation et de '
                      'programmation pour la performance de la sécurité intérieure a modifié ',
                ),
                TextSpan(
                  text: 'l’article 78-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: ' en précisant :'),
              ]),
              const _BulletPoint(
                text:
                    'que les contrôles pratiqués dans la bande des vingt kilomètres ne constituent pas '
                    'des vérifications aux frontières, mais visent à prévenir et rechercher les '
                    'infractions liées à la criminalité transfrontalière ;',
              ),
              const _BulletPoint(
                text:
                    'qu’ils ne peuvent être ni permanents, ni systématiques à l’égard des personnes '
                    'présentes ou circulant dans cette zone.',
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La loi du 30 octobre 2017 renforçant la sécurité intérieure et la lutte contre le '
                      'terrorisme a ensuite prévu la possibilité d’effectuer des contrôles d’identité autour '
                      'des ports et aéroports constituant des points de passage frontaliers désignés par '
                      'arrêté (',
                ),
                TextSpan(
                  text: 'article 78-2, alinéa 10, du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '), en fixant une durée maximale de douze heures dans un même lieu et en '
                      'interdisant tout contrôle systématique des personnes.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'En pratique, il est recommandé de préciser sur le procès-verbal l’heure de début du '
                'contrôle fondé sur ces dispositions, afin de démontrer que l’opération n’a pas excédé '
                'la durée maximale de douze heures.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.3.1 – ENDROITS DÉLIMITÉS =======================
          _ConditionCard(
            title:
                '1.2.3.1 – Des contrôles effectués dans des endroits délimités',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les contrôles en zone frontière ne peuvent être pratiqués que dans des endroits '
                'strictement délimités par la loi.',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Dans une zone située à moins de vingt kilomètres de la frontière terrestre entre '
                    'la France et les États limitrophes parties à la convention de Schengen, ainsi que '
                    'dans les zones accessibles au public des ports, aéroports et gares ferroviaires '
                    'ou routières ouverts au trafic international et désignés par arrêté interministériel, '
                    'ainsi que dans les abords de ces gares.',
              ),
              _BulletPoint(
                text:
                    'À bord d’un train effectuant une liaison internationale, sur la portion du trajet '
                    'comprise entre la frontière et le premier arrêt situé au-delà des vingt kilomètres. '
                    'Sur certaines lignes, le contrôle peut également avoir lieu entre ce premier arrêt '
                    'et un arrêt situé dans la limite des cinquante kilomètres suivants, lorsque la '
                    'ligne et les arrêts sont désignés par arrêté.',
              ),
              _BulletPoint(
                text:
                    'Sur une section autoroutière qui commence dans la zone des vingt kilomètres, '
                    'jusqu’au premier péage autoroutier situé au-delà de cette limite, ainsi que sur les '
                    'aires de stationnement attenantes. Les péages concernés sont fixés par arrêté.',
              ),
              _BulletPoint(
                text:
                    'Dans un rayon maximal de dix kilomètres autour des ports et aéroports '
                    'constituant des points de passage frontaliers en raison de leur fréquentation et '
                    'de leur vulnérabilité, tels que définis par arrêté, avec extension possible jusqu’au '
                    'premier péage autoroutier dans les mêmes conditions que ci-dessus.',
              ),
              _BulletPoint(
                text:
                    'Dans une zone comprise entre les frontières terrestres ou le littoral du '
                    'département de la Guyane et une ligne tracée à vingt kilomètres en deçà, ainsi '
                    'que sur une ligne tracée à cinq kilomètres de part et d’autre, et sur la route '
                    'nationale 2 sur le territoire de la commune de Régina.',
              ),
              _BulletPoint(
                text:
                    'En Guadeloupe, dans une zone comprise entre le littoral et une ligne tracée à un '
                    'kilomètre en deçà, ainsi que sur le territoire des communes traversées par les '
                    'routes nationales 1, 2, 4, 5, 6, 9, 10 et 11.',
              ),
              _BulletPoint(
                text: 'À Mayotte, sur l’ensemble du territoire.',
              ),
              _BulletPoint(
                text:
                    'À Saint-Martin, dans une zone comprise entre le littoral et une ligne tracée à un '
                    'kilomètre en deçà.',
              ),
              _BulletPoint(
                text:
                    'À Saint-Barthélémy, dans une zone comprise entre le littoral et une ligne tracée '
                    'à un kilomètre en deçà.',
              ),
              _BulletPoint(
                text:
                    'En Martinique, dans une zone comprise entre le littoral et une ligne tracée à un '
                    'kilomètre en deçà, ainsi que dans une zone d’un kilomètre de part et d’autre des '
                    'routes nationales 1, 2, 3, 5 et 6 et de la départementale 1.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.3.2 – FINS DÉTERMINÉES ==========================
          _ConditionCard(
            title: '1.2.3.2 – Des contrôles effectués à des fins déterminées',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                'Les contrôles en zone frontière ont pour finalité de prévenir et de rechercher les '
                'infractions liées à la criminalité transfrontalière, ainsi que de vérifier le respect des '
                'obligations pesant sur certaines personnes tenues de présenter des titres ou '
                'documents particuliers.',
              ),
              const SizedBox(height: 8),
              const _Paragraph('Ces obligations concernent notamment :'),
              _Paragraph.rich([
                const TextSpan(text: '• le permis de conduire ('),
                TextSpan(
                  text: 'article R. 233-1 du code de la route',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: ') ;'),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(text: '• le permis de chasser ('),
                TextSpan(
                  text: 'article L. 423-1 du code de l’environnement',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: ') ;'),
              ]),
              const SizedBox(height: 4),
              const _Paragraph(
                '• les autorisations exigées pour le port, la détention ou la circulation '
                'transfrontière des armes ;',
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      '• les pièces ou documents sous le couvert desquels les étrangers sont autorisés '
                      'à circuler ou à séjourner en France (',
                ),
                TextSpan(
                  text:
                      'articles L. 812-1 et L. 812-2 du code de l’entrée et du séjour des étrangers et du droit d’asile',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Comme pour les contrôles effectués sur réquisitions du procureur de la République, '
                'il est prévu le cas où, à l’occasion de ce contrôle, serait constatée une infraction '
                'autre que le simple non-respect des obligations relatives aux titres et documents '
                'exigés : le fait que le contrôle révèle une telle infraction ne constitue pas une cause '
                'de nullité des procédures incidentes.',
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
