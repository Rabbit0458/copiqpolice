// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Onboarding 4 écrans premium                   ║
// ║  Tâche      : CODE-063                                                  ║
// ║                                                                         ║
// ║  PageView 4 écrans avec animations premium (gradient shift, glow,      ║
// ║  fade-in séquencé, scale). Skip top-right. Progress dots animés.       ║
// ║  CTA évolutif (Suivant → Suivant → Suivant → Démarrer).                 ║
// ║                                                                         ║
// ║  À la fin :                                                              ║
// ║   - markCompleted() côté CasPratiqueOnboardingService                    ║
// ║   - Navigator.popAndPushNamed(callerRoute) → la home ou la liste        ║
// ║                                                                         ║
// ║  Route : `/gpx_exam/concours/cas_pratique/onboarding_premium`           ║
// ║                                                                         ║
// ║  Argument optionnel `nextRoute` (String) : route à pousser après        ║
// ║  finalisation. Défaut = `/gpx_exam/concours/cas_pratique/list`.         ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/content/gpx_exam/cas_pratique/cas_pratique_list_confiug.dart';
import 'package:copiqpolice/core/cas_pratique/onboarding/onboarding_service.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

class CasPratiqueOnboardingPremiumPage extends StatefulWidget {
  const CasPratiqueOnboardingPremiumPage({super.key, this.nextRoute});

  static const String routeName =
      '/gpx_exam/concours/cas_pratique/onboarding_premium';

  /// Route à pousser après finalisation. Défaut = liste des cas.
  final String? nextRoute;

  @override
  State<CasPratiqueOnboardingPremiumPage> createState() =>
      _CasPratiqueOnboardingPremiumPageState();
}

class _OnboardingSlide {
  final String tag;
  final IconData icon;
  final Color accent;
  final String title;
  final String message;

  const _OnboardingSlide({
    required this.tag,
    required this.icon,
    required this.accent,
    required this.title,
    required this.message,
  });
}

class _CasPratiqueOnboardingPremiumPageState
    extends State<CasPratiqueOnboardingPremiumPage>
    with TickerProviderStateMixin {
  final PageController _pc = PageController();
  int _index = 0;
  bool _finishing = false;

  late final AnimationController _glowCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      tag: 'BIENVENUE',
      icon: Icons.waving_hand_rounded,
      accent: Color(0xFF1147D9),
      title: 'Bienvenue dans Cas Pratique',
      message:
          'Le mode d\'entraînement de référence pour le concours de gardien '
          'de la paix. Tout y est conçu pour reproduire l\'épreuve réelle.',
    ),
    _OnboardingSlide(
      tag: 'CAS RÉELS',
      icon: Icons.menu_book_rounded,
      accent: Color(0xFFF59E0B),
      title: 'Des cas réels d\'annales',
      message:
          'Chaque cas vient des annales officielles GPX. Tu travailles sur '
          'des situations que tu rencontreras le jour J.',
    ),
    _OnboardingSlide(
      tag: 'CORRECTION',
      icon: Icons.psychology_rounded,
      accent: Color(0xFFA855F7),
      title: 'Une correction expliquée',
      message:
          'À la fin de chaque cas, ton score est ventilé point par point '
          'avec une réponse modèle et les références légales.',
    ),
    _OnboardingSlide(
      tag: 'GO',
      icon: Icons.rocket_launch_rounded,
      accent: Color(0xFF22C55E),
      title: "Commence par un cas gratuit",
      message:
          'Le premier cas est offert pour que tu te fasses une vraie idée. '
          'Lance-toi maintenant — tu peux abandonner et reprendre à tout moment.',
    ),
  ];

  @override
  void dispose() {
    _glowCtrl.dispose();
    _pc.dispose();
    super.dispose();
  }

  bool get _isLast => _index >= _slides.length - 1;

  void _goNext() {
    HapticFeedback.selectionClick();
    if (_isLast) {
      _finish();
      return;
    }
    _pc.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    HapticFeedback.selectionClick();
    _finish();
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    HapticFeedback.mediumImpact();
    await CasPratiqueOnboardingService.instance.markCompleted();
    if (!mounted) return;
    final next = widget.nextRoute ?? GpxCasPratiqueListPage.routeName;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_index];

    return Scaffold(
      backgroundColor: CpTokens.darkNavy,
      body: Stack(
        children: [
          // Background gradient qui change selon le slide
          _AnimatedAccentBackground(accent: slide.accent),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  current: _index,
                  total: _slides.length,
                  onSkip: _skip,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pc,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _slides.length,
                    onPageChanged: (i) {
                      setState(() => _index = i);
                      HapticFeedback.selectionClick();
                    },
                    itemBuilder: (_, i) => _SlideView(
                      slide: _slides[i],
                      glow: _glowCtrl,
                      isActive: i == _index,
                    ),
                  ),
                ),
                _BottomBar(
                  isLast: _isLast,
                  finishing: _finishing,
                  onNext: _goNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Animated background (gradient cross-fade par accent)
// ═══════════════════════════════════════════════════════════════════════════

class _AnimatedAccentBackground extends StatelessWidget {
  const _AnimatedAccentBackground({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(CpTokens.darkNavy, accent, 0.25) ?? CpTokens.darkNavy,
            CpTokens.darkNavy,
            CpTokens.darkNavyDeep,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.4),
                    radius: 1.2,
                    colors: [
                      accent.withValues(alpha: 0.20),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Top bar (progress dots + skip)
// ═══════════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.current,
    required this.total,
    required this.onSkip,
  });

  final int current;
  final int total;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 14, 4),
      child: Row(
        children: [
          // Dots
          for (int i = 0; i < total; i++) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              width: i == current ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == current
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Spacer(),
          if (current < total - 1)
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.78),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8,
                ),
              ),
              child: Text(
                'Passer',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                  letterSpacing: -0.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Slide view (icône glow + tag + title + message)
// ═══════════════════════════════════════════════════════════════════════════

class _SlideView extends StatelessWidget {
  const _SlideView({
    required this.slide,
    required this.glow,
    required this.isActive,
  });

  final _OnboardingSlide slide;
  final AnimationController glow;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing icon
          AnimatedBuilder(
            animation: glow,
            builder: (_, __) {
              final t = glow.value;
              return Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: slide.accent.withValues(alpha: 0.20),
                  border: Border.all(
                    color: slide.accent.withValues(alpha: 0.45 + 0.15 * t),
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: slide.accent.withValues(alpha: 0.30 + 0.20 * t),
                      blurRadius: 38 + 12 * t,
                      spreadRadius: 4 + 2 * t,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(slide.icon, color: Colors.white, size: 78),
              );
            },
          ),
          const SizedBox(height: 32),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey(slide.tag),
              padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 5,
              ),
              decoration: BoxDecoration(
                color: slide.accent.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: slide.accent.withValues(alpha: 0.55)),
              ),
              child: Text(
                slide.tag,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 360),
            child: Text(
              slide.title,
              key: ValueKey('${slide.tag}.title'),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 26,
                height: 1.18,
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            child: Text(
              slide.message,
              key: ValueKey('${slide.tag}.msg'),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Bottom bar (CTA)
// ═══════════════════════════════════════════════════════════════════════════

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isLast,
    required this.finishing,
    required this.onNext,
  });

  final bool isLast;
  final bool finishing;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 26),
      child: SizedBox(
        height: 58,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: finishing ? null : onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: CpTokens.darkNavy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CpTokens.r3),
            ),
            elevation: 0,
          ),
          child: finishing
              ? const SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation(CpTokens.darkNavy),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Démarrer maintenant' : 'Suivant',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLast
                          ? Icons.rocket_launch_rounded
                          : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
