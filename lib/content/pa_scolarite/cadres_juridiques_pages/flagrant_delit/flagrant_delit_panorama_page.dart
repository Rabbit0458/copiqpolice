import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — CADRES JURIDIQUES : PANORAMA DE LA FLAGRANCE
///
///  Page d’intro générale (art. 53 à 73 du code de procédure pénale) :
///   - Intro : logique de l’enquête de flagrance
///   - A. Une enquête aux pouvoirs élargis
///   - B. Les infractions concernées (articles 53 et 67 du code de procédure pénale)
///   - C. L’exigence de rapidité et de protection des libertés
///   - Nota : prudence dans l’usage de ce cadre
/// ===================================================================
class PaFlagrantDelitPanoramaPage extends StatelessWidget {
  const PaFlagrantDelitPanoramaPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/intro';

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
          tooltip: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00001", 'Retour'),
        ),
        title: Text(
          ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00002", 'Panorama de la flagrance'),
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
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00003", 'L’enquête de police sur infraction flagrante'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00004", 'Articles 53 à 73 du code de procédure pénale.'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),

          // -------------------- INTRO ----------------------------
           _Paragraph(
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00005", 'L’enquête sur infraction flagrante donne aux membres de la police judiciaire ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00006", 'des pouvoirs élargis qui portent directement atteinte aux libertés individuelles. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00007", 'Ce cadre est réservé aux situations où une infraction suffisamment grave vient ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00008", 'd’être commise et où il est indispensable d’agir vite pour recueillir des preuves ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00009", 'encore évidentes de l’infraction.'),
          ),
          const SizedBox(height: 10),

           _Paragraph(
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00010", 'Dans ce contexte, la flagrance permet à la police judiciaire d’intervenir immédiatement, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00011", 'au plus près des faits, pour constater l’infraction, rechercher son auteur et préserver ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00012", 'les éléments de preuve avant qu’ils ne disparaissent.'),
          ),
          const SizedBox(height: 14),

           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00013", 'Un cadre d’enquête d’exception, qui autorise des mesures plus intrusives que dans l’enquête préliminaire.'),
          ),
           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00014", 'Une réponse adaptée aux infractions graves, pour lesquelles la rapidité d’intervention est déterminante.'),
          ),
          const SizedBox(height: 20),

          // =======================================================
          // A. UNE ENQUÊTE AUX POUVOIRS ÉLARGIS
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00015", 'A. Une enquête aux pouvoirs élargis'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00016", 'L’enquête de flagrance ouvre aux membres de la police judiciaire des pouvoirs ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00017", 'plus étendus que dans les autres cadres d’enquête. Cette extension des prérogatives ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00018", 'se justifie par la nécessité d’intervenir immédiatement, alors que l’infraction vient ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00019", 'tout juste de se produire et que les preuves sont encore directement accessibles.'),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00020", 'Parce que ces pouvoirs portent atteinte aux libertés individuelles ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00021", '(inviolabilité du domicile, liberté d’aller et venir, respect de la vie privée, etc.), '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00022", 'la flagrance reste un cadre exceptionnel, strictement encadré par le code de procédure pénale.'),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 10),
              _ExempleBox(
                title: 'Illustration',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00023", 'Un vol avec violence vient d’être commis sur la voie publique. Les témoins ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00024", 'désignent immédiatement l’auteur qui s’enfuit dans un immeuble voisin. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00025", 'Dans le cadre de l’infraction flagrante, les officiers de police judiciaire ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00026", 'peuvent intervenir rapidement pour localiser le suspect, sécuriser les lieux ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00027", 'et préserver les preuves (armes, objets volés, traces, témoignages récents).'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // B. LES INFRACTIONS CONCERNÉES
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00028", 'B. Les infractions concernées (articles 53 et 67 du code de procédure pénale)'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00029", 'La flagrance ne s’applique pas à toutes les infractions. Le code de procédure pénale ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00030", 'réserve ce cadre aux infractions les plus graves ou à celles que le législateur a estimé ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00031", 'nécessiter une réaction rapide de la police judiciaire.'),
              ),
              SizedBox(height: 10),

              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00032", 'Les crimes, au sens de la loi pénale (article 53 du code de procédure pénale).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00033", 'Les délits punis par la loi d’une peine d’emprisonnement (article 67 du code de procédure pénale).'),
              ),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00034", 'À l’inverse, ')),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00035", 'l’enquête de flagrant délit n’est pas possible pour les contraventions '),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00036", 'ni pour les délits uniquement punis d’une peine d’amende. Dans ces situations, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00037", 'd’autres cadres juridiques d’enquête doivent être utilisés (enquête préliminaire, notamment).'),
                ),
              ]),

              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00038", 'À retenir'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00039", 'La flagrance n’est pas un cadre “par défaut” mais un régime spécifique, réservé ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00040", 'aux crimes et aux délits assortis d’une peine d’emprisonnement. Son usage doit ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00041", 'toujours être justifié par les conditions légales et la nature de l’infraction.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // C. RAPIDITÉ & PREUVES ÉVIDENTES
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00042", 'C. Un cadre fondé sur la rapidité et les preuves encore évidentes'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00043", 'L’enquête sur infraction flagrante suppose que les faits viennent de se produire ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00044", 'ou qu’ils présentent encore une évidence particulière : auteur vu sur place, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00045", 'traces matérielles immédiatement constatables, situation de poursuite, etc.'),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00046", 'C’est cette proximité avec la commission de l’infraction qui justifie l’extension ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00047", 'des prérogatives de la police judiciaire : plus on est proche des faits, plus les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00048", 'indices sont frais, plus la collecte des preuves peut être efficace.'),
              ),
              SizedBox(height: 10),

              _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00049", 'Exemple de temporalité'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00050", 'Un cambriolage vient d’être signalé : la porte est fracturée, le logement ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00051", 'est encore en désordre, des voisins ont vu un individu quitter les lieux ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00052", 'quelques minutes auparavant. La flagrance permet une intervention rapide, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00053", 'avant que les traces ne disparaissent ou que les témoins n’oublient des détails essentiels.'),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00054", 'Prudence dans l’usage de la flagrance'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00055", 'Parce qu’elle permet des atteintes importantes aux libertés individuelles, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00056", 'la flagrance doit être maniée avec rigueur. Les conditions légales doivent ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00057", 'être vérifiées dès le départ et réévaluées au fur et à mesure de l’enquête. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00058", 'Lorsque la situation de flagrance disparaît, l’enquête doit se poursuivre ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart", "f00059", 'dans un autre cadre (enquête préliminaire, instruction, etc.).'),
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
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

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
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
