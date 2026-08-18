import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class VoiesRecoursPage extends StatelessWidget {
  const VoiesRecoursPage({super.key});
  static const String routeName = '/pa/organisation_judiciaire/voies_recours';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark ? Colors.white70 : const Color(0xFF444444);
    const accent = Color(0xFF1565C0);

    TextStyle h1 = GoogleFonts.fustat(
      fontWeight: FontWeight.w900,
      fontSize: 18,
      color: textMain,
    );
    TextStyle h2 = GoogleFonts.fustat(
      fontWeight: FontWeight.w800,
      fontSize: 15,
      color: accent,
    );
    TextStyle body = GoogleFonts.fustat(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1.5,
      color: textSoft,
    );
    TextStyle bold = GoogleFonts.fustat(
      fontWeight: FontWeight.w800,
      fontSize: 14,
      color: textMain,
    );

    Widget section(String t, List<Widget> c) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(t, style: h2),
        const SizedBox(height: 8),
        ...c,
      ],
    );
    Widget bullet(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.fiber_manual_record, size: 7, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: body)),
        ],
      ),
    );
    Widget encadre(String titre, String texte, Color c) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: bold.copyWith(color: c)),
          const SizedBox(height: 6),
          Text(texte, style: body),
        ],
      ),
    );

    Widget recoursCard(
      String nom,
      String desc,
      String delai,
      String effet,
      Color c,
    ) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nom, style: bold.copyWith(color: c, fontSize: 14)),
          const SizedBox(height: 6),
          Text(desc, style: body),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                delai,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.pause_circle_outline,
                size: 14,
                color:
                    effet.contains(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                        "f00001",
                        'Oui',
                      ),
                    )
                    ? Colors.orange
                    : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                'Suspensif : $effet',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
            "f00003",
            'Voies de recours',
          ),
          style: h1.copyWith(fontSize: 17),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
              "f00004",
              '1) Définition',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00005",
                  'Une voie de recours permet à une partie de contester une décision de justice rendue.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00006",
                  'Elle peut être ordinaire (accessible à toutes les parties) ou extraordinaire (conditions restrictives).',
                ),
              ),
              encadre(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00007",
                  'Effet suspensif',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00008",
                  'Une voie de recours est suspensive quand elle empêche l\'exécution de la décision jusqu\'au jugement de la juridiction supérieure. L\'appel pénal est suspensif, sauf détention provisoire maintenue.',
                ),
                accent,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
              "f00009",
              '2) Voies de recours ordinaires',
            ),
            [
              recoursCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00010",
                  'L\'opposition',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00011",
                  'Permet à une partie condamnée par défaut (en son absence) de demander un nouveau jugement à la même juridiction.',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00012",
                  '10 jours à compter de la signification',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00013",
                  'Non',
                ),
                Colors.teal,
              ),
              recoursCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00014",
                  'L\'appel',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00015",
                  'Permet de soumettre l\'affaire à la juridiction supérieure (cour d\'appel) qui réexamine l\'affaire en fait ET en droit.',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00016",
                  '10 jours à compter du jugement (pénal)',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00017",
                  'Oui (sauf exceptions)',
                ),
                Colors.orange.shade700,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
              "f00018",
              '3) Voies de recours extraordinaires',
            ),
            [
              recoursCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00019",
                  'Le pourvoi en cassation',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00020",
                  'Soumis à la Cour de cassation qui contrôle uniquement la légalité (application du droit). Ne rejuge pas les faits.',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00021",
                  '5 jours en matière pénale après notification de l\'arrêt',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00022",
                  'Non (principe)',
                ),
                Colors.red.shade700,
              ),
              recoursCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00023",
                  'La révision',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00024",
                  'Permet de remettre en cause une condamnation définitive si de nouveaux éléments font douter de la culpabilité.',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00025",
                  'Pas de délai (procédure exceptionnelle)',
                ),
                'Possible',
                Colors.purple,
              ),
              recoursCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00026",
                  'Le réexamen',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00027",
                  'Possible après condamnation par la CEDH (Cour européenne des droits de l\'homme) pour violation de la CESDH.',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00028",
                  'Dans les 6 mois après l\'arrêt CEDH définitif',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00029",
                  'Non',
                ),
                Colors.indigo,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
              "f00030",
              '4) Focus : l\'appel pénal',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00031",
                  'Délai : 10 jours pour le prévenu, 10 jours pour le ministère public, 10 jours pour la partie civile.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00032",
                  'Juridiction d\'appel : chambre correctionnelle de la cour d\'appel (pour délits) ou cour d\'assises d\'appel (pour crimes).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00033",
                  'L\'appel pénal est suspensif : la peine principale ne s\'exécute pas pendant l\'appel (sauf maintien en détention provisoire ordonné).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00034",
                  'Reformatio in pejus : la cour d\'appel peut aggraver la peine si le parquet a fait appel, mais ne peut pas aggraver si seul le prévenu a fait appel.',
                ),
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
              "f00035",
              '5) La Cour européenne des droits de l\'homme (CEDH)',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00036",
                  'Siège à Strasbourg. Contrôle le respect de la Convention européenne des droits de l\'homme (CESDH).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00037",
                  'Saisie uniquement après épuisement des voies de recours internes.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00038",
                  'Ses arrêts condamnent l\'État — ils ne cassent pas directement la décision nationale mais peuvent engendrer un réexamen.',
                ),
              ),
              encadre(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00039",
                  'À retenir',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart",
                  "f00040",
                  'La CEDH n\'est pas une juridiction supérieure française. Elle ne juge pas les affaires pénales en tant que telles mais contrôle si les procédures respectent les droits fondamentaux garantis par la Convention.',
                ),
                accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
