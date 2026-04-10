// lib/home/journal_pa_school.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalPaSchoolPage extends StatelessWidget {
  const JournalPaSchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Text(
          'Journal — Policier Adjoint',
          style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Text(
          'Vos contenus récents et recommandations (PA).',
          style: t.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: t.bodySmall?.color?.withOpacity(.7),
            fontFamily: GoogleFonts.instrumentSans().fontFamily,
          ),
        ),
        const SizedBox(height: 16),

        // Cartes exemple (pointez vos vraies routes PA)
        _JournalCard(
          title: 'Cadres juridiques (PA)',
          route: '/pa_scolarité_pages/cadres_juridiques',
          badge: 'Cadres d’enquête',
          onOpen: () => Navigator.of(
            context,
          ).pushNamed('/pa_scolarité_pages/cadres_juridiques'),
        ),
        const SizedBox(height: 12),
        _JournalCard(
          title: 'Procédure pénale (PA) — GAV',
          route: '/pa_scolarité_pages/procedure_penale/pp_gav',
          badge: 'Cours & cas',
          onOpen: () => Navigator.of(
            context,
          ).pushNamed('/pa_scolarité_pages/procedure_penale/pp_gav'),
        ),
      ],
    );
  }
}

class _JournalCard extends StatelessWidget {
  final String title;
  final String route;
  final String badge;
  final VoidCallback onOpen;

  const _JournalCard({
    required this.title,
    required this.route,
    required this.badge,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onOpen,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF2E3137),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.school_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3137),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.instrumentSans(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
