import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class JuridictionsPenalesPage extends StatelessWidget {
  const JuridictionsPenalesPage({super.key});
  static const String routeName =
      '/pa/organisation_judiciaire/juridictions_penales';

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

    Widget juridictionCard(
      String nom,
      String infraction,
      String peine,
      String composition,
      Color couleur,
    ) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: couleur.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nom, style: bold.copyWith(color: couleur, fontSize: 15)),
          const SizedBox(height: 8),
          _InfoRow(label: 'Infraction', value: infraction),
          _InfoRow(
            label: ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
              "f00001",
              'Peine max',
            ),
            value: peine,
          ),
          _InfoRow(label: 'Composition', value: composition),
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
            "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
            "f00002",
            'Juridictions pénales',
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
              "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
              "f00003",
              '1) Les trois juridictions pénales du premier degré',
            ),
            [
              juridictionCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00004",
                  'Tribunal de police',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00005",
                  'Contraventions (classes 1 à 5)',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00006",
                  'Amende jusqu\'à 3 000 € (38 000 € pour personnes morales)',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00007",
                  '1 juge unique',
                ),
                Colors.green.shade700,
              ),
              juridictionCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00008",
                  'Tribunal correctionnel',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00009",
                  'Délits (infractions punies d\'emprisonnement jusqu\'à 10 ans)',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00010",
                  'Emprisonnement jusqu\'à 10 ans + amendes',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00011",
                  '3 juges (composition collégiale) ou juge unique',
                ),
                Colors.orange.shade700,
              ),
              juridictionCard(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00012",
                  'Cour d\'assises',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00013",
                  'Crimes (infractions punies de 10 ans à perpétuité)',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00014",
                  'Réclusion criminelle à perpétuité',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00015",
                  '3 juges professionnels + 6 jurés populaires (12 en appel)',
                ),
                Colors.red.shade700,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
              "f00016",
              '2) Le tribunal correctionnel — focus',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00017",
                  'Compétence : délits punissables d\'une peine > 2 mois d\'emprisonnement et < 10 ans.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00018",
                  'Peut statuer en comparution immédiate (CI) : jugement dans les heures suivant l\'arrestation.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00019",
                  'Peut statuer en CRPC (comparution sur reconnaissance préalable de culpabilité) : plaider coupable à la française.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00020",
                  'Peut statuer par ordonnance pénale : sans audience, pour délits simples.',
                ),
              ),
              encadre(
                'CRPC',
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00021",
                  'Procédure dans laquelle le mis en cause reconnaît sa culpabilité en échange d\'une peine négociée avec le parquet. Le juge homologue ou refuse. Pas applicable aux crimes ni à certains délits graves.',
                ),
                Colors.orange.shade700,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
              "f00022",
              '3) La cour d\'assises — focus',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00023",
                  'Seule juridiction avec jury populaire tiré au sort parmi les citoyens français.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00024",
                  'Siège dans chaque département (au TJ chef-lieu), mais se réunit par sessions périodiques.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00025",
                  'Les jurés (6 en premier ressort, 12 en appel) délibèrent avec les 3 magistrats professionnels.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00026",
                  'Décision prise à la majorité qualifiée (au moins 6 voix sur 9 en 1ère instance).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00027",
                  'Depuis 2011, les arrêts d\'assises sont motivés — obligation de justification introduite par la CJUE.',
                ),
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
              "f00028",
              '4) Juridictions pénales spécialisées',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00029",
                  'Tribunal pour enfants (TPE) : mineurs de 13 à 18 ans — depuis le CJPM 2021.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00030",
                  'Cour d\'assises des mineurs : crimes commis par les 16-18 ans.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00031",
                  'Juridiction inter-régionale spécialisée (JIRS) : criminalité organisée, grands trafics.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00032",
                  'Tribunal correctionnel spécialisé (TCS) : trafics de stupéfiants à grande échelle.',
                ),
              ),
              encadre(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00033",
                  'JIRS — À connaître',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00034",
                  '8 JIRS en France (Paris, Lyon, Marseille, Rennes, Bordeaux, Lille, Nancy, Fort-de-France). Compétentes pour la grande criminalité organisée, les trafics de stupéfiants, le terrorisme local.',
                ),
                accent,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
              "f00035",
              '5) Les voies d\'accès au jugement pénal',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00036",
                  'Citation directe : le parquet ou la partie civile cite directement le prévenu devant le tribunal.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00037",
                  'Comparution immédiate : déférement immédiat après garde à vue.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00038",
                  'Saisine après information judiciaire : ordonnance de renvoi du JI.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart",
                  "f00039",
                  'Mise en accusation : par chambre de l\'instruction pour les crimes.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
