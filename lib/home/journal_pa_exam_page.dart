import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ HapticFeedback
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/services/subscription_service.dart'; // ✅ lock logique

class _T {
  static const Color ink = Color(0xFF212529);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withOpacity(.10),
    blurRadius: 24,
    offset: const Offset(0, 14),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withOpacity(a);
}

class JournalGpxExamPage extends StatefulWidget {
  const JournalGpxExamPage({
    super.key,
    this.onTabChange, // ✅ permet de changer d'onglet depuis la page
  });

  final ValueChanged<int>? onTabChange;

  @override
  State<JournalGpxExamPage> createState() => _JournalGpxExamPageState();
}

class _JournalGpxExamPageState extends State<JournalGpxExamPage> {
  int? _selected; // 0 = structure, 1 = entrainement

  Future<void> _goLockedOrOpen(String route) async {
    HapticFeedback.selectionClick();

    // ✅ même logique "pro" : FREE => tout lock => direction Premium
    final locked = SubscriptionService.instance.state.value.isLocked;
    if (locked) {
      if (!mounted) return;
      Navigator.of(context).pushNamed('/abonnement');
      return;
    }

    // ✅ sinon garde-fou global
    final ok = await SubscriptionService.instance.guardAppAccess(context);
    if (!ok) return;

    if (!mounted) return;
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ PAS DE Scaffold ici (la Home fournit déjà le Scaffold + bottom bar)
    return ValueListenableBuilder<SubscriptionState>(
      valueListenable: SubscriptionService.instance.state,
      builder: (context, s, _) {
        final locked = s.isLocked;

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Journal — GPX Concours',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : _T.ink,
                      ),
                    ),
                  ),

                  // ✅ accès rapide aux onglets via la bottom bar
                  if (widget.onTabChange != null)
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Accueil',
                          onPressed: () => widget.onTabChange!(0),
                          icon: const Icon(Icons.home_rounded),
                        ),
                        IconButton(
                          tooltip: 'Forum',
                          onPressed: () => widget.onTabChange!(2),
                          icon: const Icon(Icons.qr_code_rounded),
                        ),
                        IconButton(
                          tooltip: 'Favoris',
                          onPressed: () => widget.onTabChange!(3),
                          icon: const Icon(Icons.favorite_rounded),
                        ),
                        IconButton(
                          tooltip: 'Profil',
                          onPressed: () => widget.onTabChange!(4),
                          icon: const Icon(Icons.person_rounded),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Choisis ce que tu veux bosser maintenant.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _muted(context, .82),
                ),
              ),
              const SizedBox(height: 20),

              _ChoiceHeroCard(
                image: 'assets/images/concours_pa_epreuves.jpeg',
                title: 'Structure du concours',
                subtitle: 'Organisation, admissibilité, admission, sport',
                selected: _selected == 0,
                disabled: locked, // ✅ lock carte (free)
                onTap: () async {
                  setState(() => _selected = 0);
                  await _goLockedOrOpen('/gpx_exam/concours/epreuves_gpx');
                },
              ),
              const SizedBox(height: 16),

              _ChoiceHeroCard(
                image: 'assets/images/concours_connaissances_generales.jpeg',
                title: 'S’entraîner',
                subtitle: 'Culture générale, langue, psycho, cas pratique',
                selected: _selected == 1,
                disabled: locked, // ✅ lock carte (free)
                onTap: () async {
                  setState(() => _selected = 1);
                  await _goLockedOrOpen('/gpx_exam/concours/culture_generale');
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
        );
      },
    );
  }
}

/// --- Carte héro (image + blur + spotlight + bouton) ---
/// ✅ inchangée visuellement, on ajoute juste un lock Premium propre
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
      img = Container(color: Colors.black.withOpacity(.06));
    }

    final borderColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0).withOpacity(.9);

    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: disabled ? 0.86 : (selected ? 1 : 0.96),
        child: GestureDetector(
          onTap: onTap, // ✅ même en disabled : ouvre /abonnement via parent
          child: Container(
            height: 235,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [_T.shadow], // ✅ pas const (getter)
              border: selected
                  ? Border.all(color: borderColor, width: 2)
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: img),

                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      color: Colors.black.withOpacity(disabled ? 0.44 : 0.30),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    width: 280,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.70,
                        colors: [
                          Colors.white.withOpacity(.34),
                          Colors.white.withOpacity(.12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // ✅ badge Premium si lock
                if (disabled)
                  const Positioned(top: 12, right: 12, child: _PremiumBadge()),

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
                            color: Colors.white.withOpacity(.92),
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

                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(
                    onTap: onTap,
                    label: disabled ? 'Débloquer' : 'Découvrir',
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
          color: _T.ink.withOpacity(.92),
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

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 10),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'Premium',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }
}
