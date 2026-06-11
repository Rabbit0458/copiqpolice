import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuridictionsPenalesPage extends StatelessWidget {
  const JuridictionsPenalesPage({super.key});
  static const String routeName = '/pa/organisation_judiciaire/juridictions_penales';

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

    Widget juridictionCard(String nom, String infraction, String peine, String composition, Color couleur) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: couleur.withValues(alpha: .07), borderRadius: BorderRadius.circular(14), border: Border.all(color: couleur.withValues(alpha: .25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(nom, style: bold.copyWith(color: couleur, fontSize: 15)),
        const SizedBox(height: 8),
        _InfoRow(label: 'Infraction', value: infraction),
        _InfoRow(label: 'Peine max', value: peine),
        _InfoRow(label: 'Composition', value: composition),
      ]),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, elevation: 0, centerTitle: true, leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain)), title: Text('Juridictions pénales', style: h1.copyWith(fontSize: 17))),
      body: ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(18, 8, 18, 32), children: [

        section('1) Les trois juridictions pénales du premier degré', [
          juridictionCard(
            'Tribunal de police',
            'Contraventions (classes 1 à 5)',
            'Amende jusqu\'à 3 000 € (38 000 € pour personnes morales)',
            '1 juge unique',
            Colors.green.shade700,
          ),
          juridictionCard(
            'Tribunal correctionnel',
            'Délits (infractions punies d\'emprisonnement jusqu\'à 10 ans)',
            'Emprisonnement jusqu\'à 10 ans + amendes',
            '3 juges (composition collégiale) ou juge unique',
            Colors.orange.shade700,
          ),
          juridictionCard(
            'Cour d\'assises',
            'Crimes (infractions punies de 10 ans à perpétuité)',
            'Réclusion criminelle à perpétuité',
            '3 juges professionnels + 6 jurés populaires (12 en appel)',
            Colors.red.shade700,
          ),
        ]),

        section('2) Le tribunal correctionnel — focus', [
          bullet('Compétence : délits punissables d\'une peine > 2 mois d\'emprisonnement et < 10 ans.'),
          bullet('Peut statuer en comparution immédiate (CI) : jugement dans les heures suivant l\'arrestation.'),
          bullet('Peut statuer en CRPC (comparution sur reconnaissance préalable de culpabilité) : plaider coupable à la française.'),
          bullet('Peut statuer par ordonnance pénale : sans audience, pour délits simples.'),
          encadre('CRPC', 'Procédure dans laquelle le mis en cause reconnaît sa culpabilité en échange d\'une peine négociée avec le parquet. Le juge homologue ou refuse. Pas applicable aux crimes ni à certains délits graves.', Colors.orange.shade700),
        ]),

        section('3) La cour d\'assises — focus', [
          bullet('Seule juridiction avec jury populaire tiré au sort parmi les citoyens français.'),
          bullet('Siège dans chaque département (au TJ chef-lieu), mais se réunit par sessions périodiques.'),
          bullet('Les jurés (6 en premier ressort, 12 en appel) délibèrent avec les 3 magistrats professionnels.'),
          bullet('Décision prise à la majorité qualifiée (au moins 6 voix sur 9 en 1ère instance).'),
          bullet('Depuis 2011, les arrêts d\'assises sont motivés — obligation de justification introduite par la CJUE.'),
        ]),

        section('4) Juridictions pénales spécialisées', [
          bullet('Tribunal pour enfants (TPE) : mineurs de 13 à 18 ans — depuis le CJPM 2021.'),
          bullet('Cour d\'assises des mineurs : crimes commis par les 16-18 ans.'),
          bullet('Juridiction inter-régionale spécialisée (JIRS) : criminalité organisée, grands trafics.'),
          bullet('Tribunal correctionnel spécialisé (TCS) : trafics de stupéfiants à grande échelle.'),
          encadre('JIRS — À connaître', '8 JIRS en France (Paris, Lyon, Marseille, Rennes, Bordeaux, Lille, Nancy, Fort-de-France). Compétentes pour la grande criminalité organisée, les trafics de stupéfiants, le terrorisme local.', accent),
        ]),

        section('5) Les voies d\'accès au jugement pénal', [
          bullet('Citation directe : le parquet ou la partie civile cite directement le prévenu devant le tribunal.'),
          bullet('Comparution immédiate : déférement immédiat après garde à vue.'),
          bullet('Saisine après information judiciaire : ordonnance de renvoi du JI.'),
          bullet('Mise en accusation : par chambre de l\'instruction pour les crimes.'),
        ]),
      ]),
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
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
      ]),
    );
  }
}
