import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/features/home/journal_gpx_school_courses_page.dart';

class _T {
  static const Color ink = Color(0xFF212529);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .10),
    blurRadius: 24,
    offset: const Offset(0, 14),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

/// Route attendue: '/journal/gpx_school'
class JournalGpxSchoolPage extends StatefulWidget {
  const JournalGpxSchoolPage({super.key});

  @override
  State<JournalGpxSchoolPage> createState() => _JournalGpxSchoolPageState();
}

class _JournalGpxSchoolPageState extends State<JournalGpxSchoolPage> {
  int? _selected; // 0 = cours, 1 = quiz

  void _openCours() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const JournalGpxSchoolCoursesPage()),
    );
  }

  void _openQuiz() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz : on le configurera ultérieurement ✅'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            Text(
              'Journal — GPX Scolarité',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : _T.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choisis ce que tu veux faire maintenant.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _muted(context, .82),
              ),
            ),
            const SizedBox(height: 20),

            _ChoiceHeroCard(
              image: 'assets/images/procedure_penale.jpg',
              title: 'Cours',
              subtitle: 'Accède à toutes les fiches et chapitres',
              selected: _selected == 0,
              onTap: () {
                setState(() => _selected = 0);
                _openCours();
              },
            ),
            const SizedBox(height: 16),

            _ChoiceHeroCard(
              image: 'assets/images/exam.jpeg',
              title: 'Quiz',
              subtitle: 'Entraîne-toi (à brancher ensuite)',
              selected: _selected == 1,
              disabled: true,
              onTap: () {
                setState(() => _selected = 1);
                _openQuiz();
              },
            ),

            const SizedBox(height: 22),
            Center(
              child: Text(
                'Tu peux revenir ici quand tu veux.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _muted(context, .7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Carte héro (image + blur + spotlight + bouton) ---
class _ChoiceHeroCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _ChoiceHeroCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget img;
    try {
      img = Image.asset(image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.black.withValues(alpha: .06));
    }

    final borderColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0).withValues(alpha: .9);

    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: disabled ? 0.70 : (selected ? 1 : 0.96),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 235,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [_T.shadow],
              border: selected
                  ? Border.all(color: borderColor, width: 2)
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // IMG
                Positioned.fill(child: img),

                // BLUR + OVERLAY
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(color: Colors.black.withValues(alpha: 0.30)),
                  ),
                ),

                // SPOTLIGHT
                Center(
                  child: Container(
                    width: 280,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.70,
                        colors: [
                          Colors.white.withValues(alpha: .34),
                          Colors.white.withValues(alpha: .12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // TITRE + SOUS-TITRE
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            letterSpacing: .3,
                            height: 1.05,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 8,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white.withValues(alpha: .92),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            height: 1.2,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 6,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BOUTON
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(
                    onTap: onTap,
                    label: disabled ? 'Bientôt' : 'Découvrir',
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

class _DiscoverButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const _DiscoverButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _T.ink.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_forward_rounded, size: 18, color: _T.ink),
            ),
          ],
        ),
      ),
    );
  }
}
