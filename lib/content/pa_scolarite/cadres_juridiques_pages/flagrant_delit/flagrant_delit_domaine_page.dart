import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaFlagrantDelitDomainePage extends StatelessWidget {
  const PaFlagrantDelitDomainePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre2';

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
          'Enquête de flagrant délit — domaine',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // --------------------------------------------------------
          // TITRE GLOBAL
          // --------------------------------------------------------
          Text(
            'Enquête de flagrant délit — domaine d’application',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'L’enquête de flagrant délit, régie par le code de procédure pénale, est soumise à des conditions tenant à la fois aux personnes concernées et aux lieux dans lesquels les actes de police judiciaire peuvent être accomplis. ',
            ),
            TextSpan(
              text:
                  'Ces conditions visent à concilier l’efficacité de l’enquête avec la protection renforcée de certaines immunités et de certains espaces.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 12),

          const _IntroBullet(
            text:
                'Certaines personnes bénéficient d’une immunité ou d’une protection particulière qui limite, voire exclut, les pouvoirs de l’enquête de flagrant délit à leur égard.',
          ),
          const _IntroBullet(
            text:
                'Certains lieux, en raison de leur statut (diplomatique, parlementaire, universitaire, militaire, défense nationale), sont soumis à des régimes d’accès et d’investigations spécifiques.',
          ),

          const SizedBox(height: 20),

          // =======================================================
          // A. LES PERSONNES
          // =======================================================
          _ConditionCard(
            title: 'A. Les personnes',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’enquête de flagrant délit ne s’exerce pas de la même manière à l’égard de toutes les personnes. '
                'Certaines bénéficient d’immunités ou de protections particulières, en vertu du droit international, de la Constitution ou de textes spécifiques.',
              ),
              SizedBox(height: 10),

              // 1) Agents diplomatiques & assimilés
              _SubTitle('1. Les agents diplomatiques et assimilés'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les agents diplomatiques, les membres de leur famille, les membres du personnel de service de la mission, ainsi que les domestiques privés de ces derniers lorsqu’ils ne sont pas ressortissants de l’État sur le territoire duquel est implantée l’ambassade, ',
                ),
                TextSpan(
                  text: 'bénéficient d’une immunité complète. ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'Ils ne peuvent faire l’objet d’aucune forme d’arrestation sur le territoire de l’État accréditaire.',
                ),
              ]),
              SizedBox(height: 6),

              // 2) Fonctionnaires consulaires
              _SubTitle('2. Les fonctionnaires consulaires'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les fonctionnaires consulaires ne peuvent être mis en état d’arrestation ou de détention préventive qu’en cas de crime grave et à la suite d’une décision de l’autorité judiciaire compétente. ',
                ),
                TextSpan(
                  text:
                      'Sauf en cas de crime flagrant, les conventions bilatérales les exemptent le plus souvent de toute arrestation.',
                ),
              ]),
              SizedBox(height: 8),

              // 3) Membres d’organismes internationaux
              _SubTitle(
                '3. Les membres de certains organismes internationaux',
              ),
              _Paragraph(
                'Les membres de certains organismes internationaux peuvent bénéficier d’immunités spécifiques prévues par des conventions internationales. '
                'Ces immunités limitent les possibilités d’enquête de flagrant délit à leur égard, sauf exceptions prévues par les textes.',
              ),
              SizedBox(height: 10),

              // 4) Président de la République
              _SubTitle('4. Le président de la République'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Sauf dans les hypothèses de compétence de la Cour pénale internationale (par exemple en matière de génocide ou de crime contre l’humanité) ou de compétence de la Haute Cour (article 68 de la Constitution : manquement manifestement incompatible avec l’exercice du mandat), ',
                ),
                TextSpan(
                  text:
                      'le président de la République bénéficie d’une irresponsabilité pour les actes accomplis dans l’exercice de ses fonctions. ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'Il bénéficie également d’une inviolabilité totale pendant la durée de son mandat. '
                'Il ne peut faire l’objet d’aucun acte d’information, d’instruction ou de poursuite pour les actes étrangers à ses fonctions, commis avant ou pendant l’exercice de son quinquennat.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Cette inviolabilité prend fin à l’expiration d’un délai d’un mois suivant la fin de son mandat ou la décision de destitution prononcée par le Parlement siégeant en Haute Cour. '
                'La loi organique n° 2014-1392 du 24 novembre 2014 fixe les conditions d’application de l’article 68 de la Constitution.',
              ),
              SizedBox(height: 10),

              // 5) Membres du Parlement
              _SubTitle('5. Les membres du Parlement'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’irresponsabilité pénale des membres du Parlement ne concerne que les opinions ou votes qu’ils émettent dans l’exercice de leurs fonctions. ',
                ),
                TextSpan(
                  text:
                      'En dehors de cette hypothèse, ils peuvent, en cas de flagrant délit, être arrêtés et placés en garde à vue. ',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Toutefois, l’officier de police judiciaire ne peut décider une mesure de garde à vue à l’encontre d’un parlementaire que s’il existe ',
                ),
                TextSpan(
                  text:
                      'des indices graves et concordants de nature à motiver sa mise en examen. ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'L’officier de police judiciaire doit en rendre compte au procureur de la République, qui informe le garde des Sceaux.',
                ),
              ]),
              SizedBox(height: 10),

              // 6) Mineurs
              _SubTitle('6. Les mineurs'),
              _Paragraph(
                'Les mineurs peuvent faire l’objet d’une enquête de flagrant délit. '
                'En matière de garde à vue, des règles spécifiques s’appliquent toutefois : présence obligatoire ou information des représentants légaux, assistance d’un avocat, durées adaptées, et prise en compte de l’intérêt supérieur de l’enfant.',
              ),

              SizedBox(height: 14),
              _NotaBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'L’enquête de flagrant délit ne permet pas de passer outre les immunités diplomatiques, les protections constitutionnelles ou les statuts particuliers de certaines fonctions. ',
                  ),
                  TextSpan(
                    text:
                        'L’officier de police judiciaire doit connaître ces régimes pour adapter ses actes d’enquête et, en cas de doute, solliciter les instructions du procureur de la République.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // B. LES LIEUX
          // =======================================================
          _ConditionCard(
            title: 'B. Les lieux',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’enquête de flagrant délit est également encadrée par des règles tenant aux lieux dans lesquels les investigations sont menées. '
                'Certains espaces bénéficient d’une inviolabilité ou d’un régime d’accès particulier, parfois subordonné à une réquisition ou à une autorisation préalable.',
              ),
              SizedBox(height: 10),

              // 1) Locaux diplomatiques et consulaires
              _SubTitle('1. Locaux diplomatiques et consulaires'),
              _BulletPoint(
                text:
                    'Les locaux diplomatiques, la demeure privée de l’agent diplomatique, ainsi que les véhicules de la mission sont inviolables, sauf sur réquisition du chef de la mission.',
              ),
              _BulletPoint(
                text:
                    'Les locaux consulaires sont protégés pour la partie utilisée aux besoins du travail consulaire. Les actes d’enquête doivent respecter cette protection.',
              ),
              SizedBox(height: 8),

              // 2) Parlement et universités
              _SubTitle(
                '2. Assemblée nationale, Sénat et enceintes universitaires',
              ),
              _BulletPoint(
                text:
                    'L’introduction dans l’enceinte de l’Assemblée nationale ou du Sénat n’est possible que sur réquisition de leurs présidents.',
              ),
              _BulletPoint(
                text:
                    'L’entrée dans une enceinte universitaire est possible dans trois hypothèses : sur réquisition du chef d’établissement, sur autorisation spéciale écrite du procureur de la République, ou à titre exceptionnel pour mettre fin à la commission d’infractions particulièrement graves.',
              ),
              SizedBox(height: 8),

              // 3) Établissements militaires / défense nationale
              _SubTitle(
                '3. Établissements militaires et lieux intéressant la défense nationale',
              ),
              _BulletPoint(
                text:
                    'En temps de guerre, l’entrée dans les établissements militaires doit être précédée d’une réquisition établie par l’officier de police judiciaire, précisant la nature et les motifs des investigations jugées nécessaires (article L. 212-6 du code de justice militaire).',
              ),
              _BulletPoint(
                text:
                    'L’entrée dans les services, établissements ou entreprises, publics ou privés, intéressant la défense nationale est soumise à autorisation préalable (article 413-7 du code pénal).',
              ),

              SizedBox(height: 14),
              _NotaBox(
                title: 'Respect des lieux protégés',
                bodySpans: [
                  TextSpan(
                    text:
                        'Même en cas de flagrance, la police judiciaire doit respecter les régimes d’inviolabilité et d’autorisation préalable attachés à certains lieux. ',
                  ),
                  TextSpan(
                    text:
                        'En pratique, l’officier de police judiciaire doit systématiquement vérifier le statut du lieu concerné et, si nécessaire, requérir l’autorité compétente (chef de mission, président d’assemblée, chef d’établissement, autorité militaire, procureur de la République…).',
                    style: TextStyle(fontWeight: FontWeight.w600),
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
  const _ExempleBox({required this.bodySpans});

  final String title = 'NOTA';
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
