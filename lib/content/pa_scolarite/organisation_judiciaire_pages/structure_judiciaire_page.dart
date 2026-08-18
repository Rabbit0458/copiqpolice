import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class StructureJudiciairePage extends StatelessWidget {
  const StructureJudiciairePage({super.key});
  static const String routeName = '/pa/organisation_judiciaire/structure';

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

    Widget section(String title, List<Widget> children) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: h2),
        const SizedBox(height: 8),
        ...children,
      ],
    );

    Widget bullet(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.fiber_manual_record, size: 7, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: body)),
        ],
      ),
    );

    Widget encadre(String titre, String texte, Color couleur) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couleur.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: bold.copyWith(color: couleur)),
          const SizedBox(height: 6),
          Text(texte, style: body),
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
            "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
            "f00001",
            'Structure judiciaire',
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
              "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
              "f00002",
              '1) Les deux ordres de juridiction',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00003",
                  'L\'ordre judiciaire règle les litiges entre personnes privées (civil) et réprime les infractions (pénal).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00004",
                  'L\'ordre administratif règle les litiges entre les particuliers et l\'État ou les administrations.',
                ),
              ),
              encadre(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00005",
                  'Tribunal des conflits',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00006",
                  'Il tranche les conflits de compétence entre les deux ordres. Présidé alternativement par le garde des Sceaux.',
                ),
                Colors.purple,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
              "f00007",
              '2) L\'ordre judiciaire — juridictions civiles',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00008",
                  'Tribunal judiciaire (TJ) : juridiction de droit commun du premier degré depuis 2020 (fusion TGI + TI).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00009",
                  'Tribunal de commerce : litiges entre commerçants ou actes de commerce.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00010",
                  'Conseil de prud\'hommes : litiges entre employeurs et salariés.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00011",
                  'Tribunal paritaire des baux ruraux : litiges entre propriétaires et exploitants agricoles.',
                ),
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
              "f00012",
              '3) L\'ordre judiciaire — juridictions pénales',
            ),
            [_TableauJuridictions()],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
              "f00013",
              '4) Le second degré — Cour d\'appel',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00014",
                  'Il existe 36 cours d\'appel en France métropolitaine et outre-mer.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00015",
                  'Elles réexaminent les affaires jugées en premier ressort (appel = voie de réformation).',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00016",
                  'La chambre correctionnelle juge les appels des jugements correctionnels.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00017",
                  'La cour d\'assises d\'appel juge les appels des arrêts de cour d\'assises.',
                ),
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
              "f00018",
              '5) Le troisième degré — Cour de cassation',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00019",
                  'Juridiction suprême de l\'ordre judiciaire, siège à Paris.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00020",
                  'Ne rejuge pas les faits — elle contrôle uniquement la bonne application du droit.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00021",
                  'En cas de cassation : renvoie devant une autre cour d\'appel (juridiction de renvoi).',
                ),
              ),
              encadre(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00022",
                  'À retenir',
                ),
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00023",
                  'La Cour de cassation ne statue pas sur les faits mais sur le droit. Elle « casse » ou « rejette » les pourvois.',
                ),
                accent,
              ),
            ],
          ),

          section(
            ScolariteText.value(
              "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
              "f00024",
              '6) Juridictions d\'exception',
            ),
            [
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00025",
                  'Tribunal pour enfants (TPE) : mineurs de 13 à 18 ans, selon ordonnance 1945 / code de la justice pénale des mineurs 2021.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00026",
                  'Cour d\'assises des mineurs : crimes commis par des mineurs de 16 à 18 ans.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00027",
                  'Haute Cour : juge le Président de la République en cas de manquement à ses devoirs.',
                ),
              ),
              bullet(
                ScolariteText.value(
                  "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
                  "f00028",
                  'Cour de justice de la République : juge les membres du gouvernement pour crimes et délits dans l\'exercice de leurs fonctions.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableauJuridictions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA);
    final rows = [
      [
        'Infraction',
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00029",
          'Juridiction compétente',
        ),
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00030",
          'Peine max',
        ),
      ],
      [
        'Contravention',
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00031",
          'Tribunal de police',
        ),
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00032",
          'Amende ≤ 3 000 €',
        ),
      ],
      [
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00033",
          'Délit',
        ),
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00034",
          'Tribunal correctionnel',
        ),
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00035",
          '10 ans d\'emprisonnement',
        ),
      ],
      [
        'Crime',
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00036",
          'Cour d\'assises',
        ),
        ScolariteText.value(
          "lib/content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart",
          "f00037",
          'Réclusion criminelle à perpétuité',
        ),
      ],
    ];
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isHeader = e.key == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    e.value[0],
                    style: TextStyle(
                      fontWeight: isHeader ? FontWeight.w900 : FontWeight.w600,
                      fontSize: isHeader ? 12 : 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    e.value[1],
                    style: TextStyle(
                      fontWeight: isHeader ? FontWeight.w900 : FontWeight.w500,
                      fontSize: isHeader ? 12 : 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    e.value[2],
                    style: TextStyle(
                      fontWeight: isHeader ? FontWeight.w900 : FontWeight.w500,
                      fontSize: isHeader ? 12 : 13,
                      color: isHeader ? null : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
