// lib/home/home_page_pa_school.dart
// Page "Scolarité — Policier Adjoint (PA)" alignée pixel-perfect sur la page GPX.
// Rendu, animations, favoris et navigation identiques à HomePageGpxSchool.

import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/physics.dart' as phys;
import 'package:google_fonts/google_fonts.dart';

// ==== Modèles partagés depuis home_page.dart ====
import 'package:copiqpolice/home/home_page.dart'
    show CategoryConfig, SubCategoryConfig, Track, UserMode;

// ==== Pages existantes ====
import 'package:copiqpolice/home/journal_pa_school.dart';
import 'package:copiqpolice/home/favoris_home.dart';
import 'package:copiqpolice/services/favorites.dart';
import 'package:copiqpolice/home/profil_page.dart';
import 'package:copiqpolice/home/parametre_home.dart';

// ======================================================================
//                               THEME TOKENS
// ======================================================================

class _T {
  static const ink = Color(0xFF1C1C1C);
  static const g300 = Color(0xFFE0E0E0);
  static const g400 = Color(0xFFBDBDBD);
  static const g500 = Color(0xFF9E9E9E);

  static const r16 = 16.0;
  static const r20 = 20.0;
  static const r24 = 24.0;

  static const fast = Duration(milliseconds: 180);
  static const med = Duration(milliseconds: 260);

  static const shadow = BoxShadow(
    blurRadius: 16,
    color: Color(0x14000000),
    offset: Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double opacity = .7]) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return (isDark ? Colors.white : Colors.black).withOpacity(opacity);
}

// ======================================================================
//                                PAGE
// ======================================================================

class HomePagePaExam extends StatefulWidget {
  const HomePagePaExam({super.key});

  /// Pont pour charger le username (injecté au boot, même API que GPX).
  static Future<String?> Function()? usernameLoader;

  static const String routeName = '/home-pa-exam';

  @override
  State<HomePagePaExam> createState() => _HomePagePaExamState();
}

class _HomePagePaExamState extends State<HomePagePaExam> {
  int _currentTab = 0;

  // ✅ Mémorisation du scroll + états enfants (deck, listes, etc.)
  final PageStorageBucket _bucket = PageStorageBucket();

  // Bonjour personnalisé
  String? _username;
  bool _isLoadingUsername = true;

  // Contexte : School + PA
  static const _mode = UserMode.exam;
  static const _track = Track.pa;

  // Source des catégories (PA locales)
  late final List<CategoryConfig> _cats =
      (categoriesConfigPA[_mode]?[_track] ?? const <CategoryConfig>[]);

  // “À venir”
  late final List<_MiniSpec> _upcoming = [
    if (_cats.isNotEmpty)
      _MiniSpec(
        title: _cats[0].label,
        subtitle: _cats[0].badge,
        image: _cats[0].image,
        route: _cats[0].route,
      ),
    if (_cats.length >= 2)
      _MiniSpec(
        title: _cats[1].label,
        subtitle: _cats[1].badge,
        image: _cats[1].image,
        route: _cats[1].route,
      ),
    if (_cats.length >= 3)
      _MiniSpec(
        title: _cats[2].label,
        subtitle: _cats[2].badge,
        image: _cats[2].image,
        route: _cats[2].route,
      ),
  ];

  // index de départ : cherche "cadres juridiques"
  late final int _initialDeckIndex = () {
    final i = _cats.indexWhere(
      (c) => c.label.trim().toLowerCase().contains('cadres juridiques'),
    );
    return i >= 0 ? i : 0;
  }();

  @override
  void initState() {
    super.initState();
    _loadUsername(); // charge {username} éventuellement
  }

  Future<void> _loadUsername() async {
    try {
      final loader = HomePagePaExam.usernameLoader;
      String? name;
      if (loader != null) {
        name = await loader();
      }
      name = (name ?? '').trim();
      if (!mounted) return;
      setState(() {
        _username = name!.isEmpty ? null : name;
        _isLoadingUsername = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _username = null;
        _isLoadingUsername = false;
      });
    }
  }

  void _openRouteOrDetails({
    required String label,
    required String route,
    List<SubCategoryConfig>? subs,
  }) {
    final redirectRoute = redirectConfigPA[route];
    final target = redirectRoute ?? route;

    if (subs != null && subs.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              _CategoryDetailPage(title: label, subcategories: subs),
        ),
      );
    } else {
      Navigator.of(context).pushNamed(target);
    }
  }

  void _goToTab(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Deck items
    final deckItems = _cats
        .map(
          (c) => _DeckItem(
            label: c.label,
            badge: c.badge,
            image: c.image,
            rating: 4.9,
            reviews: 120,
            route: c.route,
            subcategories: c.subcategories,
          ),
        )
        .toList(growable: false);

    // Onglets
    final icons = const [
      Icons.home_rounded, // 0
      Icons.article_rounded, // 1 = Journal
      Icons.qr_code_rounded,
      Icons.favorite_rounded,
      Icons.person_rounded,
    ];

    final pages = <Widget>[
      // ===== Onglet 0 — Accueil PA School =====
      PageStorage(
        bucket: _bucket,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                _isLoadingUsername
                                    ? 'Bonjour 👋'
                                    : (_username != null
                                          ? 'Bonjour ${_username!}'
                                          : 'Bonjour 👋'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bienvenue sur COP’IQ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _muted(context, .7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _IconCircle(icon: Icons.school_rounded, onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Recherche + réglages
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [_T.shadow],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Rechercher',
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: _muted(context, .6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _IconCircle(
                    icon: Icons.settings_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ParametreHomePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Titres
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Concours — Policier Adjoint',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sélection de contenu',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== HÉRO CAROUSEL =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HeroDeck(
                key: const PageStorageKey('pa-hero-deck'),
                height: 330,
                items: deckItems,
                initialIndex: _initialDeckIndex,
              ),
            ),

            const SizedBox(height: 22),

            // À venir / Tout voir
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'À venir',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _goToTab(1),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        'Tout voir',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _muted(context, .7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Mini-cards
            SizedBox(
              height: 230,
              child: ListView.separated(
                key: const PageStorageKey('pa-mini-list'),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) {
                  final m = _upcoming[i];
                  final cat = _cats.firstWhere(
                    (c) => c.route == m.route,
                    orElse: () => _cats.first,
                  );
                  return _MiniCard(
                    title: m.title,
                    subtitle: m.subtitle,
                    image: m.image,
                    rating: 4.9,
                    onTap: () => _openRouteOrDetails(
                      label: m.title,
                      route: m.route,
                      subs: cat.subcategories,
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemCount: _upcoming.length,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // ===== Autres onglets =====
      const JournalPaSchoolPage(), // index 1
      const _StubPage(title: 'QR'),
      const FavorisHomePage(),
      const ProfilPage(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: AnimatedSwitcher(duration: _T.med, child: pages[_currentTab]),
      ),
      bottomNavigationBar: _SlidingPillNavBar(
        currentIndex: _currentTab,
        onTap: (i) => _goToTab(i),
        height: 64,
        icons: icons,
      ),
    );
  }
}

// ======================================================================
//                              WIDGETS
// ======================================================================

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: theme.cardColor,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: isDark ? Colors.white : _T.ink),
        ),
      ),
    );
  }
}

class _HeroDeck extends StatefulWidget {
  final double height;
  final List<_DeckItem> items;
  final int initialIndex;

  const _HeroDeck({
    Key? key,
    required this.height,
    required this.items,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<_HeroDeck> createState() => _HeroDeckState();
}

class _HeroDeckState extends State<_HeroDeck>
    with SingleTickerProviderStateMixin {
  static const _kStorageId = ValueKey('hero-deck-index');

  late final AnimationController _ctrl =
      AnimationController.unbounded(vsync: this, value: 0)..addListener(() {
        PageStorage.maybeOf(
          context,
        )?.writeState(context, _page, identifier: _kStorageId);
        setState(() {});
      });

  double get _page => _ctrl.value;
  set _page(double v) => _ctrl.value = v;

  @override
  void initState() {
    super.initState();
    final saved =
        PageStorage.maybeOf(
              context,
            )?.readState(context, identifier: _kStorageId)
            as double?;
    _page = (saved ?? widget.initialIndex.toDouble()).clamp(
      0.0,
      (widget.items.length - 1).toDouble(),
    );
  }

  @override
  void didUpdateWidget(covariant _HeroDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _page = _page.clamp(0.0, (widget.items.length - 1).toDouble());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Drag logic
  double? _dragStartX;
  double _startPage = 0;

  void _onDragStart(DragStartDetails d, double cardWidth) {
    _dragStartX = d.globalPosition.dx;
    _startPage = _page;
    _ctrl.stop();
  }

  void _onDragUpdate(DragUpdateDetails d, double cardWidth, int itemCount) {
    if (_dragStartX == null) return;
    final dx = d.globalPosition.dx - _dragStartX!;
    final pagesDelta = -dx / cardWidth;
    final maxPage = (itemCount - 1).toDouble();
    _page = (_startPage + pagesDelta).clamp(0.0, maxPage);
  }

  void _onDragEnd(DragEndDetails d, double cardWidth, int itemCount) {
    final velocityPages = -d.velocity.pixelsPerSecond.dx / cardWidth;
    final projected = _page + velocityPages * 0.20;
    final target = projected.roundToDouble();
    _settleBySpring(
      target: target,
      velocityPages: velocityPages,
      itemCount: itemCount,
    );
    _dragStartX = null;
  }

  void _settleBySpring({
    required double target,
    required double velocityPages,
    required int itemCount,
  }) {
    final maxPage = (itemCount - 1).toDouble();
    target = target.clamp(0.0, maxPage);

    const stiffness = 420.0;
    const damping = 32.0;
    final spring = phys.SpringDescription(
      mass: 1,
      stiffness: stiffness,
      damping: damping,
    );
    final sim = phys.SpringSimulation(spring, _page, target, velocityPages);
    _ctrl.animateWith(sim);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const viewportFraction = 0.78;
    final deckWidth = MediaQuery.of(context).size.width - 40; // padding 20+20
    final cardWidth = deckWidth * viewportFraction;
    final sidePeek = (deckWidth - cardWidth) / 2;

    const maxScale = 1.0;
    const minScale = 0.90;
    const ySpread = 18.0;
    const xSpread = 52.0;
    const radius = 24.0;

    final order = List<int>.generate(widget.items.length, (i) => i)
      ..sort((a, b) => (b - _page).abs().compareTo((a - _page).abs()));

    Widget buildCard(int i) {
      final delta = i - _page;
      if (delta.abs() > 1.25) return const SizedBox.shrink();

      final t = 1.0 - delta.abs().clamp(0.0, 1.0);
      final scale = minScale + (maxScale - minScale) * t;
      final dx = delta * xSpread;
      final dy = (1 - t) * ySpread;
      final opacity = .75 + .25 * t;

      return Positioned.fill(
        child: Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: HeroCard(
                  key: ValueKey(widget.items[i].route),
                  item: widget.items[i],
                  isDark: isDark,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePeek),
        child: GestureDetector(
          onHorizontalDragStart: (d) => _onDragStart(d, cardWidth),
          onHorizontalDragUpdate: (d) =>
              _onDragUpdate(d, cardWidth, widget.items.length),
          onHorizontalDragEnd: (d) =>
              _onDragEnd(d, cardWidth, widget.items.length),
          child: Stack(
            clipBehavior: Clip.none,
            children: [for (final i in order) buildCard(i)],
          ),
        ),
      ),
    );
  }
}

class HeroCard extends StatefulWidget {
  final _DeckItem item;
  final bool isDark;

  const HeroCard({Key? key, required this.item, required this.isDark})
    : super(key: key);

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> with TickerProviderStateMixin {
  bool _isFav = false;

  late final AnimationController _popCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _pop = CurvedAnimation(
    parent: _popCtrl,
    curve: Curves.easeOutBack,
  ).drive(Tween<double>(begin: 1.0, end: 1.15));

  late final VoidCallback _favListener;

  @override
  void initState() {
    super.initState();
    FavoritesStore.I.isFavorite(widget.item.route).then((v) {
      if (mounted) setState(() => _isFav = v);
    });
    _favListener = () {
      final nowFav = FavoritesStore.I.favorites.value.any(
        (e) => e.route == widget.item.route,
      );
      if (mounted && nowFav != _isFav) setState(() => _isFav = nowFav);
    };
    FavoritesStore.I.favorites.addListener(_favListener);
  }

  @override
  void didUpdateWidget(covariant HeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.route != widget.item.route) {
      FavoritesStore.I.isFavorite(widget.item.route).then((v) {
        if (mounted) setState(() => _isFav = v);
      });
    }
  }

  @override
  void dispose() {
    FavoritesStore.I.favorites.removeListener(_favListener);
    _popCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.selectionClick();
    _popCtrl.forward(from: 0);
    setState(() => _isFav = !_isFav);
    await FavoritesStore.I.toggle(
      FavoriteItem(
        route: widget.item.route,
        title: widget.item.label,
        subtitle: widget.item.badge,
        image: widget.item.image,
        rating: widget.item.rating,
        reviews: widget.item.reviews,
      ),
    );
  }

  void _open() {
    final redirectRoute = redirectConfigPA[widget.item.route];
    final targetRoute = redirectRoute ?? widget.item.route;
    final subs = widget.item.subcategories;
    if (subs != null && subs.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _CategoryDetailPage(
            title: widget.item.label,
            subcategories: subs,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushNamed(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    // image sûre
    Widget img;
    try {
      img = Image.asset(widget.item.image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: const Color(0xFF9E9E9E).withOpacity(.25));
    }

    final colors = [
      Colors.black.withOpacity(.65),
      Colors.black.withOpacity(.30),
      Colors.transparent,
    ];

    final rating = widget.item.rating.isFinite
        ? (widget.item.rating < 4.5 ? 4.5 : widget.item.rating)
        : 4.9;
    final ratingText = rating.toStringAsFixed(1);
    const anthracite = Color(0xFF2E3137);

    return ClipRRect(
      borderRadius: BorderRadius.circular(_T.r24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          img,
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.05, 0.35, 0.75],
                colors: colors,
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Material(
              color: Theme.of(context).cardColor.withOpacity(.95),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _toggleFavorite,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: ScaleTransition(
                      scale: _pop,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          _isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey<bool>(_isFav),
                          color: _isFav ? Colors.redAccent : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: DefaultTextStyle(
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: .2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ratingText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _open,
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: anthracite,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Découvrir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Colors.black87,
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
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title, subtitle, image;
  final double rating;
  final VoidCallback onTap;

  const _MiniCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget img;
    try {
      img = Image.asset(image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: const Color(0xFF9E9E9E).withOpacity(.25));
    }

    return Material(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_T.r20),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_T.r20),
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_T.r20),
            boxShadow: const [_T.shadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: img,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 84),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : _T.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: _muted(context, .7),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$rating',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: theme.textTheme.bodyMedium?.color,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: _muted(context, .8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlidingPillNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;
  final List<IconData> icons;

  const _SlidingPillNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.height,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding.bottom;
    final h = height;
    final iconSize = (h * 0.42).clamp(18.0, 26.0);
    final dotSize = (h * 0.62).clamp(30.0, 44.0);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? Colors.white.withOpacity(.08) : _T.ink;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, pad > 0 ? pad : 8),
        child: LayoutBuilder(
          builder: (context, c) {
            final innerPadX = (dotSize / 2) + 10;
            final outerRadius = h / 2;

            final totalW = c.maxWidth;
            final usableW = totalW - (innerPadX * 2);
            final slots = icons.length;
            final slotW = usableW / slots;

            final centerX = innerPadX + slotW * (currentIndex + 0.5);
            final dotLeft = centerX - (dotSize / 2);
            final dotTop = (h - dotSize) / 2;

            return Container(
              height: h,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(outerRadius),
                boxShadow: const [_T.shadow],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    left: dotLeft,
                    top: dotTop,
                    width: dotSize,
                    height: dotSize,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: innerPadX),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(slots, (i) {
                        final selected = i == currentIndex;
                        final activeColor = isDark ? Colors.black : _T.ink;
                        return Expanded(
                          child: Center(
                            child: InkResponse(
                              onTap: () => onTap(i),
                              radius: dotSize,
                              highlightShape: BoxShape.circle,
                              child: Icon(
                                icons[i],
                                size: iconSize,
                                color: selected ? activeColor : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryDetailPage extends StatelessWidget {
  final String title;
  final List<SubCategoryConfig> subcategories;

  const _CategoryDetailPage({required this.title, required this.subcategories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final sub = subcategories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _T.ink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.article_rounded, color: _T.ink),
              ),
              title: Text(
                sub.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: _T.g500,
              ),
              onTap: () => Navigator.of(context).pushNamed(sub.route),
            ),
          );
        },
      ),
    );
  }
}

class _StubPage extends StatelessWidget {
  final String title;
  const _StubPage({required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

// ======================================================================
//                            CONFIG PA LOCALE
//         Version "Concours Policier Adjoint" (mode UserMode.exam)
// ======================================================================

// Redirections PA (si tu veux rajouter des alias pour le concours, tu peux
// compléter ce map, mais ce n’est pas obligatoire pour le moment).
const Map<String, String> redirectConfigPA = {
  '/pa/cadres_juridiques': '/pa_scolarité_pages/cadres_juridiques',
  '/pa/pp/gav': '/pa_scolarité_pages/procedure_penale/pp_gav',
};

// Catégories PA – MODE CONCOURS
// (inspire directement la structure de ton bouquin : Connaissances générales,
// Français, Étude de texte, Tests psychotechniques + pages "Analyse de l’épreuve")
const Map<UserMode, Map<Track, List<CategoryConfig>>> categoriesConfigPA = {
  UserMode.exam: {
    Track.pa: [
      // ------------------------------------------------------------------
      // 1. Vue globale du concours PA
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Les épreuves du concours PA',
        badge: 'Vue d’ensemble',
        image: 'assets/images/concours_pa_epreuves.jpeg',
        route: '/pa_exam/concours/epreuves',
        subcategories: [
          SubCategoryConfig(
            label: 'Tableau des épreuves',
            route: '/pa_exam/concours/epreuves/tableau',
          ),
          SubCategoryConfig(
            label: 'Visite médicale & enquête administrative',
            route: '/pa_exam/concours/epreuves/visite_medicale_enquete',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 2. ÉPREUVE DE PHOTOLANGAGE
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Épreuve de photolangage',
        badge: 'Expression écrite',
        image: 'assets/images/concours_photolangage.jpeg',
        route: '/pa_exam/concours/photolangage',
        subcategories: [
          SubCategoryConfig(
            label: 'Analyse de l’épreuve',
            route: '/pa_exam/concours/photolangage/analyse',
          ),
          SubCategoryConfig(
            label: 'Les étapes de la réussite',
            route: '/pa_exam/concours/photolangage/etapes_reussite',
          ),
          SubCategoryConfig(
            label: 'Entraînements (sujets & corrigés)',
            route: '/pa_exam/concours/photolangage/entrainements',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 3. TESTS PSYCHOTECHNIQUES (gros bloc, comme dans ton sommaire)
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Tests psychotechniques',
        badge: 'Logique & profil',
        image: 'assets/images/concours_tests_psy.jpeg',
        route: '/pa_exam/concours/tests_psychotechniques',
        subcategories: [
          SubCategoryConfig(
            label: 'Analyse de l’épreuve',
            route: '/pa_exam/concours/tests_psy/analyse',
          ),
          // Fiches de cours – aptitude verbale / raisonnement / etc.
          SubCategoryConfig(
            label: 'Aptitude verbale',
            route: '/pa_exam/concours/tests_psy/aptitude_verbale',
          ),
          SubCategoryConfig(
            label: 'Raisonnement logique',
            route: '/pa_exam/concours/tests_psy/raisonnement_logique',
          ),
          SubCategoryConfig(
            label: 'Observation & attention',
            route: '/pa_exam/concours/tests_psy/observation_attention',
          ),
          SubCategoryConfig(
            label: 'Personnalité & comportements',
            route: '/pa_exam/concours/tests_psy/personnalite',
          ),
          // Bloc entraînements comme dans le livre : QCM / exercices / corrigés
          SubCategoryConfig(
            label: 'Entraînements — QCM',
            route: '/pa_exam/concours/tests_psy/entrainements_qcm',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Exercices',
            route: '/pa_exam/concours/tests_psy/entrainements_exercices',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Corrigés',
            route: '/pa_exam/concours/tests_psy/entrainements_corriges',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 4. CONNAISSANCES GÉNÉRALES
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Connaissances générales',
        badge: 'Institution & culture',
        image: 'assets/images/concours_connaissances_generales.jpeg',
        route: '/pa_exam/concours/connaissances_generales',
        subcategories: [
          SubCategoryConfig(
            label: 'Fiches de cours',
            // à l’intérieur : méthodologie, Ve République, Président,
            // Gouvernement, Parlement, Institutions européennes, etc.
            route: '/pa_exam/concours/connaissances_generales/fiches_de_cours',
          ),
          SubCategoryConfig(
            label: 'Entraînements — QCM',
            route:
                '/pa_exam/concours/connaissances_generales/entrainements_qcm',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Exercices',
            route:
                '/pa_exam/concours/connaissances_generales/entrainements_exercices',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Corrigés',
            route:
                '/pa_exam/concours/connaissances_generales/entrainements_corriges',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 5. FRANÇAIS
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Français',
        badge: 'Langue & grammaire',
        image: 'assets/images/contre_nation.jpeg',
        route: '/pa_exam/concours/francais',
        subcategories: [
          SubCategoryConfig(
            label: 'Fiches de cours',
            // à l’intérieur : liens logiques, accord du participe, pluriel,
            // adjectifs, mots invariables, temps des verbes, etc.
            route: '/pa_exam/concours/francais/fiches_de_cours',
          ),
          SubCategoryConfig(
            label: 'Entraînements — QCM',
            route: '/pa_exam/concours/francais/entrainements_qcm',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Exercices',
            route: '/pa_exam/concours/francais/entrainements_exercices',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Corrigés',
            route: '/pa_exam/concours/francais/entrainements_corriges',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 6. ÉTUDE DE TEXTE
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Étude de texte',
        badge: 'Analyse & rédaction',
        image: 'assets/images/diffusion_images.jpeg',
        route: '/pa_exam/concours/etude_texte',
        subcategories: [
          SubCategoryConfig(
            label: 'Méthodologie de l’épreuve',
            route: '/pa_exam/concours/etude_texte/methodologie',
          ),
          SubCategoryConfig(
            label: 'Fiches de cours',
            // à l’intérieur : sens des mots, préfixes/suffixes, forme de la phrase,
            // conjugaison, etc.
            route: '/pa_exam/concours/etude_texte/fiches_de_cours',
          ),
          SubCategoryConfig(
            label: 'Entraînements — QCM',
            route: '/pa_exam/concours/etude_texte/entrainements_qcm',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Exercices',
            route: '/pa_exam/concours/etude_texte/entrainements_exercices',
          ),
          SubCategoryConfig(
            label: 'Entraînements — Corrigés',
            route: '/pa_exam/concours/etude_texte/entrainements_corriges',
          ),
        ],
      ),
    ],
  },

  // Tu pourras ajouter plus tard UserMode.school ici si tu veux une
  // config différente pour la scolarité PA.
};

// ======================================================================
//                       SPECS INTERNES (Deck/Mini)
// ======================================================================

class _DeckItem {
  final String label, badge, image, route;
  final double rating;
  final int reviews;
  final List<SubCategoryConfig>? subcategories;
  const _DeckItem({
    required this.label,
    required this.badge,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.route,
    this.subcategories,
  });
}

class _MiniSpec {
  final String title, subtitle, image, route;
  const _MiniSpec({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.route,
  });
}
