import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MinisterePublicPage extends StatelessWidget {
  const MinisterePublicPage({super.key});
  static const String routeName = '/pa/organisation_judiciaire/ministere_public';

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

    Widget section(String title, List<Widget> children) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 20), Text(title, style: h2), const SizedBox(height: 8), ...children]);
    Widget bullet(String text) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.only(top: 7), child: Icon(Icons.fiber_manual_record, size: 7, color: accent)), const SizedBox(width: 10), Expanded(child: Text(text, style: body))]));
    Widget encadre(String titre, String texte, Color c) => Container(margin: const EdgeInsets.symmetric(vertical: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c.withValues(alpha: .08), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withValues(alpha: .3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titre, style: bold.copyWith(color: c)), const SizedBox(height: 6), Text(texte, style: body)]));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, elevation: 0, centerTitle: true, leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain)), title: Text('Le ministère public', style: h1.copyWith(fontSize: 17))),
      body: ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(18, 8, 18, 32), children: [

        section('1) Définition et rôle', [
          bullet('Le ministère public (ou parquet) représente la société et défend l\'intérêt général.'),
          bullet('Il décide d\'engager ou non des poursuites pénales contre les auteurs d\'infractions.'),
          bullet('Il dirige la police judiciaire dans le cadre des enquêtes qu\'il supervise.'),
          encadre('Principe de hiérarchie', 'Le parquet est hiérarchisé et soumis à l\'autorité du garde des Sceaux (ministre de la Justice) via les procureurs généraux.', accent),
        ]),

        section('2) Les acteurs du parquet', [
          _ActeursTable(),
        ]),

        section('3) Les trois décisions du procureur', [
          bullet('Classement sans suite : le procureur décide de ne pas poursuivre (faits insuffisamment caractérisés, auteur inconnu, préjudice faible, etc.).'),
          bullet('Alternatives aux poursuites : rappel à la loi, médiation pénale, composition pénale, stage de citoyenneté.'),
          bullet('Engagement des poursuites : citation directe, information judiciaire, comparution immédiate ou sur reconnaissance préalable de culpabilité (CRPC).'),
          encadre('Opportunité des poursuites', 'En France, le principe d\'opportunité des poursuites donne au procureur le pouvoir discrétionnaire de classer ou poursuivre. Contraire au système de légalité (Allemagne, Espagne).', Colors.orange.shade700),
        ]),

        section('4) Le procureur et la police judiciaire', [
          bullet('Les officiers de police judiciaire (OPJ) travaillent sous son autorité fonctionnelle.'),
          bullet('Il peut donner des instructions aux OPJ dans le cadre d\'une enquête préliminaire ou de flagrance.'),
          bullet('Il saisit le juge d\'instruction pour les affaires complexes nécessitant des actes coercitifs importants.'),
          bullet('Il contrôle la légalité des gardes à vue et autorise certaines prolongations.'),
        ]),

        section('5) Parquet général — second degré', [
          bullet('Chaque cour d\'appel dispose d\'un parquet général dirigé par un procureur général.'),
          bullet('Le procureur général peut requérir contre les jugements rendus en premier ressort.'),
          bullet('Il coordonne l\'action des parquets de son ressort.'),
        ]),

        section('6) Le parquet national — juridictions spécialisées', [
          bullet('PNF — Parquet national financier : crimes économiques et financiers d\'envergure nationale.'),
          bullet('PNAT — Parquet national antiterroriste : infractions terroristes (créé en 2019).'),
          bullet('JUNALCO — Juridiction nationale chargée de la lutte contre la criminalité organisée (depuis 2023).'),
        ]),
      ]),
    );
  }
}

class _ActeursTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA);
    final rows = [
      ['Magistrat', 'Juridiction', 'Rôle'],
      ['Procureur de la République', 'TJ (1er degré)', 'Chef du parquet, décide des poursuites'],
      ['Substitut du procureur', 'TJ (1er degré)', 'Assiste et représente le procureur'],
      ['Procureur général', 'Cour d\'appel (2d degré)', 'Dirige le parquet général'],
      ['Avocat général', 'Cour d\'appel / assises', 'Représente le parquet en appel'],
      ['Procureur général', 'Cour de cassation', 'Défend l\'intérêt de la loi'],
    ];
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(children: rows.asMap().entries.map((e) {
        final isH = e.key == 0;
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9), child: Row(children: [
          Expanded(flex: 3, child: Text(e.value[0], style: TextStyle(fontWeight: isH ? FontWeight.w900 : FontWeight.w700, fontSize: 12))),
          Expanded(flex: 3, child: Text(e.value[1], style: TextStyle(fontWeight: isH ? FontWeight.w900 : FontWeight.w500, fontSize: 12))),
          Expanded(flex: 4, child: Text(e.value[2], style: TextStyle(fontWeight: isH ? FontWeight.w900 : FontWeight.w400, fontSize: 12))),
        ]));
      }).toList()),
    );
  }
}
