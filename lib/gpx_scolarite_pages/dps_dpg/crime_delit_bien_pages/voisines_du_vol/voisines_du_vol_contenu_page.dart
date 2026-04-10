import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoisinesDuVolContenuPage extends StatelessWidget {
  const VoisinesDuVolContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

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
          "Crimes & délits contre les biens",
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Text(
            "Les infractions voisines du vol",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux fiches essentielles sur les infractions voisines du vol "
            "(définitions, éléments constitutifs, aggravations et répression).",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ================= 1 =================
          _ModuleCard(
            tag: 'demande_fonds_sous_contrainte',
            title: "La demande de fonds sous contrainte",
            subtitle: "Cadre légal, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/demande_fonds_sous_contrainte',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 2 =================
          _ModuleCard(
            tag: 'abus_de_confiance',
            title: "L’abus de confiance",
            subtitle: "Qualification, éléments et répression.",
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/abus_de_confiance',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 3 =================
          _ModuleCard(
            tag: 'chantage',
            title: "Le chantage",
            subtitle: "Définition, caractérisation et sanctions.",
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/chantage',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 4 =================
          _ModuleCard(
            tag: 'filouteries',
            title: "Les filouteries",
            subtitle: "Conditions, variantes et répression.",
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/filouteries',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 5 =================
          _ModuleCard(
            tag: 'escroquerie',
            title: "L’escroquerie",
            subtitle: "Manœuvres, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/escroquerie',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 6 =================
          _ModuleCard(
            tag: 'extorsion',
            title: "L’extorsion",
            subtitle: "Violences/menaces, remise et répression.",
            imagePath: 'assets/images/stad.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/extorsion',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_voisines_du_vol',
            title: 'Quiz — Infractions voisines du vol',
            subtitle:
                'Testez vos connaissances sur les définitions, éléments constitutifs et sanctions.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/crimes_biens/quiz/voisines_du_vol'),
          ),

          const SizedBox(height: 22),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

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
        : Colors.white.withOpacity(0.92);
    final Color badgeBg = Colors.white.withOpacity(0.14);
    final Color borderClr = Colors.white.withOpacity(0.18);

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
                    Colors.black.withOpacity(.25),
                    Colors.black.withOpacity(.60),
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
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: borderClr),
                    ),
                    child: Text(
                      title.toLowerCase().startsWith('quiz') ? 'QUIZ' : 'PDF',
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
