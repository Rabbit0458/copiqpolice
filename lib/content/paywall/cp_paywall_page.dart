// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page Paywall (tier free → premium)               ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-084             ║
// ║                                                                           ║
// ║  Affiche le comparatif Free vs Premium + CTA d'abonnement.                ║
// ║                                                                           ║
// ║  Déclenchement (à câbler par les callers) :                              ║
// ║   • Tap sur un 2e cas pratique (quota free dépassé)                       ║
// ║   • Tap sur Concours blanc / Leaderboard / Export PDF (premium only)     ║
// ║   • Bouton "Passer Premium" dans Profil                                  ║
// ║                                                                           ║
// ║  Route : CpPaywallPage.routeName = '/cas-pratique/paywall'                ║
// ║  Arguments (Map) : {'trigger': 'second_case' | 'concours_blanc' | ...}    ║
// ║                                                                           ║
// ║  L'achat réel (Stripe / RevenueCat) est implémenté en CODE-085.          ║
// ║  Ici on affiche la maquette + on log l'event PostHog `paywall_viewed`.   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CpPaywallPage extends StatelessWidget {
  const CpPaywallPage({super.key, this.trigger});

  /// Contexte qui a déclenché l'ouverture du paywall.
  /// Utilisé pour personnaliser le titre/argumentaire.
  final String? trigger;

  static const String routeName = '/cas-pratique/paywall';

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

    final heroData = _heroForTrigger(trigger);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Bouton fermer ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.close_rounded, color: muted, size: 24),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            ),

            // ── Hero ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: _Hero(
                  badge: heroData.badge,
                  title: heroData.title,
                  subtitle: heroData.subtitle,
                  ink: ink,
                  muted: muted,
                ),
              ),
            ),

            // ── Plans ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: _PlansComparator(
                  ink: ink,
                  muted: muted,
                  cardBg: cardBg,
                  borderColor: borderColor,
                ),
              ),
            ),

            // ── Liste des features ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  'Tout ce qui débloque avec Premium',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: ink,
                    letterSpacing: -.2,
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  if (i >= _features.length) return null;
                  final f = _features[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: _FeatureRow(
                      icon: f.$1,
                      title: f.$2,
                      subtitle: f.$3,
                      ink: ink,
                      muted: muted,
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                  );
                },
                childCount: _features.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
              ),
            ),

            // ── CTA principal ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: _CtaSection(
                  ink: ink,
                  muted: muted,
                  onSubscribe: () => _onSubscribeTapped(context),
                ),
              ),
            ),

            // ── Liens légaux ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: _LegalFooter(muted: muted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action d'achat ──────────────────────────────────────────────────────
  void _onSubscribeTapped(BuildContext context) {
    // L'intégration Stripe / RevenueCat est en CODE-085.
    // Ici on affiche une modal informative.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final isDark = theme.brightness == Brightness.dark;
        final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111111) : Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ink.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 18),
              const Icon(Icons.lock_open_rounded,
                  color: Color(0xFFFFC700), size: 48),
              const SizedBox(height: 12),
              Text(
                'Bientôt disponible',
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: ink),
              ),
              const SizedBox(height: 6),
              Text(
                'Le module de paiement Stripe / RevenueCat est en cours\n'
                'd\'intégration (CODE-085). Reste connecté.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ink.withValues(alpha: .7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1147D9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Compris',
                    style: GoogleFonts.montserrat(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Hero personnalisé selon le trigger ──────────────────────────────────
  ({String badge, String title, String subtitle}) _heroForTrigger(
      String? trigger) {
    switch (trigger) {
      case 'second_case':
        return (
          badge: 'QUOTA ATTEINT',
          title: 'Continue sans limites',
          subtitle:
              'Tu as exploité ton cas démo gratuit de la semaine. '
                  'Passe Premium pour accéder à TOUS les cas pratiques.',
        );
      case 'concours_blanc':
        return (
          badge: 'CONCOURS BLANC',
          title: 'Passe en conditions réelles',
          subtitle:
              'Les simulations chronométrées sont réservées aux membres '
                  'Premium. Mets-toi en situation d\'examen dès aujourd\'hui.',
        );
      case 'pdf_export':
        return (
          badge: 'EXPORT PDF',
          title: 'Exporte ta copie corrigée',
          subtitle:
              'Reçois ta copie corrigée en PDF prêt à imprimer. '
                  'Disponible avec Premium.',
        );
      case 'leaderboard':
        return (
          badge: 'CLASSEMENT',
          title: 'Vois où tu te places',
          subtitle:
              'Compare-toi anonymement aux autres candidats. '
                  'Premium débloque le leaderboard hebdo.',
        );
      default:
        return (
          badge: 'COP\'IQ PREMIUM',
          title: 'Le concours, niveau supérieur',
          subtitle:
              'Accès illimité aux cas pratiques, concours blancs, export '
                  'PDF, classement, et tout l\'arsenal premium.',
        );
    }
  }

  // ── Catalogue des features Premium ─────────────────────────────────────
  static const List<(IconData, String, String)> _features = [
    (
      Icons.all_inclusive_rounded,
      'Cas pratiques illimités',
      'Accède à TOUS les cas, sans quota hebdomadaire'
    ),
    (
      Icons.timer_rounded,
      'Concours blancs',
      'Simulations chronométrées en conditions réelles'
    ),
    (
      Icons.picture_as_pdf_rounded,
      'Export PDF',
      'Télécharge ta copie corrigée pour relire hors-ligne'
    ),
    (
      Icons.leaderboard_rounded,
      'Leaderboard hebdo',
      'Classement anonymisé pour mesurer ta progression'
    ),
    (
      Icons.menu_book_rounded,
      'Annales complètes',
      'Tous les sujets et corrigés des concours passés'
    ),
    (
      Icons.psychology_rounded,
      'Recommandations IA',
      'Suggestions ciblées sur tes points faibles'
    ),
    (
      Icons.flash_on_rounded,
      'Correction temps réel',
      'Edge function dédiée — résultats instantanés'
    ),
    (
      Icons.support_agent_rounded,
      'Support prioritaire',
      'Réponse sous 24h aux appels et questions'
    ),
  ];
}

// ──────────────────────────────────────────────────────────────────────────
//  Hero
// ──────────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;
  final Color ink;
  final Color muted;
  const _Hero({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.ink,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF000B36), Color(0xFF1147D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC700),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF000B36),
                letterSpacing: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -.5,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: .88),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Comparator
// ──────────────────────────────────────────────────────────────────────────

class _PlansComparator extends StatelessWidget {
  final Color ink;
  final Color muted;
  final Color cardBg;
  final Color borderColor;
  const _PlansComparator({
    required this.ink,
    required this.muted,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PlanCard(
            title: 'Free',
            price: '0 €',
            priceSub: 'pour toujours',
            features: const [
              '1 cas démo par semaine',
              'Quiz culture G limités',
              'Pas de correction PDF',
              'Pas de concours blanc',
              'Pas de leaderboard',
            ],
            highlighted: false,
            ink: ink,
            muted: muted,
            cardBg: cardBg,
            borderColor: borderColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PlanCard(
            title: 'Premium',
            price: '9,99 €',
            priceSub: 'par mois',
            features: const [
              'Cas pratiques illimités',
              'Concours blancs inclus',
              'Export PDF',
              'Leaderboard hebdo',
              'Support prioritaire',
            ],
            highlighted: true,
            ink: ink,
            muted: muted,
            cardBg: cardBg,
            borderColor: borderColor,
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String priceSub;
  final List<String> features;
  final bool highlighted;
  final Color ink;
  final Color muted;
  final Color cardBg;
  final Color borderColor;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.priceSub,
    required this.features,
    required this.highlighted,
    required this.ink,
    required this.muted,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFFC700);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? accent : borderColor,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              if (highlighted) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'POPULAIRE',
                    style: GoogleFonts.montserrat(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF000B36),
                      letterSpacing: .8,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: ink,
                    letterSpacing: -.4,
                  ),
                ),
                TextSpan(
                  text: ' / $priceSub',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    highlighted
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: highlighted ? accent : muted,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.montserrat(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: highlighted ? ink : muted,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Feature row
// ──────────────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color ink;
  final Color muted;
  final Color cardBg;
  final Color borderColor;
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.ink,
    required this.muted,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1147D9).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1147D9), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  CTA + footer légal
// ──────────────────────────────────────────────────────────────────────────

class _CtaSection extends StatelessWidget {
  final Color ink;
  final Color muted;
  final VoidCallback onSubscribe;
  const _CtaSection({
    required this.ink,
    required this.muted,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onSubscribe,
            icon: const Icon(Icons.bolt_rounded, size: 22),
            label: Text(
              'Passer Premium pour 9,99 € / mois',
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
        Text(
          'Sans engagement · Annule quand tu veux',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: muted,
          ),
        ),
      ],
    );
  }
}

class _LegalFooter extends StatelessWidget {
  final Color muted;
  const _LegalFooter({required this.muted});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 6,
      children: [
        _link('Restaurer mes achats', muted, () {}),
        _dot(muted),
        _link('CGV', muted, () {}),
        _dot(muted),
        _link('Politique de confidentialité', muted, () {}),
      ],
    );
  }

  Widget _link(String label, Color muted, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: muted,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _dot(Color muted) => Text(
        '·',
        style: GoogleFonts.montserrat(
          fontSize: 11,
          color: muted,
        ),
      );
}
