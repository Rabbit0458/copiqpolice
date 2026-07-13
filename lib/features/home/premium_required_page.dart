// lib/features/home/premium_required_page.dart
// =============================================================================
//  COP'IQ — Page de blocage contenu premium
//  Affichée quand un utilisateur free tente d'ouvrir un module/cours/quiz.
//  Design cohérent avec l'app, thème light/dark synchronisé.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumRequiredPage extends StatelessWidget {
  const PremiumRequiredPage({super.key});

  static const String routeName = '/premium-required';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0B0D0F) : const Color(0xFFF5F6F8);
    final surface = isDark ? const Color(0xFF13171C) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F1114);
    final textMuted = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.55);
    final accentGold = isDark ? const Color(0xFFFFD166) : const Color(0xFFD4A017);
    final accentBlue = isDark ? const Color(0xFF4D9FFF) : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar minimaliste ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: textPrimary,
                      size: 20,
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).maybePop();
                    },
                  ),
                ],
              ),
            ),

            // ── Contenu principal ─────────────────────────────
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône lock stylisée
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: accentGold.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentGold.withValues(alpha: 0.30),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          size: 42,
                          color: accentGold,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Badge "Premium"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
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
                          'COP\'IQ Premium',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: accentBlue,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Titre
                      Text(
                        'Contenu réservé aux abonnés',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                          height: 1.15,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        'Ce contenu est réservé aux abonnés COP\'IQ Premium.\n'
                        'Passe à l\'abonnement pour accéder aux cours, fiches de révision, quiz et modules complets.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textMuted,
                          height: 1.55,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Carte avantages
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.06),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _Avantage(
                              icon: Icons.menu_book_rounded,
                              label: 'Cours complets structurés',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            _Avantage(
                              icon: Icons.sticky_note_2_rounded,
                              label: 'Fiches de révision',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            _Avantage(
                              icon: Icons.quiz_rounded,
                              label: 'Quiz et entraînements illimités',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            _Avantage(
                              icon: Icons.layers_rounded,
                              label: 'Tous les modules GPX & PA',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // CTA principal
                      _PremiumCTA(
                        isDark: isDark,
                        accentBlue: accentBlue,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pushNamed('/abonnement');
                        },
                      ),

                      const SizedBox(height: 12),

                      // Bouton retour secondaire
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).maybePop();
                          },
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
                            'Retour',
                            style: GoogleFonts.instrumentSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: textMuted,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
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

// ─── Widget avantage ───────────────────────────────────────────────────────
class _Avantage extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _Avantage({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? const Color(0xFF4D9FFF) : const Color(0xFF1565C0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F1114);

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: accent.withValues(alpha: 0.7),
        ),
      ],
    );
  }
}

// ─── CTA principal animé ──────────────────────────────────────────────────
class _PremiumCTA extends StatefulWidget {
  final bool isDark;
  final Color accentBlue;
  final VoidCallback onTap;

  const _PremiumCTA({
    required this.isDark,
    required this.accentBlue,
    required this.onTap,
  });

  @override
  State<_PremiumCTA> createState() => _PremiumCTAState();
}

class _PremiumCTAState extends State<_PremiumCTA> {
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Voir les abonnements',
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
