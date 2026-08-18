import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaMiseEnPerilDesMineursPage extends StatelessWidget {
  const PaMiseEnPerilDesMineursPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril';

  static const String _headerImage = 'assets/images/mineurs_famille.jpeg';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF0E0F12) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    final items = <_ModuleItem>[
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00001",
          'La corruption de mineur',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/corruption_mineur',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00002",
          'Diffusion d’un message violent/terroriste/pornographique/dangereux susceptible d’être vu par un mineur',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00003",
          'Privation d’aliments ou de soins à mineur de quinze ans',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00004",
          'Provocation à la pédopornographie',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_pedopornographie',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00005",
          'Provocation directe d’un mineur à commettre un crime ou un délit',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00006",
          'Provocation directe d’un mineur à la consommation de boissons alcooliques',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_alcool',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00007",
          'Provocation d’un mineur à l’usage ou au trafic de stupéfiants',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00008",
          'Soustraction d’un parent à ses obligations légales',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/soustraction_parent_obligations_legales',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00009",
          'Atteintes sexuelles par un majeur sur mineur de quinze ans',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_15',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00010",
          'Atteintes sexuelles par un majeur sur un mineur de plus de quinze ans',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_plus_15',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00011",
          'Exploitation de l’image / représentation pornographique d’un mineur',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/exploitation_image_porno_mineur',
      ),
      _ModuleItem(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00012",
          'Propositions sexuelles à mineur de quinze ans via communication électronique',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/propositions_sexuelles_mineur_15_en_ligne',
      ),

      // ✅ QUIZ
      _ModuleItem.quiz(
        title: ScolariteText.value(
          "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
          "f00013",
          'Quiz — Mise en péril des mineurs',
        ),
        route:
            '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/quiz_mise_en_peril',
      ),
    ];

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
            "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
            "f00014",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
            "f00015",
            'Atteintes aux mineurs & à la famille',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          const SizedBox(height: 14),
          ...items.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ModuleCard(
                title: m.title,
                subtitle: m.isQuiz ? 'Quiz' : 'Cours',
                tag: m.route,
                imagePath: m.isQuiz ? 'assets/images/quiz.jpeg' : _headerImage,
                isQuiz: m.isQuiz,
                isDark: isDark,
                onTap: () => Navigator.of(context).pushNamed(m.route),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleItem {
  final String title;
  final String route;
  final bool isQuiz;

  const _ModuleItem({required this.title, required this.route})
    : isQuiz = false;

  const _ModuleItem.quiz({required this.title, required this.route})
    : isQuiz = true;
}

class _HeaderHero extends StatelessWidget {
  const _HeaderHero({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.isDark,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .25),
                  Colors.black.withValues(alpha: .65),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: .88),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.imagePath,
    required this.isQuiz,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String tag;
  final String imagePath;
  final bool isQuiz;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color pillBg = Colors.white.withValues(alpha: isDark ? 0.14 : 0.10);
    final Color pillBorder = Colors.white.withValues(
      alpha: isDark ? 0.18 : 0.14,
    );

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: '$title — ouvrir',
        child: Container(
          height: 190,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
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
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .25),
                      Colors.black.withValues(alpha: .62),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: pillBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: pillBorder),
                      ),
                      child: Text(
                        subtitle,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isQuiz
                          ? ScolariteText.value(
                              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
                              "f00018",
                              'Testez vos connaissances',
                            )
                          : ScolariteText.value(
                              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
                              "f00019",
                              'Accéder au contenu',
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: .85),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Material(
                  color: Colors.white.withValues(alpha: .12),
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isQuiz
                                ? 'Quiz'
                                : ScolariteText.value(
                                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart",
                                    "f00020",
                                    'Découvrir',
                                  ),
                            style: GoogleFonts.fustat(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
