// COP'IQ — Photolangage PA : « Les étapes de la réussite ».
// Méthode COP'IQ en 7 étapes + checklist de relecture interactive
// (persistée localement) + CTA vers les entraînements.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyReveal, PaPsyScaffold;
import 'pa_photolangage_core.dart';

class PaPhotolangageEtapesPage extends StatefulWidget {
  static const String routeName = PaPhotolangageRoutes.etapes;
  const PaPhotolangageEtapesPage({super.key});

  @override
  State<PaPhotolangageEtapesPage> createState() =>
      _PaPhotolangageEtapesPageState();
}

class _PaPhotolangageEtapesPageState extends State<PaPhotolangageEtapesPage> {
  static const _checklistKey = 'pa_photolangage_checklist_v1';

  static const _steps = [
    (
      'OBSERVER SANS ÉCRIRE',
      Icons.visibility_rounded,
      PaPsychoBrand.accent,
      'Prends quelques secondes pour balayer toute l’image : le lieu, les '
          'personnes, les objets, les actions, les plans. Ne te précipite '
          'pas sur le stylo.',
    ),
    (
      'IDENTIFIER LA SCÈNE GÉNÉRALE',
      Icons.crop_free_rounded,
      PaPsychoBrand.cSuiteLogique,
      'Rédige une phrase d’ouverture simple, par exemple : « La '
          'photographie représente une scène de circulation dans une rue '
          'urbaine. »',
    ),
    (
      'CONSTRUIRE UN ORDRE DE DESCRIPTION',
      Icons.format_list_numbered_rounded,
      PaPsychoBrand.cRaisonnement,
      'Du général au particulier, du premier plan vers l’arrière-plan, de '
          'gauche à droite, du centre vers la périphérie. Ne passe pas '
          'd’un élément à un autre au hasard.',
    ),
    (
      'DÉCRIRE UNIQUEMENT LE VISIBLE',
      Icons.fact_check_rounded,
      PaPsychoBrand.good,
      'Distingue certitude et supposition. N’attribue ni sentiment, ni '
          'intention, ni identité. Ne transforme pas la photographie en '
          'récit.',
    ),
    (
      'UTILISER UN VOCABULAIRE PRÉCIS',
      Icons.menu_book_rounded,
      PaPsychoBrand.cVerbal,
      'Repères spatiaux, verbes descriptifs variés. Évite « il y a » dans '
          'toutes les phrases et chasse les répétitions.',
    ),
    (
      'GÉRER LES 20 MINUTES COP’IQ',
      Icons.timer_rounded,
      PaPsychoBrand.cCalcul,
      'Découpage conseillé : 2 min d’observation, 2 min de plan mental, '
          '12 min de rédaction, 4 min de relecture. Le chronomètre global '
          'reste la seule référence.',
    ),
    (
      'RELIRE MÉTHODIQUEMENT',
      Icons.spellcheck_rounded,
      PaPsychoBrand.warn,
      'Utilise la checklist ci-dessous à chaque entraînement : c’est la '
          'relecture qui transforme une copie moyenne en bonne copie.',
    ),
  ];

  static const _checklist = [
    'Majuscules en début de phrase',
    'Un point à la fin de chaque phrase',
    'Accords sujet-verbe',
    'Accords nom-adjectif',
    'Pluriels',
    'Participes passés usuels',
    'Infinitif ou participe passé (-er / -é)',
    'Homophones (a/à, ou/où, ce/se, son/sont...)',
    'Répétitions à remplacer',
    'Aucune phrase incomplète',
    'Aucun mot manquant',
    'Cohérence entre les phrases',
  ];

  Set<int> _checked = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_checklistKey) ?? const [];
      if (!mounted) return;
      setState(
        () => _checked = raw.map(int.parse).where((i) => i >= 0).toSet(),
      );
    } catch (_) {}
  }

  Future<void> _toggle(int i) async {
    setState(() {
      if (!_checked.add(i)) _checked.remove(i);
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _checklistKey,
        _checked.map((e) => e.toString()).toList(),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Les étapes de la réussite',
      title: 'La méthode COP’IQ en 7 étapes',
      subtitle:
          'Une méthode simple et mémorisable, de la première seconde '
          'd’observation à la dernière minute de relecture.',
      headerIcon: Icons.route_rounded,
      headerColor: PaPsychoBrand.cSuiteLogique,
      children: [
        for (var i = 0; i < _steps.length; i++)
          PaPsyReveal(
            index: 3 + i,
            child: _StepCard(
              number: i + 1,
              title: _steps[i].$1,
              icon: _steps[i].$2,
              color: _steps[i].$3,
              text: _steps[i].$4,
              isLast: i == _steps.length - 1,
            ),
          ),
        const SizedBox(height: 8),
        PaPsyReveal(
          index: 10,
          child: Text(
            'Checklist de relecture',
            style: PaPsychoBrand.h2(context),
          ),
        ),
        const SizedBox(height: 4),
        PaPsyReveal(
          index: 11,
          child: Text(
            'Coche les points que tu maîtrises ; ils restent enregistrés '
            'sur cet appareil.',
            style: PaPsychoBrand.small(context),
          ),
        ),
        const SizedBox(height: 12),
        PaPsyReveal(
          index: 12,
          child: Container(
            decoration: PaPsychoBrand.card(context),
            child: Column(
              children: [
                for (var i = 0; i < _checklist.length; i++)
                  CheckboxListTile(
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: PaPsychoBrand.good,
                    value: _checked.contains(i),
                    onChanged: (_) => _toggle(i),
                    title: Text(
                      _checklist[i],
                      style: PaPsychoBrand.body(context),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        PaPsyReveal(
          index: 13,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: PaPsychoBrand.tinted(
              context,
              color: PaPsychoBrand.good,
              radius: 18,
              alpha: .10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.self_improvement_rounded,
                  color: PaPsychoBrand.good,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Reste calme. Cet exercice évalue la qualité de ton '
                    'expression, pas ta personnalité. Une copie simple, '
                    'claire et bien relue vaut mieux qu’une copie ambitieuse '
                    'et fautive. L’entraînement régulier fait le reste.',
                    style: PaPsychoBrand.body(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        PaPsyReveal(
          index: 14,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                PaPhotolangageRoutes.entrainements,
              ),
              icon: const Icon(Icons.bolt_rounded),
              label: const Text('Commencer un entraînement'),
              style: FilledButton.styleFrom(
                backgroundColor: PaPsychoBrand.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final int number;
  final String title;
  final IconData icon;
  final Color color;
  final String text;
  final bool isLast;

  const _StepCard({
    required this.number,
    required this.title,
    required this.icon,
    required this.color,
    required this.text,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: PaPsychoBrand.tinted(
                  context,
                  color: color,
                  radius: 12,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: PaPsychoBrand.h3(context).copyWith(color: color),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: PaPsychoBrand.borderColor(context),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: PaPsychoBrand.card(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ÉTAPE $number — $title',
                          style: PaPsychoBrand.h3(
                            context,
                          ).copyWith(fontSize: 15.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(text, style: PaPsychoBrand.body(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
