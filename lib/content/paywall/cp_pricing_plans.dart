// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Widget de tarification (3 plans : mensuel / annuel / lifetime)  ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-086             ║
// ║                                                                           ║
// ║  Widget autonome qui présente les 3 plans avec :                          ║
// ║   • Mensuel : 9,99 €/mois + trial 7j gratuit (highlighted "Populaire")   ║
// ║   • Annuel  : 79 €/an (-33%, économise 40,88 €/an)                       ║
// ║   • Lifetime: 149 € one-shot (badge "Meilleur deal long terme")          ║
// ║                                                                           ║
// ║  Usage :                                                                  ║
// ║    CpPricingPlans(                                                        ║
// ║      onPlanSelected: (plan) => CpPayments.I.startCheckout(               ║
// ║        priceId: plan.stripePriceId,                                       ║
// ║      ),                                                                   ║
// ║    )                                                                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modèle d'un plan affichable.
class CpPricingPlan {
  final String id; // 'monthly' | 'yearly' | 'lifetime'
  final String label; // "Mensuel" / "Annuel" / "À vie"
  final String price; // "9,99 €"
  final String pricePeriod; // "/ mois" / "/ an" / ""
  final String? originalPrice; // "11,99 €" (pour affichage barré)
  final String? savingsBadge; // "ÉCONOMISE 33%"
  final String? extraBadge; // "POPULAIRE" / "MEILLEUR DEAL"
  final String? trialLabel; // "7 jours gratuits"
  final List<String> highlights; // ["Cas illimités", ...]
  final String stripePriceId; // pour appeler startCheckout
  final bool isHighlighted; // pour le visuel

  const CpPricingPlan({
    required this.id,
    required this.label,
    required this.price,
    required this.pricePeriod,
    this.originalPrice,
    this.savingsBadge,
    this.extraBadge,
    this.trialLabel,
    required this.highlights,
    required this.stripePriceId,
    this.isHighlighted = false,
  });
}

/// Liste par défaut des plans à présenter. Les IDs Stripe doivent
/// être passés via dart-define (`STRIPE_PRICE_MONTHLY`, etc.) au build.
class CpDefaultPricingPlans {
  CpDefaultPricingPlans._();

  static List<CpPricingPlan> all({
    String? monthlyPriceId,
    String? yearlyPriceId,
    String? lifetimePriceId,
  }) {
    return [
      CpPricingPlan(
        id: 'monthly',
        label: 'Mensuel',
        price: '9,99 €',
        pricePeriod: '/ mois',
        trialLabel: '7 jours gratuits',
        extraBadge: 'POPULAIRE',
        highlights: const [
          'Cas pratiques illimités',
          'Concours blancs inclus',
          'Sans engagement, annule à tout moment',
        ],
        stripePriceId: monthlyPriceId ??
            const String.fromEnvironment(
              'STRIPE_PRICE_MONTHLY',
              defaultValue: 'price_monthly_placeholder',
            ),
        isHighlighted: true,
      ),
      CpPricingPlan(
        id: 'yearly',
        label: 'Annuel',
        price: '79 €',
        pricePeriod: '/ an',
        originalPrice: '119,88 €',
        savingsBadge: 'ÉCONOMISE 33%',
        highlights: const [
          'Tout du Premium mensuel',
          '40,88 € économisés sur l\'année',
          'Idéal pour préparer son concours',
        ],
        stripePriceId: yearlyPriceId ??
            const String.fromEnvironment(
              'STRIPE_PRICE_YEARLY',
              defaultValue: 'price_yearly_placeholder',
            ),
      ),
      CpPricingPlan(
        id: 'lifetime',
        label: 'À vie',
        price: '149 €',
        pricePeriod: 'paiement unique',
        savingsBadge: 'MEILLEUR DEAL',
        highlights: const [
          'Accès Premium pour toujours',
          'Toutes les futures features incluses',
          'Sans renouvellement',
        ],
        stripePriceId: lifetimePriceId ??
            const String.fromEnvironment(
              'STRIPE_PRICE_LIFETIME',
              defaultValue: 'price_lifetime_placeholder',
            ),
      ),
    ];
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Widget principal
// ──────────────────────────────────────────────────────────────────────────

class CpPricingPlans extends StatefulWidget {
  const CpPricingPlans({
    super.key,
    this.plans,
    required this.onPlanSelected,
    this.initialSelectedId = 'monthly',
  });

  final List<CpPricingPlan>? plans;
  final ValueChanged<CpPricingPlan> onPlanSelected;
  final String initialSelectedId;

  @override
  State<CpPricingPlans> createState() => _CpPricingPlansState();
}

class _CpPricingPlansState extends State<CpPricingPlans> {
  late String _selectedId;
  late List<CpPricingPlan> _plans;

  @override
  void initState() {
    super.initState();
    _plans = widget.plans ?? CpDefaultPricingPlans.all();
    _selectedId = widget.initialSelectedId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);
    final muted = ink.withValues(alpha: .65);
    final cardBg = isDark ? const Color(0xFF111111) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .06);

    final selectedPlan = _plans.firstWhere(
      (p) => p.id == _selectedId,
      orElse: () => _plans.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Liste des plans (radio cards) ──────────────────────────────
        for (final plan in _plans)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PlanRadioCard(
              plan: plan,
              selected: plan.id == _selectedId,
              onTap: () => setState(() => _selectedId = plan.id),
              ink: ink,
              muted: muted,
              cardBg: cardBg,
              borderColor: borderColor,
            ),
          ),

        const SizedBox(height: 8),

        // ── CTA d'achat dynamique ─────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => widget.onPlanSelected(selectedPlan),
            icon: const Icon(Icons.bolt_rounded, size: 22),
            label: Text(
              selectedPlan.trialLabel != null
                  ? 'Démarrer ${selectedPlan.trialLabel!.toLowerCase()}'
                  : 'Continuer avec ${selectedPlan.label.toLowerCase()}',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1147D9),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            selectedPlan.trialLabel != null
                ? 'Annule avant la fin de l\'essai, rien à payer'
                : selectedPlan.id == 'lifetime'
                    ? 'Paiement unique, accès à vie'
                    : 'Sans engagement, annule quand tu veux',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: muted,
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Carte plan (radio style)
// ──────────────────────────────────────────────────────────────────────────

class _PlanRadioCard extends StatelessWidget {
  final CpPricingPlan plan;
  final bool selected;
  final VoidCallback onTap;
  final Color ink;
  final Color muted;
  final Color cardBg;
  final Color borderColor;

  const _PlanRadioCard({
    required this.plan,
    required this.selected,
    required this.onTap,
    required this.ink,
    required this.muted,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1147D9);
    const gold = Color(0xFFFFC700);
    final activeBorder = plan.isHighlighted ? gold : accent;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? activeBorder : borderColor,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            color: selected ? activeBorder.withValues(alpha: .05) : cardBg,
          ),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? activeBorder : muted.withValues(alpha: .4),
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeBorder,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Label + détails
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.label,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        if (plan.extraBadge != null) ...[
                          const SizedBox(width: 6),
                          _badge(plan.extraBadge!, gold,
                              const Color(0xFF000B36)),
                        ],
                        if (plan.savingsBadge != null) ...[
                          const SizedBox(width: 6),
                          _badge(
                            plan.savingsBadge!,
                            const Color(0xFF22C55E),
                            Colors.white,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          plan.price,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ink,
                            letterSpacing: -.3,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            plan.pricePeriod,
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: muted,
                            ),
                          ),
                        ),
                        if (plan.originalPrice != null) ...[
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              plan.originalPrice!,
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: muted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (plan.trialLabel != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.celebration_rounded,
                            color: Color(0xFFFFC700),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            plan.trialLabel!,
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFC700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: .8,
        ),
      ),
    );
  }
}
