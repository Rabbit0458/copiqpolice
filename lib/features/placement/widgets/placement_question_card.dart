part of '../placement_test.dart';

class PlacementQuestionCard extends StatelessWidget {
  const PlacementQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.selectedIndex,
    required this.locked,
    required this.submitting,
    required this.reduceMotion,
    required this.foreground,
    required this.domainLabel,
    required this.difficultyLabel,
    required this.onSelect,
    required this.onValidate,
  });

  final _PlacementQuestion question;
  final int index;
  final int total;
  final int? selectedIndex;
  final bool locked;
  final bool submitting;
  final bool reduceMotion;
  final Color foreground;
  final String domainLabel;
  final String difficultyLabel;
  final ValueChanged<int> onSelect;
  final Future<void> Function() onValidate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 610;
        final horizontal = MediaQuery.sizeOf(context).width >= 720;
        final selected = selectedIndex != null;

        final content = PlacementReveal(
          key: ValueKey(question.id),
          reduceMotion: reduceMotion,
          delay: Duration.zero,
          child: PlacementSurface(
            padding: EdgeInsets.fromLTRB(18, compact ? 16 : 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PlacementPill(
                      label: domainLabel,
                      icon: _domainIcon(question.domain),
                    ),
                    PlacementPill(
                      label: difficultyLabel,
                      icon: Icons.signal_cellular_alt_rounded,
                      accent: const Color(0xFF14B8A6),
                    ),
                    PlacementPill(
                      label: '${question.weight} pts',
                      icon: Icons.bolt_rounded,
                      accent: _placementGold,
                    ),
                  ],
                ),
                SizedBox(height: compact ? 15 : 22),
                Text(
                  'Question',
                  style: placementText(
                    size: 12.5,
                    weight: FontWeight.w800,
                    color: _placementMuted,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  question.question,
                  style: placementText(
                    size: compact ? 18 : 21,
                    weight: FontWeight.w900,
                    height: 1.28,
                  ),
                ),
                SizedBox(height: compact ? 16 : 22),
                ...List.generate(question.answers.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i == question.answers.length - 1 ? 0 : 10,
                    ),
                    child: PlacementAnswerTile(
                      label: question.answers[i],
                      selected: selectedIndex == i,
                      locked: locked,
                      onTap: () => onSelect(i),
                    ),
                  );
                }),
                SizedBox(height: compact ? 14 : 18),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: reduceMotion ? 0 : 210),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.98, end: 1.0).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: selected
                      ? PlacementPrimaryButton(
                          key: const ValueKey('ready'),
                          label: locked ? 'Réponse verrouillée' : 'Valider',
                          icon: locked
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          foreground: foreground,
                          enabled: !locked && !submitting,
                          onPressed: () => onValidate(),
                        )
                      : PlacementPrimaryButton(
                          key: const ValueKey('disabled'),
                          label: 'Choisis une réponse',
                          icon: Icons.lock_rounded,
                          foreground: foreground,
                          enabled: false,
                          onPressed: null,
                        ),
                ),
              ],
            ),
          ),
        );

        return Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: compact ? 4 : 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: horizontal ? 620 : 560,
              ),
              child: Center(child: content),
            ),
          ),
        );
      },
    );
  }

  IconData _domainIcon(PlacementDomain domain) {
    switch (domain) {
      case PlacementDomain.francais:
        return Icons.menu_book_rounded;
      case PlacementDomain.logique:
        return Icons.psychology_rounded;
      case PlacementDomain.deontologie:
        return Icons.gavel_rounded;
      case PlacementDomain.histoire:
        return Icons.account_balance_rounded;
      case PlacementDomain.sport:
        return Icons.directions_run_rounded;
    }
  }
}
