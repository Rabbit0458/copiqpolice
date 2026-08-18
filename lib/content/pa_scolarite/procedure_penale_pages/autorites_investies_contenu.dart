import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAutoriteInvestiesLoiPage extends StatelessWidget {
  const PaAutoriteInvestiesLoiPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
            "f00002",
            'Les autorités investies par la loi de fonctions de police judiciaire',
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00003",
              'Les autorités investies par la loi de fonctions de police judiciaire',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          // ====================== INTRO / DÉFINITION ========================
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                    "f00004",
                    'La police judiciaire est chargée de « constater les infractions à la loi pénale, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                    "f00005",
                    'à en rassembler les preuves et à en rechercher les auteurs, tant qu’une information ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                    "f00006",
                    'n’est pas ouverte ». Cette définition est donnée par ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                "f00007",
                'l’Article 14 du Code de Procédure Pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                    "f00008",
                    '. La police judiciaire désigne également l’ensemble des fonctionnaires chargés, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                    "f00009",
                    'sous la direction du procureur de la République, d’accomplir les actes prévus par cet article.',
                  ),
            ),
          ]),

          const SizedBox(height: 8),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                  "f00010",
                  'On distingue deux grandes catégories d’autorités liées à la police judiciaire :\n',
                ) +
                '\n' +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                  "f00011",
                  '• Une première catégorie composée des officiers et agents de police judiciaire, ainsi que des assistants d’enquête, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                  "f00012",
                  'qui assument à titre principal des missions de police judiciaire (police nationale, gendarmerie nationale, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                  "f00013",
                  'et, pour certaines attributions, des agents d’autres administrations ou des gardes particuliers).\n',
                ) +
                '\n' +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                  "f00014",
                  '• Une seconde catégorie composée d’autorités auxquelles la loi confie, en plus de leur mission principale ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
                  "f00015",
                  'à caractère administratif ou judiciaire, des fonctions de police judiciaire, notamment certains magistrats.',
                ),
          ),

          const SizedBox(height: 10),

          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00016",
              'Missions principales : constater les infractions, rassembler les preuves, rechercher les auteurs tant qu’aucune information n’est ouverte.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00017",
              'Une catégorie d’agents spécialisés (officiers, agents de police judiciaire, assistants d’enquête) et une catégorie d’autorités auxquelles la loi confère des attributions de police judiciaire à titre accessoire.',
            ),
          ),

          const SizedBox(height: 18),

          // ====== CHAPITRE 1 — AUTORITÉS HABITUELLES DE POLICE JUDICIAIRE ======
          _ModuleCard(
            tag: 'pp_autorites_investies_habituelles',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00018",
              'Chapitre 1 : Les autorités investies de fonctions habituelles de police judiciaire',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00019",
              'Officiers et agents de police judiciaire, assistants d’enquête, et agents spécialement habilités exerçant à titre principal des missions de police judiciaire.',
            ),
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj_habituelles',
            ),
          ),
          const SizedBox(height: 14),

          // == CHAPITRE 2 — AUTORITÉS À MISSION OCCASIONNELLE DE POLICE JUDICIAIRE ==
          _ModuleCard(
            tag: 'pp_autorites_investies_occasionnelles',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00020",
              'Chapitre 2 : Les autorités investies d’une mission occasionnelle de police judiciaire',
            ),
            subtitle: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart",
              "f00021",
              'Autorités administratives ou judiciaires, notamment certains magistrats, auxquelles la loi confie ponctuellement des attributions de police judiciaire.',
            ),
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_autorites_investies_pj_occasionnelles',
            ),
          ),

          const SizedBox(height: 22),
        ],
      ),
    );
  }

  // OUVERTURE D’UNE AUTRE PAGE (pas de PDF ici)
  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

// ---------------------------------------------------------------------------
//  CARD MODULE — COHÉRENCE VISUELLE AVEC TES AUTRES PAGES
// ---------------------------------------------------------------------------
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color subtitleColor = isDark
        ? textSoft
        : Colors.white.withValues(alpha: 0.92);
    final Color badgeBg = Colors.white.withValues(alpha: 0.14);
    final Color borderClr = Colors.white.withValues(alpha: 0.18);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero_$tag',
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .25),
                    Colors.black.withValues(alpha: .60),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: borderClr),
                    ),
                    child: Text(
                      'Module',
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Titre
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Sous-titre
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5,
                      height: 1.3,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
