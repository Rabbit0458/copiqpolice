import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolationOrdonnancesJafPage extends StatelessWidget {
  const PaViolationOrdonnancesJafPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf';

  static const String _headerImage =
      'assets/images/viol_inceste_agressions_substances_nuisibles.jpeg';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF0E0F12) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
? Colors.white70
: const Color(0xFF222222).withValues(alpha: .70);

    final items = <_Item>[
      const _Item(
        title: 'Le défaut de notification de changement (ordonnance JAF)',
        route:
            '/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement',
      ),
      const _Item(
        title:
            'Le non-respect des obligations ou interdictions (ordonnance JAF)',
        route:
            '/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions',
      ),
      const _Item.quiz(
        title: 'Quiz — Ordonnances JAF (violences)',
        route:
            '/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/quiz_ordonnances_jaf',
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
          tooltip: 'Retour',
        ),
        title: Text(
          'Atteintes aux mineurs & à la famille',
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
              child: _Card(
                title: m.title,
                isQuiz: m.isQuiz,
                tag: m.route,
                imagePath: m.isQuiz ? 'assets/images/quiz.jpeg' : _headerImage,
                onTap: () => Navigator.of(context).pushNamed(m.route),
                isDark: isDark,
                textSoft: textSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String title;
  final String route;
  final bool isQuiz;

  const _Item({required this.title, required this.route}) : isQuiz = false;

  const _Item.quiz({required this.title, required this.route}) : isQuiz = true;
}

class _HeroTop extends StatelessWidget {
  const _HeroTop({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String imagePath;

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

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.isQuiz,
    required this.tag,
    required this.imagePath,
    required this.onTap,
    required this.isDark,
    required this.textSoft,
  });

  final String title;
  final bool isQuiz;
  final String tag;
  final String imagePath;
  final VoidCallback onTap;
  final bool isDark;
  final Color textSoft;

  @override
  Widget build(BuildContext context) {
    final Color pillBg = Colors.white.withValues(alpha: isDark ? 0.14 : 0.10);
    final Color pillBorder = Colors.white.withValues(alpha: isDark ? 0.18 : 0.14);

    return GestureDetector(
      onTap: onTap,
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
                      isQuiz ? 'Quiz' : 'Module',
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
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isQuiz ? 'Testez vos connaissances' : 'Accéder au contenu',
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
                          isQuiz ? 'Quiz' : 'Découvrir',
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
    );
  }
}
