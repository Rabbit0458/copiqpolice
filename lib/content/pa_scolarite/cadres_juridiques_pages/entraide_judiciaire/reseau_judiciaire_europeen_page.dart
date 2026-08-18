import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaReseauJudiciaireEuropeenPage extends StatelessWidget {
  const PaReseauJudiciaireEuropeenPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/reseau_judiciaire_europeen';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
            "f00001",
            'Retour',
          ),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
            "f00002",
            'Réseau judiciaire européen',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // =================================================================
          // EN-TÊTE GENERAL
          // =================================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
              "f00003",
              'L’entraide judiciaire internationale',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
              "f00004",
              'Chapitre 1 — La coopération pénale policière',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 12),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
              "f00005",
              '1.3 — Le Réseau judiciaire européen (R.J.E.)',
            ),
          ),
          const SizedBox(height: 4),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00006",
                  'Créé en 1998, le Réseau judiciaire européen (R.J.E.) est un réseau de magistrats. ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00007",
                  'Il a pour objectif de faciliter l’exécution et la coordination des demandes ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00008",
                  'd’entraide pénale au sein de l’Union européenne.',
                ),
          ),
          const SizedBox(height: 8),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
              "f00009",
              'Présentation générale du Réseau judiciaire européen',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00010",
                      'Le R.J.E. met à disposition des magistrats de l’ensemble des États membres ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00011",
                      'de l’Union européenne des outils pratiques pour l’entraide pénale ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00012",
                      'internationale. Un site internet dédié regroupe différents outils et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00013",
                      'informations, permettant à tout magistrat d’identifier rapidement les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00014",
                      'coordonnées de l’autorité étrangère compétente pour exécuter une demande ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00015",
                      'd’entraide pénale ou un mandat européen émis.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
              "f00016",
              'Les points de contact du R.J.E. en France',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00017",
                  'Les points de contact du R.J.E. sont, en France, répartis sur trois niveaux :',
                ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00018",
                  '1. Niveau de l’administration centrale',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00019",
                      'Au sein de l’administration centrale, les points de contact français du réseau ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00020",
                      'sont notamment :',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00021",
                  'Le directeur des affaires criminelles et des grâces ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00022",
                  'Le chef du service des affaires européennes et internationales ;',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00023",
                      'Le chef du bureau de l’entraide pénale internationale, qui exerce également ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00024",
                      'la fonction de coordonnateur national du R.J.E.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00025",
                  '2. Niveau des juridictions',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00026",
                      'Pour les juridictions, il existe au niveau de chaque parquet général, au sein ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00027",
                      'des cours d’appel, un point de contact régional du R.J.E. Ces magistrats ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00028",
                      'facilitent la circulation de l’information et l’orientation des demandes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00029",
                      'd’entraide pénale internationale.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                  "f00030",
                  '3. Niveau international',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00031",
                      'Au plan international, tous les magistrats de liaison français à l’étranger sont ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00032",
                      'également des points de contact français du réseau. Ils constituent un relais ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00033",
                      'privilégié pour les autorités judiciaires françaises dans leurs échanges avec ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00034",
                      'les États auprès desquels ils sont accrédités.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00035",
                      'Le secrétariat du Réseau judiciaire européen est basé à Eurojust. Le R.J.E., ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00036",
                      'par sa nature informelle et souple, permet une grande réactivité dans le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00037",
                      'traitement des demandes d’entraide et dans la résolution pratique des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart",
                      "f00038",
                      'difficultés rencontrées par les autorités judiciaires nationales.',
                    ),
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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
