import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPActionPubliqueChapitre1TitrePreliminairePage extends StatelessWidget {
  const PaPPActionPubliqueChapitre1TitrePreliminairePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_1_titre_preliminaire';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardBg = isDark
        ? const Color(0xFF2B3036)
        : const Color(0xFFF5F7FB);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark ? Colors.white : const Color(0xFF0D47A1);

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
          'Chapitre 1 — Titre préliminaire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // =================== EN-TÊTE CHAPITRE ============================
          Text(
            'Titre préliminaire et\nfondements de la procédure pénale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Repères essentiels sur les grands principes de la procédure pénale '
            'et sur la naissance des actions publique et civile à partir d’une '
            'même infraction.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // =================== ARTICLE PRELIMINAIRE ========================
          _ConditionCard(
            title: 'Article préliminaire du Code de procédure pénale',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: 'Article préliminaire du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : ce texte pose les grands principes qui s’imposent à '
                      'tous les acteurs de la procédure pénale.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle(
                'I — Procédure équitable, contradictoire et équilibrée',
              ),
              const _Paragraph(
                'La procédure pénale doit être équitable et contradictoire et '
                'préserver l’équilibre des droits des parties. '
                'Elle doit garantir la séparation entre, d’une part, les autorités '
                'chargées de l’action publique (principalement le ministère public) '
                'et, d’autre part, les autorités de jugement. '
                'Les personnes placées dans des conditions semblables et '
                'poursuivies pour les mêmes infractions doivent être jugées '
                'selon les mêmes règles.',
              ),
              const SizedBox(height: 8),

              const _SubTitle('II — Protection des victimes'),
              const _Paragraph(
                'L’autorité judiciaire veille, au cours de toute procédure pénale, '
                'à l’information et à la garantie des droits des victimes. '
                'Les victimes doivent pouvoir être associées à la procédure et '
                'être informées des suites données à leur affaire.',
              ),
              const SizedBox(height: 8),

              const _SubTitle(
                'III — Présomption d’innocence et droits de la défense',
              ),
              const _Paragraph(
                'Toute personne suspectée ou poursuivie est présumée innocente '
                'tant que sa culpabilité n’a pas été légalement établie. '
                'Les atteintes à la présomption d’innocence doivent être '
                'prévenues, réparées et réprimées conformément à la loi. '
                'La personne a le droit d’être informée des charges retenues '
                'contre elle et d’être assistée par un défenseur.',
              ),
              const SizedBox(height: 6),

              const _IntroBullet(
                text:
                    'Si la personne ne comprend pas la langue française, elle a droit, '
                    'dans une langue qu’elle comprend, à l’assistance d’un interprète '
                    'tout au long de la procédure, y compris pour les entretiens '
                    'avec son avocat en lien direct avec un interrogatoire ou une audience.',
              ),
              const _IntroBullet(
                text:
                    'Sauf renonciation expresse et éclairée de sa part, elle a droit à la '
                    'traduction des pièces essentielles à l’exercice de sa défense et à la '
                    'garantie du caractère équitable du procès.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Mesures de contrainte et respect de la dignité'),
              const _Paragraph(
                'Les mesures de contrainte dont la personne peut faire l’objet sont '
                'prises sur décision ou sous le contrôle effectif de l’autorité judiciaire. '
                'Elles doivent être strictement limitées aux nécessités de la procédure, '
                'proportionnées à la gravité de l’infraction reprochée et ne pas porter '
                'atteinte à la dignité de la personne.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Délai raisonnable et vie privée'),
              const _Paragraph(
                'Il doit être définitivement statué sur l’accusation dans un délai raisonnable. '
                'Les mesures portant atteinte à la vie privée d’une personne ne peuvent être '
                'prises, sur décision ou sous le contrôle effectif de l’autorité judiciaire, '
                'que si elles sont nécessaires à la manifestation de la vérité et proportionnées '
                'à la gravité de l’infraction.',
              ),
              const SizedBox(height: 6),

              const _SubTitle(
                'Voies de recours et déclarations de la personne',
              ),
              const _Paragraph(
                'Toute personne condamnée a le droit de faire examiner sa condamnation '
                'par une autre juridiction. '
                'En matière criminelle et correctionnelle, aucune condamnation ne peut être '
                'prononcée sur le seul fondement de déclarations faites par la personne '
                'sans qu’elle ait pu s’entretenir avec un avocat et être assistée par lui.',
              ),
              const SizedBox(height: 6),

              const _SubTitle('Droit de se taire'),
              const _Paragraph(
                'En matière de crime ou de délit, le droit de se taire sur les faits reprochés '
                'est notifié à toute personne suspectée ou poursuivie avant tout recueil de '
                'ses observations et avant tout interrogatoire, y compris lorsque l’audition '
                'vise à obtenir des renseignements sur sa personnalité ou à prononcer une '
                'mesure de sûreté. Aucune condamnation ne peut être prononcée sur le seul '
                'fondement de déclarations recueillies sans que ce droit ait été notifié.',
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le respect du secret professionnel de la défense et du conseil, ',
                ),
                TextSpan(
                  text:
                      'prévu à l’article 66-5 de la loi n° 71-1130 du 31 décembre 1971 ',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      'portant réforme de certaines professions judiciaires et juridiques, '
                      'est garanti au cours de la procédure pénale dans les conditions '
                      'prévues par le Code de procédure pénale.',
                ),
              ]),
              const SizedBox(height: 12),

              const _NotaBox(
                title: 'À retenir pour l’enquêteur',
                bodySpans: [
                  TextSpan(
                    text:
                        'ces principes guident toutes les mesures d’enquête. Un acte utile '
                        'juridiquement mais réalisé en violation de ces garanties fondamentales '
                        'risque d’être annulé et de fragiliser tout le dossier.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 1.1 NOTIONS GENERALES =======================
          const _SubTitle('1.1 — Notions générales'),
          const SizedBox(height: 4),
          const _Paragraph(
            'Le plus souvent, une infraction à la loi pénale — crime, délit ou '
            'contravention — cause un dommage à autrui. Par exemple, une personne '
            'blessée après des violences volontaires. Dans ce cas, un même fait pénal '
            'fait naître deux actions en justice distinctes.',
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: 'Naissance des deux actions',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _IntroBullet(
                text:
                    'Une action tendant à faire appliquer à l’auteur une peine prévue par la loi : '
                    'c’est l’action publique.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’action publique a pour objet l’application des peines.',
                ),
              ]),
              const SizedBox(height: 8),

              const _IntroBullet(
                text:
                    'Une action visant à la réparation du dommage corporel, matériel ou moral '
                    'subi par la victime : c’est l’action civile.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 2 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’action civile tend à la réparation du dommage causé par l’infraction.',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('Cas particuliers'),
              const _BulletPoint(
                text:
                    'Certaines infractions ne causent pas de dommage direct à une personne '
                    'déterminée (par exemple : port d’une arme à feu soumise à autorisation '
                    'sans droit). Elles ne donnent alors naissance qu’à une seule action : '
                    'l’action publique.',
              ),
              const _BulletPoint(
                text:
                    'À l’inverse, il peut exister une action civile indépendante de toute '
                    'infraction pénale. La victime agit alors sur le fondement de la '
                    'responsabilité civile.',
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: 'Article 1240 du Code civil',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' et '),
                TextSpan(
                  text: 'article 4-1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' permettent à une victime d’obtenir réparation de son préjudice même '
                      'en dehors de toute poursuite pénale. Cette action relève alors du '
                      'juge civil uniquement.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 1.2 COMPARAISON DES DEUX ACTIONS ============
          const _SubTitle('1.2 — Comparaison des deux actions'),
          const SizedBox(height: 4),
          const _Paragraph(
            'L’action publique et l’action civile présentent des différences nettes, '
            'mais aussi des points de rapprochement puisqu’elles prennent naissance '
            'à partir d’une même infraction.',
          ),
          const SizedBox(height: 14),

          // ----------------- 1.2.1 LES DIFFERENCES -------------------------
          _ConditionCard(
            title:
                '1.2.1 — Les différences entre action publique et action civile',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _SubTitle('Fondement'),
              _BulletPoint(
                text:
                    'L’action publique trouve son fondement dans l’infraction elle-même '
                    '(atteinte à l’ordre public).',
              ),
              _BulletPoint(
                text:
                    'L’action civile a pour fondement le dommage causé à la victime. '
                    'Sans préjudice, il n’y a pas d’action civile.',
              ),
              SizedBox(height: 8),

              _SubTitle('But poursuivi'),
              _BulletPoint(
                text:
                    'L’action publique vise à réparer le trouble social par l’application '
                    'd’une peine.',
              ),
              _BulletPoint(
                text:
                    'L’action civile a pour objet la réparation du préjudice individuel '
                    '(dommages-intérêts).',
              ),
              SizedBox(height: 8),

              _SubTitle('Personnes pouvant agir'),
              _BulletPoint(
                text:
                    'L’action publique est exercée par les magistrats du ministère public '
                    'contre les auteurs et complices de l’infraction, sauf cas particuliers '
                    'où la victime peut la mettre en mouvement (plainte avec constitution '
                    'de partie civile, citations directes, etc.).',
              ),
              _BulletPoint(
                text:
                    'L’action civile appartient à la victime ou à ses ayants cause, qui '
                    'l’exercent contre l’auteur de l’infraction, ses héritiers ou les '
                    'personnes civilement responsables.',
              ),
              SizedBox(height: 8),

              _SubTitle('Caractère de chaque action'),
              _BulletPoint(
                text:
                    'L’action publique est d’ordre public : le ministère public ne peut '
                    'ni y renoncer ni transiger, sauf exceptions prévues par la loi '
                    '(par exemple certaines alternatives aux poursuites).',
              ),
              _BulletPoint(
                text:
                    'L’action civile est d’ordre privé : la partie lésée peut renoncer à '
                    'son action ou transiger.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ----------------- 1.2.2 RAPPROCHEMENTS -------------------------
          _ConditionCard(
            title: '1.2.2 — Points de rapprochement',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _BulletPoint(
                text:
                    'Les deux actions naissent d’un même fait : l’infraction. C’est ce '
                    'fait unique qui déclenche à la fois la réaction de la société et '
                    'la demande de réparation de la victime.',
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: 'Article 3 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’action civile peut être exercée en même temps que l’action '
                      'publique devant la juridiction répressive. La victime conserve '
                      'néanmoins la faculté de saisir directement le juge civil.',
                ),
              ]),
              const SizedBox(height: 8),

              const _BulletPoint(
                text:
                    'Lorsque la victime dépose une plainte avec constitution de partie '
                    'civile alors que l’action publique n’a pas encore été mise en œuvre, '
                    'son initiative déclenche l’action publique.',
              ),
              const SizedBox(height: 6),

              const _BulletPoint(
                text:
                    'Si l’action civile est portée devant le juge civil, celui-ci doit tenir '
                    'compte de la décision pénale définitive : la chose jugée au pénal a '
                    'autorité sur le civil. On dit que « le criminel tient le civil en état ».',
              ),
              const SizedBox(height: 6),

              const _Paragraph(
                'Tout au long du procès pénal, l’action publique et, par ricochet, l’action '
                'civile s’exercent à travers les actes de poursuite, d’instruction et de '
                'jugement. Ce n’est pas un moment unique du procès, mais un fil conducteur '
                'qui suit toute la procédure.',
              ),
              const SizedBox(height: 10),

              const _NotaBox(
                title: 'En pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'l’enquêteur doit toujours garder à l’esprit la double dimension de '
                        'son dossier : la réponse pénale (action publique) et la réparation '
                        'du préjudice de la victime (action civile). Une procédure claire, '
                        'précise et respectueuse des droits des parties sécurise ces deux '
                        'volets.',
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
