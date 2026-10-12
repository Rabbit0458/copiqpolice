import 'package:flutter/material.dart';

import '../services/subscription_service.dart';

bool isQuotaExerciseRoute(String? name) {
  final path = Uri.tryParse(name ?? '')?.path ?? '';
  final exam = RegExp(r'^/(gpx|pa)_exam/concours/');
  if (!exam.hasMatch(path)) return false;
  final leaf = path.substring(exam.firstMatch(path)!.end);
  const culture = {
    'police_securite',
    'sante',
    'securite_routiere',
    'mythologie',
    'droit',
    'sciences',
    'sport',
    'francais',
    'musique',
    'cinema',
    'geographie',
    'actualite',
    'institutions_europeennes',
    'histoire_france',
  };
  if (leaf.startsWith('culture_generale_')) {
    return culture.contains(leaf.substring('culture_generale_'.length));
  }
  const exercises = {
    'calcul_mental',
    'calcul_rapide',
    'concentration',
    'attention_concentration',
    'attention_visuelle',
    'logique_verbale',
    'raisonnement_logique',
    'spatial',
    'rotations',
    'suites_logiques',
    'mode_concours',
  };
  if (leaf.startsWith('tests_psychotechniques/')) {
    return exercises.contains(leaf.substring('tests_psychotechniques/'.length));
  }
  return leaf == 'tests_psy/aptitude_verbale' ||
      RegExp(
        r'^langue_etrangere/exemples_(allemand|espagnol|anglais)$',
      ).hasMatch(leaf) ||
      RegExp(
        r'^cas_pratique/(case_([1-6]|dynamic)|concours_blanc)$',
      ).hasMatch(leaf);
}

/// Keep the exercise builder lazy: no questions load until the server allows it.
class ExamAccessGate extends StatefulWidget {
  const ExamAccessGate({super.key, required this.builder, this.authorize});

  final WidgetBuilder builder;
  final Future<ConsumeResult> Function()? authorize;

  static Widget wrap(
    String? route,
    WidgetBuilder builder,
    BuildContext context,
  ) {
    return isQuotaExerciseRoute(route)
        ? ExamAccessGate(builder: builder)
        : builder(context);
  }

  @override
  State<ExamAccessGate> createState() => _ExamAccessGateState();
}

class _ExamAccessGateState extends State<ExamAccessGate> {
  late Future<ConsumeResult> _permission;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _permission = _authorize();
  }

  Future<ConsumeResult> _authorize() =>
      (widget.authorize ?? SubscriptionService.instance.consumeFreeRequest)();

  Future<void> _retry() async {
    if (_retrying) return;
    setState(() => _retrying = true);
    try {
      if (widget.authorize == null) {
        final allowed = await SubscriptionService.instance.guardAppAccess(
          context,
        );
        if (!allowed || !mounted) return;
      }
      if (!mounted) return;
      final permission = _authorize();
      setState(() => _permission = permission);
      await permission;
    } catch (_) {
      // FutureBuilder keeps a failed authorization closed.
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConsumeResult>(
      future: _permission,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data?.allowed == true) return widget.builder(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Accès à l’exercice')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 32),
                  const SizedBox(height: 16),
                  const Text(
                    'Accès indisponible. Vérifie ta connexion ou tes accès gratuits.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _retrying ? null : _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/abonnement'),
                    child: const Text('Voir Premium'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
