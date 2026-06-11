// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Page CONCOURS BLANC                                             ║
// ║                                                                           ║
// ║  Bouton central de la bottom bar du module GPX EXAM.                      ║
// ║  Action : lancer une simulation officielle chronométrée du concours       ║
// ║  Gardien de la Paix dans les conditions réelles d'examen.                 ║
// ║                                                                           ║
// ║  Cette version est un SQUELETTE premium prêt à être branché.              ║
// ║  Le contenu fonctionnel (sélection d'épreuve, chronomètre, copie, etc.)  ║
// ║  sera codé dans une étape ultérieure.                                     ║
// ║                                                                           ║
// ║  Route : ConcoursBlancPage.routeName = '/home-gpx-exam/concours-blanc'    ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConcoursBlancPage extends StatelessWidget {
  const ConcoursBlancPage({super.key});

  static const String routeName = '/home-gpx-exam/concours-blanc';

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF000B36), Color(0xFF1147D9)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.timer_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Concours blanc',
                                style: GoogleFonts.montserrat(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: ink,
                                  letterSpacing: -.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Simule l\'épreuve dans les conditions réelles',
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
                  ],
                ),
              ),
            ),

            // ── Hero — invitation au lancement ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF000B36), Color(0xFF1147D9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFFFC700),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'PROCHAIN CONCOURS BLANC',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFC700),
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Lance ta simulation',
                        style: GoogleFonts.montserrat(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '3h chrono · 5 épreuves au choix · correction automatique avec score officiel',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: .85),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            _showComingSoonSheet(context);
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 22),
                          label: Text(
                            'Commencer une épreuve',
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC700),
                            foregroundColor: const Color(0xFF000B36),
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
              ),
            ),

            // ── Section : Modes disponibles (placeholders) ────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Text(
                  'Choisis ton épreuve',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  const epreuves = _comingEpreuves;
                  if (i >= epreuves.length) return null;
                  final e = epreuves[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _EpreuveCard(
                      title: e.$1,
                      durationLabel: e.$2,
                      pointsLabel: e.$3,
                      icon: e.$4,
                      cardBg: cardBg,
                      ink: ink,
                      muted: muted,
                      borderColor: borderColor,
                      onTap: () => _showComingSoonSheet(context),
                    ),
                  );
                },
                childCount: _comingEpreuves.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // ── Modal "à venir" ─────────────────────────────────────────────────────
  void _showComingSoonSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
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
            const Icon(
              Icons.construction_rounded,
              color: Color(0xFF1147D9),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Bientôt disponible',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Le module concours blanc est en cours de développement.\nReste connecté pour la mise en ligne.',
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Compris',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Données placeholder pour les épreuves ────────────────────────────────
  static const List<(String, String, String, IconData)> _comingEpreuves = [
    (
      'Cas pratique',
      '45 min',
      '/ 20 pts',
      Icons.assignment_rounded,
    ),
    (
      'Culture générale',
      '30 min',
      '/ 15 pts',
      Icons.public_rounded,
    ),
    (
      'Français — synthèse',
      '60 min',
      '/ 20 pts',
      Icons.menu_book_rounded,
    ),
    (
      'QCM connaissances',
      '20 min',
      '/ 30 pts',
      Icons.quiz_rounded,
    ),
    (
      'Épreuve complète (3h)',
      '180 min',
      '/ 100 pts',
      Icons.timelapse_rounded,
    ),
  ];
}

// ──────────────────────────────────────────────────────────────────────────
//  Carte épreuve (placeholder)
// ──────────────────────────────────────────────────────────────────────────

class _EpreuveCard extends StatelessWidget {
  final String title;
  final String durationLabel;
  final String pointsLabel;
  final IconData icon;
  final Color cardBg;
  final Color ink;
  final Color muted;
  final Color borderColor;
  final VoidCallback onTap;

  const _EpreuveCard({
    required this.title,
    required this.durationLabel,
    required this.pointsLabel,
    required this.icon,
    required this.cardBg,
    required this.ink,
    required this.muted,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1147D9).withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF1147D9), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$durationLabel  ·  $pointsLabel',
                      style: GoogleFonts.montserrat(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: muted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
