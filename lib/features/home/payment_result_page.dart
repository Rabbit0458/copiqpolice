import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/entitlement_service.dart';
import '../../core/services/subscription_service.dart';

enum PaymentResultStatus {
  success,
  cancel,
  declined,
  insufficientFunds,
  incorrectCvc,
  expiredCard,
  authenticationRequired,
  networkError,
  failed,
}

class PaymentResultPage extends StatefulWidget {
  const PaymentResultPage({
    super.key,
    required this.status,
    this.sessionId,
    this.errorCode,
  });

  static const successRoute = '/payment-success';
  static const cancelRoute = '/payment-cancel';
  static const failureRoute = '/payment-failure';

  final PaymentResultStatus status;
  final String? sessionId;
  final String? errorCode;

  static const _officialHosts = <String>{
    'copiqpolice.app',
    'www.copiqpolice.app',
    'copiq.fr',
    'www.copiq.fr',
    'app.copiq.fr',
  };

  static const _successPaths = <String>{
    '/success',
    '/payment-success',
    '/paywall/success',
  };

  static const _cancelPaths = <String>{
    '/cancel',
    '/canceled',
    '/cancelled',
    '/payment-cancel',
    '/paywall/cancel',
  };

  static const _failurePaths = <String>{
    '/failure',
    '/failed',
    '/error',
    '/payment-failure',
    '/paywall/failure',
  };

  static String _logicalPath(Uri uri) {
    if (uri.scheme == 'copiqpolice') {
      final host = uri.host.isEmpty ? '' : '/${uri.host}';
      return '$host${uri.path}'.replaceAll(RegExp(r'/+'), '/');
    }
    return uri.path.isEmpty ? '/' : uri.path;
  }

  static bool supportsUri(Uri uri) {
    final allowedOrigin =
        uri.scheme.isEmpty ||
        uri.scheme == 'copiqpolice' ||
        (uri.scheme == 'https' && _officialHosts.contains(uri.host));
    if (!allowedOrigin) return false;
    final path = _logicalPath(uri);
    return _successPaths.contains(path) ||
        _cancelPaths.contains(path) ||
        _failurePaths.contains(path);
  }

  static PaymentResultStatus statusFromUri(Uri uri) {
    final value = <String?>[
      uri.queryParameters['status'],
      uri.queryParameters['code'],
      uri.queryParameters['reason'],
      uri.queryParameters['error'],
      uri.queryParameters['payment_status'],
    ].whereType<String>().join(' ').toLowerCase();

    if (value.contains('insufficient_funds')) {
      return PaymentResultStatus.insufficientFunds;
    }
    if (value.contains('incorrect_cvc') || value.contains('invalid_cvc')) {
      return PaymentResultStatus.incorrectCvc;
    }
    if (value.contains('expired_card')) return PaymentResultStatus.expiredCard;
    if (value.contains('authentication_required') ||
        value.contains('requires_action') ||
        value.contains('3ds')) {
      return PaymentResultStatus.authenticationRequired;
    }
    if (value.contains('network_error') ||
        value.contains('connection_error') ||
        value.contains('timeout')) {
      return PaymentResultStatus.networkError;
    }
    if (value.contains('card_declined') ||
        value.contains('do_not_honor') ||
        value.contains('declined')) {
      return PaymentResultStatus.declined;
    }
    if (value.contains('cancel')) return PaymentResultStatus.cancel;
    if (value.contains('success') ||
        value.contains('completed') ||
        value.contains('paid')) {
      return PaymentResultStatus.success;
    }

    final path = _logicalPath(uri);
    if (_successPaths.contains(path)) return PaymentResultStatus.success;
    if (_cancelPaths.contains(path)) return PaymentResultStatus.cancel;
    return PaymentResultStatus.failed;
  }

  static PaymentResultPage fromUri(Uri uri) {
    return PaymentResultPage(
      status: statusFromUri(uri),
      sessionId: uri.queryParameters['session_id'],
      errorCode: uri.queryParameters['code'] ?? uri.queryParameters['error'],
    );
  }

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage>
    with SingleTickerProviderStateMixin {
  static const _logoUrl =
      'https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png';
  bool _checking = false;
  bool _premiumConfirmed = false;
  bool _verificationTimedOut = false;
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
    if (widget.status == PaymentResultStatus.success) {
      unawaited(_verifySubscription());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verifySubscription() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _verificationTimedOut = false;
    });

    for (var attempt = 0; attempt < 8 && mounted; attempt++) {
      try {
        await SubscriptionService.instance.refresh(
          force: true,
          withQuota: true,
        );
        await EntitlementService.instance.refresh(force: true);
        if (SubscriptionService.instance.state.value.isPremium ||
            EntitlementService.instance.state.value.premium) {
          if (!mounted) return;
          setState(() {
            _premiumConfirmed = true;
            _checking = false;
          });
          return;
        }
      } catch (_) {
        // Le webhook Stripe peut être légèrement différé : on retente calmement.
      }
      if (attempt < 7) await Future<void>.delayed(const Duration(seconds: 3));
    }

    if (mounted) {
      setState(() {
        _checking = false;
        _verificationTimedOut = true;
      });
    }
  }

  void _goHome() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/home-bootstrap', (_) => false);
  }

  void _retryPayment() {
    Navigator.of(context).pushNamedAndRemoveUntil('/abonnement', (_) => false);
  }

  _PaymentCopy get _copy {
    if (widget.status == PaymentResultStatus.success) {
      if (_premiumConfirmed) {
        return const _PaymentCopy(
          icon: Icons.workspace_premium_rounded,
          title: 'Bienvenue dans Premium',
          message:
              'Félicitations et merci d’avoir rejoint COP’IQ ! Ton abonnement est actif et tout le contenu Premium est maintenant débloqué.',
          accent: Color(0xFF16A765),
        );
      }
      if (_verificationTimedOut) {
        return const _PaymentCopy(
          icon: Icons.schedule_rounded,
          title: 'Confirmation en cours',
          message:
              'Le paiement a bien été reçu. La synchronisation prend un peu plus de temps que prévu.',
          accent: Color(0xFF2D6CDF),
        );
      }
      return const _PaymentCopy(
        icon: Icons.shield_outlined,
        title: 'Vérification du paiement',
        message:
            'Nous sécurisons ton accès Premium. Cela ne prend que quelques secondes.',
        accent: Color(0xFF2D6CDF),
      );
    }

    switch (widget.status) {
      case PaymentResultStatus.cancel:
        return const _PaymentCopy(
          icon: Icons.arrow_back_rounded,
          title: 'Paiement annulé',
          message:
              'Aucun prélèvement n’a été effectué. Tu peux reprendre quand tu veux.',
          accent: Color(0xFF64748B),
        );
      case PaymentResultStatus.declined:
        return const _PaymentCopy(
          icon: Icons.credit_card_off_rounded,
          title: 'Carte refusée',
          message:
              'Ta banque n’a pas autorisé ce paiement. Essaie une autre carte ou contacte-la.',
          accent: Color(0xFFE24A5A),
        );
      case PaymentResultStatus.insufficientFunds:
        return const _PaymentCopy(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Solde insuffisant',
          message:
              'Le solde disponible ne permet pas de finaliser l’abonnement.',
          accent: Color(0xFFE24A5A),
        );
      case PaymentResultStatus.incorrectCvc:
        return const _PaymentCopy(
          icon: Icons.password_rounded,
          title: 'Cryptogramme incorrect',
          message:
              'Vérifie les trois chiffres au dos de ta carte puis réessaie.',
          accent: Color(0xFFE24A5A),
        );
      case PaymentResultStatus.expiredCard:
        return const _PaymentCopy(
          icon: Icons.event_busy_rounded,
          title: 'Carte expirée',
          message:
              'Cette carte n’est plus valide. Utilise une autre carte pour continuer.',
          accent: Color(0xFFE24A5A),
        );
      case PaymentResultStatus.authenticationRequired:
        return const _PaymentCopy(
          icon: Icons.verified_user_outlined,
          title: 'Validation requise',
          message:
              'L’authentification de ta banque n’a pas été terminée. Relance le paiement.',
          accent: Color(0xFFF59E0B),
        );
      case PaymentResultStatus.networkError:
        return const _PaymentCopy(
          icon: Icons.wifi_off_rounded,
          title: 'Connexion interrompue',
          message:
              'Vérifie ta connexion. Aucun accès ne sera activé sans confirmation sécurisée.',
          accent: Color(0xFFF59E0B),
        );
      case PaymentResultStatus.failed:
        return const _PaymentCopy(
          icon: Icons.error_outline_rounded,
          title: 'Paiement non finalisé',
          message:
              'Une erreur est survenue. Tu peux réessayer sans risque de double prélèvement.',
          accent: Color(0xFFE24A5A),
        );
      case PaymentResultStatus.success:
        throw StateError('Handled above');
    }
  }

  @override
  Widget build(BuildContext context) {
    final copy = _copy;
    final isSuccessFlow = widget.status == PaymentResultStatus.success;
    // Une session Stripe déjà validée ne doit jamais proposer de relancer un
    // paiement, même si la synchronisation Premium prend plus de temps.
    final canRetry = !isSuccessFlow;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 52,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scale,
                    child: _PaymentStatusMark(
                      logoUrl: _logoUrl,
                      accent: copy.accent,
                      icon: copy.icon,
                      checking: _checking,
                      success: _premiumConfirmed,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    copy.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    copy.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.5,
                      color: const Color(0xFF667085),
                    ),
                  ),
                  if (widget.sessionId != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Référence sécurisée • ${widget.sessionId!.substring(0, widget.sessionId!.length > 12 ? 12 : widget.sessionId!.length)}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF98A2B3),
                      ),
                    ),
                  ],
                  const SizedBox(height: 38),
                  if (canRetry)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _retryPayment,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Réessayer le paiement'),
                        style: FilledButton.styleFrom(
                          backgroundColor: copy.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  if (_verificationTimedOut) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _verifySubscription,
                      icon: const Icon(Icons.sync_rounded),
                      label: const Text('Vérifier à nouveau'),
                    ),
                  ],
                  if (_premiumConfirmed) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: FilledButton.icon(
                        onPressed: _goHome,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(
                          'Commencer avec Premium',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF16A765),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentStatusMark extends StatelessWidget {
  const _PaymentStatusMark({
    required this.logoUrl,
    required this.accent,
    required this.icon,
    required this.checking,
    required this.success,
  });

  final String logoUrl;
  final Color accent;
  final IconData icon;
  final bool checking;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: success
          ? 'Paiement validé, abonnement Premium actif'
          : checking
          ? 'Vérification sécurisée du paiement en cours'
          : 'Résultat du paiement',
      child: SizedBox(
        width: 126,
        height: 126,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (success) ...[
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.65, end: 1),
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutBack,
                builder: (_, value, child) => Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value.clamp(0, 1), child: child),
                ),
                child: Container(
                  width: 122,
                  height: 122,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF35C981).withValues(alpha: .28),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 4,
                right: 6,
                child: _SuccessSpark(delay: 250),
              ),
              const Positioned(
                left: 2,
                bottom: 18,
                child: _SuccessSpark(delay: 430),
              ),
            ],
            Container(
              width: 96,
              height: 96,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.11),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.25)),
                boxShadow: success
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: .22),
                          blurRadius: 28,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Image.network(
                logoUrl,
                fit: BoxFit.contain,
                semanticLabel: 'Logo COP’IQ',
                errorBuilder: (_, __, ___) =>
                    Icon(icon, color: accent, size: 42),
              ),
            ),
            if (checking)
              SizedBox(
                width: 108,
                height: 108,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: accent,
                  backgroundColor: accent.withValues(alpha: .12),
                ),
              ),
            if (success)
              Positioned(
                right: 10,
                bottom: 9,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 620),
                  curve: Curves.easeOutBack,
                  builder: (_, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A765),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuccessSpark extends StatelessWidget {
  const _SuccessSpark({required this.delay});
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: const Interval(.35, 1, curve: Curves.easeOutBack),
      builder: (_, value, __) => Transform.scale(
        scale: value,
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Color(0xFF35C981),
          size: 22,
        ),
      ),
    );
  }
}

class _PaymentCopy {
  const _PaymentCopy({
    required this.icon,
    required this.title,
    required this.message,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color accent;
}
