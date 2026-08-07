// lib/features/home/payment_result_page.dart
// =============================================================================
//  COP'IQ — Écran de retour de paiement (Stripe Checkout)
//  Affiché quand l'app est ramenée au premier plan via les deep links
//  copiqpolice://paywall/success et copiqpolice://paywall/cancel (voir
//  deep_links_service.dart + supabase/functions/cas_pratique_create_checkout).
//  Le webhook Stripe met à jour l'entitlement de façon asynchrone : on affiche
//  donc un état "confirmé" optimiste puis on poll en tâche de fond pour
//  refléter l'activation réelle, sans jamais bloquer l'accès à l'app.
//  Design cohérent avec premium_required_page.dart / abonnement_page.dart.
// =============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/services/entitlement_service.dart';
import 'package:copiqpolice/core/services/subscription_service.dart';
import 'package:copiqpolice/features/home/home_page.dart' show HomePage;

enum PaymentResultStatus { success, cancel }

class PaymentResultPage extends StatefulWidget {
  final PaymentResultStatus status;

  const PaymentResultPage({super.key, required this.status});

  static const String routeNameSuccess = '/payment-success';
  static const String routeNameCancel = '/payment-cancel';

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iconCtrl;
  Timer? _pollTimer;
  int _pollAttempts = 0;
  bool _checking = false;
  bool _confirmed = false;

  bool get _isSuccess => widget.status == PaymentResultStatus.success;

  @override
  void initState() {
    super.initState();
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();

    if (_isSuccess) {
      HapticFeedback.mediumImpact();
      _startConfirmationPolling();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  void _startConfirmationPolling() {
    _checking = true;
    unawaited(_pollOnce());
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pollOnce(),
    );
  }

  Future<void> _pollOnce() async {
    _pollAttempts++;
    try {
      await SubscriptionService.instance.refresh(force: true, withQuota: true);
      final ent = await EntitlementService.instance.refresh(force: true);
      final premiumNow =
          ent.premium || SubscriptionService.instance.state.value.isPremium;

      if (!mounted) return;

      if (premiumNow) {
        _pollTimer?.cancel();
        setState(() {
          _confirmed = true;
          _checking = false;
        });
        HapticFeedback.lightImpact();
        return;
      }
    } catch (_) {
      // Best-effort : on retente au prochain tick, sans bloquer l'UI.
    }

    // ~24s d'attente webhook max : au-delà on arrête de faire tourner le
    // spinner, l'accès reste possible et le realtime prendra le relais.
    if (_pollAttempts >= 8 && mounted) {
      _pollTimer?.cancel();
      setState(() => _checking = false);
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _iconCtrl.dispose();
    super.dispose();
  }

  void _goToApp() {
    HapticFeedback.mediumImpact();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(HomePage.routeName, (r) => false);
  }

  void _retry() {
    HapticFeedback.selectionClick();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/abonnement', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0B0D0F) : const Color(0xFFF5F6F8);
    final surface = isDark ? const Color(0xFF13171C) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F1114);
    final textMuted =
        (isDark ? Colors.white : Colors.black).withValues(alpha: 0.55);
    final accentBlue = isDark ? const Color(0xFF4D9FFF) : const Color(0xFF1565C0);
    final accentGold = isDark ? const Color(0xFFFFD166) : const Color(0xFFD4A017);
    final accentGreen = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
    final accentRed = isDark ? const Color(0xFFFF6B6B) : const Color(0xFFD64545);
    final accent = _isSuccess ? accentGreen : accentRed;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Icône animée ─────────────────────────────
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _iconCtrl,
                      curve: Curves.elasticOut,
                    ),
                    child: Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accent.withValues(alpha: 0.30),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _isSuccess ? Icons.check_rounded : Icons.close_rounded,
                        size: 54,
                        color: accent,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  if (_isSuccess) ...[
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentBlue.withValues(alpha: 0.15),
                            accentGold.withValues(alpha: 0.12),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentBlue.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "COP'IQ Premium",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: accentBlue,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Titre ─────────────────────────────
                  Text(
                    _isSuccess ? 'Paiement confirmé' : 'Paiement annulé',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                      height: 1.15,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _isSuccess
                        ? "Merci ! Ton abonnement COP'IQ Premium est en cours d'activation."
                        : "Le paiement n'a pas abouti. Aucun montant n'a été débité.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textMuted,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Carte statut d'activation ─────────────────────────
                  if (_isSuccess)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.25 : 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: _checking
                                ? CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: accentBlue,
                                  )
                                : Icon(
                                    _confirmed
                                        ? Icons.verified_rounded
                                        : Icons.hourglass_top_rounded,
                                    color: _confirmed ? accentGreen : accentGold,
                                    size: 22,
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _confirmed
                                  ? 'Accès Premium activé sur ton compte'
                                  : (_checking
                                      ? 'Activation de ton accès en cours…'
                                      : "Ça peut prendre quelques instants — tu peux déjà continuer."),
                              style: GoogleFonts.instrumentSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  // ── CTA principal : accès à toute l'app ─────────────────
                  _ResultCTA(
                    isDark: isDark,
                    accentBlue: accentBlue,
                    label: "Accéder à l'application",
                    onTap: _goToApp,
                  ),

                  if (!_isSuccess) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _retry,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Réessayer',
                          style: GoogleFonts.instrumentSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── CTA principal animé (identique à la DA premium_required_page) ────────
class _ResultCTA extends StatefulWidget {
  final bool isDark;
  final Color accentBlue;
  final String label;
  final VoidCallback onTap;

  const _ResultCTA({
    required this.isDark,
    required this.accentBlue,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ResultCTA> createState() => _ResultCTAState();
}

class _ResultCTAState extends State<_ResultCTA> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isDark
                  ? [const Color(0xFF1E6FDB), const Color(0xFF0A4BAD)]
                  : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: widget.accentBlue.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.instrumentSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
