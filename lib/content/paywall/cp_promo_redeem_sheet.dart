// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Widget de saisie d'un code promo (bottom sheet)                 ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-087             ║
// ║                                                                           ║
// ║  Bottom sheet qui permet à l'utilisateur :                                ║
// ║   • De saisir un code (uppercase auto, max 32 chars, alphanum + tirets)  ║
// ║   • De valider en temps réel via edge fn `cas_pratique_redeem_promo`     ║
// ║     mode `validate_only=true` (UI feedback sans consommation)            ║
// ║   • De voir le détail de la réduction (X% / -Y€ / +N mois)              ║
// ║   • De confirmer pour appliquer (consommation + stripe_coupon_id retourné)║
// ║                                                                           ║
// ║  Usage :                                                                  ║
// ║    final res = await showModalBottomSheet&lt;CpPromoResult?&gt;(              ║
// ║      context: context,                                                    ║
// ║      builder: (_) => const CpPromoRedeemSheet(priceId: 'price_monthly'), ║
// ║    );                                                                     ║
// ║    if (res?.valid == true) {                                              ║
// ║      // Brancher res.stripeCouponId sur le checkout                      ║
// ║      CpPayments.I.startCheckout(                                         ║
// ║        priceId: 'price_monthly',                                          ║
// ║        // coupon_id à passer côté backend (extension future)             ║
// ║      );                                                                   ║
// ║    }                                                                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Résultat retourné au caller
// ──────────────────────────────────────────────────────────────────────────

class CpPromoResult {
  final bool valid;
  final String code;
  final String? discountKind; // 'percent' | 'fixed_amount' | 'free_months'
  final int? discountValue;
  final String? stripeCouponId;
  final String? reason; // si invalide

  const CpPromoResult({
    required this.valid,
    required this.code,
    this.discountKind,
    this.discountValue,
    this.stripeCouponId,
    this.reason,
  });

  /// Label humain : "−50%" / "−10 €" / "+1 mois offert"
  String get humanLabel {
    switch (discountKind) {
      case 'percent':
        return '−${discountValue ?? 0}%';
      case 'fixed_amount':
        final euros = (discountValue ?? 0) / 100;
        return '−${euros.toStringAsFixed(2)} €';
      case 'free_months':
        final n = discountValue ?? 0;
        return n == 1 ? '+1 mois offert' : '+$n mois offerts';
      default:
        return '';
    }
  }

  /// Message d'erreur humain selon `reason`
  String? get errorMessage {
    if (valid) return null;
    switch (reason) {
      case 'code_not_found':
        return 'Ce code n\'existe pas.';
      case 'not_yet_valid':
        return 'Ce code n\'est pas encore activé.';
      case 'expired':
        return 'Ce code a expiré.';
      case 'max_global_reached':
        return 'Ce code a atteint sa limite d\'utilisations.';
      case 'max_per_user_reached':
        return 'Tu as déjà utilisé ce code.';
      case 'plan_not_eligible':
        return 'Ce code n\'est pas valable sur ce plan.';
      default:
        return 'Code invalide.';
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Widget bottom sheet
// ──────────────────────────────────────────────────────────────────────────

class CpPromoRedeemSheet extends StatefulWidget {
  const CpPromoRedeemSheet({super.key, this.priceId});

  /// Si renseigné, valide aussi que le code est éligible pour ce plan.
  final String? priceId;

  @override
  State<CpPromoRedeemSheet> createState() => _CpPromoRedeemSheetState();
}

class _CpPromoRedeemSheetState extends State<CpPromoRedeemSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  bool _validating = false;
  bool _applying = false;
  CpPromoResult? _lastResult;

  SupabaseClient get _sb => Supabase.instance.client;

  static const _kMinLen = 4;
  static const _kMaxLen = 32;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String raw) {
    final cleaned = raw.toUpperCase();
    if (cleaned != raw) {
      // Restaure la majuscule sans déplacer le curseur
      _controller.value = TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }
    setState(() {
      _lastResult = null;
    });
    _debounce?.cancel();
    if (cleaned.length < _kMinLen) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _validate();
    });
  }

  Future<void> _validate() async {
    final code = _controller.text.trim();
    if (code.length < _kMinLen) return;
    setState(() => _validating = true);
    try {
      final res = await _sb.functions.invoke(
        'cas_pratique_redeem_promo',
        body: {
          'code': code,
          if (widget.priceId != null) 'price_id': widget.priceId,
          'validate_only': true,
        },
      );
      final data = res.data;
      if (data is! Map) {
        setState(() => _lastResult = CpPromoResult(
              valid: false,
              code: code,
              reason: 'invalid_response',
            ));
        return;
      }
      final valid = data['valid'] == true;
      final disc = data['discount'] is Map
          ? Map<String, dynamic>.from(data['discount'] as Map)
          : null;
      setState(() {
        _lastResult = CpPromoResult(
          valid: valid,
          code: code,
          discountKind: disc?['kind']?.toString(),
          discountValue: (disc?['value'] as num?)?.toInt(),
          stripeCouponId: data['stripe_coupon_id']?.toString(),
          reason: data['reason']?.toString(),
        );
      });
    } catch (e) {
      setState(() => _lastResult = CpPromoResult(
            valid: false,
            code: code,
            reason: 'network_error',
          ));
    } finally {
      if (mounted) setState(() => _validating = false);
    }
  }

  Future<void> _apply() async {
    final code = _controller.text.trim();
    if (code.isEmpty || _lastResult?.valid != true) return;
    setState(() => _applying = true);
    try {
      final res = await _sb.functions.invoke(
        'cas_pratique_redeem_promo',
        body: {
          'code': code,
          if (widget.priceId != null) 'price_id': widget.priceId,
          'validate_only': false,
        },
      );
      final data = res.data;
      if (data is Map && data['valid'] == true) {
        final disc = data['discount'] is Map
            ? Map<String, dynamic>.from(data['discount'] as Map)
            : null;
        final result = CpPromoResult(
          valid: true,
          code: code,
          discountKind: disc?['kind']?.toString(),
          discountValue: (disc?['value'] as num?)?.toInt(),
          stripeCouponId: data['stripe_coupon_id']?.toString(),
          reason: 'applied',
        );
        if (!mounted) return;
        Navigator.of(context).pop(result);
      } else {
        final reason = data is Map ? data['reason']?.toString() : 'unknown';
        if (!mounted) return;
        setState(() => _lastResult = CpPromoResult(
              valid: false,
              code: code,
              reason: reason,
            ));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _lastResult = CpPromoResult(
            valid: false,
            code: code,
            reason: 'network_error',
          ));
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);
    final muted = ink.withValues(alpha: .65);
    final sheetBg = isDark ? const Color(0xFF111111) : Colors.white;

    final result = _lastResult;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ink.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1147D9).withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.local_offer_rounded,
                    color: Color(0xFF1147D9),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code promo',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: ink,
                        ),
                      ),
                      Text(
                        'Saisis ton code pour activer la réduction',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Champ de saisie ─────────────────────────────────────
            TextField(
              controller: _controller,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                LengthLimitingTextInputFormatter(_kMaxLen),
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
              ],
              onChanged: _onChanged,
              style: GoogleFonts.robotoMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ink,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'STUDENT50',
                hintStyle: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: muted.withValues(alpha: .5),
                  letterSpacing: 1.5,
                ),
                filled: true,
                fillColor: ink.withValues(alpha: .04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: _validating
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : result?.valid == true
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF22C55E),
                          )
                        : result?.valid == false
                            ? const Icon(
                                Icons.error_rounded,
                                color: Color(0xFFEF4444),
                              )
                            : null,
              ),
            ),

            // ── Feedback résultat ────────────────────────────────────
            if (result != null) ...[
              const SizedBox(height: 12),
              if (result.valid)
                _SuccessBanner(label: result.humanLabel, ink: ink)
              else
                _ErrorBanner(
                  message: result.errorMessage ?? 'Code invalide.',
                ),
            ],

            const SizedBox(height: 22),

            // ── CTA ─────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (result?.valid == true && !_applying)
                    ? _apply
                    : null,
                icon: _applying
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 18),
                label: Text(
                  _applying
                      ? 'Application…'
                      : 'Appliquer la réduction',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1147D9),
                  disabledBackgroundColor: ink.withValues(alpha: .12),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Bannières feedback
// ──────────────────────────────────────────────────────────────────────────

class _SuccessBanner extends StatelessWidget {
  final String label;
  final Color ink;
  const _SuccessBanner({required this.label, required this.ink});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withValues(alpha: .10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF22C55E).withValues(alpha: .4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.celebration_rounded,
            color: Color(0xFF22C55E),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Code valide — réduction $label',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: .35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
