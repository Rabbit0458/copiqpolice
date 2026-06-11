import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    TextStyle h1 = GoogleFonts.fustat(fontWeight: FontWeight.w900, fontSize: 18, color: textMain);
    TextStyle h2 = GoogleFonts.fustat(fontWeight: FontWeight.w800, fontSize: 15, color: accent);
    TextStyle body = GoogleFonts.fustat(fontWeight: FontWeight.w500, fontSize: 14, height: 1.5, color: textSoft);
    TextStyle bold = GoogleFonts.fustat(fontWeight: FontWeight.w800, fontSize: 14, color: textMain);

    Widget section(String t, List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 20), Text(t, style: h2), const SizedBox(height: 8), ...c]);
    Widget bullet(String t) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.only(top: 7), child: Icon(Icons.fiber_manual_record, size: 7, color: accent)), const SizedBox(width: 10), Expanded(child: Text(t, style: body))]));
    Widget encadre(String titre, String texte, Color c) => Container(margin: const EdgeInsets.symmetric(vertical: 8), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c.withValues(alpha: .08), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.withValues(alpha: .3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titre, style: bold.copyWith(color: c)), const SizedBox(height: 6), Text(texte, style: body)]));

    Widget recoursCard(String nom, String desc, String delai, String effet, Color c) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.withValues(alpha: .07), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withValues(alpha: .25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(nom, style: bold.copyWith(color: c, fontSize: 14)),
        const SizedBox(height: 6),
        Text(desc, style: body),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.schedule, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(delai, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(width: 12),
          Icon(Icons.pause_circle_outline, size: 14, color: effet.contains('Oui') ? Colors.orange : Colors.grey),
          const SizedBox(width: 4),
          Text('Suspensif : $effet', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ]),
      ]),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, elevation: 0, centerTitle: true, leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain)), title: Text('Voies de recours', style: h1.copyWith(fontSize: 17))),
      body: ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(18, 8, 18, 32), children: [

        section('1) Définition', [
          bullet('Une voie de recours permet à une partie de contester une décision de justice rendue.'),
          bullet('Elle peut être ordinaire (accessible à toutes les parties) ou extraordinaire (conditions restrictives).'),
          encadre('Effet suspensif', 'Une voie de recours est suspensive quand elle empêche l\'exécution de la décision jusqu\'au jugement de la juridiction supérieure. L\'appel pénal est suspensif, sauf détention provisoire maintenue.', accent),
        ]),

        section('2) Voies de recours ordinaires', [
          recoursCard(
            'L\'opposition',
            'Permet à une partie condamnée par défaut (en son absence) de demander un nouveau jugement à la même juridiction.',
            '10 jours à compter de la signification',
            'Non',
            Colors.teal,
          ),
          recoursCard(
            'L\'appel',
            'Permet de soumettre l\'affaire à la juridiction supérieure (cour d\'appel) qui réexamine l\'affaire en fait ET en droit.',
            '10 jours à compter du jugement (pénal)',
            'Oui (sauf exceptions)',
            Colors.orange.shade700,
          ),
        ]),

        section('3) Voies de recours extraordinaires', [
          recoursCard(
            'Le pourvoi en cassation',
            'Soumis à la Cour de cassation qui contrôle uniquement la légalité (application du droit). Ne rejuge pas les faits.',
            '5 jours en matière pénale après notification de l\'arrêt',
            'Non (principe)',
            Colors.red.shade700,
          ),
          recoursCard(
            'La révision',
            'Permet de remettre en cause une condamnation définitive si de nouveaux éléments font douter de la culpabilité.',
            'Pas de délai (procédure exceptionnelle)',
            'Possible',
            Colors.purple,
          ),
          recoursCard(
            'Le réexamen',
            'Possible après condamnation par la CEDH (Cour européenne des droits de l\'homme) pour violation de la CESDH.',
            'Dans les 6 mois après l\'arrêt CEDH définitif',
            'Non',
            Colors.indigo,
          ),
        ]),

        section('4) Focus : l\'appel pénal', [
          bullet('Délai : 10 jours pour le prévenu, 10 jours pour le ministère public, 10 jours pour la partie civile.'),
          bullet('Juridiction d\'appel : chambre correctionnelle de la cour d\'appel (pour délits) ou cour d\'assises d\'appel (pour crimes).'),
          bullet('L\'appel pénal est suspensif : la peine principale ne s\'exécute pas pendant l\'appel (sauf maintien en détention provisoire ordonné).'),
          bullet('Reformatio in pejus : la cour d\'appel peut aggraver la peine si le parquet a fait appel, mais ne peut pas aggraver si seul le prévenu a fait appel.'),
        ]),

        section('5) La Cour européenne des droits de l\'homme (CEDH)', [
          bullet('Siège à Strasbourg. Contrôle le respect de la Convention européenne des droits de l\'homme (CESDH).'),
          bullet('Saisie uniquement après épuisement des voies de recours internes.'),
          bullet('Ses arrêts condamnent l\'État — ils ne cassent pas directement la décision nationale mais peuvent engendrer un réexamen.'),
          encadre('À retenir', 'La CEDH n\'est pas une juridiction supérieure française. Elle ne juge pas les affaires pénales en tant que telles mais contrôle si les procédures respectent les droits fondamentaux garantis par la Convention.', accent),
        ]),
      ]),
    );
  }
}
