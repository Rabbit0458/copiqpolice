import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class HierarchieAssistantsEnquetePage extends StatelessWidget {
  const HierarchieAssistantsEnquetePage({super.key});

  static const String routeName =
      '/gpx/generalites/hierarchie/assistants_enquete';

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
        ? const Color(0xFFFFB74D)
        : const Color(0xFFF57C00);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
            "f00002",
            'Les assistants d’enquête',
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
              "f00003",
              'Les assistants d’enquête',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                "f00004",
                'Les assistants d’enquête, prévus à l’article 21-3 du code de procédure pénale, ont pour mission de seconder les officiers de police judiciaire et les agents de police judiciaire dans l’accomplissement de certaines formalités procédurales. ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                "f00005",
                'Ils renforcent la capacité opérationnelle des services d’enquête, tout en agissant dans un cadre strictement défini par la loi.',
              ),
            ),
          ]),
          const SizedBox(height: 12),

          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
              "f00006",
              'Les assistants d’enquête ne remplacent pas les officiers de police judiciaire ou les agents de police judiciaire, mais les appuient dans la réalisation des actes de procédure.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
              "f00007",
              'Ils sont choisis parmi des personnels déjà insérés dans les institutions de sécurité intérieure ou de justice, et spécialement formés à ces missions.',
            ),
          ),

          const SizedBox(height: 20),

          // =======================================================
          // A. MISSION ET RÔLE DES ASSISTANTS D’ENQUÊTE
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
              "f00008",
              'A. Missions des assistants d’enquête',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                      "f00009",
                      'Les assistants d’enquête sont chargés de seconder les officiers de police judiciaire et les agents de police judiciaire dans l’accomplissement de certaines formalités procédurales. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                      "f00010",
                      'Ils participent concrètement au déroulement de l’enquête, en réalisant des tâches techniques ou administratives qui nécessitent une bonne maîtrise de la procédure pénale.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00011",
                  'Leur intervention permet aux officiers de police judiciaire et aux agents de police judiciaire de se concentrer sur les actes d’enquête les plus sensibles ou les plus décisifs, tout en garantissant la qualité et la traçabilité des opérations réalisées.',
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00012",
                  'Travail en appui',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                          "f00013",
                          'Les assistants d’enquête agissent toujours sous l’autorité et la responsabilité des officiers de police judiciaire et des agents de police judiciaire. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                          "f00014",
                          'Ils n’ont pas vocation à décider seuls des orientations de l’enquête, mais à mettre en œuvre les tâches qui leur sont confiées.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // B. PROFILS RECRUTÉS COMME ASSISTANTS D’ENQUÊTE
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
              "f00015",
              'B. Les personnels pouvant être assistants d’enquête (article 21-3 du code de procédure pénale)',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                      "f00016",
                      'Les assistants d’enquête sont recrutés parmi des personnels déjà intégrés dans les structures de la gendarmerie nationale ou de la police nationale. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                      "f00017",
                      'Ils apportent leur expérience et leurs compétences dans le domaine administratif, technique ou opérationnel.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00018",
                  'Militaires du corps de soutien technique et administratif',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00019",
                  'Les militaires appartenant au corps de soutien technique et administratif de la gendarmerie nationale peuvent être désignés comme assistants d’enquête.',
                ),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00020",
                  'Personnels administratifs de catégorie B',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00021",
                  'Les personnels administratifs de catégorie B de la police nationale et de la gendarmerie nationale peuvent également exercer les fonctions d’assistant d’enquête.',
                ),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00022",
                  'Agents de police judiciaire adjoints',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00023",
                  'Les agents de police judiciaire adjoints de la police nationale et de la gendarmerie nationale peuvent, eux aussi, être désignés comme assistants d’enquête.',
                ),
              ),

              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00024",
                  'Diversité des profils',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                          "f00025",
                          'Cette diversité de profils (militaires de soutien, personnels administratifs, agents de police judiciaire adjoints) permet de doter les services d’enquête de compétences variées, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                          "f00026",
                          'utiles tant pour la gestion des procédures que pour le suivi administratif et logistique des dossiers.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // C. FORMATION ET APTITUDE
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
              "f00027",
              'C. Formation et aptitude des assistants d’enquête',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                    "f00028",
                    'Les assistants d’enquête doivent avoir satisfait à une formation spécifique, sanctionnée par un examen, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                    "f00029",
                    'certifiant leur aptitude à assurer les missions que la loi leur confie.',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00030",
                  'Cette formation porte notamment sur la procédure pénale, les droits des personnes mises en cause ou victimes, la rédaction des actes, ainsi que sur les outils informatiques et les applications métiers utilisées dans les services d’enquête.',
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                  "f00031",
                  'Garantie de compétence',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                          "f00032",
                          'L’exigence de formation et d’examen garantit que les assistants d’enquête maîtrisent les règles de fond et de forme des actes qu’ils accomplissent. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart",
                          "f00033",
                          'Elle contribue à la fiabilité juridique des procédures et à la qualité globale du travail d’enquête.',
                        ),
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
