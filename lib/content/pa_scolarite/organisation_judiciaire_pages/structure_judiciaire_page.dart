import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    TextStyle h1 = GoogleFonts.fustat(fontWeight: FontWeight.w900, fontSize: 18, color: textMain);
    TextStyle h2 = GoogleFonts.fustat(fontWeight: FontWeight.w800, fontSize: 15, color: accent);
    TextStyle body = GoogleFonts.fustat(fontWeight: FontWeight.w500, fontSize: 14, height: 1.5, color: textSoft);
    TextStyle bold = GoogleFonts.fustat(fontWeight: FontWeight.w800, fontSize: 14, color: textMain);

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
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.only(top: 7), child: Icon(Icons.fiber_manual_record, size: 7, color: accent)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: body)),
      ]),
    );

    Widget encadre(String titre, String texte, Color couleur) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: couleur.withValues(alpha: .08), borderRadius: BorderRadius.circular(12), border: Border.all(color: couleur.withValues(alpha: .3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(titre, style: bold.copyWith(color: couleur)),
        const SizedBox(height: 6),
        Text(texte, style: body),
      ]),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain)),
        title: Text('Structure judiciaire', style: h1.copyWith(fontSize: 17)),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          section('1) Les deux ordres de juridiction', [
            bullet('L\'ordre judiciaire règle les litiges entre personnes privées (civil) et réprime les infractions (pénal).'),
            bullet('L\'ordre administratif règle les litiges entre les particuliers et l\'État ou les administrations.'),
            encadre('Tribunal des conflits', 'Il tranche les conflits de compétence entre les deux ordres. Présidé alternativement par le garde des Sceaux.', Colors.purple),
          ]),

          section('2) L\'ordre judiciaire — juridictions civiles', [
            bullet('Tribunal judiciaire (TJ) : juridiction de droit commun du premier degré depuis 2020 (fusion TGI + TI).'),
            bullet('Tribunal de commerce : litiges entre commerçants ou actes de commerce.'),
            bullet('Conseil de prud\'hommes : litiges entre employeurs et salariés.'),
            bullet('Tribunal paritaire des baux ruraux : litiges entre propriétaires et exploitants agricoles.'),
          ]),

          section('3) L\'ordre judiciaire — juridictions pénales', [
            _TableauJuridictions(),
          ]),

          section('4) Le second degré — Cour d\'appel', [
            bullet('Il existe 36 cours d\'appel en France métropolitaine et outre-mer.'),
            bullet('Elles réexaminent les affaires jugées en premier ressort (appel = voie de réformation).'),
            bullet('La chambre correctionnelle juge les appels des jugements correctionnels.'),
            bullet('La cour d\'assises d\'appel juge les appels des arrêts de cour d\'assises.'),
          ]),

          section('5) Le troisième degré — Cour de cassation', [
            bullet('Juridiction suprême de l\'ordre judiciaire, siège à Paris.'),
            bullet('Ne rejuge pas les faits — elle contrôle uniquement la bonne application du droit.'),
            bullet('En cas de cassation : renvoie devant une autre cour d\'appel (juridiction de renvoi).'),
            encadre('À retenir', 'La Cour de cassation ne statue pas sur les faits mais sur le droit. Elle « casse » ou « rejette » les pourvois.', accent),
          ]),

          section('6) Juridictions d\'exception', [
            bullet('Tribunal pour enfants (TPE) : mineurs de 13 à 18 ans, selon ordonnance 1945 / code de la justice pénale des mineurs 2021.'),
            bullet('Cour d\'assises des mineurs : crimes commis par des mineurs de 16 à 18 ans.'),
            bullet('Haute Cour : juge le Président de la République en cas de manquement à ses devoirs.'),
            bullet('Cour de justice de la République : juge les membres du gouvernement pour crimes et délits dans l\'exercice de leurs fonctions.'),
          ]),
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
      ['Infraction', 'Juridiction compétente', 'Peine max'],
      ['Contravention', 'Tribunal de police', 'Amende ≤ 3 000 €'],
      ['Délit', 'Tribunal correctionnel', '10 ans d\'emprisonnement'],
      ['Crime', 'Cour d\'assises', 'Réclusion criminelle à perpétuité'],
    ];
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isHeader = e.key == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(children: [
              Expanded(flex: 3, child: Text(e.value[0], style: TextStyle(fontWeight: isHeader ? FontWeight.w900 : FontWeight.w600, fontSize: isHeader ? 12 : 13))),
              Expanded(flex: 4, child: Text(e.value[1], style: TextStyle(fontWeight: isHeader ? FontWeight.w900 : FontWeight.w500, fontSize: isHeader ? 12 : 13))),
              Expanded(flex: 4, child: Text(e.value[2], style: TextStyle(fontWeight: isHeader ? FontWeight.w900 : FontWeight.w500, fontSize: isHeader ? 12 : 13, color: isHeader ? null : Colors.red.shade700))),
            ]),
          );
        }).toList(),
      ),
    );
  }
}
