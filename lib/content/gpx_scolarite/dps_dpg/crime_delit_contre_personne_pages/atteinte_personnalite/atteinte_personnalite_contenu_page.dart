import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtteintePersonnaliteContenuPage extends StatelessWidget {
  const AtteintePersonnaliteContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite';

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
          "Crimes & délits contre la personne",
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
            "Atteintes à la personnalité",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux fiches essentielles relatives aux infractions portant atteinte à la personnalité "
            "(définitions, éléments constitutifs, circonstances et répression).",
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
            tag: 'personnalite_denonciation_calomnieuse',
            title: "La dénonciation calomnieuse",
            subtitle: "Définition, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 2 =================
          _ModuleCard(
            tag: 'personnalite_diffusion_enregistrement_sexuel_sans_accord',
            title:
                "La diffusion, sans l'accord de la personne concernée, d'un enregistrement ou document portant sur des paroles ou images à caractère sexuel",
            subtitle: "Cadre légal, qualification et répression.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 3 =================
          _ModuleCard(
            tag: 'personnalite_violation_domicile_particulier',
            title: "La violation de domicile commise par un particulier",
            subtitle: "Éléments constitutifs, aggravations et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/violation_domicile_particulier',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 4 =================
          _ModuleCard(
            tag: 'personnalite_violation_correspondances_voie_electronique',
            title:
                "La violation des correspondances émises par la voie électronique",
            subtitle: "Notion, comportements visés et répression.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/violation_correspondances_voie_electronique',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 5 =================
          _ModuleCard(
            tag: 'personnalite_atteinte_representation_personne',
            title: "L’atteinte à la représentation de la personne",
            subtitle: "Qualification, caractérisation et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_representation_personne',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 6 =================
          _ModuleCard(
            tag: 'personnalite_atteinte_intimite_vie_privee',
            title: "L’atteinte à l’intimité de la vie privée",
            subtitle: "Définition, éléments et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_vie_privee',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 7 =================
          _ModuleCard(
            tag: 'personnalite_atteinte_intimite_personne',
            title: "L’atteinte à l’intimité d’une personne",
            subtitle: "Notion, comportements réprimés et peines.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_intimite_personne',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 8 =================
          _ModuleCard(
            tag: 'personnalite_secret_correspondances_particulier',
            title:
                "L’atteinte au secret des correspondances commise par un particulier",
            subtitle: "Cadre légal, caractérisation et répression.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier',
            ),
          ),
          const SizedBox(height: 14),

          // ================= 9 =================
          _ModuleCard(
            tag: 'personnalite_secret_professionnel',
            title: "L’atteinte au secret professionnel",
            subtitle: "Champ, éléments constitutifs et sanctions.",
            imagePath: 'assets/images/personnalite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_atteinte_personnalite',
            title: 'Quiz — Atteintes à la personnalité',
            subtitle:
                'Testez vos connaissances sur les qualifications, éléments constitutifs et répression.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/crimes_personne/quiz/atteinte_personnalite',
            ),
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
