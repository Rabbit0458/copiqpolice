import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — HIÉRARCHIE : AGENTS DE POLICE JUDICIAIRE (APJ)
///
///  Structure identique à tes pages "conditions de la complicité" / OPJ :
///   - Intro générale : rôle des APJ
///   - A. La qualité d’agent de police judiciaire
///   - B. Les agents de police judiciaire de l’article 20 du code de procédure pénale
///   - C. Les agents de police judiciaire de l’article 20-1 du code de procédure pénale
///   - Nota sur la remise à niveau / réserve opérationnelle
/// ===================================================================
class HierarchieApjPage extends StatelessWidget {
  const HierarchieApjPage({super.key});

  static const String routeName = '/gpx/generalites/hierarchie/apj';

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
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

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
          'Agents de police judiciaire',
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
            'Les agents de police judiciaire (APJ)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Les agents de police judiciaire sont définis par les articles 20, 20-1 et 21 du code de procédure pénale. ',
            ),
            const TextSpan(
              text:
                  'Ils disposent de certaines attributions de police judiciaire et ont pour mission essentielle de seconder les officiers de police judiciaire dans l’exercice de leurs fonctions.',
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph(
            'Le code de procédure pénale distingue plusieurs catégories d’agents de police judiciaire, en fonction de leur statut, de leur affectation et, pour certains, de leur engagement dans la réserve opérationnelle.',
          ),
          const SizedBox(height: 14),

          const _IntroBullet(
            text:
                'Les agents de police judiciaire participent aux enquêtes, sous la direction et le contrôle des officiers de police judiciaire.',
          ),
          const _IntroBullet(
            text:
                'Ils exercent des attributions de police judiciaire encadrées par le code de procédure pénale et les instructions de l’autorité judiciaire.',
          ),

          const SizedBox(height: 20),

          // =======================================================
          // A. QUALITÉ D’AGENT DE POLICE JUDICIAIRE
          // =======================================================
          _ConditionCard(
            title: 'A. La qualité d’agent de police judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les agents de police judiciaire sont investis de certaines attributions de police judiciaire. '
                'Ils doivent, en parallèle, seconder les officiers de police judiciaire dans l’accomplissement de leurs missions d’enquête.',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’article 20 du code de procédure pénale définit une première catégorie d’agents de police judiciaire. ',
                ),
                TextSpan(
                  text:
                      'L’article 20-1 du code de procédure pénale prévoit une autre catégorie visant plus spécifiquement la réserve opérationnelle de la police nationale et de la gendarmerie nationale.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // B. APJ DE L’ARTICLE 20 DU CODE DE PROCÉDURE PÉNALE
          // =======================================================
          _ConditionCard(
            title:
                'B. Les agents de police judiciaire de l’article 20 du code de procédure pénale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Sont agents de police judiciaire au sens de l’article 20 du code de procédure pénale (sous réserve des dispositions de l’article 20-1 du même code) :',
                ),
              ]),
              SizedBox(height: 10),

              _BulletPoint(
                text:
                    'Les militaires de la gendarmerie nationale autres que les volontaires, lorsqu’ils ne disposent pas de la qualité d’officier de police judiciaire.',
              ),
              _BulletPoint(
                text:
                    'Les fonctionnaires des services actifs de la police nationale, titulaires et stagiaires, lorsqu’ils ne disposent pas de la qualité d’officier de police judiciaire.',
              ),

              SizedBox(height: 12),
              _NotaBox(
                title: 'Rôle opérationnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Ces agents de police judiciaire participent aux missions d’enquête, exécutent les instructions des officiers de police judiciaire et réalisent les actes entrant dans leurs attributions, sous la direction de l’autorité judiciaire.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // === B.2 CONDITIONS D’EXERCICE APJ 20 ==================
          _ConditionCard(
            title:
                'B.2 Conditions d’exercice de la qualité d’agent de police judiciaire (article 20)',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Les agents de police judiciaire mentionnés à l’article 20 du code de procédure pénale ne peuvent exercer les attributions attachées à cette qualité que s’ils remplissent certaines conditions liées à leur emploi et à leurs missions.',
              ),
              SizedBox(height: 10),

              _BulletPoint(
                text:
                    'Ils doivent être affectés à un emploi comportant l’exercice de la police judiciaire.',
              ),
              _BulletPoint(
                text:
                    'Ils ne doivent pas participer, en unité constituée, à une opération de maintien de l’ordre.',
              ),
              SizedBox(height: 8),

              _Paragraph(
                'Sont donc exclus, pour l’exercice effectif de ces attributions, les fonctionnaires des services actifs affectés principalement à des tâches administratives ou engagés dans une mission de maintien de l’ordre.',
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: 'Modalités d’emploi',
                bodySpans: [
                  TextSpan(
                    text:
                        'Des instructions émanant de chaque direction active précisent les modalités d’emploi des gardiens agents de police judiciaire de l’article 20, afin d’assurer une utilisation cohérente et sécurisée de leurs prérogatives en matière de police judiciaire.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // C. APJ DE L’ARTICLE 20-1 DU CODE DE PROCÉDURE PÉNALE
          // =======================================================
          _ConditionCard(
            title:
                'C. Les agents de police judiciaire de l’article 20-1 du code de procédure pénale',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'L’article 20-1 du code de procédure pénale prévoit une qualité d’agent de police judiciaire au bénéfice de certains personnels servant dans la réserve opérationnelle.',
              ),
              SizedBox(height: 10),

              _SubTitle(
                'Personnels pouvant bénéficier de la qualité d’agent de police judiciaire (article 20-1)',
              ),
              _Paragraph(
                'Peuvent bénéficier de la qualité d’agent de police judiciaire, lorsqu’ils servent dans la réserve opérationnelle de la police nationale ou de la gendarmerie nationale :',
              ),
              SizedBox(height: 6),

              _BulletPoint(
                text:
                    'Les fonctionnaires de la police nationale, actifs ou à la retraite, ayant exercé en tant qu’officier de police judiciaire ou agent de police judiciaire pendant au moins cinq années au cours de leur activité.',
              ),
              _BulletPoint(
                text:
                    'Les militaires de la gendarmerie nationale, actifs ou à la retraite, ayant exercé en tant qu’officier de police judiciaire ou agent de police judiciaire pendant au moins cinq années au cours de leur activité.',
              ),

              SizedBox(height: 10),

              _SubTitle('Remise à niveau professionnelle'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Pour bénéficier durablement de cette qualité d’agent de police judiciaire dans la réserve opérationnelle, ',
                ),
                TextSpan(
                  text:
                      'les personnels ayant rompu le lien avec le service dans lequel ils exerçaient en tant qu’officier de police judiciaire ou agent de police judiciaire depuis plus d’un an ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      'sont soumis à une remise à niveau professionnelle adaptée et périodique.',
                ),
              ]),
              SizedBox(height: 8),

              _NotaBox(
                title: 'Objectif de la remise à niveau',
                bodySpans: [
                  TextSpan(
                    text:
                        'Cette formation vise à garantir que les agents de police judiciaire de la réserve opérationnelle maîtrisent toujours les règles de procédure, les droits des personnes et les techniques d’enquête, malgré l’interruption éventuelle de leur activité principale.',
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
