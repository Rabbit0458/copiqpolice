import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JugeInstructionPage extends StatelessWidget {
  const JugeInstructionPage({super.key});
  static const String routeName = '/pa/organisation_judiciaire/juge_instruction';

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
    Widget check(String text, Color c) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_rounded, size: 18, color: c), const SizedBox(width: 10), Expanded(child: Text(text, style: body))]));
    Widget encadre(String titre, String texte, Color c) => Container(margin: const EdgeInsets.symmetric(vertical: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c.withValues(alpha: .08), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withValues(alpha: .3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titre, style: bold.copyWith(color: c)), const SizedBox(height: 6), Text(texte, style: body)]));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, elevation: 0, centerTitle: true, leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain)), title: Text('Le juge d\'instruction', style: h1.copyWith(fontSize: 17))),
      body: ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(18, 8, 18, 32), children: [

        section('1) Définition', [
          bullet('Le juge d\'instruction (JI) est un magistrat du siège chargé d\'instruire les affaires pénales les plus complexes.'),
          bullet('Il est saisi par le procureur de la République via un réquisitoire introductif ou par la victime constituée partie civile.'),
          encadre('Magistrat du siège vs parquet', 'Le juge d\'instruction appartient au siège (inamovible, indépendant). Il est distinct du parquet (magistrature debout, soumise à hiérarchie).', accent),
        ]),

        section('2) Les pouvoirs du juge d\'instruction', [
          check('Inculper (mettre en examen) toute personne contre qui il existe des indices graves ou concordants.', Colors.blue),
          check('Délivrer des mandats : de comparution, d\'amener, d\'arrêt, de dépôt.', Colors.blue),
          check('Ordonner une détention provisoire (via le juge des libertés et de la détention — JLD).', Colors.orange),
          check('Placer sous contrôle judiciaire ou sous surveillance électronique mobile.', Colors.blue),
          check('Ordonner des perquisitions, écoutes téléphoniques, géolocalisation, interceptions.', Colors.blue),
          check('Délivrer des commissions rogatoires (délégation aux OPJ).', Colors.blue),
        ]),

        section('3) La commission rogatoire', [
          bullet('Le JI peut déléguer l\'exécution de certains actes d\'instruction aux OPJ par commission rogatoire (CR).'),
          bullet('La CR doit être écrite, signée, datée et délimiter précisément l\'objet de la délégation.'),
          bullet('Les OPJ agissent pour le compte du JI — ils ont alors les mêmes pouvoirs que lui dans les limites de la CR.'),
          encadre('À retenir', 'Un OPJ exécutant une CR agit sous l\'autorité du JI, non du procureur. Il rédige un procès-verbal et le retourne au JI.', Colors.green.shade700),
        ]),

        section('4) La mise en examen', [
          bullet('Condition : indices graves ou concordants rendant vraisemblable la participation aux faits.'),
          bullet('La personne mise en examen bénéficie de droits renforcés : avocat, accès au dossier, possibilité de demander des actes.'),
          bullet('Elle n\'est pas encore condamnée — présomption d\'innocence maintenue.'),
          bullet('Le témoin assisté est entre le simple témoin et la mise en examen : indices insuffisants pour MEX, mais peut être entendu avec avocat.'),
        ]),

        section('5) La clôture de l\'instruction', [
          bullet('Ordonnance de renvoi en jugement : si charges suffisantes → renvoi devant tribunal correctionnel (délit) ou mise en accusation devant cour d\'assises (crime).'),
          bullet('Ordonnance de non-lieu : charges insuffisantes → la personne est libre, affaire classée.'),
          bullet('Le JLD statue sur les demandes de mise en liberté et prolongations de détention provisoire.'),
        ]),

        section('6) Contrôle de l\'instruction', [
          bullet('Chambre de l\'instruction (chambre spécialisée de la cour d\'appel) : contrôle les actes du JI sur appel.'),
          bullet('Elle peut annuler des actes irréguliers (nullités de procédure).'),
          bullet('Elle statue sur les demandes de mise en liberté en appel.'),
        ]),
      ]),
    );
  }
}
