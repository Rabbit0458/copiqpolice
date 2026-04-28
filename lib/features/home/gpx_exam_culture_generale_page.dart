import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

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

class _CultureItem {
  final String title;
  final String route;
  final String image;
  final String subtitle;

  const _CultureItem({
    required this.title,
    required this.route,
    required this.image,
    required this.subtitle,
  });
}

/// Route attendue: '/gpx_exam/concours/culture_generale'
class GpxExamCultureGeneralePage extends StatefulWidget {
  const GpxExamCultureGeneralePage({super.key});

  static const routeName = '/gpx_exam/concours/culture_generale';

  @override
  State<GpxExamCultureGeneralePage> createState() =>
      _GpxExamCultureGeneralePageState();
}

class _GpxExamCultureGeneralePageState
    extends State<GpxExamCultureGeneralePage> {
  int? _selected;

  void _go(String route) => Navigator.of(context).pushNamed(route);

  late final List<_CultureItem> _items = const [
    _CultureItem(
      title: 'Histoire de France & institutions',
      route: '/gpx_exam/concours/culture_generale_histoire_france',
      image: 'assets/images/histoire_de_france.webp',
      subtitle: 'Repères, dates, institutions',
    ),
    _CultureItem(
      title: 'Institutions européennes',
      route: '/gpx_exam/concours/culture_generale_institutions_europeennes',
      image: 'assets/images/ue.jpg',
      subtitle: 'UE, traités, organes et rôles',
    ),
    _CultureItem(
      title: 'Actualité & société',
      route: '/gpx_exam/concours/culture_generale_actualite',
      image: 'assets/images/macron.jpg',
      subtitle: 'Société, enjeux contemporains',
    ),
    _CultureItem(
      title: 'Géographie française & mondiale',
      route: '/gpx_exam/concours/culture_generale_geographie',
      image: 'assets/images/geographie.png',
      subtitle: 'France + monde, repères et cartes',
    ),
    _CultureItem(
      title: 'Français & Humanités',
      route: '/gpx_exam/concours/culture_generale_francais',
      image: 'assets/images/francais_cg.jpg',
      subtitle: 'Langue, culture, humanités',
    ),
    _CultureItem(
      title: 'Sport & culture générale',
      route: '/gpx_exam/concours/culture_generale_sport',
      image: 'assets/images/sport_cg.jpg',
      subtitle: 'Sports, événements, vocabulaire',
    ),
    _CultureItem(
      title: 'Sciences & environnement',
      route: '/gpx_exam/concours/culture_generale_sciences',
      image: 'assets/images/science.jpg',
      subtitle: 'Sciences, climat, enjeux',
    ),
    _CultureItem(
      title: 'Santé & bien-être',
      route: '/gpx_exam/concours/culture_generale_sante',
      image: 'assets/images/sante.png',
      subtitle: 'Santé publique, prévention',
    ),
    _CultureItem(
      title: 'Police & sécurité publique',
      route: '/gpx_exam/concours/culture_generale_police_securite',
      image: 'assets/images/police.webp',
      subtitle: 'Sécurité, missions, prévention',
    ),
    _CultureItem(
      title: 'Mythologie & culture générale',
      route: '/gpx_exam/concours/culture_generale_mythologie',
      image: 'assets/images/mythologie.webp',
      subtitle: 'Mythes, figures, récits',
    ),
    _CultureItem(
      title: 'Musique & culture générale',
      route: '/gpx_exam/concours/culture_generale_musique',
      image: 'assets/images/musique.jpg',
      subtitle: 'Compositeurs, styles, repères',
    ),
    _CultureItem(
      title: 'Cinéma & culture générale',
      route: '/gpx_exam/concours/culture_generale_cinema',
      image: 'assets/images/cinema.png',
      subtitle: 'Films, réalisateurs, repères',
    ),
    _CultureItem(
      title: 'Droit & culture générale',
      route: '/gpx_exam/concours/culture_generale_droit',
      image: 'assets/images/action_justice.jpeg',
      subtitle: 'Bases juridiques, notions clés',
    ),
    _CultureItem(
      title: 'Langue & culture générale',
      route: '/gpx_exam/concours/culture_generale_langue',
      image: 'assets/images/langue_francaise.webp',
      subtitle: 'Langue, vocabulaire, pièges',
    ),
    _CultureItem(
      title: 'Sécurité routière & culture générale',
      route: '/gpx_exam/concours/culture_generale_securite_routiere',
      image: 'assets/images/secu.webp',
      subtitle: 'Code, prévention, sécurité',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ✅ Bouton retour flottant (style "glass", adaptatif dark/light)
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 10),
          child: Builder(
            builder: (context) {
              final canPop = Navigator.of(context).canPop();
              final isDark = Theme.of(context).brightness == Brightness.dark;

              final bg = isDark
                  ? Colors.white.withOpacity(0.14)
                  : Colors.black.withOpacity(0.22);

              final border = isDark
                  ? Colors.white.withOpacity(0.22)
                  : Colors.white.withOpacity(0.12);

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: canPop ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !canPop,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Material(
                        color: bg,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).maybePop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: border, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Retour',
                                  style: GoogleFonts.instrumentSans(
                                    color: Colors.white.withOpacity(0.95),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // ✅ Corps : on décale un peu le haut pour éviter que le bouton flotte sur le titre
      body: SafeArea(
        top: true,
        bottom: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            64,
            20,
            28,
          ), // 👈 64 = espace bouton
          children: [
            Text(
              'Concours GPX — Culture générale',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : _T.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sélectionne un thème pour commencer.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _muted(context, .82),
              ),
            ),
            const SizedBox(height: 20),

            for (int i = 0; i < _items.length; i++) ...[
              _ChoiceHeroCard(
                image: _items[i].image,
                title: _items[i].title,
                subtitle: _items[i].subtitle,
                selected: _selected == i,
                onTap: () {
                  setState(() => _selected = i);
                  _go(_items[i].route);
                },
              ),
              if (i != _items.length - 1) const SizedBox(height: 16),
            ],

            const SizedBox(height: 22),
            Center(
              child: Text(
                'Bon entraînement 💪',
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
                Positioned.fill(child: img),

                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(color: Colors.black.withOpacity(0.30)),
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
