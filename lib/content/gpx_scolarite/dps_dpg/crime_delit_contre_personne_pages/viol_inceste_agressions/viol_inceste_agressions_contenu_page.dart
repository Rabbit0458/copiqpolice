import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolIncesteAgressionsContenuPage extends StatelessWidget {
  const ViolIncesteAgressionsContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions';

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
            "Viol, inceste & agressions sexuelles",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Accédez aux documents essentiels relatifs au viol, à l’inceste, aux agressions sexuelles "
            "et aux infractions connexes (éléments constitutifs, circonstances, répression).",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ================= PDF 1 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_contrainte_tiers',
            title:
                "La contrainte exercée en vue de subir une atteinte sexuelle de la part d’un tiers",
            subtitle: "Définition, conditions et régime de répression.",
            imagePath:
                'assets/images/viol_inceste_agressions_personne_vulnerable.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 2 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_substances_nuisibles',
            title: "L’administration de substances nuisibles",
            subtitle: "Notion, éléments constitutifs et sanctions.",
            imagePath:
                'assets/images/viol_inceste_agressions_substances_nuisibles.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/administration_substances_nuisibles',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 3 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_substance_pour_viol_ou_agression',
            title:
                "L’administration d’une substance afin de commettre un viol ou une agression sexuelle",
            subtitle: "Finalité sexuelle, caractérisation et répression.",
            imagePath:
                'assets/images/viol_inceste_agressions_substance_pour_viol_ou_agression.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/substance_pour_viol_ou_agression',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 4 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_agression_majeur_mineur_15',
            title:
                "L’agression sexuelle commise par un majeur sur un mineur de 15 ans",
            subtitle: "Protection renforcée du mineur et sanctions.",
            imagePath:
                'assets/images/viol_inceste_agressions_agression_majeur_mineur_15.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_majeur_mineur_15',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 5 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_agression_incestueuse',
            title: "L’agression sexuelle incestueuse",
            subtitle: "Définition de l’inceste, circonstances et répression.",
            imagePath:
                'assets/images/viol_inceste_agressions_agression_incestueuse.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 6 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_harcelement_sexuel',
            title: "Le harcèlement sexuel",
            subtitle: "Éléments constitutifs, preuve et sanctions.",
            imagePath:
                'assets/images/viol_inceste_agressions_harcelement_sexuel.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/harcelement_sexuel',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 7 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_viol_majeur_mineur_15',
            title: "Le viol commis par un majeur sur un mineur de 15 ans",
            subtitle: "Qualification, circonstances et peines.",
            imagePath:
                'assets/images/viol_inceste_agressions_agression_majeur_mineur_15.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_majeur_mineur_15',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 8 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_viol_incestueux',
            title: "Le viol incestueux",
            subtitle: "Définition, cadre légal et répression.",
            imagePath:
                'assets/images/viol_inceste_agressions_viol_incestueux.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_incestueux',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 9 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_viol',
            title: "Le viol",
            subtitle: "Définition, éléments constitutifs et peines.",
            imagePath: 'assets/images/viol_inceste_agressions_viol.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/viol',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 10 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_autres_que_viol',
            title: "Les agressions sexuelles autres que le viol",
            subtitle: "Qualification, exemples et sanctions.",
            imagePath:
                'assets/images/viol_inceste_agressions_autres_que_viol.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/agressions_sexuelles_autres_que_viol',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 11 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_mineur_15_violences_contrainte',
            title:
                "Les agressions sexuelles imposées à un mineur de 15 ans par violences, contrainte, menace ou surprise",
            subtitle: "Cadre aggravé et logique de protection du mineur.",
            imagePath:
                'assets/images/viol_inceste_agressions_agression_majeur_mineur_15.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/mineur_15_violences_contrainte_menace_surprise',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 12 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_personne_vulnerable',
            title:
                "Les agressions sexuelles imposées à une personne vulnérable",
            subtitle: "Vulnérabilité, preuve et circonstances aggravantes.",
            imagePath:
                'assets/images/viol_inceste_agressions_personne_vulnerable.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/personne_vulnerable',
            ),
          ),
          const SizedBox(height: 14),

          // ================= PDF 13 =================
          _ModuleCard(
            tag: 'viol_inceste_agressions_exhibition_sexuelle',
            title: "L’exhibition sexuelle",
            subtitle: "Définition, conditions de caractérisation et sanctions.",
            imagePath:
                'assets/images/viol_inceste_agressions_exhibition_sexuelle.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/exhibition_sexuelle',
            ),
          ),

          const SizedBox(height: 22),

          // ================= QUIZ =================
          _ModuleCard(
            tag: 'quiz_viol_inceste_agressions',
            title: 'Quiz — Viol, inceste & agressions sexuelles',
            subtitle:
                'Testez vos connaissances sur les qualifications, éléments constitutifs et répression.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/crimes_personne/quiz/viol_inceste_agressions',
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
