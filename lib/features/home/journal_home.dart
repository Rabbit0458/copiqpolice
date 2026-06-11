// lib/home/journal_home.dart
import 'dart:ui' show PointerDeviceKind, ImageFilter;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pont global pour synchroniser le parcours choisi depuis la Home.
/// Valeurs: 'gpx' ou 'pa'
class JournalBridge {
  static final ValueNotifier<String> selectedKey = ValueNotifier<String>('gpx');
}

/// ===================================================================
/// TOKENS / THEME HELPERS
/// ===================================================================
class _J {
  static const Color ink = Color(0xFF212529);
  static const double r12 = 12, r16 = 16, r20 = 20, r24 = 24;
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration med = Duration(milliseconds: 420);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withAlpha(26), // ≃ 0.10
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

Color _jMuted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _J.ink);
  return base.withValues(alpha: a);
}

/// ===================================================================
/// TRACK SELECTION (GPX / PA)
/// ===================================================================
enum _Track { gpx, pa }

extension _TrackX on _Track {
  String get key => this == _Track.gpx ? 'gpx' : 'pa';
  String get title =>
      this == _Track.gpx ? 'Gardien de la Paix' : 'Policier adjoint';

  /// Menu principal “Parcours” (cartes héros)
  List<_HeroItem> get primary {
    if (this == _Track.gpx) {
      return const [
        _HeroItem(
          label: 'Institutions',
          caption: 'Police Nationale',
          image: 'assets/images/copic_institutions.jpg',
          route: '/journal/institutions',
          rating: 4.9,
          reviews: 132,
        ),
        _HeroItem(
          label: 'Scientologie',
          caption: 'Culture G',
          image: 'assets/images/image6.jpg',
          route: '/journal/scientologie',
          rating: 4.7,
          reviews: 101,
        ),
        _HeroItem(
          label: 'Français',
          caption: 'Orthographe & grammaire',
          image: 'assets/images/image2.jpeg',
          route: '/journal/francais',
          rating: 4.6,
          reviews: 96,
          locked: true,
        ),
        _HeroItem(
          label: 'Psychotechnique',
          caption: 'Raisonnement & logique',
          image: 'assets/images/psy.jpeg',
          route: '/journal/psychotechnique',
          rating: 4.7,
          reviews: 88,
        ),
      ];
    } else {
      return const [
        _HeroItem(
          label: 'Institutions',
          caption: 'Révision express',
          image: 'assets/images/copic_institutions.jpg',
          route: '/journal/pa/institutions',
          rating: 4.7,
          reviews: 102,
        ),
        _HeroItem(
          label: 'Technique & Terrain',
          caption: 'Pratique',
          image: 'assets/images/image4.jpeg',
          route: '/journal/pa/terrain',
          rating: 4.5,
          reviews: 73,
        ),
        _HeroItem(
          label: 'Français',
          caption: 'Compétences écrites',
          image: 'assets/images/image2.jpeg',
          route: '/journal/pa/francais',
          rating: 4.5,
          reviews: 64,
          locked: true,
        ),
      ];
    }
  }

  /// Grille des catégories générales
  List<_CategoryItem> get general => const [
    _CategoryItem(
      title: 'Organisation',
      image: 'assets/images/cat_organisation.jpg',
      route: '/journal/cat/organisation',
    ),
    _CategoryItem(
      title: 'Hiérarchie',
      image: 'assets/images/cat_hierarchie.jpg',
      route: '/journal/cat/hierarchie',
    ),
    _CategoryItem(
      title: 'Libertés publiques',
      image: 'assets/images/cat_libertes.jpeg',
      route: '/journal/cat/libertes_publiques',
    ),
    _CategoryItem(
      title: 'La déontologie',
      image: 'assets/images/cat_deontologie.jpg',
      route: '/journal/cat/deontologie',
    ),
    _CategoryItem(
      title: 'Bases juridiques',
      image: 'assets/images/cat_bases_juridiques.jpg',
      route: '/journal/cat/bases_juridiques',
    ),
    _CategoryItem(
      title: 'Infractions',
      image: 'assets/images/cat_infractions.jpg',
      route: '/journal/cat/infractions',
    ),
    _CategoryItem(
      title: 'Routier',
      image: 'assets/images/cat_routier.jpg',
      route: '/journal/cat/routier',
    ),
    _CategoryItem(
      title: 'Armement',
      image: 'assets/images/cat_armement.jpg',
      route: '/journal/cat/armement',
    ),
  ];
}

/// ===================================================================
/// PAGE JOURNAL (s’adapte automatiquement au parcours choisi)
/// ===================================================================
class JournalHomePage extends StatefulWidget {
  static const routeName = '/journal';
  const JournalHomePage({super.key});

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
  static const _spKeyTrack = 'selected_track'; // 'gpx' | 'pa'
  late _Track _track = _Track.gpx;
  bool _loading = true;

  final PageController _heroCtrl = PageController(viewportFraction: .88);
  late VoidCallback _bridgeListener;

  @override
  void initState() {
    super.initState();

    // 1) Prendre immédiatement la valeur du pont (définie par la Home)
    _track = (JournalBridge.selectedKey.value == 'pa') ? _Track.pa : _Track.gpx;

    // 2) Écoute des changements en temps réel provenant de la Home
    _bridgeListener = () {
      final v = JournalBridge.selectedKey.value;
      final t = (v == 'pa') ? _Track.pa : _Track.gpx;
      if (t != _track && mounted) {
        setState(() => _track = t);
      }
    };
    JournalBridge.selectedKey.addListener(_bridgeListener);

    // 3) Charger une valeur de secours depuis les prefs (si présente)
    _loadTrackFallback();
  }

  @override
  void dispose() {
    JournalBridge.selectedKey.removeListener(_bridgeListener);
    super.dispose();
  }

  /// Lit la préférence uniquement comme **fallback** ; ne modifie PAS le pont.
  Future<void> _loadTrackFallback() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(
      _spKeyTrack,
    ); // peut être null si jamais enregistré
    if (!mounted) return;

    setState(() {
      if (raw == 'pa') _track = _Track.pa; // sinon laisser la valeur du pont
      _loading = false;
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_track.title} — contenu rafraîchi'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ScrollConfiguration(
      behavior: const _UltraSmoothScrollBehavior(),
      child: Column(
        children: [
          _JournalHeader(title: _track.title), // 👉 plus de bouton “changer”
          const SizedBox(height: 6),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: _onRefresh,
              displacement: 54,
              edgeOffset: 0,
              strokeWidth: 2.4,
              color: Theme.of(context).colorScheme.primary,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // === SECTION PARCOURS (cartes héros) ===
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: _HeroSection(
                      controller: _heroCtrl,
                      items: _track.primary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // === SECTION CATEGORIES GENERALES (grille) ===
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(
                      'Catégories',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _CategoriesGrid(items: _track.general),
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

/// ===================================================================
/// Header avec titre dynamique (sans menu de changement)
/// ===================================================================
class _JournalHeader extends StatelessWidget {
  final String title;
  const _JournalHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.instrumentSansTextTheme(
      Theme.of(context).textTheme,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================================================================
/// ULTRA SMOOTH SCROLL BEHAVIOR
/// ===================================================================
class _UltraSmoothScrollBehavior extends MaterialScrollBehavior {
  const _UltraSmoothScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
  }
}

/// ===================================================================
/// SECTION HEROS (Parcours) — cartes larges
/// ===================================================================
class _HeroItem {
  final String label;
  final String caption;
  final String image;
  final String route;
  final double rating;
  final int reviews;
  final bool locked;
  const _HeroItem({
    required this.label,
    required this.caption,
    required this.image,
    required this.route,
    required this.rating,
    required this.reviews,
    this.locked = false,
  });
}

class _HeroSection extends StatefulWidget {
  final PageController controller;
  final List<_HeroItem> items;
  const _HeroSection({required this.controller, required this.items});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  double _page = 0;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _page = widget.controller.initialPage.toDouble();
    _listener = () {
      if (!mounted) return;
      setState(() => _page = widget.controller.page ?? 0);
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = (MediaQuery.of(context).size.height * .34).clamp(240.0, 360.0);

    return SizedBox(
      height: h,
      child: Stack(
        children: [
          PageView.builder(
            controller: widget.controller,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.items.length,
            onPageChanged: (_) => HapticFeedback.selectionClick(),
            itemBuilder: (context, i) {
              final it = widget.items[i];
              final d = (i - _page).abs().clamp(0.0, 1.0);
              final scale = 1 - 0.05 * d;
              final dx = 10 * (i - _page);

              return Transform.translate(
                offset: Offset(dx, 6 * d),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: _HeroCard(item: it),
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _CircleButton(
                icon: Icons.arrow_forward_rounded,
                onTap: () {
                  final c = widget.controller;
                  final last = (widget.items.length - 1).clamp(0, 999);
                  final current = (c.page ?? 0).round();
                  HapticFeedback.selectionClick();
                  if (current >= last) {
                    c.animateToPage(
                      0,
                      duration: _J.med,
                      curve: Curves.easeInOut,
                    );
                  } else {
                    c.nextPage(duration: _J.med, curve: Curves.easeInOut);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final _HeroItem item;
  const _HeroCard({required this.item});

  static const String itemCaption = 'Révisions';

  @override
  Widget build(BuildContext context) {
    Widget img;
    try {
      img = Image.asset(item.image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.grey.shade400.withValues(alpha: .25));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (item.locked) {
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Abonnement requis pour accéder à ce module'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
          return;
        }
        Navigator.of(context).pushNamed(item.route);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_J.r24),
          boxShadow: [_J.shadow],
          color: Theme.of(context).cardColor,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: img),

            // Overlay dégradé bas
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withValues(alpha: isDark ? .55 : .45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Effet flou + cadenas si locked
            if (item.locked)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_J.r24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.6, sigmaY: 2.6),
                        child: Container(color: Colors.black.withValues(alpha: .10)),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .55),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.lock_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Abonnement requis',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Texte bas
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    itemCaption,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.reviews} avis',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(23),
          boxShadow: [_J.shadow],
        ),
        child: Icon(icon, color: isDark ? Colors.white : _J.ink),
      ),
    );
  }
}

/// ===================================================================
/// GRILLE DE CATÉGORIES
/// ===================================================================
class _CategoryItem {
  final String title;
  final String image;
  final String route;
  final bool locked;
  const _CategoryItem({
    required this.title,
    required this.image,
    required this.route,
    this.locked = false,
  });
}

class _CategoriesGrid extends StatelessWidget {
  final List<_CategoryItem> items;
  const _CategoriesGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final isWide = c.maxWidth >= 720;
        final cross = isWide ? 2 : 1;
        final ratio = isWide ? (16 / 9) : 1.25;

        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.only(bottom: 8),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: ratio,
          ),
          itemBuilder: (_, i) => _CategoryCard(item: items[i]),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    Widget img;
    try {
      img = Image.asset(item.image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.grey.shade400.withValues(alpha: .25));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (item.locked) {
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Débloquez cette catégorie pour y accéder'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        Navigator.of(context).pushNamed(item.route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(_J.r20),
          boxShadow: [_J.shadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_J.r20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(child: img),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withValues(alpha: .95),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [_J.shadow],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_rounded,
                              size: 16,
                              color: _jMuted(context, .9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Module',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _jMuted(context, .95),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : _J.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quiz, fiches & entraînements',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: _jMuted(context),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: _jMuted(context, .82),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Entrer',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: _jMuted(context, .9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
