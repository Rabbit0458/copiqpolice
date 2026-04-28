import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchieIntroStructurePage extends StatelessWidget {
  const HierarchieIntroStructurePage({super.key});

  static const String routeName = '/gpx/generalites/hierarchie/intro_structure';

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
        : const Color(0xFF1F1F1F).withOpacity(.90);
    final Color accent = isDark
        ? const Color(0xFF90CAF9)
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
          'Structure des fonctions judiciaires',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            'La hiérarchie des fonctions judiciaires',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO GÉNÉRALE -------------------
          _Paragraph.rich([
            const TextSpan(
              text:
                  'La police judiciaire est exercée sous la direction du procureur de la République, conformément à l’article 12 du code de procédure pénale. ',
            ),
            const TextSpan(
              text:
                  'Dans chaque ressort de cour d’appel, elle est placée sous la surveillance du procureur général et sous le contrôle de la chambre de l’instruction (article 13 du code de procédure pénale).',
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph(
            'Pour exercer cette mission essentiellement répressive, la loi – en particulier le code de procédure pénale – confère aux personnels de la police nationale une qualification judiciaire : officier de police judiciaire, agent de police judiciaire ou agent de police judiciaire adjoint. '
            'Les officiers de police judiciaire et les agents de police judiciaire peuvent être secondés par des assistants d’enquête pour certaines démarches procédurales.',
          ),
          const SizedBox(height: 14),

          const _IntroBullet(
            text:
                'La police judiciaire agit toujours sous l’autorité du ministère public et sous le contrôle de la juridiction d’instruction.',
          ),
          const _IntroBullet(
            text:
                'Les qualifications judiciaires (officier de police judiciaire, agent de police judiciaire, agent de police judiciaire adjoint, assistants d’enquête) structurent la répartition des missions et des responsabilités au sein des services.',
          ),

          const SizedBox(height: 20),

          // =======================================================
          // A. DIRECTION ET CONTRÔLE DE LA POLICE JUDICIAIRE
          // =======================================================
          _ConditionCard(
            title: 'A. Direction et contrôle de la police judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'La police judiciaire ne fonctionne jamais de manière autonome. Elle agit dans un cadre hiérarchique et judiciaire très précis, qui garantit le respect des libertés individuelles et la régularité de la procédure pénale.',
              ),
              SizedBox(height: 10),
              _SubTitle('Rôle du procureur de la République'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le procureur de la République dirige l’activité de la police judiciaire. ',
                ),
                TextSpan(
                  text:
                      'Il oriente les enquêtes, fixe les priorités, décide de l’opportunité des poursuites et contrôle la légalité des actes réalisés par les services enquêteurs.',
                ),
              ]),
              SizedBox(height: 8),
              _SubTitle('Surveillance du procureur général'),
              _Paragraph(
                'Au niveau du ressort de la cour d’appel, le procureur général exerce une surveillance sur l’ensemble de l’activité de police judiciaire. '
                'Il veille notamment à la cohérence des pratiques, au respect de la loi et au bon fonctionnement des services enquêteurs.',
              ),
              SizedBox(height: 8),
              _SubTitle('Contrôle de la chambre de l’instruction'),
              _Paragraph(
                'La chambre de l’instruction contrôle certains actes et décisions pris dans le cadre des enquêtes et de l’instruction. '
                'Elle peut, par exemple, vérifier la régularité des actes, statuer sur des nullités de procédure ou encore apprécier la manière dont les pouvoirs de police judiciaire ont été exercés.',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // B. LES TROIS NIVEAUX DE QUALIFICATION JUDICIAIRE
          // =======================================================
          _ConditionCard(
            title: 'B. Les trois niveaux de qualification judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'La loi distingue trois grandes catégories de personnels investis de pouvoirs de police judiciaire au sein de la police nationale et de la gendarmerie nationale. '
                'Chacune de ces catégories dispose d’un niveau de responsabilité et de prérogatives différent.',
              ),
              SizedBox(height: 10),

              _SubTitle('1. Les officiers de police judiciaire'),
              _Paragraph(
                'Les officiers de police judiciaire disposent des pouvoirs les plus étendus en matière d’enquête pénale. '
                'Ils dirigent les investigations, prennent certaines décisions coercitives prévues par le code de procédure pénale et rendent compte directement au procureur de la République ou au juge d’instruction.',
              ),
              SizedBox(height: 8),

              _SubTitle('2. Les agents de police judiciaire'),
              _Paragraph(
                'Les agents de police judiciaire assistent les officiers de police judiciaire dans la conduite des enquêtes. '
                'Ils réalisent de nombreux actes de procédure dans le cadre des instructions qui leur sont données (constatations, auditions, notifications, etc.).',
              ),
              SizedBox(height: 8),

              _SubTitle('3. Les agents de police judiciaire adjoints'),
              _Paragraph(
                'Les agents de police judiciaire adjoints disposent de pouvoirs plus limités, mais contribuent directement aux missions de police judiciaire sur le terrain : '
                'policiers adjoints, agents de police municipale, gardes champêtres, réservistes, etc. '
                'Ils agissent sous le contrôle des officiers de police judiciaire et des agents de police judiciaire.',
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: 'Logique de hiérarchie fonctionnelle',
                bodySpans: [
                  TextSpan(
                    text:
                        'Cette organisation par niveaux (officiers de police judiciaire, agents de police judiciaire, agents de police judiciaire adjoints) permet de répartir les responsabilités en fonction des compétences, de la formation et du degré d’initiative attendu de chaque catégorie de personnels.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // C. LES ASSISTANTS D’ENQUÊTE ET LE TRAVAIL EN ÉQUIPE
          // =======================================================
          _ConditionCard(
            title: 'C. Les assistants d’enquête et le travail en équipe',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les officiers de police judiciaire et les agents de police judiciaire peuvent être secondés par des assistants d’enquête, désignés à l’article 21-3 du code de procédure pénale. ',
                ),
                TextSpan(
                  text:
                      'Ces personnels participent à l’accomplissement de certaines formalités procédurales et renforcent la capacité opérationnelle des services d’enquête.',
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                'Ils sont recrutés parmi des personnels spécifiquement identifiés (corps de soutien, personnels administratifs, agents de police judiciaire adjoints, etc.) et doivent suivre une formation assortie d’un examen attestant leur aptitude à exercer ces missions.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Une chaîne judiciaire coordonnée',
                bodySpans: [
                  TextSpan(
                    text:
                        'La police judiciaire repose sur un travail d’équipe : officiers de police judiciaire, agents de police judiciaire, agents de police judiciaire adjoints et assistants d’enquête agissent de manière complémentaire, '
                        'sous la direction de l’autorité judiciaire, pour garantir l’efficacité de l’enquête et la protection des droits fondamentaux.',
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
  const _ExempleBox({required this.title, required this.bodySpans});

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
        color: bgColor.withOpacity(isDark ? .65 : .9),
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
                    : const Color(0xFF102027).withOpacity(.95),
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
