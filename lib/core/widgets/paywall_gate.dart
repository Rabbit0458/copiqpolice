// lib/core/widgets/paywall_gate.dart
//
// COP'IQ — Paywall Gate (granular premium content gating)
//
// Wraps a widget that requires a Premium subscription. If the user is free
// (and not an owner), shows a premium-styled overlay with a CTA to subscribe.
//
// Usage:
//   PaywallGate(
//     featureName: "Entraînements illimités",
//     child: MyPremiumModule(),
//   )
//
// Owner role bypasses the paywall (founder/dev mode).
// Reads entitlement from EntitlementService and listens to changes from
// SubscriptionService for instant unlock after a Stripe checkout.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/entitlement_service.dart';
import '../services/subscription_service.dart';

class PaywallGate extends StatefulWidget {
  final Widget child;
  final String featureName;

  /// If true (default), the underlying child is still rendered but blurred/locked.
  /// If false, only the paywall card is shown — useful for "blocking" pages.
  final bool peek;

  const PaywallGate({
    super.key,
    required this.child,
    required this.featureName,
    this.peek = true,
  });

  @override
  State<PaywallGate> createState() => _PaywallGateState();
}

class _PaywallGateState extends State<PaywallGate> {
  Entitlement _ent = Entitlement.guest;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    SubscriptionService.instance.state.addListener(_onSubChanged);
    _refresh();
  }

  @override
  void dispose() {
    SubscriptionService.instance.state.removeListener(_onSubChanged);
    super.dispose();
  }

  void _onSubChanged() => _refresh();

  Future<void> _refresh() async {
    final ent = await EntitlementService.instance.refresh();
    if (!mounted) return;
    setState(() {
      _ent = ent;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = _ent.premium; // covers owner + paid + trial
    if (!_loaded) {
      return const _PaywallLoading();
    }
    if (unlocked) return widget.child;

    return Stack(
      children: [
        if (widget.peek)
          IgnorePointer(
            ignoring: true,
            child: Opacity(opacity: 0.35, child: widget.child),
          ),
        Positioned.fill(
          child: Center(
            child: _PaywallCard(featureName: widget.featureName, ent: _ent),
          ),
        ),
      ],
    );
  }
}

class _PaywallLoading extends StatelessWidget {
  const _PaywallLoading();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2.4),
      ),
    );
  }
}

class _PaywallCard extends StatelessWidget {
  final String featureName;
  final Entitlement ent;
  const _PaywallCard({required this.featureName, required this.ent});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final tone = t.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: t.colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: tone.withValues(alpha: .45)),
          boxShadow: [
            BoxShadow(
              blurRadius: 28,
              offset: const Offset(0, 14),
              color: Colors.black.withValues(alpha: isDark ? .42 : .12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: isDark ? .22 : .14),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tone.withValues(alpha: .45)),
              ),
              child: Icon(Icons.lock_rounded, color: tone, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              "Réservé à l'accès Premium",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.25,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$featureName est inclus dans l'abonnement.\n"
              "Souscris pour débloquer instantanément cette fonctionnalité.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: t.colorScheme.onSurface.withValues(alpha: .78),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/abonnement'),
                style: FilledButton.styleFrom(
                  backgroundColor: tone,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.1,
                  ),
                ),
                icon: const Icon(Icons.workspace_premium_rounded),
                label: const Text("Voir les offres"),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Annulation en 30 secondes — sans engagement.",
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: t.colorScheme.onSurface.withValues(alpha: .55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
