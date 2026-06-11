// lib/services/subscription_gate.dart
import 'package:flutter/material.dart';
import 'subscription_service.dart';

class SubscriptionGate extends StatefulWidget {
  final Widget child;
  const SubscriptionGate({super.key, required this.child});

  @override
  State<SubscriptionGate> createState() => _SubscriptionGateState();
}

class _SubscriptionGateState extends State<SubscriptionGate> {
  final _svc = SubscriptionService.instance;

  @override
  void initState() {
    super.initState();
    _svc.startAutoSync();
    // refresh initial (clean)
    _svc.refresh(force: true, withQuota: true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SubscriptionState>(
      valueListenable: _svc.state,
      builder: (_, st, __) {
        final locked = st.isLocked;

        return Stack(
          children: [
            widget.child,

            if (locked) ...[
              // voile
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.55),
                    alignment: Alignment.center,
                    child: _LockCard(
                      remaining: st.remaining ?? 0,
                      resetsAt: st.resetsAt,
                      onPremium: () =>
                          Navigator.of(context).pushNamed('/abonnement'),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _LockCard extends StatelessWidget {
  final int remaining;
  final DateTime? resetsAt;
  final VoidCallback onPremium;

  const _LockCard({
    required this.remaining,
    required this.resetsAt,
    required this.onPremium,
  });

  String _fmt(DateTime? d) {
    if (d == null) return '—';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm à $hh:$mi';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txt = theme.colorScheme.onSurface;

    return Container(
      width: 420,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_rounded, size: 42, color: txt),
          const SizedBox(height: 10),
          Text(
            'Limite gratuite atteinte',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous avez utilisé vos 10 accès gratuits.\nRéinitialisation : ${_fmt(resetsAt?.toLocal())}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              color: txt.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPremium,
              child: const Text('Passer Premium'),
            ),
          ),
        ],
      ),
    );
  }
}
