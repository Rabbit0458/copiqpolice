import 'dart:async';

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/physics.dart' as phys;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:copiqpolice/features/onboarding/mode_picker.dart';

// ==== Types publics exportés par ta home ====
import 'package:copiqpolice/home/home_page.dart'
    show CategoryConfig, SubCategoryConfig, Track, UserMode;

// ==== Pages existantes ====
import 'package:copiqpolice/home/journal_gpx_school.dart';
import 'package:copiqpolice/home/favoris_home.dart';
import 'package:copiqpolice/core/services/favorites.dart';
import 'package:copiqpolice/home/details_page.dart';
import 'package:copiqpolice/home/profil_page.dart';
import 'package:copiqpolice/home/parametre_home.dart';
import 'package:copiqpolice/features/onboarding/pa_school.dart' show PaSchoolProgram;

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

class HomePagePaSchool extends StatefulWidget {
  const HomePagePaSchool({super.key});

  static PaSchoolProgram program = PaSchoolProgram.institutionValeurs;
  static Future<String?> Function()? usernameLoader;

  static const String routeName = '/home-pa-school';

  @override
  State<HomePagePaSchool> createState() => _HomePageGpxSchoolState();
}

class _HomePageGpxSchoolState extends State<HomePagePaSchool>
    with WidgetsBindingObserver {
  int _currentTab = 0;

  // ✅ Mémorisation du scroll + états enfants (deck, listes, etc.)
  final PageStorageBucket _bucket = PageStorageBucket();

  // 👉 État du bonjour personnalisé
  String? _username;
  bool _isLoadingUsername = true;

  // Contexte figé : School + GPX
  static const _mode = UserMode.school;
  static const _track = Track.pa;

  late final List<CategoryConfig> _cats =
      (paSchoolCategoriesConfig[HomePagePaSchool.program] ??
      const <CategoryConfig>[]);

  // =====================  PERSISTENCE DE L'INDEX DU DECK  =====================

  static const String _kDeckIndexKey = 'pa_school_hero_deck_index';
  int _initialDeckIndex = 0;
  bool _hasLoadedDeckIndex = false;

  int _computeDefaultDeckIndex() {
    final i = _cats.indexWhere(
      (c) => c.label.trim().toLowerCase() == 'cadres juridiques',
    );
    return i >= 0 ? i : 0;
  }

  // =====================  ✅ REPRENDRE : dernier module ouvert  =====================

  static const String _kLastRouteKey = 'pa_school_last_route';
  static const String _kLastLabelKey = 'pa_school_last_label';

  String? _lastRoute;
  String? _lastLabel;

  Future<void> _loadLastOpened() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final r = prefs.getString(_kLastRouteKey);
      final l = prefs.getString(_kLastLabelKey);
      if (!mounted) return;

      setState(() {
        _lastRoute = (r != null && r.trim().isNotEmpty) ? r : null;
        _lastLabel = (l != null && l.trim().isNotEmpty) ? l : null;
      });
    } catch (_) {}
  }

  Future<void> _saveLastOpened({
    required String route,
    required String label,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastRouteKey, route);
      await prefs.setString(_kLastLabelKey, label);
    } catch (_) {}
  }

  // =====================  🔎 BARRE DE RECHERCHE -> NAVIGATION AUTO  =====================

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  Timer? _debounce;
  String _lastAutoRoute = '';
  String _lastAutoQuery = '';

  String _norm(String s) {
    var t = s.toLowerCase().trim();
    const from = 'àáâäãåçèéêëìíîïñòóôöõùúûüýÿœæ’\'"';
    const to = 'aaaaaaceeeeiiiinooooouuuuyyoea  ';
    for (var i = 0; i < from.length; i++) {
      t = t.replaceAll(from[i], to[i]);
    }
    t = t.replaceAll(RegExp(r'[^a-z0-9]+'), ' ');
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    return t;
  }

  bool _matchesQuery(CategoryConfig c, String q) {
    if (q.isEmpty) return false;
    final label = _norm(c.label);
    if (label.startsWith(q)) return true;
    for (final w in label.split(' ')) {
      if (w.startsWith(q)) return true;
    }
    return false;
  }

  List<CategoryConfig> _candidatesFor(String rawQuery) {
    final q = _norm(rawQuery);
    if (q.length < 3) return const [];
    return _cats.where((c) => _matchesQuery(c, q)).toList(growable: false);
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 160), () {
      if (!mounted) return;
      final candidates = _candidatesFor(value);

      if (candidates.length == 1) {
        final c = candidates.first;
        final q = _norm(value);
        if (_lastAutoRoute == c.route && _lastAutoQuery == q) return;

        _lastAutoRoute = c.route;
        _lastAutoQuery = q;

        _searchFocus.unfocus();
        _searchCtrl.clear();

        _openRouteOrDetails(
          label: c.label,
          route: c.route,
          subs: c.subcategories,
        );

        Future.delayed(const Duration(milliseconds: 250), () {
          if (!mounted) return;
          _lastAutoRoute = '';
          _lastAutoQuery = '';
        });
      }
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchCtrl.clear();
    _searchFocus.unfocus();
    _lastAutoRoute = '';
    _lastAutoQuery = '';
    setState(() {});
  }

  // =====================  📈 PROGRESSION (Supabase quiz_history)  =====================

  int _computeTotalModules() {
    int total = 0;
    for (final c in _cats) {
      final subs = c.subcategories;
      if (subs != null && subs.isNotEmpty) {
        total += subs.length;
      } else {
        total += 1;
      }
    }
    return total;
  }

  late final SupabaseClient _sb = Supabase.instance.client;
  late final ProgressRepository _progressRepo = ProgressRepository(_sb);

  String? _uid;
  Future<ProgressSummary>? _progressFuture;

  RealtimeChannel? _progressChan;

  void _refreshProgress() {
    if (!mounted) return;
    final uid = _uid;
    if (uid == null || uid.isEmpty) return;

    setState(() {
      _progressFuture = _progressRepo.loadProgress(
        uid: uid,
        totalModules: _computeTotalModules(),
        track: _track.name, // "pa"
        mode: _mode.name, // "school"
      );
    });
  }

  Future<void> _loadUidAndProgress() async {
    try {
      final uid = _sb.auth.currentUser?.id;
      _uid = uid;
      _refreshProgress();
      _setupRealtimeProgress();
    } catch (_) {}
  }

  void _setupRealtimeProgress() {
    final uid = _uid;
    if (uid == null || uid.isEmpty) return;

    _progressChan?.unsubscribe();
    _progressChan = _sb
        .channel('progress_home_pa_school_$uid')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'quiz_history',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'uid',
            value: uid,
          ),
          callback: (payload) {
            _refreshProgress();
          },
        )
        .subscribe();
  }

  // =====================  LIFECYCLE  =====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initialDeckIndex = _computeDefaultDeckIndex();

    _loadUsername();
    _loadSavedDeckIndex();
    _loadLastOpened();

    _loadUidAndProgress();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _progressChan?.unsubscribe();

    _debounce?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProgress();
    }
  }

  // =====================  STORAGE DECK  =====================

  Future<void> _loadSavedDeckIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getInt(_kDeckIndexKey);

      if (!mounted) return;

      if (saved != null && saved >= 0 && saved < _cats.length) {
        setState(() {
          _initialDeckIndex = saved;
          _hasLoadedDeckIndex = true;
        });
      } else {
        setState(() {
          _initialDeckIndex = _computeDefaultDeckIndex();
          _hasLoadedDeckIndex = true;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _initialDeckIndex = _computeDefaultDeckIndex();
        _hasLoadedDeckIndex = true;
      });
    }
  }

  void _saveDeckIndex(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kDeckIndexKey, index);
    } catch (_) {}
  }

  // =====================  USERNAME  =====================

  Future<void> _loadUsername() async {
    try {
      final loader = HomePagePaSchool.usernameLoader;
      String? name;
      if (loader != null) {
        name = await loader();
      }

      final sanitized = (name ?? '').trim();
      if (!mounted) return;

      setState(() {
        _username = sanitized.isEmpty ? null : sanitized;
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

  // =====================  NAV  =====================

  Future<void> _openRouteOrDetails({
    required String label,
    required String route,
    List<SubCategoryConfig>? subs,
  }) async {
    // ✅ Sauvegarde "Reprendre"
    _saveLastOpened(route: route, label: label);

    final redirectRoute = redirectConfig[route];
    final target = redirectRoute ?? route;

    if (subs != null && subs.isNotEmpty) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              _CategoryDetailPage(title: label, subcategories: subs),
        ),
      );
    } else {
      await Navigator.of(context).pushNamed(target);
    }

    // ✅ refresh après retour d’un module/quiz
    _refreshProgress();
    await _loadLastOpened(); // ✅ important : met à jour _lastRoute/_lastLabel après retour
  }

  void _goToTab(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentTab = index);
  }

  // =====================  BUILD  =====================

  @override
  Widget build(BuildContext context) {
    if (!_hasLoadedDeckIndex) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

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

    final icons = const [
      Icons.home_rounded,
      Icons.article_rounded,
      Icons.qr_code_rounded,
      Icons.favorite_rounded,
      Icons.person_rounded,
    ];

    final pages = <Widget>[
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
                        Text(
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
                  _IconCircle(
                    icon: Icons.school_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ModePickerScreen(),
                        ),
                      );
                    },
                  ),
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
                              controller: _searchCtrl,
                              focusNode: _searchFocus,
                              onChanged: _onSearchChanged,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Rechercher (ex: san, nat, arm...)',
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: _muted(context, .6),
                                ),
                              ),
                            ),
                          ),
                          if (_searchCtrl.text.trim().isNotEmpty)
                            InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: _clearSearch,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: _muted(context, .75),
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
                'Scolarité — Policier Adjoint',
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

            // ✅ Deck (FIX : ctaLabel + open géré par le parent)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HeroDeck(
                // 🔥 IMPORTANT : force rebuild du deck quand _lastRoute change
                key: ValueKey('pa-hero-deck-${_lastRoute ?? "none"}'),
                height: 330,
                items: deckItems,
                initialIndex: _initialDeckIndex,
                onIndexChanged: _saveDeckIndex,

                // ✅ "Reprendre" si c'est le dernier module ouvert
                ctaLabelBuilder: (item) {
                  return (_lastRoute != null && _lastRoute == item.route)
                      ? 'Reprendre'
                      : 'Découvrir';
                },

                // ✅ laisse le parent gérer la navigation + sauvegarde "dernier ouvert"
                onOpen: (item) {
                  _openRouteOrDetails(
                    label: item.label,
                    route: item.route,
                    subs: item.subcategories,
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ✅ PROGRESSION
            FutureBuilder<ProgressSummary>(
              future: _progressFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [_T.shadow],
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [_T.shadow],
                      ),
                      child: Text(
                        'Impossible de charger la progression.',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: _muted(context, .75),
                        ),
                      ),
                    ),
                  );
                }

                final data =
                    snap.data ??
                    ProgressSummary(
                      seenModules: 0,
                      totalModules: _computeTotalModules(),
                      finishedQuizzes: 0, // ✅ AJOUT
                      streakDays: 0,
                      weeklyStudy: Duration.zero,
                      recentDone: const [],
                    );

                return ProgressCardV4(
                  data: data,
                  onTapDetails: () {
                    final uid = Supabase.instance.client.auth.currentUser?.id;
                    if (uid == null) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DetailsPage(uid: uid)),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 18),
            const SizedBox(height: 24),
          ],
        ),
      ),

      const JournalGpxSchoolPage(),
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

class _ModeBubble extends StatelessWidget {
  final UserMode mode;
  const _ModeBubble({required this.mode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [_T.shadow],
      ),
      child: Icon(Icons.school_rounded, color: isDark ? Colors.white : _T.ink),
    );
  }
}

class _HeroDeck extends StatefulWidget {
  final double height;
  final List<_DeckItem> items;
  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;

  /// ✅ Injecte "Découvrir" / "Reprendre" sans modifier _DeckItem
  final String Function(_DeckItem item)? ctaLabelBuilder;

  /// ✅ Permet au parent de gérer l'ouverture (pour persister "dernier ouvert")
  final void Function(_DeckItem item)? onOpen;

  const _HeroDeck({
    Key? key,
    required this.height,
    required this.items,
    required this.initialIndex,
    this.onIndexChanged,
    this.ctaLabelBuilder,
    this.onOpen,
  }) : super(key: key);

  @override
  State<_HeroDeck> createState() => _HeroDeckState();
}

class _HeroDeckState extends State<_HeroDeck>
    with SingleTickerProviderStateMixin {
  static const _kStorageId = ValueKey('hero-deck-index');

  late final AnimationController _ctrl = AnimationController.unbounded(
    vsync: this,
    value: 0,
  )..addListener(_onTick);

  double get _page => _ctrl.value;
  set _page(double v) => _ctrl.value = v;

  int _lastReportedIndex = 0;
  bool _initializedFromStorage = false;

  void _onTick() {
    PageStorage.maybeOf(
      context,
    )?.writeState(context, _page, identifier: _kStorageId);

    if (widget.items.isNotEmpty) {
      final idx = _page.round().clamp(0, widget.items.length - 1);
      if (idx != _lastReportedIndex) {
        _lastReportedIndex = idx;
        widget.onIndexChanged?.call(idx);
      }
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initializedFromStorage || widget.items.isEmpty) return;

    final saved =
        PageStorage.maybeOf(
              context,
            )?.readState(context, identifier: _kStorageId)
            as double?;

    final maxPage = (widget.items.length - 1).toDouble();
    _page = (saved ?? widget.initialIndex.toDouble()).clamp(0.0, maxPage);

    _lastReportedIndex = _page.round().clamp(0, widget.items.length - 1);
    _initializedFromStorage = true;
  }

  @override
  void didUpdateWidget(covariant _HeroDeck oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items.length != widget.items.length &&
        widget.items.isNotEmpty) {
      final maxPage = (widget.items.length - 1).toDouble();
      _page = _page.clamp(0.0, maxPage);
      _lastReportedIndex = _page.round().clamp(0, widget.items.length - 1);
    }

    if (!_initializedFromStorage &&
        oldWidget.initialIndex != widget.initialIndex) {
      if (widget.items.isNotEmpty) {
        final maxPage = (widget.items.length - 1).toDouble();
        _page = widget.initialIndex.toDouble().clamp(0.0, maxPage);
        _lastReportedIndex = _page.round().clamp(0, widget.items.length - 1);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // -------- API publique : pilotage externe --------
  void goTo(int index, {double velocityPages = 0}) {
    if (widget.items.isEmpty) return;
    final max = (widget.items.length - 1).toDouble();
    final target = index.toDouble().clamp(0.0, max);
    _settleBySpring(
      target: target,
      velocityPages: velocityPages,
      itemCount: widget.items.length,
    );
  }

  // ------------------------- Gestuelle -------------------------
  double? _dragStartX;
  double _startPage = 0;

  void _onDragStart(DragStartDetails d, double cardWidth) {
    _dragStartX = d.globalPosition.dx;
    _startPage = _page;
    _ctrl.stop();
  }

  void _onDragUpdate(DragUpdateDetails d, double cardWidth, int itemCount) {
    if (_dragStartX == null || itemCount == 0) return;
    final dx = d.globalPosition.dx - _dragStartX!;
    final pagesDelta = -dx / cardWidth;
    final maxPage = (itemCount - 1).toDouble();
    _page = (_startPage + pagesDelta).clamp(0.0, maxPage);
  }

  void _onDragEnd(DragEndDetails d, double cardWidth, int itemCount) {
    if (itemCount == 0) return;

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
    if (itemCount == 0) return;
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
    if (widget.items.isEmpty) return SizedBox(height: widget.height);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    const viewportFraction = 0.78;
    final deckWidth = MediaQuery.of(context).size.width - 40;
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

      final item = widget.items[i];

      // ✅ label CTA injecté
      final ctaLabel = widget.ctaLabelBuilder?.call(item) ?? 'Découvrir';

      // ✅ PAS de callback fantôme :
      final VoidCallback? onOpenCb = widget.onOpen == null
          ? null
          : () => widget.onOpen!.call(item);

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
                  key: ValueKey(item.route),
                  item: item,
                  isDark: isDark,
                  ctaLabel: ctaLabel,
                  onOpen: onOpenCb,
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

  /// ✅ Injecté par _HeroDeck (Découvrir / Reprendre)
  final String ctaLabel;

  /// ✅ Injecté par _HeroDeck (le parent gère la nav + persistance)
  final VoidCallback? onOpen;

  const HeroCard({
    Key? key,
    required this.item,
    required this.isDark,
    this.ctaLabel = 'Découvrir',
    this.onOpen,
  }) : super(key: key);

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
    HapticFeedback.selectionClick();

    // ✅ priorité : le parent gère la nav (et donc "Reprendre" persisté)
    if (widget.onOpen != null) {
      widget.onOpen!.call();
      return;
    }

    // fallback (au cas où)
    final redirectRoute = redirectConfig[widget.item.route];
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

    // ✅ bouton gris plus clair
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctaBg = isDark
        ? const ui.Color.fromARGB(255, 71, 75, 83)
        : const ui.Color.fromARGB(255, 71, 75, 83);

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

          // coeur
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

          // bottom content
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
                        color: ctaBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(.10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.ctaLabel,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
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

class _FavIcon extends StatelessWidget {
  const _FavIcon();

  @override
  Widget build(BuildContext context) {
    // on remonte jusqu’au _HeroCardState pour lire _isFav
    final state = context.findAncestorStateOfType<_HeroCardState>();
    final isFav = state?._isFav ?? false;
    return Icon(
      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      color: isFav ? Colors.redAccent : null,
    );
  }
}

class _DepthCard extends StatelessWidget {
  final double elevation;
  final double shadowOpacity;
  final Widget child;
  const _DepthCard({
    required this.elevation,
    required this.shadowOpacity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: Colors.black.withOpacity(shadowOpacity),
      borderRadius: BorderRadius.circular(_T.r24),
      clipBehavior: Clip.antiAlias,
      child: child,
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

    // Image sûre (fallback sans warning de dépréciation)
    Widget img;
    try {
      img = Image.asset(image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: const Color(0xFF9E9E9E).withValues(alpha: .25));
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
              // Image 16:9 avec coins supérieurs arrondis
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: img, // ✅ pas de Positioned ici
                ),
              ),

              // ✅ zone texte souple + hauteur mini pour éviter l’overflow
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

class _HomeActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);
    final muted = (isDark ? Colors.white : Colors.black).withOpacity(.65);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [_T.shadow],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(
                    .06,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: ink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================  _CategoryDetailPage (cartes visuelles)  =====================

class _CategoryDetailPage extends StatelessWidget {
  final String title;
  final List<SubCategoryConfig> subcategories;

  const _CategoryDetailPage({required this.title, required this.subcategories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Couleurs de base
    final Color bg = isDark ? const Color(0xFF0E0F12) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        itemCount: subcategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final sub = subcategories[i];
          return _ModuleCard(
            tag: sub.route,
            title: sub.label,
            subtitle: _subtitleFor(sub.label),
            imagePath: sub.image ?? _imageFor(sub.label),
            textMain: textMain,
            textSoft: textSoft,
            isDark: isDark,
            onTap: () => Navigator.of(context).pushNamed(sub.route),
          );
        },
      ),
    );
  }

  // -------- Images par thème (heuristiques simples) --------
  String _imageFor(String label) {
    final l = label.toLowerCase().trim();

    if (l.startsWith('quiz')) return 'assets/images/quiz.jpeg';

    if (l.contains('quiz generalite') || l.contains('quiz generalite')) {
      return 'assets/images/quiz.jpeg';
    }
    if (l.contains('classification'))
      return 'assets/images/classification.jpeg';
    if (l.contains('infraction'))
      return 'assets/images/infraction_materiel.jpeg';
    if (l.contains('tentative')) return 'assets/images/infraction_legal.jpeg';
    if (l.contains('complic')) return 'assets/images/complicite.jpeg';
    if (l.contains('légitime') || l.contains('legitime')) {
      return 'assets/images/legitime_defense.jpeg';
    }
    if (l.contains('arme') || l.contains('cadre légal')) {
      return 'assets/images/armes_munitions.jpeg';
    }
    if (l.contains('libert')) return 'assets/images/libertes_publiques.jpeg';
    if (l.contains('rétention') || l.contains('retention')) {
      return 'assets/images/retention.jpeg';
    }
    if (l.contains('hierarchie') || l.contains('hierarchie')) {
      return 'assets/images/libertes_intro.jpeg';
    }

    // ============================
    // Cadres juridiques — IMAGES
    // ============================
    if (l.contains('quiz cadres') || l.contains('quiz cadres')) {
      return 'assets/images/quiz.jpeg';
    }

    if (l.contains('cadres d\'enquête') || l.contains('cadres d’enquête')) {
      return 'assets/images/cadres_enquete.jpeg';
    }

    if (l.contains('flagrant')) {
      return 'assets/images/enquete_flagrant.jpeg';
      // (tu peux changer le nom si tu veux, mais mets une image dédiée)
    }

    if (l.contains('préliminaire') || l.contains('preliminaire')) {
      return 'assets/images/enquete_preliminaire.jpeg';
    }

    if (l.contains('commission') && l.contains('rogatoire')) {
      return 'assets/images/commission_rogatoire.jpeg';
    }

    if (l.contains('découverte') && l.contains('blessée')) {
      return 'assets/images/personne_blessee.jpeg';
    }

    if (l.contains('mort') ||
        l.contains('cause inconnue') ||
        l.contains('suspecte')) {
      return 'assets/images/mort_suspecte.jpeg';
    }

    if (l.contains('délinquance') || l.contains('criminalité')) {
      return 'assets/images/criminalite_organisee.jpeg';
    }

    if (l.contains('personnes') && l.contains('fuite')) {
      return 'assets/images/recherche_fuite.jpeg';
    }

    if (l.contains('disparitions') || l.contains('inquiétantes')) {
      return 'assets/images/abandon_famille.jpeg';
    }

    if (l.contains('contrôles') ||
        l.contains('vérifications') ||
        l.contains('identité')) {
      return 'assets/images/controle_identite.jpeg';
    }

    if (l.contains('entraide') || l.contains('internationale')) {
      return 'assets/images/libertes_expression.jpeg';
    }

    // Procédure pénale — nouvelles catégories
    if (l.contains('action publique') ||
        l.contains('autorités') ||
        l.contains('police judiciaire') ||
        l.contains('mission de police')) {
      return 'assets/images/pp_action_publique_autorites_pj.jpeg';
    }

    if (l.contains('nullité') || l.contains('actes de procédure')) {
      return 'assets/images/pp_nullite_actes.jpeg';
    }

    if (l.contains('juridictions') ||
        l.contains('jugement') ||
        l.contains('exécution des décisions')) {
      return 'assets/images/pp_juridictions_execution.jpeg';
    }

    // Quiz "instruction préparatoire, mandats & détention provisoire"
    if (l.contains('quiz instruction préparatoire') ||
        l.contains('quiz instruction preparatoire')) {
      return 'assets/images/quiz.jpeg';
    }

    // Module "Instruction préparatoire, mandats, contrôle judiciaire, détention provisoire"
    if (l.contains('instruction préparatoire') ||
        l.contains('instruction preparatoire') ||
        l.contains('mandats de justice') ||
        l.contains('contrôle judiciaire') ||
        l.contains('controle judiciaire') ||
        l.contains('détention provisoire') ||
        l.contains('detention provisoire')) {
      return 'assets/images/pp_instruction_mandats_detention.jpeg';
    }

    // Droit pénal général
    if (l.contains('loi pénale') || l.contains('loi penale')) {
      return 'assets/images/droit_penal_general.jpeg';
    }
    if (l.contains('responsabilité pénale') ||
        l.contains('responsabilite penale')) {
      return 'assets/images/droit_penal_general_2.jpeg';
    }

    // Sanction
    if (l.contains('peines') || l.contains('sûreté') || l.contains('surete')) {
      return 'assets/images/sanction.jpeg';
    }
    if (l.contains('aggravation')) return 'assets/images/aggravations.jpeg';
    if (l.contains('pluralité') || l.contains('pluralite')) {
      return 'assets/images/pluralite_infractions.jpeg';
    }
    if (l.contains('quiz') && l.contains('sanction') ||
        l.contains('sanction')) {
      return 'assets/images/quiz.jpeg';
    }

    // Contre la personne
    if (l.contains('mise en danger'))
      return 'assets/images/mise_en_danger.jpeg';
    if (l.contains('viol') || l.contains('agressions sexuelles')) {
      return 'assets/images/viol_agressions.jpeg';
    }
    if (l.contains('enlèvement') || l.contains('enlevement')) {
      return 'assets/images/enlevement.jpeg';
    }
    if (l.contains('diffusion d’images') || l.contains('diffusion d\'images')) {
      return 'assets/images/diffusion_images.jpeg';
    }
    if (l.contains('dignité') || l.contains('dignite')) {
      return 'assets/images/dignite.jpeg';
    }
    if (l.contains('personnalité') || l.contains('personnalite')) {
      return 'assets/images/personnalite.jpeg';
    }
    if (l.contains('involontaires')) {
      return 'assets/images/atteintes_involontaires.jpeg';
    }
    if (l.contains('volontaires à la vie') ||
        l.contains('volontaires a la vie')) {
      return 'assets/images/atteintes_vie.jpeg';
    }
    if (l.contains('volontaires à l’intégrité') ||
        l.contains('volontaires a l’integrite') ||
        l.contains('integrite')) {
      return 'assets/images/atteintes_integrite.jpeg';
    }

    // Mineurs & famille
    if (l.contains('mineurs')) return 'assets/images/mineurs_famille.jpeg';
    if (l.contains('jaf')) return 'assets/images/ordonnances_jaf.jpeg';
    if (l.contains('autorité parentale') || l.contains('autorite parentale')) {
      return 'assets/images/autorite_parentale.jpeg';
    }
    if (l.contains('abandon de famille')) {
      return 'assets/images/abandon_famille.jpeg';
    }

    // Contre la nation
    if (l.contains('association de malfaiteurs')) {
      return 'assets/images/association_malfaiteurs.jpeg';
    }
    if (l.contains('abus d’autorité') || l.contains('abus d\'autorite')) {
      return 'assets/images/abus_autorite.jpeg';
    }
    if (l.contains('action de la justice')) {
      return 'assets/images/action_justice.jpeg';
    }
    if (l.contains('administration par des particuliers')) {
      return 'assets/images/administration_particuliers.jpeg';
    }
    if (l.contains('faux') && l.contains('usage')) {
      return 'assets/images/faux_usage_faux.jpeg';
    }
    if (l.contains('probité') || l.contains('probite')) {
      return 'assets/images/probite.jpeg';
    }

    // Contre les biens
    if (l.contains('recel')) return 'assets/images/recel.jpeg';
    if (l.contains('vol')) return 'assets/images/vol.jpeg';
    if (l.contains('stad')) return 'assets/images/stad.jpeg';
    if (l.contains('chèques') ||
        l.contains('cheques') ||
        l.contains('contrefa')) {
      return 'assets/images/contrefacons.jpeg';
    }
    if (l.contains('destructions') ||
        l.contains('dégradations') ||
        l.contains('degradations')) {
      return 'assets/images/destructions.jpeg';
    }
    if (l.contains('voisines du vol')) {
      return 'assets/images/voisines_vol.jpeg';
    }

    // Circulation
    if (l.contains('stupéfiants') || l.contains('stupefiants')) {
      return 'assets/images/conduite_stupefiants.jpeg';
    }
    if (l.contains('ivresse')) return 'assets/images/ivresse.jpeg';
    if (l.contains('état alcoolique') || l.contains('etat alcoolique')) {
      return 'assets/images/etat_alcoolique.jpeg';
    }
    if (l.contains('assurance')) return 'assets/images/defaut_assurance.jpeg';
    if (l.contains('permis')) return 'assets/images/defaut_permis.jpeg';
    if (l.contains('délit de fuite') || l.contains('delit de fuite')) {
      return 'assets/images/delit_fuite.jpeg';
    }
    if (l.contains('excès de vitesse') || l.contains('exces de vitesse')) {
      return 'assets/images/grand_exces_vitesse.jpeg';
    }
    if (l.contains('vérifications') || l.contains('verifications')) {
      return 'assets/images/refus_verifications.jpeg';
    }
    if (l.contains('obtempérer') || l.contains('obtemperer')) {
      return 'assets/images/refus_obtemperer.jpeg';
    }
    if (l.contains('rodéo') || l.contains('rodeo')) {
      return 'assets/images/rodeo_motorise.jpeg';
    }
    if (l.contains('plaques') || l.contains('inscriptions')) {
      return 'assets/images/plaques_inscriptions.jpeg';
    }
    if (l.contains('incitation') ||
        l.contains('organisation') ||
        l.contains('promotion')) {
      return 'assets/images/image4.jpeg';
    }

    // Armes
    if (l.contains('classification des armes')) {
      return 'assets/images/armes_munitions.jpeg';
    }
    if (l.contains('définitions') || l.contains('definitions')) {
      return 'assets/images/armes_definitions.jpeg';
    }
    if (l.contains('introduction')) return 'assets/images/armes_intro.jpeg';
    if (l.contains('cat. a') ||
        l.contains('cat. b') ||
        l.contains('cat a') ||
        l.contains('cat b')) {
      return 'assets/images/armes_cat_ab.jpeg';
    }
    if (l.contains('cat. c') ||
        l.contains('cat. d') ||
        l.contains('cat c') ||
        l.contains('cat d')) {
      return 'assets/images/armes_cat_cd.jpeg';
    }
    if (l.contains('matériels de guerre') ||
        l.contains('materiels de guerre')) {
      return 'assets/images/armes_materiels_guerre.jpeg';
    }
    if (l.contains('acquisition') ||
        l.contains('détention') ||
        l.contains('detention')) {
      return 'assets/images/armes_acquisition_detention.jpeg';
    }
    if (l.contains('port') || l.contains('transport')) {
      return 'assets/images/armes_port_transport.jpeg';
    }

    // Libertés publiques
    if (l.contains('introduction générale') ||
        l.contains('introduction generale')) {
      return 'assets/images/libertes_intro.jpeg';
    }
    if (l.contains('garanties')) return 'assets/images/libertes_garanties.jpeg';
    if (l.contains('expression collectives')) {
      return 'assets/images/libertes_expression.jpeg';
    }
    if (l.contains('vie privée') || l.contains('vie privee')) {
      return 'assets/images/libertes_vie_privee.jpeg';
    }

    // Stups
    if (l.contains('stupéfiants') || l.contains('stupefiants')) {
      return 'assets/images/stupefiants.jpeg';
    }
    if (l.contains('cession') || l.contains('offre illicite')) {
      return 'assets/images/stup_cession_offre.jpeg';
    }
    if (l.contains('direction') || l.contains('organisation')) {
      return 'assets/images/stup_direction_org.jpeg';
    }
    if (l.contains('facilitation'))
      return 'assets/images/stup_facilitation.jpeg';
    if (l.contains('production') || l.contains('fabrication')) {
      return 'assets/images/stup_production.jpeg';
    }
    if (l.contains('provocation d’un majeur') ||
        l.contains('provocation d\'un majeur')) {
      return 'assets/images/stup_provocation.jpeg';
    }
    if (l.contains('blanchiment')) return 'assets/images/stup_blanchiment.jpeg';
    if (l.contains('transport') ||
        l.contains('détention') ||
        l.contains('detention')) {
      return 'assets/images/stup_transport_detention.jpeg';
    }
    if (l.contains('importation') || l.contains('exportation')) {
      return 'assets/images/stup_import_export.jpeg';
    }
    if (l.contains('usage illicite')) return 'assets/images/stup_usage.jpeg';

    // Défaut
    return 'assets/images/generalite.jpeg';
  }

  String _subtitleFor(String label) {
    final l = label.toLowerCase();

    // Généralités
    if (l.contains('classification')) return 'Concepts de base';
    if (l.contains('infraction')) return 'Éléments légal, matériel & moral';
    if (l.contains('tentative')) return 'Actes non consommés mais punissables';
    if (l.contains('complic')) return 'Participation punissable à l’infraction';
    if (l.contains('légitime') || l.contains('legitime')) {
      return 'Protection immédiate et nécessaire';
    }
    if (l.contains('armes')) return 'Usage et régimes applicables';
    if (l.contains('libert')) return 'Droits fondamentaux et garanties';
    if (l.contains('rétention') || l.contains('retention')) {
      return 'Mesures temporaires en locaux de police';
    }
    if (l.contains('quiz generalites')) {
      return 'Testez vos connaissances sur les généralités';
    }

    // Cadres juridiques
    if (l.contains('cadres d\'enquête') || l.contains('cadres d’enquête')) {
      return 'Vue d’ensemble des différents cadres prévus par le code de procédure pénale';
    }

    if (l.contains('flagrant')) {
      return 'Enquête de police sur infraction flagrante (art. 53 à 73 du code de procédure pénale)';
    }

    if (l.contains('préliminaire') || l.contains('preliminaire')) {
      return 'Cadre d’enquête hors flagrance (art. 75 à 78 du code de procédure pénale)';
    }

    if (l.contains('commission') && l.contains('rogatoire')) {
      return 'Instruction déléguée par le juge (art. 81 et 151 à 154-2 du code de procédure pénale)';
    }

    if (l.contains('découverte') && l.contains('blessée')) {
      return 'Premiers actes en cas de blessé grave (art. 74 al. 6 du code de procédure pénale)';
    }

    if (l.contains('mort') ||
        l.contains('cause inconnue') ||
        l.contains('suspecte')) {
      return 'Constat, enquête et saisines (art. 74 et 80-4 du code de procédure pénale)';
    }

    if (l.contains('délinquance') || l.contains('criminalité')) {
      return 'Procédure renforcée pour la délinquance et la criminalité organisées';
    }

    if (l.contains('personnes') && l.contains('fuite')) {
      return 'Cadre juridique de la recherche des personnes recherchées (art. 74-2 du code de procédure pénale)';
    }

    if (l.contains('disparitions') || l.contains('inquiétantes')) {
      return 'Disparition de cause inconnue ou suspecte (art. 74-1 et 80-4 du code de procédure pénale)';
    }

    if (l.contains('contrôles') ||
        l.contains('vérifications') ||
        l.contains('identité')) {
      return 'Contrôles, relevés signalétiques et vérifications d’identité';
    }

    if (l.contains('entraide') || l.contains('internationale')) {
      return 'Coopération entre autorités judiciaires françaises et étrangères';
    }

    if (l.contains('quiz cadres')) {
      return 'Testez vos connaissances sur la procédure pénale';
    }

    // Procédure pénale — descriptions adaptées
    if (l.contains('action publique') ||
        l.contains('autorités') ||
        l.contains('police judiciaire') ||
        l.contains('mission de police')) {
      return 'Action civile/pénale, organisation, compétences, contrôle PJ';
    }

    if (l.contains('nullité') || l.contains('actes de procédure')) {
      return 'Causes, effets et régime juridique des nullités';
    }

    if (l.contains('juridictions') ||
        l.contains('jugement') ||
        l.contains('exécution des décisions')) {
      return 'Organisation, compétences, voies de recours, exécution';
    }

    if (l.contains('instruction préparatoire') ||
        l.contains('mandats de justice') ||
        l.contains('contrôle judiciaire') ||
        l.contains('détention provisoire') ||
        l.contains('detention provisoire')) {
      return 'Instruction, mandats, CJ, détention provisoire';
    }

    if (l.contains('quiz instruction')) {
      return 'Testez vos connaissances sur la procédure pénale';
    }

    // Par défaut
    return 'Module';
  }
}

// =====================  Mini-composants internes  =====================

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.isDark,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final bool isDark;
  final VoidCallback onTap;

  static const double _minHeight = 190;

  double _measureTextHeight({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: null, // ✅ on laisse le texte prendre la place nécessaire
    )..layout(maxWidth: maxWidth);

    return tp.size.height;
  }

  @override
  Widget build(BuildContext context) {
    final Color badgeBg = Colors.white.withOpacity(isDark ? 0.14 : 0.10);
    final Color borderClr = Colors.white.withOpacity(isDark ? 0.18 : 0.14);

    return LayoutBuilder(
      builder: (context, c) {
        // ---- Layout constants (doivent matcher ton design) ----
        const double pad = 16;
        const double badgeHApprox = 28; // approx (12px font + padding)
        const double gapAfterBadge = 10;
        const double gapTitleSub = 6;

        // CTA : on réserve de la place à droite pour ne jamais masquer le texte
        const double ctaApproxW = 118; // approx largeur "Découvrir"
        const double ctaApproxH = 44; // approx hauteur CTA
        const double gapBetweenTextAndCta = 12;

        // Largeur dispo pour le texte (on réserve la place du CTA)
        final double textMaxWidth =
            (c.maxWidth - (pad * 2) - ctaApproxW - gapBetweenTextAndCta).clamp(
              140.0,
              c.maxWidth,
            );

        final titleStyle = GoogleFonts.fustat(
          fontWeight: FontWeight.w900,
          fontSize: 24,
          color: Colors.white,
          height: 1.06,
        );

        final subtitleStyle = GoogleFonts.fustat(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white.withOpacity(.85),
          height: 1.15,
        );

        final double titleH = _measureTextHeight(
          text: title,
          style: titleStyle,
          maxWidth: textMaxWidth,
        );

        final double subH = subtitle.trim().isEmpty
            ? 0
            : _measureTextHeight(
                text: subtitle,
                style: subtitleStyle,
                maxWidth: textMaxWidth,
              );

        // Hauteur nécessaire du bloc bas (texte + CTA)
        // On prend le max entre (hauteur texte) et (hauteur CTA) pour que tout rentre.
        final double bottomBlockH = math.max(
          titleH + (subH > 0 ? (gapTitleSub + subH) : 0),
          ctaApproxH,
        );

        final double computedHeight =
            pad + badgeHApprox + gapAfterBadge + bottomBlockH + pad;

        final double cardHeight = computedHeight < _minHeight
            ? _minHeight
            : computedHeight;

        return GestureDetector(
          onTap: onTap,
          child: Semantics(
            button: true,
            label: '$title — découvrir',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: cardHeight, // ✅ hauteur bornée => plus de hasSize
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'hero_$tag',
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),

                    // gradient
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(.10),
                            Colors.black.withOpacity(.55),
                            Colors.black.withOpacity(.78),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),

                    // contenu
                    Padding(
                      padding: const EdgeInsets.all(pad),
                      child: Stack(
                        children: [
                          // Badge
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: borderClr),
                              ),
                              child: Text(
                                'Module',
                                style: GoogleFonts.fustat(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Texte (bas gauche) — ✅ ne se fait jamais recouvrir par le CTA
                          Positioned(
                            left: 0,
                            right: ctaApproxW + gapBetweenTextAndCta,
                            bottom: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: titleStyle,
                                ),
                                if (subtitle.trim().isNotEmpty) ...[
                                  const SizedBox(height: gapTitleSub),
                                  Text(
                                    subtitle,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: subtitleStyle,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // CTA (bas droite)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: _RoundCTA(onTap: onTap),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoundCTA extends StatelessWidget {
  const _RoundCTA({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.12),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                'Découvrir',
                style: GoogleFonts.fustat(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
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

// =====================  Progression  =====================

class ProgressSummary {
  final int seenModules;
  final int totalModules;
  final int streakDays;
  final Duration weeklyStudy;
  final List<RecentDone> recentDone;

  final int finishedQuizzes; // ✅ NEW

  const ProgressSummary({
    required this.seenModules,
    required this.totalModules,
    required this.streakDays,
    required this.weeklyStudy,
    required this.recentDone,
    required this.finishedQuizzes, // ✅ NEW
  });

  double get progress =>
      totalModules == 0 ? 0.0 : (seenModules / totalModules).clamp(0.0, 1.0);

  int get percent => (progress * 100).round();
}

class RecentDone {
  final String moduleName;
  final int correct;
  final int total;
  final DateTime finishedAt;

  const RecentDone({
    required this.moduleName,
    required this.correct,
    required this.total,
    required this.finishedAt,
  });

  int get scorePercent => total == 0 ? 0 : ((correct / total) * 100).round();
}

Color scoreColor(BuildContext context, int percent) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (percent >= 80) {
    return isDark ? const Color(0xFF37D67A) : const Color(0xFF17A34A); // vert
  }
  if (percent >= 50) {
    return isDark ? const Color(0xFFFFB020) : const Color(0xFFF59E0B); // orange
  }
  return isDark ? const Color(0xFFFF5A6A) : const Color(0xFFEF4444); // rouge
}

String scoreLabel(int percent) {
  if (percent >= 80) return 'Excellent';
  if (percent >= 50) return 'Correct';
  return 'À revoir';
}

class UiTokensV4 {
  final bool isDark;

  final Color ink;
  final Color muted;
  final Color border;
  final Color track;

  final Color surface;
  final Color glass;

  /// ✅ Marque fixe
  final Color brand;

  /// ✅ Couleur utilisée pour la barre d’AVANCEMENT
  /// (on la garde en "score" pour ne pas casser ton code existant)
  final Color score;

  UiTokensV4._({
    required this.isDark,
    required this.ink,
    required this.muted,
    required this.border,
    required this.track,
    required this.surface,
    required this.glass,
    required this.brand,
    required this.score,
  });

  factory UiTokensV4.of(
    BuildContext context, {
    required int percent,
    Color? brandAccent,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ink = isDark ? Colors.white : const Color(0xFF111111);
    final muted = ink.withOpacity(.62);

    final surface = isDark
        ? Colors.white.withOpacity(.06)
        : Colors.black.withOpacity(.03);

    final glass = isDark
        ? Colors.white.withOpacity(.055)
        : Colors.white.withOpacity(.74);

    final border = ink.withOpacity(isDark ? .12 : .10);
    final track = ink.withOpacity(isDark ? .14 : .10);

    final brand =
        brandAccent ??
        (isDark ? const Color(0xFF8AB4FF) : const Color(0xFF2563EB));

    // ✅ IMPORTANT :
    // la barre d'avancement ne doit PAS devenir rouge juste parce que 6% d'avancement.
    // Donc on force la couleur de "barre" à la marque.
    final score = brand;

    return UiTokensV4._(
      isDark: isDark,
      ink: ink,
      muted: muted,
      border: border,
      track: track,
      surface: surface,
      glass: glass,
      brand: brand,
      score: score,
    );
  }

  SweepGradient brandSweep(double t) => SweepGradient(
    transform: GradientRotation(t * 2 * math.pi),
    colors: [
      brand.withOpacity(isDark ? .95 : .85),
      brand.withOpacity(isDark ? .22 : .16),
      brand.withOpacity(isDark ? .95 : .85),
    ],
  );

  SweepGradient scoreSweep(double t) => SweepGradient(
    transform: GradientRotation((t + .18) * 2 * math.pi),
    colors: [
      score.withOpacity(isDark ? .95 : .85),
      score.withOpacity(isDark ? .22 : .16),
      score.withOpacity(isDark ? .95 : .85),
    ],
  );

  LinearGradient brandTint() => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brand.withOpacity(isDark ? .18 : .14), Colors.transparent],
  );
}

class ProgressCardV4 extends StatelessWidget {
  final ProgressSummary data;
  final VoidCallback? onTapDetails;
  final Color? brandAccent;

  const ProgressCardV4({
    super.key,
    required this.data,
    this.onTapDetails,
    this.brandAccent,
  });

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h <= 0) return '${m} min';
    return '${h} h ${m.toString().padLeft(2, '0')}';
  }

  // Niveau = moyenne des 5 derniers quiz (ou moins si <5)
  _MasteryStatus _computeMastery(BuildContext context) {
    final theme = Theme.of(context);
    final recents = data.recentDone;

    if (recents.isEmpty) {
      return _MasteryStatus(
        label: 'Commencer',
        icon: Icons.play_arrow_rounded,
        color: theme.hintColor,
        avgScore: null,
      );
    }

    final takeN = recents.take(5).toList();
    final avg =
        takeN.map((e) => e.scorePercent).reduce((a, b) => a + b) / takeN.length;

    final p = avg.round();

    if (p >= 85) {
      return _MasteryStatus(
        label: 'Excellent',
        icon: Icons.verified_rounded,
        color: Colors.green,
        avgScore: p,
      );
    }
    if (p >= 70) {
      return _MasteryStatus(
        label: 'Bien',
        icon: Icons.thumb_up_rounded,
        color: Colors.blue,
        avgScore: p,
      );
    }
    return _MasteryStatus(
      label: 'À revoir',
      icon: Icons.priority_high_rounded,
      color: Colors.redAccent,
      avgScore: p,
    );
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT : uiT.score DOIT suivre l'avancement (pas le niveau)
    // Donc on garde percent = data.percent (avancement)
    final uiT = UiTokensV4.of(
      context,
      percent: data.percent,
      brandAccent: brandAccent,
    );

    final mastery = _computeMastery(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: uiT.glass,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: uiT.border),
            boxShadow: const [_T.shadow],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= Header =================
                Row(
                  children: [
                    _BrandIconTile(uiT: uiT),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Progression',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: uiT.ink,
                        ),
                      ),
                    ),
                    if (onTapDetails != null)
                      _DetailsButtonV4(
                        uiT: uiT,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTapDetails!.call();
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // ================= Ligne Avancement (clair) =================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 6%
                    Text(
                      '${data.percent}%',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: uiT.ink,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Labels + modules
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Avancement',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: uiT.muted,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Modules complétés : ${data.seenModules} / ${data.totalModules}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: uiT.muted,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ================= Barre = Avancement UNIQUEMENT =================
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: data.progress,
                    minHeight: 10,
                    backgroundColor: uiT.track,
                    // Couleur cohérente, pas "rouge niveau"
                    valueColor: AlwaysStoppedAnimation<Color>(uiT.brand),
                  ),
                ),

                const SizedBox(height: 8),

                // ================= Petit helper =================
                Text(
                  '${data.finishedQuizzes} quiz terminés',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: uiT.brand,
                  ),
                ),

                const SizedBox(height: 12),

                // ================= Ligne Niveau (séparée, impossible à confondre) =================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: uiT.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: uiT.border),
                  ),
                  child: Row(
                    children: [
                      // pastille couleur
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: mastery.color.withOpacity(
                            uiT.isDark ? .90 : .85,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: mastery.color.withOpacity(
                                uiT.isDark ? .20 : .14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      Icon(mastery.icon, size: 18, color: mastery.color),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          'Niveau : ${mastery.label}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: uiT.ink,
                            height: 1.0,
                          ),
                        ),
                      ),

                      if (mastery.avgScore != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: mastery.color.withOpacity(.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: mastery.color.withOpacity(.22),
                            ),
                          ),
                          child: Text(
                            '${mastery.avgScore}%',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: mastery.color,
                              height: 1.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ================= Stats =================
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _StatPillV4(
                      uiT: uiT,
                      icon: Icons.local_fire_department_rounded,
                      label: 'Série',
                      value: '${data.streakDays} j',
                    ),
                    _StatPillV4(
                      uiT: uiT,
                      icon: Icons.schedule_rounded,
                      label: 'Semaine',
                      value: _formatDuration(data.weeklyStudy),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MasteryStatus {
  final String label;
  final IconData icon;
  final Color color;
  final int? avgScore;

  const _MasteryStatus({
    required this.label,
    required this.icon,
    required this.color,
    required this.avgScore,
  });
}

class _TinyPill extends StatelessWidget {
  final String text;
  final UiTokensV4 uiT;

  const _TinyPill({required this.text, required this.uiT});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: uiT.brand.withOpacity(uiT.isDark ? .10 : .08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: uiT.brand.withOpacity(.18)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 10.5,
          color: uiT.brand,
          height: 1.0,
        ),
      ),
    );
  }
}

class _MasteryChipV4 extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String? trailingText;

  const _MasteryChipV4({
    required this.label,
    required this.icon,
    required this.color,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: color,
              height: 1.0,
            ),
          ),
          if (trailingText != null) ...[
            const SizedBox(width: 8),
            Text(
              trailingText!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: color,
                height: 1.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrandIconTile extends StatelessWidget {
  final UiTokensV4 uiT;
  const _BrandIconTile({required this.uiT});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [uiT.brand.withOpacity(uiT.isDark ? .22 : .16), uiT.surface],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: uiT.border),
      ),
      child: Icon(Icons.trending_up_rounded, color: uiT.brand, size: 20),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final UiTokensV4 uiT;
  final int percent;

  const _ScoreChip({required this.uiT, required this.percent});

  @override
  Widget build(BuildContext context) {
    final label = scoreLabel(percent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: uiT.score.withOpacity(uiT.isDark ? .14 : .10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: uiT.score.withOpacity(.26)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w900,
          fontSize: 11.5,
          color: uiT.score,
          height: 1,
        ),
      ),
    );
  }
}

class _DetailsButtonV4 extends StatefulWidget {
  final UiTokensV4 uiT;
  final VoidCallback onTap;

  const _DetailsButtonV4({required this.uiT, required this.onTap});

  @override
  State<_DetailsButtonV4> createState() => _DetailsButtonV4State();
}

class _DetailsButtonV4State extends State<_DetailsButtonV4> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: widget.uiT.brand.withOpacity(widget.uiT.isDark ? .12 : .10),
            border: Border.all(color: widget.uiT.brand.withOpacity(.28)),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: widget.uiT.brand.withOpacity(
                  widget.uiT.isDark ? .12 : .08,
                ),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Détails',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  color: widget.uiT.brand,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: widget.uiT.brand,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPillV4 extends StatelessWidget {
  final UiTokensV4 uiT;
  final IconData icon;
  final String label;
  final String value;

  const _StatPillV4({
    required this.uiT,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: uiT.brand.withOpacity(uiT.isDark ? .10 : .08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: uiT.brand.withOpacity(.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: uiT.brand),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: uiT.muted,
              fontSize: 12,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (uiT.isDark ? Colors.white : Colors.black).withOpacity(
                .06,
              ),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: (uiT.isDark ? Colors.white : Colors.black).withOpacity(
                  .08,
                ),
              ),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                color: uiT.ink,
                fontSize: 12,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressRepository {
  final SupabaseClient supabase;
  ProgressRepository(this.supabase);

  /// ✅ Filtre la progression par `track` + `mode`
  ///
  /// - track: ex "pa", "gpx"...
  /// - mode:  ex "school", "terrain"...
  ///
  /// IMPORTANT : adapte la valeur envoyée si dans ta BDD tu stockes
  /// "PA" au lieu de "pa", etc.
  Future<ProgressSummary> loadProgress({
    required String uid,
    required int totalModules,
    required String track,
    required String mode,
  }) async {
    final now = DateTime.now();

    final weekday = now.weekday; // 1..7
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: weekday - 1));

    // ✅ Ici, le vrai fix : on filtre par uid + track + mode
    final rows = await supabase
        .from('quiz_history')
        .select(
          'module_name, quiz_name, total_questions, correct_count, started_at, finished_at, track, mode',
        )
        .eq('uid', uid)
        .eq('track', track)
        .eq('mode', mode)
        .not('finished_at', 'is', null)
        .order('finished_at', ascending: false)
        .limit(300);

    DateTime? parseDT(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());

    final finished = <Map<String, dynamic>>[];
    for (final r in rows) {
      final f = parseDT(r['finished_at']);
      if (f == null) continue;
      finished.add({...r, '_finished': f});
    }

    // ✅ tentatives terminées (dans CE track/mode)
    final finishedQuizzes = finished.length;

    // ✅ modules uniques complétés (dans CE track/mode)
    // On privilégie module_name, sinon quiz_name
    final seen = <String>{};
    for (final r in finished) {
      final module = (r['module_name'] ?? '').toString().trim();
      final quiz = (r['quiz_name'] ?? '').toString().trim();
      final key = module.isNotEmpty ? module : quiz;
      if (key.isNotEmpty) seen.add(key);
    }

    // ✅ streak (jours consécutifs)
    final days = <DateTime>{};
    for (final r in finished) {
      final f = r['_finished'] as DateTime;
      days.add(DateTime(f.year, f.month, f.day));
    }

    int streak = 0;
    if (days.isNotEmpty) {
      final today = DateTime(now.year, now.month, now.day);

      DateTime cursor = days.contains(today)
          ? today
          : days.contains(today.subtract(const Duration(days: 1)))
          ? today.subtract(const Duration(days: 1))
          : today;

      while (days.contains(cursor)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      }
    }

    // ✅ temps de travail semaine
    Duration weekly = Duration.zero;
    for (final r in finished) {
      final f = r['_finished'] as DateTime;
      if (f.isBefore(startOfWeek)) break;

      final s = parseDT(r['started_at']);
      if (s == null) continue;

      final diff = f.difference(s);
      if (diff.isNegative) continue;

      // évite les sessions oubliées ouvertes
      if (diff.inHours > 3) continue;

      weekly += diff;
    }

    // ✅ 5 derniers quiz
    final recent = finished
        .take(5)
        .map((r) {
          final module = (r['module_name'] ?? '').toString().trim();
          final quiz = (r['quiz_name'] ?? '').toString().trim();
          final title = module.isNotEmpty
              ? module
              : (quiz.isNotEmpty ? quiz : 'Quiz');

          final total = (r['total_questions'] ?? 0) as int;
          final correct = (r['correct_count'] ?? 0) as int;
          final f = r['_finished'] as DateTime;

          return RecentDone(
            moduleName: title,
            correct: correct,
            total: total,
            finishedAt: f,
          );
        })
        .toList(growable: false);

    return ProgressSummary(
      seenModules: seen.length,
      totalModules: totalModules,
      finishedQuizzes: finishedQuizzes,
      streakDays: streak,
      weeklyStudy: weekly,
      recentDone: recent,
    );
  }
}

// ======================================================================
//                        CONFIGS LOCALES (PA SCHOOL)
// ======================================================================

const Map<PaSchoolProgram, List<CategoryConfig>> paSchoolCategoriesConfig = {
  // =========================================================
  // 1) INSTITUTION & VALEURS
  // =========================================================
  PaSchoolProgram.institutionValeurs: [
    CategoryConfig(
      label: 'Formation initiale',
      badge: 'Bases & méthodo',
      image: 'assets/images/copic_institutions.jpg',
      route: '/pa/institution/formation_initiale',
      subcategories: [
        SubCategoryConfig(
          label: 'La formation initiale',
          route: '/pa/institution/formation_initiale/formation',
          image: 'assets/images/copic_institutions.jpg',
        ),
        SubCategoryConfig(
          label: 'Mémento prise de notes & méthodologie',
          route: '/pa/institution/formation_initiale/memento_notes',
          image: 'assets/images/concours_connaissances_generales.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Organisation de la Police Nationale',
      badge: 'Structures & rôles',
      image: 'assets/images/background.jpeg',
      route: '/pa/institution/organisation_pn',
      subcategories: [
        SubCategoryConfig(
          label: 'Organigramme du Ministère de l’Intérieur',
          route: '/pa/institution/organisation_pn/organigramme_mi',
          image: 'assets/images/organigramme_mi.jpeg',
        ),
        SubCategoryConfig(
          label: 'Organisation & Direction de la Police Nationale',
          route: '/pa/institution/organisation_pn/organisation',
        ),
        SubCategoryConfig(
          label: 'Direction générale de la sécurité intérieure',
          route: '/pa/institution/organisation_pn/dgsi.jpeg',
          image: 'assets/images/dgsi.jpeg',
        ),
        SubCategoryConfig(
          label: 'Préfecture de police',
          route: '/pa/institution/organisation_pn/prefecture_police',
          image: 'assets/images/prefecture_police.jpeg',
        ),
        SubCategoryConfig(
          label: 'Organigrammes',
          route: '/pa/institution/organisation_pn/organigrammes',
        ),
        SubCategoryConfig(
          label: 'Hiérarchie des personnels de la Police Nationale',
          route: '/pa/institution/organisation_pn/hierarchie',
          image: 'assets/images/hierarchie_police.jpeg',
        ),
        SubCategoryConfig(
          label: 'Règles d’emploi des policiers adjoints',
          route: '/pa/institution/organisation_pn/regles_emploi_pa',
          image: 'assets/images/regles_emploi_pa.jpeg',
        ),
        SubCategoryConfig(
          label: 'Horaires de service en sécurité publique',
          route: '/pa/institution/organisation_pn/horaires_service_sp',
          image: 'assets/images/horaires_service_sp.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Déontologie',
      badge: 'Éthique & cadre',
      image: 'assets/images/cat_organisation.jpg',
      route: '/pa/institution/deontologie',
      subcategories: [
        SubCategoryConfig(
          label: 'Code de déontologie commenté (PN & GN)',
          route: '/pa/institution/deontologie/code_commente',
          image: 'assets/images/code_commente.webp',
        ),
        SubCategoryConfig(
          label: 'Marques extérieures de respect (salut, présentation)',
          route: '/pa/institution/deontologie/marques_respect',
          image: 'assets/images/marques_respect.jpeg',
        ),
        SubCategoryConfig(
          label: 'Droits & obligations des policiers',
          route: '/pa/institution/deontologie/droits_obligations',
        ),
        SubCategoryConfig(
          label: 'Policier hors service : dois-je intervenir ? (AMARIS)',
          route: '/pa/institution/deontologie/hors_service_amaris',
          image: 'assets/images/hors_service_amaris.jpeg',
        ),
        SubCategoryConfig(
          label: 'Sanctions & récompenses',
          route: '/pa/institution/deontologie/sanctions_recompenses',
          image: 'assets/images/sanction.jpeg',
        ),
        SubCategoryConfig(
          label: 'Enquête administrative',
          route: '/pa/institution/deontologie/enquete_administrative',
        ),
        SubCategoryConfig(
          label: 'Usage des réseaux sociaux',
          route: '/pa/institution/deontologie/reseaux_sociaux',
          image: 'assets/images/reseaux_sociaux.jpg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Information de la hiérarchie',
      badge: 'Écrits pro',
      image: 'assets/images/cat_hierarchie.jpg',
      route: '/pa/institution/hierarchie_info',
      subcategories: [
        SubCategoryConfig(
          label: 'Le compte-rendu',
          route: '/pa/institution/hierarchie_info/compte_rendu',
          image: 'assets/images/compte_rendu.jpeg',
        ),
        SubCategoryConfig(
          label: 'Le formalisme du rapport',
          route: '/pa/institution/hierarchie_info/formalisme_rapport',
          image: 'assets/images/formalisme_rapport.jpeg',
        ),
        SubCategoryConfig(
          label: 'Modèles de rapports',
          route: '/pa/institution/hierarchie_info/modeles',
          image: 'assets/images/modeles.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Accueil du public',
      badge: 'Victimes & assistance',
      image: 'assets/images/image1.jpeg',
      route: '/pa/institution/accueil_public',
      subcategories: [
        SubCategoryConfig(
          label: 'Charte de l’accueil du public & assistance aux victimes',
          route: '/pa/institution/accueil_public/charte',
          image: 'assets/images/charte.jpeg',
        ),
        SubCategoryConfig(
          label: 'Référentiel Marianne',
          route: '/pa/institution/accueil_public/marianne',
          image: 'assets/images/marianne.jpg',
        ),
        SubCategoryConfig(
          label: 'Dépliants & doctrine accueil / prise en charge',
          route: '/pa/institution/accueil_public/doctrine',
          image: 'assets/images/doctrine.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quelques démarches administratives',
          route: '/pa/institution/accueil_public/demarches',
        ),
        SubCategoryConfig(
          label: 'Protection des locaux de police',
          route: '/pa/institution/accueil_public/protection_locaux',
          image: 'assets/images/protection_locaux.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Laïcité, police et religions',
      badge: 'Neutralité',
      image: 'assets/images/image6.jpg',
      route: '/pa/institution/laicite',
      subcategories: [
        SubCategoryConfig(
          label: 'La laïcité (DLPAJ / bureau des cultes)',
          route: '/pa/institution/laicite/laicite_dlpaj',
          image: 'assets/images/laicite_dlpaj.jpeg',
        ),
        SubCategoryConfig(
          label: 'Charte de la laïcité dans les services publics',
          route: '/pa/institution/laicite/charte',
          image: 'assets/images/charte_laicite.jpeg',
        ),
        SubCategoryConfig(
          label: 'Principaux rites & pratiques des cultes en France',
          route: '/pa/institution/laicite/rites_cultes',
          image: 'assets/images/rites_cultes.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Histoire de la police',
      badge: 'Repères',
      image: 'assets/images/image4.jpeg',
      route: '/pa/institution/histoire',
      subcategories: [
        SubCategoryConfig(
          label: 'Points de repères chronologiques',
          route: '/pa/institution/histoire/reperes',
        ),
      ],
    ),
  ],

  PaSchoolProgram.dpsDpg: [
    CategoryConfig(
      label: 'Généralités',
      badge: 'Socle initial',
      image: 'assets/images/generalite.jpeg',
      route: '/pa/dps_dpg/socle_initial/generalites',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des infractions',
          route: '/gpx/generalites/classification_infractions',
        ),
        SubCategoryConfig(
          label: 'L’infraction',
          route: '/gpx/generalites/infraction_intro',
        ),
        SubCategoryConfig(
          label: 'La tentative punissable',
          route: '/gpx/generalites/tentative_intro',
        ),
        SubCategoryConfig(
          label: 'La complicité',
          route: '/gpx/generalites/complicite_intro',
        ),
        SubCategoryConfig(
          label: 'La légitime défense',
          route: '/gpx/generalites/legitimedefense_intro',
        ),
        SubCategoryConfig(
          label: 'Cadre légal d’usage des armes',
          route: '/gpx/generalites/usagedesarmes_intro',
        ),
        SubCategoryConfig(
          label: 'Les libertés publiques',
          route: '/gpx/generalites/libertespubliques_intro',
        ),
        SubCategoryConfig(
          label: 'Rétention dans les locaux de police',
          route: '/gpx/generalites/retention_locaux_police_intro',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Hiérarchie — fonctions judiciaires',
      badge: 'Socle initial',
      image: 'assets/images/cat_hierarchie.jpg',
      route: '/pa/dps_dpg/socle_initial/hierarchie',
      subcategories: [
        SubCategoryConfig(
          label: 'Hiérarchie des personnels de la Police Nationale',
          route: '/gpx/generalites/hierarchie_intro',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Cadres juridiques',
      badge: 'Socle initial',
      image: 'assets/images/cadres_juridiques.jpeg',
      route: '/pa/dps_dpg/socle_initial/cadres_juridiques',
      subcategories: [
        SubCategoryConfig(
          label: 'Les cadres d\'enquête',
          route: '/gpx/generalites/cadres_enquete_intro',
        ),
        SubCategoryConfig(
          label: 'L’enquête de flagrant délit',
          route: '/gpx/generalites/flagrant_delit_intro',
        ),
        SubCategoryConfig(
          label: 'L’enquête préliminaire',
          route: '/gpx/generalites/enquete_preliminaire_intro',
        ),
        SubCategoryConfig(
          label: 'La commission rogatoire',
          route: '/gpx/generalites/commission_rogatoire_intro',
        ),
        SubCategoryConfig(
          label: 'Découverte d’une personne grièvement blessée',
          route: '/gpx/generalites/personne_blessee_intro',
        ),
        SubCategoryConfig(
          label: 'Mort de cause inconnue ou suspecte',
          route: '/gpx/generalites/mort_inconnue_intro',
        ),
        SubCategoryConfig(
          label: 'Délinquance & criminalité organisées',
          route: '/gpx/generalites/criminalite_deliquance_intro',
        ),
        SubCategoryConfig(
          label: 'Recherche des personnes en fuite',
          route: '/gpx/generalites/personnes_fuite_intro',
        ),
        SubCategoryConfig(
          label: 'Disparitions inquiétantes',
          route: '/gpx/cadres_juridiques/disparitions_inquietantes_intro',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Contrôle d’identité',
      badge: 'Socle initial',
      image: 'assets/images/controle_identite.jpeg',
      route: '/pa/dps_dpg/socle_initial/controle_identite',
      subcategories: [
        SubCategoryConfig(
          label: 'Contrôles et vérifications d’identité',
          route: '/gpx/generalites/flagrant_delit_intro',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Circulation routière',
      badge: 'Socle initial',
      image: 'assets/images/circulation_routiere.jpeg',
      route: '/pa/dps_dpg/socle_initial/circulation',
      subcategories: [
        SubCategoryConfig(
          label: 'Compétences des agents verbalisateurs',
          route: '/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs',
        ),
        SubCategoryConfig(
          label: 'Conduite après usage de stupéfiants',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/conduite_stupefiants',
        ),
        SubCategoryConfig(
          label: 'Conduite en état d’ivresse',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/ivresse',
        ),
        SubCategoryConfig(
          label: 'Conduite sous l’empire d’un état alcoolique',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/etat_alcoolique',
        ),
        SubCategoryConfig(
          label: 'Défaut d’assurance',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/defaut_assurance',
        ),
        SubCategoryConfig(
          label: 'Défaut de permis de conduire',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/defaut_permis',
        ),
        SubCategoryConfig(
          label: 'Délit de fuite',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/delit_fuite',
        ),
        SubCategoryConfig(
          label: 'Grand excès de vitesse',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/grand_exces_vitesse',
        ),
        SubCategoryConfig(
          label: 'Refus de vérifications',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/refus_verifications',
        ),
        SubCategoryConfig(
          label: 'Refus d’obtempérer',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/refus_obtemperer',
        ),
        SubCategoryConfig(
          label: 'Rodéo motorisé',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/rodeo_motorise',
        ),
        SubCategoryConfig(
          label: 'Plaques & inscriptions (délits liés)',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/plaques_inscriptions',
        ),
        SubCategoryConfig(
          label: 'Incitation / organisation / promotion',
          route:
              '/gpx_scolarité_pages/infraction_circulation_routière_pages/incitation_organisation_promotion',
        ),
        SubCategoryConfig(
          label: 'Quiz — Infractions à la circulation routière',
          route:
              '/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Organisation judiciaire',
      badge: 'Socle initial',
      image: 'assets/images/cat_organisation.jpg',
      route: '/pa/dps_dpg/socle_initial/organisation_judiciaire',
      subcategories: [
        SubCategoryConfig(
          label: 'L’organisation judiciaire',
          route:
              '/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation',
        ),
        SubCategoryConfig(
          label: 'La magistrature',
          route:
              '/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Atteintes aux biens',
      badge: 'Socle initial',
      image: 'assets/images/contre_biens.png',
      route: '/pa/dps_dpg/socle_initial/atteintes_biens',
      subcategories: [
        SubCategoryConfig(
          label: 'Le vol',
          route: '/pa/dps_dpg/socle_initial/atteintes_biens/vol',
        ),
        SubCategoryConfig(
          label: 'Destructions, dégradations, détériorations',
          route: '/pa/dps_dpg/socle_initial/atteintes_biens/destructions',
        ),
        SubCategoryConfig(
          label: 'Infractions sans danger pour les personnes',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_biens/sans_danger_personnes',
        ),
        SubCategoryConfig(
          label: 'Infractions dangereuses pour les personnes',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_biens/dangereuses_personnes',
        ),
        SubCategoryConfig(
          label: 'Tags et graffitis',
          route: '/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Atteintes aux personnes',
      badge: 'Socle initial',
      image: 'assets/images/contre_personne.png',
      route: '/pa/dps_dpg/socle_initial/atteintes_personnes',
      subcategories: [
        SubCategoryConfig(
          label: 'Les discriminations',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/discriminations',
        ),
        SubCategoryConfig(
          label: 'Les violences volontaires',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/violences_volontaires',
        ),
        SubCategoryConfig(
          label: 'Les violences habituelles',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/violences_habituelles',
        ),
        SubCategoryConfig(
          label: 'Violences contre les forces de sécurité intérieure',
          route: '/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi',
        ),
        SubCategoryConfig(
          label: 'Atteintes volontaires à la vie',
          route: '/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie',
        ),
        SubCategoryConfig(
          label: 'Le viol',
          route: '/pa/dps_dpg/socle_initial/atteintes_personnes/viol',
        ),
        SubCategoryConfig(
          label: 'Agressions sexuelles',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/agressions_sexuelles',
        ),
        SubCategoryConfig(
          label: 'Harcèlement sexuel',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/harcelement_sexuel',
        ),
        SubCategoryConfig(
          label: 'Exhibition sexuelle',
          route: '/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition',
        ),
        SubCategoryConfig(
          label: 'Mise en péril des mineurs',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril',
        ),
        SubCategoryConfig(
          label: 'Atteinte à l’intimité d’une personne',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/atteinte_intimite',
        ),
        SubCategoryConfig(
          label: 'Outrage sexiste et sexuel',
          route:
              '/pa/dps_dpg/socle_initial/atteintes_personnes/outrage_sexiste',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Autorité de l’État',
      badge: 'Socle initial',
      image: 'assets/images/repression.png',
      route: '/pa/dps_dpg/socle_initial/autorite_etat',
      subcategories: [
        SubCategoryConfig(
          label: 'Refus d’obtempérer',
          route: '/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer',
        ),
        SubCategoryConfig(
          label: 'L’outrage',
          route: '/pa/dps_dpg/socle_initial/autorite_etat/outrage',
        ),
        SubCategoryConfig(
          label: 'La rébellion',
          route: '/pa/dps_dpg/socle_initial/autorite_etat/rebellion',
        ),
        SubCategoryConfig(
          label: 'Provocation directe à la rébellion',
          route:
              '/pa/dps_dpg/socle_initial/autorite_etat/provocation_rebellion',
        ),
      ],
    ),

    // =======================================================
    // SOCLE AVANCÉ — D.P.S / D.P.G
    // =======================================================
    CategoryConfig(
      label: 'Généralités',
      badge: 'Socle avancé',
      image: 'assets/images/droit_penal_general.jpeg',
      route: '/pa/dps_dpg/socle_avance/generalites',
      subcategories: [
        SubCategoryConfig(
          label: 'Le droit pénal',
          route: '/pa/dps_dpg/socle_avance/generalites/droit_penal',
        ),
        SubCategoryConfig(
          label: 'Immunités et inviolabilités',
          route:
              '/pa/dps_dpg/socle_avance/generalites/immunites_inviolabilites',
        ),
        SubCategoryConfig(
          label: 'La responsabilité pénale',
          route: '/pa/dps_dpg/socle_avance/generalites/responsabilite_penale',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Acteurs de la Police Judiciaire',
      badge: 'Socle avancé',
      image: 'assets/images/pp_action_publique_autorites_pj.png',
      route: '/pa/dps_dpg/socle_avance/acteurs_pj',
      subcategories: [
        SubCategoryConfig(
          label: 'Compétences des OPJ',
          route: '/pa/dps_dpg/socle_avance/acteurs_pj/opj',
        ),
        SubCategoryConfig(
          label: 'Compétences des APJ',
          route: '/pa/dps_dpg/socle_avance/acteurs_pj/apj',
        ),
        SubCategoryConfig(
          label: 'Assistants d’enquête',
          route: '/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete',
        ),
        SubCategoryConfig(
          label: 'Prérogatives judiciaires (OPJ / APJ / APJA)',
          route: '/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives',
        ),
        SubCategoryConfig(
          label: 'Le procureur de la République',
          route: '/pa/dps_dpg/socle_avance/acteurs_pj/procureur',
        ),
        SubCategoryConfig(
          label: 'Le juge d’instruction',
          route: '/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Atteintes aux biens',
      badge: 'Socle avancé',
      image: 'assets/images/contre_biens.png',
      route: '/pa/dps_dpg/socle_avance/atteintes_biens',
      subcategories: [
        SubCategoryConfig(
          label: 'L’extorsion',
          route: '/pa/dps_dpg/socle_avance/atteintes_biens/extorsion',
        ),
        SubCategoryConfig(
          label: 'L’escroquerie',
          route: '/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie',
        ),
        SubCategoryConfig(
          label: 'L’abus de confiance',
          route: '/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance',
        ),
        SubCategoryConfig(
          label: 'La filouterie',
          route: '/pa/dps_dpg/socle_avance/atteintes_biens/filouterie',
        ),
        SubCategoryConfig(
          label: 'Le recel',
          route: '/pa/dps_dpg/socle_avance/atteintes_biens/recel',
        ),
        SubCategoryConfig(
          label: 'Abstention volontaire de combattre un sinistre',
          route: '/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Atteintes aux personnes',
      badge: 'Socle avancé',
      image: 'assets/images/contre_personne.png',
      route: '/pa/dps_dpg/socle_avance/atteintes_personnes',
      subcategories: [
        SubCategoryConfig(
          label: 'Atteintes involontaires à la vie et à l’intégrité',
          route: '/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires',
        ),
        SubCategoryConfig(
          label: 'Menaces contre les personnes',
          route: '/pa/dps_dpg/socle_avance/atteintes_personnes/menaces',
        ),
        SubCategoryConfig(
          label: 'Entrave volontaire à l’arrivée des secours',
          route: '/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours',
        ),
        SubCategoryConfig(
          label: 'Non-obstacle à la commission d’un crime ou délit',
          route: '/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle',
        ),
        SubCategoryConfig(
          label: 'Non-assistance à personne en péril',
          route: '/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance',
        ),
        SubCategoryConfig(
          label: 'Appels téléphoniques malveillants',
          route:
              '/pa/dps_dpg/socle_avance/atteintes_personnes/appels_malveillants',
        ),
        SubCategoryConfig(
          label: 'Risque causé à autrui',
          route: '/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Délits routiers',
      badge: 'Socle avancé',
      image: 'assets/images/circulation_routiere.jpeg',
      route: '/pa/dps_dpg/socle_avance/delits_routiers',
      subcategories: [
        SubCategoryConfig(
          label: 'Rodéo motorisé',
          route: '/pa/dps_dpg/socle_avance/delits_routiers/rodeo',
        ),
        SubCategoryConfig(
          label: 'Incitation / organisation / promotion',
          route: '/pa/dps_dpg/socle_avance/delits_routiers/incitation',
        ),
        SubCategoryConfig(
          label: 'Délit de fuite',
          route: '/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite',
        ),
        SubCategoryConfig(
          label: 'Refus d’obtempérer',
          route: '/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer',
        ),
        SubCategoryConfig(
          label:
              'Autres délits routiers (alcool, stup, permis, vérifications…)',
          route: '/pa/dps_dpg/socle_avance/delits_routiers/autres',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Autorité de l’État',
      badge: 'Socle avancé',
      image: 'assets/images/repression.png',
      route: '/pa/dps_dpg/socle_avance/autorite_etat',
      subcategories: [
        SubCategoryConfig(
          label: 'Menaces envers les dépositaires de l’autorité publique',
          route: '/pa/dps_dpg/socle_avance/autorite_etat/menaces',
        ),
        SubCategoryConfig(
          label: 'Corruption passive',
          route: '/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive',
        ),
        SubCategoryConfig(
          label: 'Corruption active',
          route: '/pa/dps_dpg/socle_avance/autorite_etat/corruption_active',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Stupéfiants',
      badge: 'Socle avancé',
      image: 'assets/images/stupefiants.jpeg',
      route: '/pa/dps_dpg/socle_avance/stupefiants',
      subcategories: [
        SubCategoryConfig(
          label: 'Usage illicite de stupéfiants',
          route: '/pa/dps_dpg/socle_avance/stupefiants/usage_illicite',
        ),
        SubCategoryConfig(
          label: 'Cession / offre illicites (consommation personnelle)',
          route: '/pa/dps_dpg/socle_avance/stupefiants/cession_offre',
        ),
      ],
    ),
  ],
};

const Map<String, String> redirectConfig = {
  // Généralités
  '/generalite': '/gpx_scolarité_pages/generalite_pages',
  '/classification_infractions': '/gpx/generalites/classification_infractions',
  '/infraction': '/gpx/generalites/infraction',
  '/tentative_punissable': '/gpx/generalites/tentative_punissable',
  '/complicite': '/gpx/generalites/complicite',
  '/legitime_defense': '/gpx/generalites/legitime_defense',
  '/cadre_legal_armes': '/gpx/generalites/cadre_legal_armes',
  '/libertes_publiques': '/gpx/generalites/libertes_publiques',
  '/retention_locaux_police': '/gpx/generalites/retention_locaux_police',

  // Cadres juridiques
  '/cadres_juridiques': '/gpx_scolarité_pages/cadres_juridiques_pages',
  '/cadres_enquete':
      '/gpx_scolarité_pages/cadres_juridiques_pages/cadres_enquete',
  '/enquete_flagrant_delit':
      '/gpx_scolarité_pages/cadres_juridiques_pages/enquete_flagrant_delit',
  '/enquete_preliminaire':
      '/gpx_scolarité_pages/cadres_juridiques_pages/enquete_preliminaire',
  '/autres_cadres_enquete':
      '/gpx_scolarité_pages/cadres_juridiques_pages/autres_cadres_enquete',
  '/commission_rogatoire':
      '/gpx_scolarité_pages/cadres_juridiques_pages/autres_cadres_enquete', // à définir (Commission Rogatoire)
  // Procédure pénale (compat /pp/*)
  '/pp/action_publique_autorites_pj':
      '/gpx_scolarité_pages/procédure_pénale_pages/pp_action_publique_autorites_pj',

  '/pp/nullite_actes_procedure':
      '/gpx_scolarité_pages/procédure_pénale_pages/pp_nullite_actes_procedure',

  '/pp/juridictions_jugement_execution':
      '/gpx_scolarité_pages/procédure_pénale_pages/pp_juridictions_jugement_execution',

  '/pp/instruction_mandats_controle_detention':
      '/gpx_scolarité_pages/procédure_pénale_pages/pp_instruction_mandats_controle_detention',
  '/pp/quiz/instruction_preparatoire':
      '/gpx/procedure_penale/quiz/instruction_preparatoire',

  // Droit pénal général
  '/dpg': '/gpx_scolarité_pages/droit_pénale_général_pages',
  '/dpg/loi_penale':
      '/gpx_scolarité_pages/droit_pénale_général_pages/loi_penale',
  '/dpg/responsabilite_penale':
      '/gpx_scolarité_pages/droit_pénale_général_pages/responsabilite_penale',

  // Sanction
  '/sanction': '/gpx_scolarité_pages/sanction_pages',
  '/sanction/classification_peines':
      '/gpx_scolarité_pages/sanction_pages/classification_peines',
  '/sanction/causes_aggravation':
      '/gpx_scolarité_pages/sanction_pages/causes_aggravation',
  '/sanction/pluralite_infractions':
      '/gpx_scolarité_pages/sanction_pages/pluralite_infractions',

  // Contre la personne
  '/crimes_personne': '/gpx_scolarité_pages/crime_delit_contre_personne_pages',
  '/crimes_personne/mise_en_danger':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/mise_en_danger',
  '/crimes_personne/viol_inceste_agressions':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/viol_inceste_agressions',
  '/crimes_personne/enlevement_sequestration':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/enlevement_sequestration',
  '/crimes_personne/enregistrement_diffusion_images':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images',
  '/crimes_personne/dignite_personne':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/dignite_personne',
  '/crimes_personne/personnalite':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/personnalite',
  '/crimes_personne/atteintes_involontaires':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/atteintes_involontaires',
  '/crimes_personne/atteintes_volontaires_vie':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie',
  '/crimes_personne/atteintes_volontaires_integrite':
      '/gpx_scolarité_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite',

  // Mineurs & famille
  '/mineurs_famille': '/gpx_scolarité_pages/mineurs_famille_pages',
  '/mineurs_famille/mise_en_peril':
      '/gpx_scolarité_pages/mineurs_famille_pages/mise_en_peril',
  '/mineurs_famille/violation_ordonnances_jaf':
      '/gpx_scolarité_pages/mineurs_famille_pages/violation_ordonnances_jaf',
  '/mineurs_famille/autorite_parentale':
      '/gpx_scolarité_pages/mineurs_famille_pages/autorite_parentale',
  '/mineurs_famille/abandon_famille':
      '/gpx_scolarité_pages/mineurs_famille_pages/abandon_famille',

  // Contre la nation
  '/crimes_nation': '/gpx_scolarité_pages/crime_delit_nation_pages',
  '/crimes_nation/association_malfaiteurs':
      '/gpx_scolarité_pages/crime_delit_nation_pages/association_malfaiteurs',
  '/crimes_nation/abus_autorite':
      '/gpx_scolarité_pages/crime_delit_nation_pages/abus_autorite',
  '/crimes_nation/atteintes_action_justice':
      '/gpx_scolarité_pages/crime_delit_nation_pages/atteintes_action_justice',
  '/crimes_nation/atteintes_administration':
      '/gpx_scolarité_pages/crime_delit_nation_pages/atteintes_administration',
  '/crimes_nation/faux_usage_faux':
      '/gpx_scolarité_pages/crime_delit_nation_pages/faux_usage_faux',
  '/crimes_nation/probite':
      '/gpx_scolarité_pages/crime_delit_nation_pages/probite',

  // Contre les biens
  '/crimes_biens': '/gpx_scolarité_pages/crime_delit_bien_pages',
  '/crimes_biens/recel_non_justification':
      '/gpx_scolarité_pages/crime_delit_bien_pages/recel_non_justification',
  '/crimes_biens/vol': '/gpx_scolarité_pages/crime_delit_bien_pages/vol',
  '/crimes_biens/stad': '/gpx_scolarité_pages/crime_delit_bien_pages/stad',
  '/crimes_biens/contrefacons_falsifications':
      '/gpx_scolarité_pages/crime_delit_bien_pages/contrefacons_falsifications',
  '/crimes_biens/destructions_degradations':
      '/gpx_scolarité_pages/crime_delit_bien_pages/destructions_degradations',
  '/crimes_biens/voisines_du_vol':
      '/gpx_scolarité_pages/crime_delit_bien_pages/voisines_du_vol',

  // Circulation
  '/circulation': '/gpx_scolarité_pages/infraction_circulation_routière_pages',
  '/circulation/conduite_stupefiants':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/conduite_stupefiants',
  '/circulation/ivresse':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/ivresse',
  '/circulation/etat_alcoolique':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/etat_alcoolique',
  '/circulation/defaut_assurance':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/defaut_assurance',
  '/circulation/defaut_permis':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/defaut_permis',
  '/circulation/delit_fuite':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/delit_fuite',
  '/circulation/grand_exces_vitesse':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/grand_exces_vitesse',
  '/circulation/refus_verifications':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/refus_verifications',
  '/circulation/refus_obtemperer':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/refus_obtemperer',
  '/circulation/rodeo_motorise':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/rodeo_motorise',
  '/circulation/plaques_inscriptions':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/plaques_inscriptions',
  '/circulation/incitation_organisation_promotion':
      '/gpx_scolarité_pages/infraction_circulation_routière_pages/incitation_organisation_promotion',

  // Armes
  '/armes': '/gpx_scolarité_pages/armes_munitions_pages',
  '/armes/classification':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_classification',
  '/armes/definitions':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_definitions',
  '/armes/introduction':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_introduction',
  '/armes/acquisition_detention_ab':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_acquisition_detention_ab',
  '/armes/port_transport_cd':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_port_transport_cd',
  '/armes/materiels_guerre_elements':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_materiels_guerre_elements',
  '/armes/regles_acquisition_detention':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_regles_acquisition_detention',
  '/armes/regles_port_transport':
      '/gpx_scolarité_pages/armes_munitions_pages/armes_regles_port_transport',

  // Libertés publiques
  '/libertes': '/gpx_scolarité_pages/libertés_publiques_pages',
  '/libertes/introduction':
      '/gpx_scolarité_pages/libertés_publiques_pages/introduction',
  '/libertes/garanties_protection':
      '/gpx_scolarité_pages/libertés_publiques_pages/garanties_protection',
  '/libertes/expression_collectives':
      '/gpx_scolarité_pages/libertés_publiques_pages/expression_collectives',
  '/libertes/individuelles_vie_privee':
      '/gpx_scolarité_pages/libertés_publiques_pages/individuelles_vie_privee',

  // Stups
  '/stup': '/gpx_scolarité_pages/stupéfiants_pages',
  '/stup/introduction': '/gpx_scolarité_pages/stupéfiants_pages/introduction',
  '/stup/cession_offre': '/gpx_scolarité_pages/stupéfiants_pages/cession_offre',
  '/stup/direction_organisation':
      '/gpx_scolarité_pages/stupéfiants_pages/direction_organisation',
  '/stup/facilitation_usage':
      '/gpx_scolarité_pages/stupéfiants_pages/facilitation_usage',
  '/stup/production_fabrication':
      '/gpx_scolarité_pages/stupéfiants_pages/production_fabrication',
  '/stup/provocation_majeur':
      '/gpx_scolarité_pages/stupéfiants_pages/provocation_majeur',
  '/stup/blanchiment_produit':
      '/gpx_scolarité_pages/stupéfiants_pages/blanchiment_produit',
  '/stup/transport_detention_offre':
      '/gpx_scolarité_pages/stupéfiants_pages/transport_detention_offre',
  '/stup/import_export': '/gpx_scolarité_pages/stupéfiants_pages/import_export',
  '/stup/usage_illicite':
      '/gpx_scolarité_pages/stupéfiants_pages/usage_illicite',
};

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
