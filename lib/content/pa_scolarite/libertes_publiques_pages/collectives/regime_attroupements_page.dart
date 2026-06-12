import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRegimeAttroupementsPage extends StatelessWidget {
  const PaRegimeAttroupementsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/collectives/regime_attroupements';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF5E35B1)
        : const Color(0xFF512DA8);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
          'Le régime des attroupements',
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
          // ==================================================================
          // TITRE + INTRO
          // ==================================================================
          Text(
            'Le régime des attroupements',
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
                  'L’attroupement est au cœur du maintien de l’ordre public. Il se distingue de la manifestation déclarée, '
                  'mais obéit à un régime juridique très encadré (Code Pénal et Code de la Sécurité Intérieure). ',
            ),
            TextSpan(
              text:
                  'Pour le policier, connaître précisément la définition de l’attroupement, les conditions de dispersion, '
                  'l’emploi de la force et les infractions associées est indispensable pour agir légalement et en sécurité.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 18),

          // ==================================================================
          // CHAPITRE 1 — DÉFINITION
          // ==================================================================
          _HypoCard(
            title: 'Chapitre 1 — Définition de l’attroupement',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Selon l’article 431-3 du Code Pénal, constitue un attroupement ',
                ),
                TextSpan(
                  text:
                      'tout rassemblement de personnes sur la voie publique ou dans un lieu public susceptible de troubler l’ordre public.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Pas besoin de violences effectives : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'il n’est pas exigé que des violences soient commises pour qu’un rassemblement soit qualifié d’attroupement. '
                      'Une simple menace de trouble peut suffire.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Attroupement ≠ manifestation illicite : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la manifestation illicite résulte d’une absence de déclaration, d’une déclaration incomplète ou inexacte, '
                      'ou encore d’une manifestation interdite par arrêté. L’attroupement vise le trouble potentiel à l’ordre public.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Le régime des attroupements est régi par les articles 431-3 à 431-8-1 du Code Pénal '
                'et par les articles L.211-9 et L.211-10 du Code de la Sécurité Intérieure.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Nature politique de l’infraction : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'par un arrêt du 28 mars 2017, la chambre criminelle de la Cour de cassation a qualifié le délit '
                      'd’attroupement prévu à l’article 431-4 du Code Pénal de ',
                ),
                TextSpan(
                  text: 'délit politique.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Procédures pénales rapides : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'l’article 431-8-1 du Code Pénal permet de recourir à des procédures rapides (comparution immédiate, '
                      'comparution sur reconnaissance préalable de culpabilité) sans remettre en cause le caractère politique du délit.',
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Procédures applicables à tous les délits commis à l’occasion d’attroupements :\n',
                ),
                TextSpan(
                  text:
                      '• convocation par procès-verbal et comparution immédiate (art. 393 à 397-7 C.P.P.) ;\n',
                ),
                TextSpan(
                  text:
                      '• comparution sur reconnaissance préalable de culpabilité (CRPC) (art. 495-7 à 495-15-1 C.P.P.).',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Réflexe policier',
                bodySpans: [
                  TextSpan(
                    text:
                        'Dès lors qu’un rassemblement devient susceptible de troubler l’ordre public, on peut entrer dans le champ '
                        'de l’attroupement. La qualification pénale et le respect des procédures de sommations et de dispersion '
                        'seront déterminants pour la suite judiciaire.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==================================================================
          // CHAPITRE 2 — PROCESSUS DE DISPERSION
          // ==================================================================
          _HypoCard(
            title: 'Chapitre 2 — Le processus de dispersion',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Dans les cas d’attroupements prévus à l’article 431-3 du Code Pénal, le maintien de l’ordre relève '
                'exclusivement du ministre de l’Intérieur (article D.211-10 du C.S.I.).',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Les forces armées, à l’exception de la gendarmerie nationale, ne peuvent participer au maintien de l’ordre '
                'que lorsqu’elles sont légalement requises. La réquisition est adressée par l’autorité civile territoriale '
                'responsable au commandant militaire compétent.',
              ),
              const SizedBox(height: 14),

              // 2.1 Décision de dispersion
              Text(
                '2.1 — La décision de dispersion',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Autorité compétente : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'c’est l’autorité civile, présente sur les lieux du rassemblement, qui apprécie la réalité et l’intensité '
                      'du danger pour l’ordre public.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Motivation de la décision : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la décision de dispersion doit être fondée sur des critères objectifs (équipements des participants, '
                      'présence d’armes, formation des individus, constitution de barricades, incendies, dissimulation des visages, etc.).',
                ),
              ]),
              const SizedBox(height: 14),

              // 2.2 Autorités habilitées
              Text(
                '2.2 — Les autorités habilitées à exécuter les sommations',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’article 431-3 alinéa 2 du Code Pénal et l’article L.211-9 du Code de la Sécurité Intérieure énumèrent '
                'les autorités habilitées à effectuer les sommations (préfet, sous-préfet, directeur de cabinet, maire ou adjoint, '
                'directeur de service territorial de la police, commandant de groupement de gendarmerie, commissaire mandaté, etc.).',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’article R.211-12 C.S.I. impose que ces autorités portent des insignes distinctifs lors des sommations :\n',
                ),
                TextSpan(
                  text:
                      '• écharpe tricolore ou brassard tricolore pour le représentant de l’État dans le département ;\n',
                ),
                TextSpan(
                  text:
                      '• écharpe tricolore ou brassard tricolore pour le maire ou l’un de ses adjoints ;\n',
                ),
                TextSpan(
                  text:
                      '• brassard tricolore pour l’officier de police judiciaire de la police nationale ou de la gendarmerie nationale.',
                ),
              ]),
              const SizedBox(height: 14),

              // 2.3 Exécution des sommations
              Text(
                '2.3 — L’exécution des sommations',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’article R.211-11 du Code de la Sécurité Intérieure prévoit que l’autorité habilitée doit procéder '
                'à deux sommations avant d’ordonner la dispersion par la force :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Annonce des sommations, généralement au moyen d’un haut-parleur, par des formules du type : '
                      '« Attention ! Attention ! Obéissance à la loi. Dispersez-vous. »\n',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les sommations sont répétées : première sommation, puis une seconde sommation en cas de refus de se disperser.\n',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'En cas d’impossibilité d’utiliser un haut-parleur (bruit, situation tactique…), la loi prévoit l’usage d’un '
                      'signal sonore ou visuel (par exemple, une fusée de couleur) pour compléter ou remplacer les formules orales.',
                ),
              ]),
              const SizedBox(height: 14),

              // 2.4 Dispersion et emploi de la force
              Text(
                '2.4 — La dispersion des attroupements et l’emploi de la force',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '2.4.1 — L’emploi de la force après les sommations',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’article R.211-13 C.S.I. précise que le recours à la force ne doit intervenir que lorsque les circonstances '
                'le rendent “absolument nécessaire au maintien de l’ordre public”. Si une autre solution est envisageable, '
                'elle doit être privilégiée.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La force déployée doit être strictement proportionnée au trouble à faire cesser et doit cesser dès que le trouble a pris fin.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le recours aux armes est encadré : les armes à feu susceptibles d’être utilisées sont énumérées par l’article D.211-17 C.S.I. :\n',
                ),
                TextSpan(text: '• grenades à effet sonore ;\n'),
                TextSpan(
                  text:
                      '• grenades lacrymogènes (instantanées ou à effet prolongé) ;\n',
                ),
                TextSpan(
                  text:
                      '• lanceurs de grenades calibre 40 ou 56 mm (et leurs munitions) ;\n',
                ),
                TextSpan(text: '• grenades à main de désencerclement, etc.'),
              ]),
              const SizedBox(height: 10),
              Text(
                '2.4.2 — Un usage immédiat de la force',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’article L.211-9 C.S.I. permet, dans certains cas, un recours immédiat à la force publique sans attendre la fin '
                'des sommations, notamment lorsque des violences ou voies de fait sont exercées contre les forces de l’ordre '
                'ou lorsque des lieux stratégiques sont menacés.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Dans ces situations, certaines armes non létales ou armes à feu spécifiques peuvent être utilisées '
                      '(D.211-19 et D.211-20 et s. C.S.I.) : projectiles non métalliques tirés par lanceur, grenades, etc.',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Point de vigilance opérationnelle',
                bodySpans: [
                  TextSpan(
                    text:
                        'Chaque usage de la force (et a fortiori des armes) doit pouvoir être justifié a posteriori : respect de la procédure '
                        '(sommations, signaux), nécessité et proportionnalité. Les procès-verbaux devront relater précisément les étapes de la dispersion.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ==================================================================
          // CHAPITRE 3 — INFRACTIONS ET SANCTIONS
          // ==================================================================
          _HypoCard(
            title: 'Chapitre 3 — Infractions et sanctions',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '3.1 — La participation à l’attroupement après sommations',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Article 431-4 du Code Pénal : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'le fait de continuer volontairement à participer à un attroupement après les sommations, sans être porteur d’une arme, '
                      'est puni d’un an d’emprisonnement et de 15 000 € d’amende. '
                      'La peine est portée à 3 ans et 45 000 € lorsque l’auteur dissimule volontairement tout ou partie de son visage '
                      'afin de ne pas être identifié.',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Article 431-5 du Code Pénal : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'le fait de participer à un attroupement en étant porteur d’une arme constitue un délit puni de 3 ans d’emprisonnement '
                      'et de 45 000 € d’amende. '
                      'Si la personne armée dissimule volontairement son visage après les sommations, la peine peut atteindre 5 ans '
                      'd’emprisonnement et 75 000 € d’amende.',
                ),
              ]),
              const SizedBox(height: 14),
              Text(
                '3.2 — La provocation à un attroupement armé',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Article 431-6 du Code Pénal : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'réprime la provocation directe à un attroupement armé par des discours, écrits ou tout autre moyen. '
                      'Les peines vont jusqu’à 5 ans d’emprisonnement et 45 000 € d’amende, portées à 7 ans et 100 000 € si la provocation '
                      'a été suivie d’effets (l’attroupement armé a effectivement eu lieu).',
                ),
              ]),
              const SizedBox(height: 14),
              Text(
                '3.3 — La provocation à commettre certains crimes ou délits',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Selon l’article 24 de la loi du 29 juillet 1881, la provocation à certains crimes ou délits commis à l’occasion '
                'd’attroupements peut être punie de 5 ans d’emprisonnement et 45 000 € d’amende. Sont notamment visés :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      '• les atteintes volontaires à la vie ou à l’intégrité des personnes ;\n'
                      '• les violences, destructions et dégradations dangereuses ;\n'
                      '• la rébellion et les outrages contre les agents de la force publique ;\n'
                      '• les entraves à la circulation routière, etc.',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'À retenir pour le procès-verbal',
                bodySpans: [
                  TextSpan(
                    text:
                        'En matière d’attroupements, il est essentiel de préciser dans les PV : la réalité des sommations, la situation '
                        'de l’intéressé (présent après sommations, armé ou non, visage dissimulé ou non) et, le cas échéant, '
                        'les actes de provocation ou de violences commis.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ==================================================================
          // CHAPITRE 4 — RÉPARATION DES DOMMAGES
          // ==================================================================
          _HypoCard(
            title:
                'Chapitre 4 — La réparation des dommages causés au cours des attroupements',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article L.211-10 du Code de la Sécurité Intérieure dispose que ',
                ),
                TextSpan(
                  text:
                      '« l’État est civilement responsable des dégâts et dommages résultant des crimes et délits commis, '
                      'à force ouverte ou par violence, par des attroupements ou rassemblements armés ou non armés, '
                      'soit contre les personnes, soit contre les biens ». ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’État peut exercer une action récursoire contre les auteurs du fait dommageable, dans les conditions prévues '
                      'par le code civil (articles 1240 et s.).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Une action récursoire peut également être engagée contre la commune lorsque la responsabilité de celle-ci '
                      'se trouve engagée.',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Conséquence pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Pour les forces de l’ordre, cette responsabilité de l’État justifie la rigueur dans le compte-rendu des faits '
                        'et des moyens employés. Les rapports et procès-verbaux serviront de base à l’indemnisation des victimes '
                        'et à l’éventuelle action récursoire contre les auteurs identifiés.',
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

/// ===================================================================
///  WIDGETS PRIVÉS (mêmes styles que les autres pages COP’IQ)
/// ===================================================================

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
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .10),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    final baseStyle = GoogleFonts.fustat(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: color,
    );

    if (spans == null) {
      return Text(text ?? '', textAlign: TextAlign.justify, style: baseStyle);
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint(this.text) : spans = null;
  const _BulletPoint.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFFBBDEFB)
        : const Color(0xFF1565C0);

    final baseStyle = GoogleFonts.fustat(
      fontSize: 13.8,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F).withValues(alpha: .92),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3, right: 8),
            child: Icon(Icons.check_rounded, size: 16, color: iconColor),
          ),
          Expanded(
            child: (spans == null)
                ? Text(text ?? '', style: baseStyle)
                : RichText(
                    text: TextSpan(style: baseStyle, children: spans),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color border = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1976D2);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border.withValues(alpha: .65), width: 0.9),
        color: isDark
            ? const Color(0xFF0D47A1).withValues(alpha: .18)
            : const Color(0xFFE3F2FD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, size: 18, color: border),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fustat(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: border,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.fustat(
                      fontSize: 13.5,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white70
                          : const Color(0xFF1F1F1F).withValues(alpha: .92),
                    ),
                    children: bodySpans,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color border = isDark
        ? const Color(0xFFFFCC80)
        : const Color(0xFFFF9800);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border.withValues(alpha: .7), width: 0.9),
        color: isDark
            ? const Color(0xFFFFA726).withValues(alpha: .16)
            : const Color(0xFFFFF3E0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, size: 18, color: border),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fustat(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: border,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: GoogleFonts.fustat(
                      fontSize: 13.5,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white70
                          : const Color(0xFF1F1F1F).withValues(alpha: .92),
                    ),
                    children: bodySpans,
                  ),
                ),
      
              ],
            ),
          ),
        ],
      ),
    );
  }
}
