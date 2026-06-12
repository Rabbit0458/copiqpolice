import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteVisiteGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteVisiteGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/visites_vehicules_bagages_navires';

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
          'Véhicules, bagages, navires',
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
            'Visites de véhicules, bagages et navires',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Contrôles d’identité, visites de véhicules, inspection visuelle et fouille de bagages, '
            'visites de navires : régimes juridiques, infractions visées, autorités compétentes et '
            'modalités pratiques.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.5 – GENERAL ==========================
          _ConditionCard(
            title:
                '1.2.5 – Les visites de véhicules, l’inspection visuelle des bagages ou leur fouille, les visites de navires',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le régime spécifique des visites de véhicules, de l’inspection visuelle ou de la '
                      'fouille des bagages et des visites de navires est prévu par l’',
                ),
                TextSpan(
                  text: 'article 78-2-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text: '. Cet article distingue quatre volets autonomes :\n',
                ),
              ]),
              const _IntroBullet(text: 'les contrôles d’identité ;'),
              const _IntroBullet(text: 'les visites de véhicules ;'),
              const _IntroBullet(
                text: 'les inspections visuelles et les fouilles de bagages ;',
              ),
              const _IntroBullet(text: 'les visites de navires.'),
              const SizedBox(height: 6),
              const _Paragraph(
                'Ces opérations peuvent être réalisées indépendamment d’un contrôle préalable de '
                'l’identité du conducteur, du propriétaire des bagages ou des occupants du navire.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.5.1 – RÉQUISITIONS PROCUREUR =========
          _ConditionCard(
            title:
                '1.2.5.1 – Sur réquisitions écrites du procureur de la République',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'Les opérations prévues à l’'),
                TextSpan(
                  text: 'article 78-2-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' peuvent être ordonnées sur réquisitions écrites du procureur '
                      'de la République. Celui-ci détermine les lieux, la durée et la nature des opérations '
                      'à mener (contrôle d’identité, visites de véhicules, inspection ou fouille de bagages, '
                      'visites de navires).',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ========== 1.2.5.1.1 – INFRACTIONS VISÉES =====================
          _ConditionCard(
            title: '1.2.5.1.1 – Infractions visées',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les opérations peuvent être décidées aux fins de recherche et de poursuite des '
                'infractions suivantes :',
              ),
              _BulletPoint(
                text:
                    'actes de terrorisme prévus aux articles 421-1 à 421-6 du code pénal ;',
              ),
              _BulletPoint(
                text:
                    'infractions en matière de prolifération des armes de destruction massive et de '
                    'leurs vecteurs, visées notamment aux articles L. 1333-9, L. 1333-11, L. 1333-13-3, '
                    'L. 1333-13-4, L. 1333-13-5, L. 2339-14, L. 2339-15, L. 2341-1, L. 2341-2, '
                    'L. 2341-4, L. 2342-59 et L. 2342-60 du code de la défense ;',
              ),
              _BulletPoint(
                text:
                    'infractions en matière d’armes, notamment l’article 222-54 du code pénal et '
                    'l’article L. 317-8 du code de la sécurité intérieure ;',
              ),
              _BulletPoint(
                text:
                    'infractions en matière d’explosifs prévues par l’article 322-11-1 du code pénal '
                    'et l’article L. 2353-4 du code de la défense ;',
              ),
              _BulletPoint(
                text:
                    'infractions de vol prévues aux articles 311-3 à 311-11 du code pénal ;',
              ),
              _BulletPoint(
                text:
                    'infractions de recel, visées aux articles 321-1 et 321-2 du code pénal ;',
              ),
              _BulletPoint(
                text:
                    'faits de trafic de stupéfiants prévus aux articles 222-34 à 222-38 du code pénal.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ========== 1.2.5.1.2 – QUALITÉ DES PERSONNES ==================
          _ConditionCard(
            title: '1.2.5.1.2 – Qualité des personnes',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le législateur distingue les agents pouvant réaliser les différents types de mesures '
                'prévues par les réquisitions :',
              ),
              _BulletPoint(
                text:
                    'les contrôles d’identité peuvent être réalisés par les officiers de police judiciaire '
                    'et, sur leur ordre et sous leur responsabilité, par les agents de police judiciaire '
                    'et les agents de police judiciaire adjoints mentionnés aux 1°, 1° bis et 1° ter de '
                    'l’article 21 du code de procédure pénale ;',
              ),
              _BulletPoint(
                text:
                    'les visites de véhicules ou de navires ainsi que les inspections visuelles et fouilles '
                    'de bagages doivent être effectuées par des officiers de police judiciaire ; la '
                    'présence effective de l’officier de police judiciaire est donc indispensable.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ========== 1.2.5.1.3 – MODALITÉS ==============================
          _ConditionCard(
            title: '1.2.5.1.3 – Modalités',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les opérations ne peuvent avoir lieu que sur réquisitions écrites du procureur '
                      'de la République, qui en fixe les lieux et la durée. Cette durée ne peut excéder ',
                ),
                TextSpan(
                  text: 'vingt-quatre heures consécutives',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ', renouvelables sur décision expresse et motivée du même magistrat. La Cour de '
                      'cassation rappelle que plusieurs jours de contrôles ne peuvent être couverts par '
                      'une réquisition unique (Crim., 13 septembre 2017, n°17-83.986).',
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle('La visite des véhicules'),
              _Paragraph(
                'La visite des véhicules se déroule différemment selon que le véhicule est en circulation '
                'ou à l’arrêt :',
              ),
              _BulletPoint(
                text:
                    'véhicule en circulation : il ne peut être immobilisé que le temps strictement '
                    'nécessaire au déroulement de la visite et en présence du conducteur ;',
              ),
              _BulletPoint(
                text:
                    'véhicule à l’arrêt ou en stationnement : la visite doit avoir lieu en présence du '
                    'conducteur ou du propriétaire. À défaut, l’officier ou l’agent de police judiciaire '
                    'requiert une personne extérieure ne relevant pas de son autorité administrative, '
                    'sauf si la visite comporte des risques graves pour la sécurité des personnes et des biens.',
              ),
              _Paragraph(
                'En cas de découverte d’une infraction, si le conducteur ou le propriétaire du véhicule '
                'en fait la demande, ou si la visite a eu lieu en leur absence, un procès-verbal est établi. '
                'Il indique le lieu, les dates et heures de début et de fin des opérations. Un exemplaire est '
                'remis à l’intéressé, un autre est transmis sans délai au procureur de la République.',
              ),
              _Paragraph(
                'La visite des véhicules spécialement aménagés à usage d’habitation et effectivement '
                'utilisés comme résidence ne peut être effectuée que selon les règles applicables aux '
                'perquisitions et visites domiciliaires.',
              ),
              SizedBox(height: 10),

              _SubTitle('La visite des navires'),
              _Paragraph(
                'Le navire ne peut être immobilisé que le temps strictement nécessaire à la visite, '
                'sans que celle-ci puisse excéder douze heures. Elle se déroule en présence du '
                'capitaine ou de son représentant et comprend l’inspection des extérieurs, des cales, '
                'des soutes et des locaux, à l’exception de ceux aménagés à un usage d’habitation.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                'L’inspection visuelle des bagages ou leur fouille',
              ),
              _Paragraph(
                'Dans les mêmes conditions de réquisitions et pour les mêmes infractions, les officiers '
                'de police judiciaire peuvent, assistés le cas échéant des agents de police judiciaire et '
                'des agents de police judiciaire adjoints (articles 21, 1°, 1° bis et 1° ter du code de '
                'procédure pénale), procéder à l’inspection visuelle des bagages ou à leur fouille en '
                'tous lieux accessibles au public.',
              ),
              _Paragraph(
                'Les propriétaires des bagages ne peuvent être retenus que le temps strictement '
                'nécessaire au déroulement de l’inspection ou de la fouille, et l’opération se déroule '
                'en leur présence.',
              ),
              _Paragraph(
                'En cas de découverte d’une infraction, si le propriétaire le demande, un procès-verbal '
                'mentionnant le lieu, les dates et heures de début et de fin des opérations est rédigé. '
                'Un exemplaire est remis à l’intéressé, un autre transmis sans délai au procureur de la '
                'République.',
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'La loi n° 2025-379 du 28 avril 2025 relative au renforcement de la sûreté dans les '
                        'transports permet désormais aux officiers de police judiciaire et, sous leur contrôle, '
                        'aux agents de police judiciaire et agents de police judiciaire adjoints mentionnés aux '
                        '1°, 1° bis, 1° ter et 2° de l’article 21 du code de procédure pénale de procéder, de '
                        'leur propre initiative, à l’inspection visuelle des bagages et, avec le consentement du '
                        'propriétaire, à leur fouille :\n',
                  ),
                  TextSpan(
                    text:
                        '• sur les lignes et dans les gares des réseaux ferroviaires et guidés (article L. 2241-1-2 du code des transports) ;\n'
                        '• dans les services de transport public routier de personnes réguliers ou à la demande, '
                        'y compris dans les aménagements où ces services déposent et prennent en charge les '
                        'passagers (article L. 3116-1 du code des transports).',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.5.2 – CRIME OU DÉLIT FLAGRANT ==================
          _ConditionCard(
            title: '1.2.5.2 – En cas de crime ou de délit flagrant',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Lorsqu’il existe à l’égard du conducteur ou d’un passager une ou plusieurs raisons '
                'plausibles de soupçonner qu’il a commis, comme auteur ou complice, un crime ou un '
                'délit flagrant, les officiers de police judiciaire peuvent, assistés le cas échéant des '
                'agents de police judiciaire et des agents de police judiciaire adjoints (article 21, 1°, '
                '1° bis et 1° ter du code de procédure pénale), procéder à la visite des véhicules '
                'circulant ou arrêtés sur la voie publique ou dans des lieux accessibles au public.',
              ),
              _Paragraph(
                'Les modalités d’organisation du contrôle sont alors les mêmes que celles prévues à '
                'l’article 78-2-2 du code de procédure pénale.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.5.3 – PRÉVENIR UNE ATTEINTE GRAVE =============
          _ConditionCard(
            title:
                '1.2.5.3 – Pour prévenir une atteinte grave à la sécurité des personnes et des biens',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Pour prévenir une atteinte grave à la sécurité des personnes et des biens, les officiers '
                'de police judiciaire et, sur leur ordre et sous leur responsabilité, les agents de police '
                'judiciaire et agents de police judiciaire adjoints (article 21, 1°, 1° bis et 1° ter du code '
                'de procédure pénale) peuvent :',
              ),
              _BulletPoint(
                text:
                    'procéder aux contrôles d’identité prévus à l’alinéa 8 de l’article 78-2 du code de '
                    'procédure pénale ;',
              ),
              _BulletPoint(
                text:
                    'mettre en œuvre, avec l’accord du conducteur ou, à défaut, sur instructions du '
                    'procureur de la République communiquées par tout moyen, la visite des véhicules '
                    'circulant, arrêtés ou stationnant sur la voie publique ou dans des lieux accessibles '
                    'au public, pour une durée maximale de trente minutes ;',
              ),
              _BulletPoint(
                text:
                    'procéder à l’inspection visuelle ou à la fouille des bagages, en présence du '
                    'propriétaire, pour une durée qui ne peut excéder trente minutes.',
              ),
              _Paragraph(
                'En cas de découverte d’une infraction, si le conducteur, le propriétaire du véhicule ou '
                'du bagage le demande, ou si la visite a eu lieu hors leur présence, un procès-verbal '
                'mentionnant le lieu et les dates et heures de début et de fin des opérations est établi. '
                'Un exemplaire est remis à l’intéressé, un autre transmis sans délai au procureur de la '
                'République.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.5.4 – MANIFESTATION ET PORT D’ARME ============
          _ConditionCard(
            title:
                '1.2.5.4 – Recherche des auteurs d’une participation à une manifestation en étant porteur d’une arme',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'En application de l’'),
                TextSpan(
                  text: 'article 78-2-5 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', sur réquisitions écrites du procureur de la République, les officiers de police '
                      'judiciaire et, sous leur contrôle, les agents de police judiciaire et agents de police '
                      'judiciaire adjoints peuvent, sur les lieux d’une manifestation sur la voie publique '
                      'et à ses abords immédiats, procéder :',
                ),
              ]),
              const _BulletPoint(
                text:
                    'à l’inspection visuelle des bagages des personnes et à leur fouille, dans les '
                    'conditions prévues au paragraphe III de l’article 78-2-2 ;',
              ),
              const _BulletPoint(
                text:
                    'à la visite des véhicules circulant, arrêtés ou stationnant sur la voie publique ou '
                    'dans des lieux accessibles au public, dans les conditions prévues au paragraphe II '
                    'du même article.',
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Dans ce dispositif, les contrôles d’identité sont exclus : seules les mesures portant sur '
                'les bagages et les véhicules sont autorisées afin de rechercher les auteurs d’une '
                'participation à une manifestation en étant porteur d’une arme.',
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
