import 'dart:async';

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/physics.dart' as phys;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:copiqpolice/onboarding/mode_picker.dart';

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
import 'package:copiqpolice/onboarding/gpx_school.dart' show GpxSchoolProgram;

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

class HomePageGpxSchool extends StatefulWidget {
  const HomePageGpxSchool({
    super.key,
    this.apjTileKey,
    this.discoveryLockToApj = false,
    this.onApjTapOverride,

    // ✅ keys tuto home
    this.modeGradeButtonKey,
    this.settingsButtonKey,
    this.heroDeckKey,
    this.progressCardKey,
    this.bottomNavKey,
    this.navJournalKey,
    this.navFavoritesKey,
    this.navProfileKey,

    // ✅ AJOUT : lock global pendant le tutoriel
    this.tutorialLock = false,
  });

  /// Tutoriel : clé pour mesurer la tuile APJ
  final GlobalKey? apjTileKey;

  /// ✅ AJOUT : lock global pendant le tuto
  final bool tutorialLock;

  // ✅ Keys pour le tutoriel Home
  final GlobalKey? modeGradeButtonKey; // 🎓
  final GlobalKey? settingsButtonKey; // ⚙️
  final GlobalKey? heroDeckKey; // 🟨
  final GlobalKey? progressCardKey; // 🟩
  final GlobalKey? bottomNavKey; // 🟦
  final GlobalKey? navJournalKey; // 🟪
  final GlobalKey? navFavoritesKey; // 🟥
  final GlobalKey? navProfileKey; // 🩷

  /// Tutoriel : bloque l’ouverture des autres modules (APJ only)
  final bool discoveryLockToApj;

  /// Tutoriel : si défini, on délègue le tap APJ
  final VoidCallback? onApjTapOverride;

  static GpxSchoolProgram program = GpxSchoolProgram.institutionValeurs;
  static Future<String?> Function()? usernameLoader;

  static const String routeName = '/home-gpx-school';

  @override
  State<HomePageGpxSchool> createState() => _HomePageGpxSchoolState();
}

class _HomePageGpxSchoolState extends State<HomePageGpxSchool>
    with WidgetsBindingObserver {
  int _currentTab = 0;

  // ✅ Mémorisation du scroll + états enfants (deck, listes, etc.)
  final PageStorageBucket _bucket = PageStorageBucket();

  // 👉 État du bonjour personnalisé
  String? _username;
  bool _isLoadingUsername = true;

  // Contexte figé : School + GPX
  static const _mode = UserMode.school;
  static const _track = Track.gpx;

  late final List<CategoryConfig> _cats =
      (gpxSchoolCategoriesConfig[HomePageGpxSchool.program] ??
      const <CategoryConfig>[]);

  // =====================  PERSISTENCE DE L'INDEX DU DECK  =====================

  static const String _kDeckIndexKey = 'gpx_school_hero_deck_index';
  int _initialDeckIndex = 0;
  bool _hasLoadedDeckIndex = false;

  int _computeDefaultDeckIndex() {
    final i = _cats.indexWhere(
      (c) => c.label.trim().toLowerCase() == 'cadres juridiques',
    );
    return i >= 0 ? i : 0;
  }

  // =====================  ✅ REPRENDRE : dernier module ouvert  =====================

  static const String _kLastRouteKey = 'gpx_school_last_route';
  static const String _kLastLabelKey = 'gpx_school_last_label';

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
        .channel('progress_home_gpx_school_$uid')
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
      final loader = HomePageGpxSchool.usernameLoader;
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
                    key: widget.modeGradeButtonKey,
                    icon: Icons.school_rounded,
                    onTap: widget.tutorialLock
                        ? null
                        : () {
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
                    key: widget.settingsButtonKey,
                    icon: Icons.settings_rounded,
                    onTap: widget.tutorialLock
                        ? null
                        : () {
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
                'Scolarité — Gardien de la Paix',
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
              child: KeyedSubtree(
                key: widget.heroDeckKey, // ✅ focus carré jaune
                child: _HeroDeck(
                  // 🔥 IMPORTANT : force rebuild du deck quand _lastRoute change
                  key: ValueKey('pa-hero-deck-${_lastRoute ?? "none"}'),
                  height: 330,
                  items: deckItems,
                  initialIndex: _initialDeckIndex,
                  onIndexChanged: _saveDeckIndex,
                  ctaLabelBuilder: (item) {
                    return (_lastRoute != null && _lastRoute == item.route)
                        ? 'Reprendre'
                        : 'Découvrir';
                  },
                  onOpen: (item) {
                    if (widget.tutorialLock)
                      return; // ✅ swipe OK, ouverture NON
                    _openRouteOrDetails(
                      label: item.label,
                      route: item.route,
                      subs: item.subcategories,
                    );
                  },
                ),
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
                  key: widget.progressCardKey, // ✅ focus carré vert
                  data: data,
                  onTapDetails: () {
                    if (widget.tutorialLock) return; // ✅ lock
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
        onTap: (i) {
          if (widget.tutorialLock) return; // ✅ lock
          _goToTab(i);
        },
        height: 64,
        icons: icons,

        // ✅ keys tuto home
        barKey: widget.bottomNavKey,
        journalKey: widget.navJournalKey,
        favoritesKey: widget.navFavoritesKey,
        profileKey: widget.navProfileKey,
      ),
    );
  }
}

// ======================================================================
//                              WIDGETS
// ======================================================================

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    super.key,
    required this.icon,
    this.onTap, // ✅ nullable
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onTap == null;

    return Opacity(
      opacity: disabled ? 0.55 : 1.0, // ✅ rendu "lock"
      child: InkWell(
        onTap: onTap, // ✅ null ok
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.cardColor,
            boxShadow: const [_T.shadow],
          ),
          child: Icon(
            icon,
            color: disabled ? _muted(context, .55) : theme.iconTheme.color,
          ),
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

  // ✅ TUTO: lock total (aucun tap)
  final bool locked;

  // ✅ keys tuto
  final Key? barKey;
  final Key? journalKey; // index 1
  final Key? favoritesKey; // index 3
  final Key? profileKey; // index 4

  const _SlidingPillNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.height,
    required this.icons,
    this.locked = false,
    this.barKey,
    this.journalKey,
    this.favoritesKey,
    this.profileKey,
  });

  Key? _keyForIndex(int i) {
    if (i == 1) return journalKey;
    if (i == 3) return favoritesKey;
    if (i == 4) return profileKey;
    return null;
  }

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
              key: barKey, // ✅ focus rectangle bleu (bar entière)
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

                  // ✅ On bloque toute interaction pendant le tuto
                  AbsorbPointer(
                    absorbing: locked,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: innerPadX),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(slots, (i) {
                          final selected = i == currentIndex;

                          // Couleurs (on garde ton style)
                          final activeColor = isDark ? Colors.black : _T.ink;
                          final inactiveColor = isDark
                              ? Colors.white
                              : Colors.white.withOpacity(.92);

                          final itemKey = _keyForIndex(i);

                          Widget iconWidget = Icon(
                            icons[i],
                            size: iconSize,
                            color: selected ? activeColor : inactiveColor,
                          );

                          // ✅ Tap sans splash / sans highlight bleu
                          Widget tappable = GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => onTap(i),
                            child: SizedBox(
                              height: h,
                              width: double.infinity,
                              child: Center(child: iconWidget),
                            ),
                          );

                          // ✅ Keys pour le spotlight
                          if (itemKey != null) {
                            tappable = KeyedSubtree(
                              key: itemKey,
                              child: tappable,
                            );
                          }

                          return Expanded(child: tappable);
                        }),
                      ),
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

class _DeckItem {
  final String label;
  final String badge;
  final String image;
  final String route;
  final double rating;
  final int reviews;
  final List<SubCategoryConfig>? subcategories;

  const _DeckItem({
    required this.label,
    required this.badge,
    required this.image,
    required this.route,
    required this.rating,
    required this.reviews,
    this.subcategories,
  });
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
    if (l.contains('usage illicite'))
      return 'assets/images/conduite_stupefiants.jpeg';

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

/// ✅ Spotlight sans BackdropFilter (stable Impeller, pas d'erreur CanAcceptOpacity)
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.hole,
    required this.dimOpacity,
    required this.radius,
  });

  final Rect hole;
  final double dimOpacity;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(dimOpacity);

    // Full screen
    final full = Path()..addRect(Offset.zero & size);

    // Hole
    final cut = Path()
      ..addRRect(RRect.fromRectAndRadius(hole, Radius.circular(radius)));

    // Difference => on dessine tout SAUF le trou
    final overlay = Path.combine(PathOperation.difference, full, cut);
    canvas.drawPath(overlay, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter old) {
    return old.hole != hole ||
        old.dimOpacity != dimOpacity ||
        old.radius != radius;
  }
}

// ======================================================================
//                        CONFIGS LOCALES (GPX SCHOOL)
// ======================================================================

const Map<GpxSchoolProgram, List<CategoryConfig>> gpxSchoolCategoriesConfig = {
  // =========================================================
  // 1) INSTITUTIONS & VALEURS
  // =========================================================
  GpxSchoolProgram.institutionValeurs: [
    CategoryConfig(
      label: 'Formation initiale',
      badge: 'Bases & méthodo',
      image: 'assets/images/copic_institutions.jpg',
      route: '/gpx/institution/formation_initiale',
      subcategories: [
        SubCategoryConfig(
          label: 'La formation initiale',
          route: '/gpx/institution/formation_initiale/formation',
          image: 'assets/images/copic_institutions.jpg',
        ),
        SubCategoryConfig(
          label: 'Mémento prise de notes & méthodologie',
          route: '/gpx/institution/formation_initiale/memento_notes',
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
          route: '/pa/institution/organisation_pn/dgsi',
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
        SubCategoryConfig(
          label: 'Quiz — Organisation (global)',
          route: '/gpx/institution/organisation_pn/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Déontologie',
      badge: 'Éthique & cadre',
      image: 'assets/images/cat_organisation.jpg',
      route: '/gpx/institution/deontologie',
      subcategories: [
        SubCategoryConfig(
          label: 'Code de déontologie commenté (PN & GN)',
          route: '/gpx/institution/deontologie/code_commente',
          image: 'assets/images/code_commente.webp',
        ),
        SubCategoryConfig(
          label: 'Marques extérieures de respect (salut, présentation)',
          route: '/gpx/institution/deontologie/marques_respect',
          image: 'assets/images/marques_respect.jpeg',
        ),
        SubCategoryConfig(
          label: 'Droits & obligations des policiers',
          route: '/gpx/institution/deontologie/droits_obligations',
        ),
        SubCategoryConfig(
          label: 'Policier hors service : dois-je intervenir ? (AMARIS)',
          route: '/gpx/institution/deontologie/hors_service_amaris',
          image: 'assets/images/hors_service_amaris.jpeg',
        ),
        SubCategoryConfig(
          label: 'Sanctions & récompenses',
          route: '/gpx/institution/deontologie/sanctions_recompenses',
          image: 'assets/images/sanction.jpeg',
        ),
        SubCategoryConfig(
          label: 'Enquête administrative',
          route: '/gpx/institution/deontologie/enquete_administrative',
        ),
        SubCategoryConfig(
          label: 'Usage des réseaux sociaux',
          route: '/gpx/institution/deontologie/reseaux_sociaux',
          image: 'assets/images/reseaux_sociaux.jpg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Déontologie',
          route: '/gpx/institution/deontologie/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Information de la hiérarchie',
      badge: 'Écrits pro',
      image: 'assets/images/cat_hierarchie.jpg',
      route: '/gpx/institution/hierarchie_info',
      subcategories: [
        SubCategoryConfig(
          label: 'Le compte-rendu',
          route: '/gpx/institution/hierarchie_info/compte_rendu',
          image: 'assets/images/compte_rendu.jpeg',
        ),
        SubCategoryConfig(
          label: 'Le formalisme du rapport',
          route: '/gpx/institution/hierarchie_info/formalisme_rapport',
          image: 'assets/images/formalisme_rapport.jpeg',
        ),
        SubCategoryConfig(
          label: 'Modèles de rapports',
          route: '/gpx/institution/hierarchie_info/modeles',
          image: 'assets/images/modeles.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Accueil du public',
      badge: 'Victimes & assistance',
      image: 'assets/images/image1.jpeg',
      route: '/gpx/institution/accueil_public',
      subcategories: [
        SubCategoryConfig(
          label: 'Charte de l’accueil du public & assistance aux victimes',
          route: '/gpx/institution/accueil_public/charte',
          image: 'assets/images/charte.jpeg',
        ),
        SubCategoryConfig(
          label: 'Référentiel Marianne',
          route: '/gpx/institution/accueil_public/marianne',
          image: 'assets/images/marianne.jpg',
        ),
        SubCategoryConfig(
          label: 'Dépliants & doctrine accueil / prise en charge',
          route: '/gpx/institution/accueil_public/doctrine',
          image: 'assets/images/doctrine.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quelques démarches administratives',
          route: '/gpx/institution/accueil_public/demarches',
        ),
        SubCategoryConfig(
          label: 'Protection des locaux de police',
          route: '/gpx/institution/accueil_public/protection_locaux',
          image: 'assets/images/protection_locaux.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Accueil du public',
          route: '/gpx/institution/accueil_public/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Laïcité, police et religions',
      badge: 'Neutralité',
      image: 'assets/images/image6.jpg',
      route: '/gpx/institution/laicite',
      subcategories: [
        SubCategoryConfig(
          label: 'La laïcité (DLPAJ / bureau des cultes)',
          route: '/gpx/institution/laicite/laicite_dlpaj',
          image: 'assets/images/laicite_dlpaj.jpeg',
        ),
        SubCategoryConfig(
          label: 'Charte de la laïcité dans les services publics',
          route: '/gpx/institution/laicite/charte',
          image: 'assets/images/charte_laicite.jpeg',
        ),
        SubCategoryConfig(
          label: 'Principaux rites & pratiques des cultes en France',
          route: '/gpx/institution/laicite/rites_cultes',
          image: 'assets/images/rites_cultes.jpeg',
        ),
        //SubCategoryConfig(
        //  label: 'Quiz — Laïcité',
        //  route: '/gpx/institution/laicite/quiz',
        //  image: 'assets/images/quiz.jpeg',
        //),
      ],
    ),
    CategoryConfig(
      label: 'Histoire de la police',
      badge: 'Repères',
      image: 'assets/images/image4.jpeg',
      route: '/gpx/institution/histoire',
      subcategories: [
        SubCategoryConfig(
          label: 'Points de repères chronologiques',
          route: '/gpx/institution/histoire/reperes',
        ),
      ],
    ),
  ],

  // =========================================================
  // 2) DPS / DPG
  // =========================================================
  GpxSchoolProgram.dpsDpg: [
    CategoryConfig(
      label: 'Généralités',
      badge: 'Concepts de base',
      image: 'assets/images/generalite.jpeg',
      route: '/gpx_scolarite_pages/generalite_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des infractions',
          route: '/gpx/generalites/classification_infractions',
        ),
        SubCategoryConfig(
          label: 'L\'infraction',
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
          label: 'Cadre légal d\'usage des armes',
          route: '/gpx/generalites/usagedesarmes_intro',
        ),
        SubCategoryConfig(
          label: 'Les libertés publiques',
          route: '/gpx/generalites/libertespubliques_intro',
        ),
        SubCategoryConfig(
          label: 'Cas de rétention dans les locaux de police',
          route: '/gpx/generalites/retention_locaux_police_intro',
        ),
        SubCategoryConfig(
          label:
              'La hiérarchie des personnels de la Police Nationale : Fonctions judiciaires',
          route: '/gpx/generalites/hierarchie_intro',
        ),
        SubCategoryConfig(
          label:
              'Quiz généralités, classification des infractions, infraction, tentative punissable etc..',
          route: '/gpx/procedure_penale/quiz/generalité_principales',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Cadres juridiques',
      badge: 'Cadres d\'enquête',
      image: 'assets/images/cadres_juridiques.jpeg',
      route: '/gpx_scolarite_pages/cadres_juridiques_pages',
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
        SubCategoryConfig(
          label: 'Contrôles et vérifications d’identité',
          route: '/gpx/generalites/flagrant_delit_intro',
        ),
        SubCategoryConfig(
          label: 'Entraide judiciaire internationale',
          route: '/gpx/generalites/entraide_judiciaire_intro',
        ),
        SubCategoryConfig(
          label:
              'Quiz cadres juridiques, les cadres d\'enquête, l\'enquête de flagrant délit etc..',
          route: '/gpx/procedure_penale/quiz/cadres_juridiques_principales',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Procédure Pénale',
      badge: 'Cours & cas pratiques',
      image: 'assets/images/procedure_penale.jpg',
      route: '/gpx_scolarite_pages/procédure_pénale_pages',
      subcategories: [
        SubCategoryConfig(
          label:
              'Action publique, action civile, autorités & contrôle de la PJ',
          route:
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_autorites_pj',
        ),
        SubCategoryConfig(
          label: 'Nullité des actes de procédure',
          route:
              '/gpx_scolarite_pages/procédure_pénale_pages/nullite_intro_page',
        ),
        SubCategoryConfig(
          label: 'Juridictions de jugement & exécution des décisions',
          route:
              '/gpx_scolarite_pages/procédure_pénale_pages/juridictions_intro',
        ),
        SubCategoryConfig(
          label:
              'Instruction préparatoire, mandats, contrôle jud., détention provisoire',
          route:
              '/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_mandats_controle_detention',
        ),
        SubCategoryConfig(
          label:
              'Quiz instruction préparatoire, mandats & détention provisoire',
          route: '/gpx/procedure_penale/quiz/instruction_preparatoire',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Droit pénal général',
      badge: 'Loi & responsabilité',
      image: 'assets/images/droit_penal_general.jpeg',
      route: '/gpx_scolarite_pages/droit_pénale_général_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'De la loi pénale',
          route: '/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale',
        ),
        SubCategoryConfig(
          label: 'De la responsabilité pénale',
          route:
              '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale',
        ),
      ],
    ),
    CategoryConfig(
      label: 'La sanction',
      badge: 'Peines & sûreté',
      image: 'assets/images/sanction.jpeg',
      route: '/gpx_scolarite_pages/sanction_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des peines et mesures de sûreté',
          route: '/gpx_scolarite_pages/sanction_pages/classification_peines',
        ),
        SubCategoryConfig(
          label: 'Causes d’aggravation de la sanction',
          route:
              '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction',
        ),
        SubCategoryConfig(
          label: 'Règles en cas de pluralité d’infractions',
          route: '/gpx_scolarite_pages/sanction_pages/pluralite_infractions',
        ),
        SubCategoryConfig(
          label: 'Quiz — Sanction  (récidive, réitération, concours réel)',
          route: '/gpx/sanction/quiz/sanction_page',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Crimes & délits contre la personne',
      badge: 'Atteintes aux personnes',
      image: 'assets/images/contre_personne.jpeg',
      route: '/gpx_scolarite_pages/crime_delit_contre_personne_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'La mise en danger de la personne',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger',
        ),
        SubCategoryConfig(
          label: 'Le viol, l’inceste et autres agressions sexuelles',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/avertissement',
        ),
        SubCategoryConfig(
          label: 'L’enlèvement et la séquestration',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enlevement_sequestration',
        ),
        SubCategoryConfig(
          label: 'Enregistrement & diffusion d’images',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images',
        ),
        SubCategoryConfig(
          label: 'Atteintes à la dignité de la personne',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne',
        ),
        SubCategoryConfig(
          label: 'Atteintes à la personnalité',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite',
        ),
        SubCategoryConfig(
          label: 'Atteintes involontaires à la vie et à l’intégrité',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires',
        ),
        SubCategoryConfig(
          label: 'Atteintes volontaires à la vie',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie',
        ),
        SubCategoryConfig(
          label: 'Atteintes volontaires à l’intégrité physique',
          route:
              '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite',
        ),
        SubCategoryConfig(
          label: 'Quiz — Crimes & délits contre la personne',
          route: '/gpx/crimes_personne/quiz/crimes_delits_personne',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Atteintes aux mineurs & à la famille',
      badge: 'Protection des mineurs',
      image: 'assets/images/mineurs_famille.jpeg',
      route: '/gpx_scolarite_pages/mineurs_famille_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'La mise en péril des mineurs',
          route: '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril',
        ),
        SubCategoryConfig(
          label: 'Violation d’ordonnances JAF (violences)',
          route:
              '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf',
        ),
        SubCategoryConfig(
          label: 'Atteintes à l’exercice de l’autorité parentale',
          route:
              '/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale',
        ),
        SubCategoryConfig(
          label: 'L’abandon de famille',
          route: '/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille',
        ),
        SubCategoryConfig(
          label: 'Quiz — L’abandon de famille',
          route: '/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Crimes & délits contre la nation',
      badge: 'Institutions & justice',
      image: 'assets/images/contre_nation.jpeg',
      route: '/gpx_scolarite_pages/crime_delit_nation_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Association de malfaiteurs',
          route:
              '/gpx_scolarite_pages/crime_delit_nation_pages/association_malfaiteurs',
        ),
        SubCategoryConfig(
          label: 'Abus d’autorité contre les particuliers',
          route: '/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite',
        ),
        SubCategoryConfig(
          label: 'Atteintes à l’action de la justice',
          route:
              '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice',
        ),
        SubCategoryConfig(
          label: 'Atteintes à l’administration par des particuliers',
          route:
              '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration',
        ),
        SubCategoryConfig(
          label: 'Faux et usage de faux',
          route:
              '/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux',
        ),
        SubCategoryConfig(
          label: 'Manquements au devoir de probité',
          route: '/gpx_scolarite_pages/crime_delit_nation_pages/probite',
        ),
        SubCategoryConfig(
          label: 'Quiz — Crimes & délits contre la nation',
          route: '/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_nation',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Crimes & délits contre les biens',
      badge: 'Atteintes aux biens',
      image: 'assets/images/contre_biens.jpeg',
      route: '/gpx_scolarite_pages/crime_delit_bien_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Recel & non-justification de ressources',
          route:
              '/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification',
        ),
        SubCategoryConfig(
          label: 'Le vol',
          route: '/gpx_scolarite_pages/crime_delit_bien_pages/vol',
        ),
        SubCategoryConfig(
          label: 'Atteintes aux STAD (informatique)',
          route: '/gpx_scolarite_pages/crime_delit_bien_pages/stad',
        ),
        SubCategoryConfig(
          label: 'Contrefaçons & falsifications de chèques',
          route:
              '/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications',
        ),
        SubCategoryConfig(
          label: 'Destructions, dégradations, détériorations',
          route:
              '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations',
        ),
        SubCategoryConfig(
          label: 'Infractions voisines du vol',
          route: '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol',
        ),
        SubCategoryConfig(
          label: 'Quiz — Crimes & délits contre les biens',
          route: '/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_bien',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Infractions à la circulation routière',
      badge: 'Code de la route',
      image: 'assets/images/circulation_routiere.jpeg',
      route: '/gpx_scolarite_pages/infraction_circulation_routière_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Conduite après usage de stupéfiants',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/conduite_stupefiants',
        ),
        SubCategoryConfig(
          label: 'Conduite en état d’ivresse',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/ivresse',
        ),
        SubCategoryConfig(
          label: 'Conduite sous l’empire d’un état alcoolique',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/etat_alcoolique',
        ),
        SubCategoryConfig(
          label: 'Défaut d’assurance',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_assurance',
        ),
        SubCategoryConfig(
          label: 'Défaut de permis de conduire',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_permis',
        ),
        SubCategoryConfig(
          label: 'Délit de fuite',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/delit_fuite',
        ),
        SubCategoryConfig(
          label: 'Grand excès de vitesse',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/grand_exces_vitesse',
        ),
        SubCategoryConfig(
          label: 'Refus de vérifications',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_verifications',
        ),
        SubCategoryConfig(
          label: 'Refus d’obtempérer',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_obtemperer',
        ),
        SubCategoryConfig(
          label: 'Rodéo motorisé',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise',
        ),
        SubCategoryConfig(
          label: 'Plaques & inscriptions (délits liés)',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions',
        ),
        SubCategoryConfig(
          label: 'Incitation / organisation / promotion',
          route:
              '/gpx_scolarite_pages/infraction_circulation_routière_pages/incitation_organisation_promotion',
        ),
        SubCategoryConfig(
          label: 'Quiz — Infractions à la circulation routière',
          route:
              '/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Armes & munitions',
      badge: 'Régimes spéciaux',
      image: 'assets/images/armes_munitions.jpeg',
      route: '/gpx_scolarite_pages/armes_munitions_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Classification des armes et des munitions',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_classification',
        ),
        SubCategoryConfig(
          label: 'Définitions',
          route: '/gpx_scolarite_pages/armes_munitions_pages/armes_definitions',
        ),
        SubCategoryConfig(
          label: 'Introduction',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_introduction',
        ),
        SubCategoryConfig(
          label: 'Acquisition/détention cat. A ou B sans autorisation',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_acquisition_detention_ab',
        ),
        SubCategoryConfig(
          label: 'Port/transport sans motif légitime (cat. C ou D)',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd',
        ),
        SubCategoryConfig(
          label: 'Régimes matériels de guerre / éléments d’arme',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_materiels_guerre_elements',
        ),
        SubCategoryConfig(
          label: 'Règles d’acquisition & détention',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_regles_acquisition_detention',
        ),
        SubCategoryConfig(
          label: 'Règles de port & transport',
          route:
              '/gpx_scolarite_pages/armes_munitions_pages/armes_regles_port_transport',
        ),
        SubCategoryConfig(
          label: 'Quiz — Classification des armes et des munitions',
          route: '/gpx/armes_munitions_pages/quiz/quiz_armes_munitions_pages',
        ),
      ],
    ),
    CategoryConfig(
      label: 'Libertés publiques',
      badge: 'Droits & garanties',
      image: 'assets/images/libertes_publiques.jpeg',
      route: '/gpx/generalites/libertespubliques_intro',
    ),
    CategoryConfig(
      label: 'Stupéfiants — usage & trafic',
      badge: 'Stups',
      image: 'assets/images/stupefiants.jpeg',
      route: '/gpx_scolarite_pages/stupéfiants_pages',
      subcategories: [
        SubCategoryConfig(
          label: 'Introduction',
          route: '/gpx_scolarite_pages/stupéfiants_pages/introduction',
        ),
        SubCategoryConfig(
          label: 'Cession/offre illicites pour consommation personnelle',
          route: '/gpx_scolarite_pages/stupéfiants_pages/cession_offre',
        ),
        SubCategoryConfig(
          label: 'Direction/organisation d’un trafic',
          route:
              '/gpx_scolarite_pages/stupéfiants_pages/direction_organisation',
        ),
        SubCategoryConfig(
          label: 'Facilitation à l’usage illicite',
          route: '/gpx_scolarite_pages/stupéfiants_pages/facilitation_usage',
        ),
        SubCategoryConfig(
          label: 'Production/fabrication illicites',
          route:
              '/gpx_scolarite_pages/stupéfiants_pages/production_fabrication',
        ),
        SubCategoryConfig(
          label: 'Provocation d’un majeur à l’usage ou au trafic',
          route: '/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur',
        ),
        SubCategoryConfig(
          label: 'Blanchiment du produit du trafic',
          route: '/gpx_scolarite_pages/stupéfiants_pages/blanchiment_produit',
        ),
        SubCategoryConfig(
          label: 'Transport/détention/offre/cession/acquisition/emploi',
          route:
              '/gpx_scolarite_pages/stupéfiants_pages/transport_detention_offre',
        ),
        SubCategoryConfig(
          label: 'Importation/exportation illicites',
          route: '/gpx_scolarite_pages/stupéfiants_pages/import_export',
        ),
        SubCategoryConfig(
          label: 'Usage illicite de stupéfiants',
          route: '/gpx_scolarite_pages/stupéfiants_pages/usage_illicite',
        ),
        SubCategoryConfig(
          label: 'Quiz — Stupéfiants — usage & trafic',
          route: '/gpx/stupéfiants_pages/quiz/quiz_stupéfiants',
        ),
      ],
    ),
  ],

  // =========================================================
  // 3) MÉMENTO CIRCULATION ROUTIÈRE
  // =========================================================
  GpxSchoolProgram.mememtoCirculationRoutiere: [
    // =========================================================
    // 1) PROCÉDURES EN MATIÈRE DE CIRCULATION ROUTIÈRE
    // =========================================================
    CategoryConfig(
      label: 'Procédures circulation routière',
      badge: 'Procédures',
      image: 'assets/images/memento_procedures.jpeg',
      route: '/gpx/memento_circulation/procedures',
      subcategories: [
        SubCategoryConfig(
          label: 'L’amende forfaitaire',
          route: '/gpx/memento_circulation/procedures/amende_forfaitaire',
          image: 'assets/images/amende_forfaitaire.jpeg',
        ),
        SubCategoryConfig(
          label: 'L’amende forfaitaire délictuelle',
          route:
              '/gpx/memento_circulation/procedures/amende_forfaitaire_delictuelle',
          image: 'assets/images/amende_forfaitaire_delictuelle.jpeg',
        ),
        SubCategoryConfig(
          label: 'La consignation',
          route: '/gpx/memento_circulation/procedures/consignation',
          image: 'assets/images/consignation.jpeg',
        ),
        SubCategoryConfig(
          label: 'L’immobilisation du véhicule',
          route: '/gpx/memento_circulation/procedures/immobilisation',
          image: 'assets/images/immobilisation.jpeg',
        ),
        SubCategoryConfig(
          label: 'La mise en fourrière',
          route: '/gpx/memento_circulation/procedures/mise_en_fourriere',
          image: 'assets/images/mise_en_fourriere.jpeg',
        ),
        SubCategoryConfig(
          label: 'La conduite sous l’influence de l’alcool',
          route: '/gpx/memento_circulation/procedures/conduite_alcool',
          image: 'assets/images/ivresse.jpeg',
        ),
        SubCategoryConfig(
          label: 'La conduite après usage de stupéfiants',
          route: '/gpx/memento_circulation/procedures/conduite_stupefiants',
          image: 'assets/images/stupefiants.jpeg',
        ),
        SubCategoryConfig(
          label: 'La rétention du permis de conduire',
          route: '/gpx/memento_circulation/procedures/retention_permis',
          image: 'assets/images/retention_permis.jpeg',
        ),
        SubCategoryConfig(
          label: 'Le permis à points',
          route: '/gpx/memento_circulation/procedures/permis_a_points',
          image: 'assets/images/permis_points.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Procédures circulation',
          route: '/gpx/memento_circulation/procedures/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Contrôle routier & pièces',
      badge: 'Contrôle',
      image: 'assets/images/memento_controle_routier.jpeg',
      route: '/gpx/memento_circulation/controle_routier',
      subcategories: [
        SubCategoryConfig(
          label: 'Le cadre légal du contrôle routier',
          route: '/gpx/memento_circulation/controle_routier/cadre_legal',
          image: 'assets/images/cadres_juridiques.jpeg',
        ),
        SubCategoryConfig(
          label: 'Le permis de conduire',
          route: '/gpx/memento_circulation/controle_routier/permis_conduire',
          image: 'assets/images/permis_conduire.jpeg',
        ),
        SubCategoryConfig(
          label: 'Le brevet de sécurité routière',
          route: '/gpx/memento_circulation/controle_routier/bsr',
          image: 'assets/images/bsr.jpeg',
        ),
        SubCategoryConfig(
          label: 'Les certificats d’immatriculation',
          route:
              '/gpx/memento_circulation/controle_routier/certificat_immatriculation',
          image: 'assets/images/certificat_immatriculation.jpeg',
        ),
        SubCategoryConfig(
          label: 'Le contrôle technique des véhicules',
          route: '/gpx/memento_circulation/controle_routier/controle_technique',
          image: 'assets/images/controle_technique.jpeg',
        ),
        SubCategoryConfig(
          label: 'L’assurance',
          route:
              '/gpx/memento_circulation/controle_routier/assurance_obligatoire',
          image: 'assets/images/assurance_obligatoire.jpeg',
        ),

        // ✅ QUIZ catégorie
        SubCategoryConfig(
          label: 'Quiz — Contrôle routier',
          route: '/gpx/memento_circulation/controle_routier/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Équipements véhicules & usagers',
      badge: 'Équipements',
      image: 'assets/images/memento_equipements.jpeg',
      route: '/gpx/memento_circulation/equipements',
      subcategories: [
        // Équipements des véhicules
        SubCategoryConfig(
          label: 'Les pneumatiques',
          route: '/gpx/memento_circulation/equipements/pneumatiques',
          image: 'assets/images/pneumatiques.jpeg',
        ),
        SubCategoryConfig(
          label: 'Éclairage et signalisation',
          route: '/gpx/memento_circulation/equipements/eclairage_signalisation',
          image: 'assets/images/eclairage_signalisation.jpeg',
        ),
        SubCategoryConfig(
          label: 'Chargement',
          route: '/gpx/memento_circulation/equipements/chargement',
          image: 'assets/images/chargement.jpeg',
        ),
        SubCategoryConfig(
          label: 'Les plaques',
          route: '/gpx/memento_circulation/equipements/plaques',
          image: 'assets/images/plaques.jpeg',
        ),
        SubCategoryConfig(
          label: 'Miroirs / rétroviseurs / vision indirecte',
          route: '/gpx/memento_circulation/equipements/retroviseurs_vision',
          image: 'assets/images/retroviseurs.jpeg',
        ),
        SubCategoryConfig(
          label: 'Les essuie-glace',
          route: '/gpx/memento_circulation/equipements/essuie_glace',
          image: 'assets/images/essuie_glace.jpeg',
        ),
        SubCategoryConfig(
          label: 'Nuisances des véhicules (fumées, bruit, avertisseur sonore)',
          route: '/gpx/memento_circulation/equipements/nuisances',
          image: 'assets/images/nuisances.jpeg',
        ),
        SubCategoryConfig(
          label: 'Ceinture de sécurité / retenue enfant',
          route: '/gpx/memento_circulation/equipements/ceinture_retenue_enfant',
          image: 'assets/images/ceinture_retenue_enfant.jpeg',
        ),
        SubCategoryConfig(
          label: 'Casque et gants de protection',
          route: '/gpx/memento_circulation/equipements/casque_gants',
          image: 'assets/images/casque_gants.jpeg',
        ),
        SubCategoryConfig(
          label: 'Casque “cycliste”',
          route: '/gpx/memento_circulation/equipements/casque_cycliste',
          image: 'assets/images/casque_cycliste.jpeg',
        ),
        SubCategoryConfig(
          label: 'Gilet de haute visibilité',
          route: '/gpx/memento_circulation/equipements/gilet_haute_visibilite',
          image: 'assets/images/gilet_haute_visibilite.jpeg',
        ),

        // ✅ QUIZ catégorie
        SubCategoryConfig(
          label: 'Quiz — Équipements',
          route: '/gpx/memento_circulation/equipements/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),

    CategoryConfig(
      label: 'Natinf',
      badge: 'Natinf',
      image: 'assets/images/natinf.png',
      route: '/gpx/memento_circulation/natinf',
      subcategories: [
        SubCategoryConfig(
          label: 'Natinf',
          route: '/gpx/memento_circulation/controle_routier/natinf',
          image: 'assets/images/natinf.png',
        ),
      ],
    ),
  ],

  GpxSchoolProgram.policierEnInterventionsa: [
    CategoryConfig(
      label: 'Circulation & séjour des étrangers',
      badge: 'Étrangers',
      image: 'assets/images/mandat_arret.jpeg',
      route: '/gpx/intervention/etrangers',
      subcategories: [
        SubCategoryConfig(
          label: 'L’accord de Schengen',
          route: '/gpx/intervention/etrangers/schengen',
          image: 'assets/images/schengen.jpeg',
        ),
        SubCategoryConfig(
          label: 'Coopération policière et judiciaire (UE)',
          route: '/gpx/intervention/etrangers/cooperation-ue',
          image: 'assets/images/cooperation_ue.jpeg',
        ),
        SubCategoryConfig(
          label: 'Les différents titres de séjour',
          route: '/gpx/intervention/etrangers/titres-sejour',
          image: 'assets/images/titres_sejour.jpeg',
        ),

        // ✅ QUIZ (à ajouter)
        SubCategoryConfig(
          label: 'Quiz — Étrangers',
          route: '/gpx/intervention/etrangers/quiz',
        ),
      ],
    ),

    // 2) LA PROTECTION DES MINEURS
    CategoryConfig(
      label: 'Protection des mineurs',
      badge: 'Mineurs',
      image: 'assets/images/mineurs_famille.jpeg',
      route: '/gpx/intervention/mineurs',
      subcategories: [
        SubCategoryConfig(
          label: 'Le statut juridique du mineur',
          route: '/gpx/intervention/mineurs/statut-juridique',
        ),
        SubCategoryConfig(
          label: 'Protection des mineurs sur la voie publique',
          route: '/gpx/intervention/mineurs/voie-publique',
        ),
        SubCategoryConfig(
          label: 'Quiz — Mineurs',
          route: '/gpx/intervention/mineurs/quiz',
        ),
      ],
    ),

    // 3) L’ACCIDENT DE LA CIRCULATION
    CategoryConfig(
      label: 'Accident de la circulation',
      badge: 'Accident',
      image: 'assets/images/mise_en_danger.jpeg',
      route: '/gpx/intervention/accident-circulation',
      subcategories: [
        SubCategoryConfig(
          label: 'Technique du plan des lieux',
          route: '/gpx/intervention/accident-circulation/plan-lieux-technique',
          image: 'assets/images/plan_lieux.jpeg',
        ),
        SubCategoryConfig(
          label: 'Différents modèles de plan',
          route: '/gpx/intervention/accident-circulation/modeles-plan',
          image: 'assets/images/modele-sans-cotes.jpeg',
        ),
        SubCategoryConfig(
          label: 'Renseignements à recueillir sur les lieux',
          route:
              '/gpx/intervention/accident-circulation/renseignements-a-recueillir',
          image: 'assets/images/renseignements.jpeg',
        ),
        SubCategoryConfig(
          label: 'Tableau synthèse des renseignements à recueillir',
          route: '/gpx/intervention/accident-circulation/tableau-synthese',
          image: 'assets/images/tableau_synthese.jpeg',
        ),
        SubCategoryConfig(
          label: 'L’avis à la famille',
          route: '/gpx/intervention/accident-circulation/avis-famille',
          image: 'assets/images/avis_famille.jpeg',
        ),
        SubCategoryConfig(
          label: '“J’annonce une mauvaise nouvelle” (AMARIS)',
          route:
              '/gpx/intervention/accident-circulation/annoncer-mauvaise-nouvelle',
          image: 'assets/images/mauvaise_nouvelle.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Accident',
          route: '/gpx/intervention/accident-circulation/quiz',
        ),
      ],
    ),

    // 4) L’INTERVENTION EN MATIÈRE D’USAGE DE STUPÉFIANTS
    CategoryConfig(
      label: 'Intervention : usage de stupéfiants',
      badge: 'Stupéfiants',
      image: 'assets/images/stupefiants.jpeg',
      route: '/gpx/intervention/stupefiants',
      subcategories: [
        SubCategoryConfig(
          label: 'Amende forfaitaire délictuelle (usage illicite)',
          route: '/gpx/intervention/stupefiants/amende-forfaitaire-delictuelle',
        ),
        SubCategoryConfig(
          label: 'Quiz — Stupéfiants',
          route: '/gpx/intervention/stupefiants/quiz',
        ),
      ],
    ),

    // 5) L’INTERVENTION DANS UN DÉBIT DE BOISSONS
    CategoryConfig(
      label: 'Intervention : débit de boissons',
      badge: 'Débit',
      image: 'assets/images/ivresse.jpeg',
      route: '/gpx/intervention/debit-boissons',
      subcategories: [
        SubCategoryConfig(
          label: 'Intervention dans un débit de boissons',
          route: '/gpx/intervention/debit-boissons/intervention',
          image: 'assets/images/boissons_intervention.jpeg',
        ),
        SubCategoryConfig(
          label: 'Contrôle des débits de boissons',
          route: '/gpx/intervention/debit-boissons/controle',
          image: 'assets/images/boissons_controle.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Débit de boissons',
          route: '/gpx/intervention/debit-boissons/quiz',
        ),
      ],
    ),

    // 6) LES MALADES MENTAUX
    CategoryConfig(
      label: 'Les malades mentaux',
      badge: 'Psychiatrie',
      image: 'assets/images/malades_mentaux.jpeg',
      route: '/gpx/intervention/malades-mentaux',
      subcategories: [
        SubCategoryConfig(
          label:
              'Intervenir auprès de personnes ne jouissant pas de toutes leurs capacités mentales',
          route: '/gpx/intervention/malades-mentaux/intervenir',
          image: 'assets/images/malades_mentaux_intervenir.jpeg',
        ),
        SubCategoryConfig(
          label: 'Admission en soins psychiatriques sans consentement',
          route: '/gpx/intervention/malades-mentaux/soins-sans-consentement',
          image: 'assets/images/soins_sans_consentement.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Malades mentaux',
          route: '/gpx/intervention/malades-mentaux/quiz',
        ),
      ],
    ),

    // 7) L’INTERVENTION EN PRÉSENCE D’UN ANIMAL
    CategoryConfig(
      label: 'Intervention : présence d’un animal',
      badge: 'Animal',
      image: 'assets/images/animal.jpeg',
      route: '/gpx/intervention/animal',
      subcategories: [
        SubCategoryConfig(
          label: 'Lutte contre la maltraitance animale',
          route: '/gpx/intervention/animal/maltraitance',
          image: 'assets/images/maltraitance.jpeg',
        ),
        SubCategoryConfig(
          label: '“Intervenir face à un chien dangereux” (AMARIS)',
          route: '/gpx/intervention/animal/chien-dangereux',
          image: 'assets/images/chien_dangereux.jpeg',
        ),
        SubCategoryConfig(
          label: 'Protocole sanitaire en cas de morsure',
          route: '/gpx/intervention/animal/protocole-morsure',
          image: 'assets/images/protocole_morsure.jpeg',
        ),
        SubCategoryConfig(
          label: 'Chiens d’attaque, de garde ou de défense',
          route: '/gpx/intervention/animal/chiens-categories',
          image: 'assets/images/chiens_categories.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Animal',
          route: '/gpx/intervention/animal/quiz',
        ),
      ],
    ),

    // 8) LES AUTRES INTERVENTIONS
    CategoryConfig(
      label: 'Les autres interventions',
      badge: 'Divers',
      image: 'assets/images/autres_interventions.jpeg',
      route: '/gpx/intervention/autres',
      subcategories: [
        SubCategoryConfig(
          label: 'Intervention sur les lieux d’un sinistre',
          route: '/gpx/intervention/autres/sinistre',
          image: 'assets/images/sinistre.jpeg',
        ),
        SubCategoryConfig(
          label: '“Primo-intervenant sur un incendie” (AMARIS)',
          route: '/gpx/intervention/autres/incendie-primo',
          image: 'assets/images/incendie_primo.jpeg',
        ),
        SubCategoryConfig(
          label:
              'Intervention sur une alarme (établissement à caractère financier ou commercial)',
          route: '/gpx/intervention/autres/alarme-etablissement',
          image: 'assets/images/alarme_etablissement.jpeg',
        ),
        SubCategoryConfig(
          label: 'Principes de levée de doute lors d’agressions armées',
          route: '/gpx/intervention/autres/levee-doute-agression-armee',
          image: 'assets/images/levee_doute_agression_armee.jpeg',
        ),
        SubCategoryConfig(
          label:
              'Intervention suite à une agression armée à caractère crapuleux',
          route: '/gpx/intervention/autres/agression-armee-crapuleux',
          image: 'assets/images/agression_armee_crapuleux.jpeg',
        ),
        SubCategoryConfig(
          label:
              'Intervention suite à la violation d’un bracelet anti-rapprochement (interdiction de se rapprocher)',
          route: '/gpx/intervention/autres/violation-bar',
        ),
        SubCategoryConfig(
          label: 'Plan Vigipirate',
          route: '/gpx/intervention/autres/plan-vigipirate',
          image: 'assets/images/vigipirate.jpeg',
        ),
        SubCategoryConfig(
          label: 'Quiz — Autres interventions',
          route: '/gpx/intervention/autres/quiz',
        ),
      ],
    ),
  ],

  // =========================================================
  // 4) POLICIER EN INTERVENTION
  // =========================================================
  GpxSchoolProgram.policierEnIntervention: [
    // 1) LA PRISE DE SERVICE
    CategoryConfig(
      label: 'La prise de service',
      badge: 'Service',
      image: 'assets/images/cat_hierarchie.jpg',
      route: '/gpx/intervention/prise-service',
      subcategories: [
        SubCategoryConfig(
          label: "La prise de service : l’appel",
          route: '/gpx/intervention/prise-service/appel',
          image: 'assets/images/prise_de_service.png',
        ),
        SubCategoryConfig(
          label: "Les principaux registres du poste",
          route: '/gpx/intervention/prise-service/registres',
          image: 'assets/images/registe_poste.png',
        ),
        SubCategoryConfig(
          label: "Les applications “main courante” et “déclaration d’usagers”",
          route: '/gpx/intervention/prise-service/applications',
          image: 'assets/images/main_courante.jpeg',
        ),
        SubCategoryConfig(
          label: "Mesures de sécurité, la fouille intégrale",
          route: '/gpx/intervention/prise-service/fouille-integrale',
          image: 'assets/images/fouille.jpeg',
        ),
        SubCategoryConfig(
          label: "La gestion humaine et matérielle de la garde à vue",
          route: '/gpx/intervention/prise-service/garde-a-vue',
          image: 'assets/images/gav.jpeg',
        ),
        SubCategoryConfig(
          label: "Maîtriser le risque d’évasion et de fuite (AMARIS)",
          route: '/gpx/intervention/prise-service/risque-evasion-fuite',
          image: 'assets/images/amaris.jpg',
        ),
      ],
    ),

    // 2) LA PATROUILLE
    CategoryConfig(
      label: 'La patrouille',
      badge: 'Patrouille',
      image: 'assets/images/memento_controle_routier.jpeg',
      route: '/gpx/intervention/patrouille',
      subcategories: [
        SubCategoryConfig(
          label: "La patrouille",
          route: '/gpx/intervention/patrouille/patrouille',
          image: 'assets/images/cat_infractions.jpg',
        ),
        SubCategoryConfig(
          label: "La communication radioélectrique",
          route: '/gpx/intervention/patrouille/communication-radio',
          image: 'assets/images/prise_de_service.png',
        ),
        SubCategoryConfig(
          label: "Plaquette : respect de la procédure radio",
          route: '/gpx/intervention/patrouille/procedure-radio',
          image: 'assets/images/prise_de_service.png',
        ),
        SubCategoryConfig(
          label: "MEMO TPH 900",
          route: '/gpx/intervention/patrouille/memo-tph-900',
          image: 'assets/images/prise_de_service.png',
        ),
        SubCategoryConfig(
          label: "Les principaux fichiers",
          route: '/gpx/intervention/patrouille/principaux-fichiers',
          image: 'assets/images/copic_institutions.jpg',
        ),
        SubCategoryConfig(
          label: "L’interrogation du F.P.R.",
          route: '/gpx/intervention/patrouille/interrogation-fpr',
          image: 'assets/images/criminalite_organisee.jpeg',
        ),
        SubCategoryConfig(
          label: "La caméra piéton",
          route: '/gpx/intervention/patrouille/camera-pieton',
          image: 'assets/images/camera_pieton.jpg',
        ),
        SubCategoryConfig(
          label: "L’utilité de la caméra piéton (AMARIS)",
          route: '/gpx/intervention/patrouille/utilite-camera',
          image: 'assets/images/amaris.jpg',
        ),
        SubCategoryConfig(
          label: "Les équipements de sécurité",
          route: '/gpx/intervention/patrouille/equipements-securite',
          image: 'assets/images/equipement_securite.jpg',
        ),
        SubCategoryConfig(
          label: "La conduite des véhicules de police",
          route: '/gpx/intervention/patrouille/conduite-vehicules',
          image: 'assets/images/voiture_police.jpg',
        ),
        SubCategoryConfig(
          label: "L’usage des signaux sonores et lumineux",
          route: '/gpx/intervention/patrouille/signaux-sonores-lumineux',
          image: 'assets/images/gyro.jpg',
        ),
        SubCategoryConfig(
          label: "Le signalement descriptif",
          route: '/gpx/intervention/patrouille/signalement-descriptif',
          image: 'assets/images/signalement_descriptif.jpg',
        ),
        SubCategoryConfig(
          label: "La palpation de sécurité",
          route: '/gpx/intervention/patrouille/palpation-securite',
          image: 'assets/images/fouille.jpeg',
        ),
        SubCategoryConfig(
          label: "Le menottage",
          route: '/gpx/intervention/patrouille/menottage',
          image: 'assets/images/menottage.jpeg',
        ),
        SubCategoryConfig(
          label:
              "Enregistrement et diffusion éventuelle d'images et de paroles de fonctionnaires de police dans l'exercice de leurs fonctions.",
          route:
              '/gpx/intervention/patrouille/enregistrement-diffusion-images-paroles',
          image: 'assets/images/enregistement_police.jpg',
        ),
        SubCategoryConfig(
          label: "Synthèse des indicateurs de basculement",
          route:
              '/gpx/intervention/patrouille/synthese-indicateurs-basculement',
          image: 'assets/images/emotion.webp',
        ),
      ],
    ),

    // 3) L’ACCIDENT DE LA CIRCULATION
    CategoryConfig(
      label: 'L’accident de la circulation',
      badge: 'Accident',
      image: 'assets/images/mise_en_danger.jpeg',
      route: '/gpx/intervention/accident-circulation',
      subcategories: [
        SubCategoryConfig(
          label:
              "La sécurité pendant le trajet et sur les lieux du constat d’un accident de la circulation",
          route: '/gpx/intervention/accident-circulation/securite-trajet-lieux',
          image: 'assets/images/acccident_voiture.jpeg',
        ),
        SubCategoryConfig(
          label: "Les différents types d’accidents de la circulation routière",
          route: '/gpx/intervention/accident-circulation/types-accidents',
          image: 'assets/images/different_accident.jpg',
        ),
        SubCategoryConfig(
          label: "La régulation de la circulation",
          route:
              '/gpx/intervention/accident-circulation/regulation-circulation',
          image: 'assets/images/regulastion_accident.webp',
        ),
      ],
    ),

    // 4) L’INTERVENTION AU DOMICILE
    CategoryConfig(
      label: 'L’intervention au domicile',
      badge: 'Domicile',
      image: 'assets/images/mineurs_famille.jpeg',
      route: '/gpx/intervention/domicile',
      subcategories: [
        SubCategoryConfig(
          label: "Le domicile et la violation de domicile",
          route: '/gpx/intervention/domicile/violation-domicile',
          image: 'assets/images/violation_domicile.webp',
        ),
        SubCategoryConfig(
          label: "Les bruits et tapages",
          route: '/gpx/intervention/domicile/bruits-tapages',
          image: 'assets/images/tapage.jpg',
        ),
        SubCategoryConfig(
          label: "Le différend familial",
          route: '/gpx/intervention/domicile/differend-familial',
          image: 'assets/images/different_familiale.jpg',
        ),
        SubCategoryConfig(
          label:
              "Violences conjugales : conduite à tenir lors des interventions à domicile",
          route: '/gpx/intervention/domicile/violences-conjugales',
          image: 'assets/images/violence_conjugale.jpg',
        ),
      ],
    ),

    // 5) LES AUTRES INTERVENTIONS
    CategoryConfig(
      label: 'Les autres interventions',
      badge: 'Divers',
      image: 'assets/images/hierarchie_police.jpeg',
      route: '/gpx/intervention/autres',
      subcategories: [
        SubCategoryConfig(
          label: "“Primo-intervenant sur une scène d’infraction” (AMARIS)",
          route: '/gpx/intervention/autres/primo-scene-infraction-amaris',
          image: 'assets/images/flagrant_delit.webp',
        ),
        SubCategoryConfig(
          label:
              "Bagages abandonnés, oubliés ; objets, engins ou véhicules suspects",
          route: '/gpx/intervention/autres/alertes-a-la-bombe',
          image: 'assets/images/deminage_camion.png',
        ),
        SubCategoryConfig(
          label: "Identification et détection des produits suspects",
          route:
              '/gpx/intervention/autres/identification-detection-produits-suspects',
          image: 'assets/images/identifiacation_colis.png',
        ),
        SubCategoryConfig(
          label: "L’ivresse publique et manifeste (I.P.M.)",
          route: '/gpx/intervention/autres/ipm',
          image: 'assets/images/ipm.jpg',
        ),
        SubCategoryConfig(
          label: "Les plans ORSEC",
          route: '/gpx/intervention/autres/plans-orsec',
          image: 'assets/images/ORSEC_large.jpg',
        ),
      ],
    ),

    // 6) FORMULAIRES UTILES
    CategoryConfig(
      label: 'Formulaires utiles',
      badge: 'Docs',
      image: 'assets/images/copic_institutions.jpg',
      route: '/gpx/intervention/formulaires-utiles',
      subcategories: [
        SubCategoryConfig(
          label: "Avis de rétention d’un permis de conduire",
          route: '/gpx/intervention/formulaires-utiles/avis-retention-permis',
          image: 'assets/images/retention_permis_conduire.jpg',
        ),
        SubCategoryConfig(
          label: "Fiche d’immobilisation",
          route: '/gpx/intervention/formulaires-utiles/fiche-immobilisation',
          image: 'assets/images/fiche_immobilisation.jpg',
        ),
        SubCategoryConfig(
          label:
              "Fiche descriptive de l’état du véhicule à enlever en fourrière",
          route:
              '/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere',
          image: 'assets/images/fourrière.webp',
        ),
      ],
    ),
  ],

  // =========================================================
  // 5) RECUEIL PV (APJ 20)
  // =========================================================
  GpxSchoolProgram.recueilPvApj20: [
    // =========================================================
    // INTRODUCTION
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Introduction',
      badge: 'Bases',
      image: 'assets/images/pv_intro.jpg',
      route: '/gpx/pv_apj20/introduction',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/introduction/preambule',
          image: 'assets/images/pv_preambule.png',
        ),
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/introduction/procedure',
          image: 'assets/images/pv_procedure.png',
        ),
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/introduction/proces_verbaux',
          image: 'assets/images/proces_verbaux.png',
        ),
        SubCategoryConfig(
          label: 'L’état-civil',
          route: '/gpx/pv_apj20/introduction/etat_civil',
          image: 'assets/images/etat_civil.png',
        ),
      ],
    ),

    // =========================================================
    // LA PLAINTE
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — La plainte',
      badge: 'Plainte',
      image: 'assets/images/pv_plainte.jpeg',
      route: '/gpx/pv_apj20/plainte',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/plainte/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas de procès-verbal de plainte contre auteur inconnu',
          route: '/gpx/pv_apj20/plainte/pv_saisine_personne_inconnue',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas de procès-verbal de plainte contre personne dénommée',
          route: '/gpx/pv_apj20/plainte/pv_saisine_personne_denommee',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas de procès-verbal de plainte contre personne dénommée — Suite',
          route: '/gpx/pv_apj20/plainte/pv_saisine_personne_denommee_suite',
          image: 'assets/images/canevas.png',
        ),

        // --- Violences conjugales (pack)
        SubCategoryConfig(
          label: 'Violences conjugales — Grille d’évaluation du danger',
          route:
              '/gpx/pv_apj20/plainte/violences_conjugales/presentation_grille_danger',
          image: 'assets/images/pv_vc_grille_danger.jpg',
        ),
        SubCategoryConfig(
          label:
              'Violences conjugales — Document d’information synthétique (démarches & dispositifs)',
          route:
              '/gpx/pv_apj20/plainte/violences_conjugales/document_info_synthetique',
          image: 'assets/images/pv_vc_document_info.webp',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV de plainte d’une victime de violences conjugales',
          route: '/gpx/pv_apj20/plainte/violences_conjugales/pv_victime',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // LES CONSTATATIONS
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Constatations',
      badge: 'Constats',
      image: 'assets/images/perquisition.jpeg',
      route: '/gpx/pv_apj20/constatations',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/constatations/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/constatations/canevas_pv',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // LE TÉMOIGNAGE
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Témoignage',
      badge: 'Audition',
      image: 'assets/images/renseignements.jpeg',
      route: '/gpx/pv_apj20/temoignage',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/temoignage/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV d’enquête de voisinage',
          route: '/gpx/pv_apj20/temoignage/enquete_voisinage',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV d’audition de témoin',
          route: '/gpx/pv_apj20/temoignage/audition_temoins',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // LE CONTRÔLE D’IDENTITÉ
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Contrôle d’identité',
      badge: 'Identité',
      image: 'assets/images/pv_controle_identite.jpeg',
      route: '/gpx/pv_apj20/controle_identite',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/controle_identite/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV de contrôle d’identité',
          route: '/gpx/pv_apj20/controle_identite/pv_controle_identite',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV de contrôle d’identité + fiche de recherche',
          route: '/gpx/pv_apj20/controle_identite/pv_ci_fiche_recherche',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // L’INTERPELLATION — LA CONDUITE AU POSTE
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Interpellation & conduite au poste',
      badge: 'Interpellation',
      image: 'assets/images/pv_interpellation.jpeg',
      route: '/gpx/pv_apj20/interpellation',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/interpellation/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV de contrôle d’identité + découverte d’une arme',
          route: '/gpx/pv_apj20/interpellation/ci_decouverte_arme',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV d’interpellation',
          route: '/gpx/pv_apj20/interpellation/pv_interpellation',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV de conduite au poste',
          route: '/gpx/pv_apj20/interpellation/conduite_au_poste',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Les mandats (recherche, comparution, amener, arrêt)',
          route: '/gpx/pv_apj20/interpellation/mandats',
          image: 'assets/images/pv_mandats.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV de notification de mandat',
          route: '/gpx/pv_apj20/interpellation/notification_mandat',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV de recherches infructueuses (exécution mandat)',
          route: '/gpx/pv_apj20/interpellation/recherches_infructueuses_mandat',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas de compte-rendu à l’O.P.J.',
          route: '/gpx/pv_apj20/interpellation/compte_rendu_opj',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // STATUT DU GARDÉ À VUE & SUSPECT LIBRE
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — GAV & suspect libre',
      badge: 'Droits',
      image: 'assets/images/pv_gav_suspect_libre.jpeg',
      route: '/gpx/pv_apj20/gav_suspect_libre',
      subcategories: [
        SubCategoryConfig(
          label: 'La garde à vue : généralités',
          route: '/gpx/pv_apj20/gav_suspect_libre/gav_generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : notification placement GAV + droits (A.P.J.)',
          route: '/gpx/pv_apj20/gav_suspect_libre/notification_gav_droits_apj',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Le suspect libre : généralités',
          route: '/gpx/pv_apj20/gav_suspect_libre/suspect_libre_generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : notification des droits au suspect majeur',
          route:
              '/gpx/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV : notification en audition libre (contravention/délit non puni emprisonnement)',
          route:
              '/gpx/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : notification des droits — Art. 65 du C.P.P.',
          route:
              '/gpx/pv_apj20/gav_suspect_libre/notification_droits_art_65_cpp',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Intervention de l’avocat : généralités',
          route: '/gpx/pv_apj20/gav_suspect_libre/avocat_generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : entretien du gardé à vue avec l’avocat',
          route: '/gpx/pv_apj20/gav_suspect_libre/entretien_gav_avocat',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // AUDITION DU SUSPECT (GAV OU LIBRE)
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Audition du suspect',
      badge: 'Audition',
      image: 'assets/images/pv_audition_suspect.jpeg',
      route: '/gpx/pv_apj20/audition_suspect',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/audition_suspect/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : audition du gardé à vue',
          route: '/gpx/pv_apj20/audition_suspect/audition_gav',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : audition du suspect libre',
          route: '/gpx/pv_apj20/audition_suspect/audition_suspect_libre',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV : audition du suspect libre + notification des droits (contravention/délit non puni emprisonnement)',
          route:
              '/gpx/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Le civilement responsable : généralités',
          route:
              '/gpx/pv_apj20/audition_suspect/civilement_responsable_generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : audition du civilement responsable',
          route:
              '/gpx/pv_apj20/audition_suspect/audition_civilement_responsable',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // PERQUISITION EN ENQUÊTE PRÉLIMINAIRE
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Perquisition (enquête préliminaire)',
      badge: 'Enquête',
      image: 'assets/images/pv_perquisition.jpeg',
      route: '/gpx/pv_apj20/perquisition_preliminaire',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/perquisition_preliminaire/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : perquisition en enquête préliminaire',
          route: '/gpx/pv_apj20/perquisition_preliminaire/perquisition',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : fouille de véhicule en enquête préliminaire',
          route: '/gpx/pv_apj20/perquisition_preliminaire/fouille_vehicule',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // RÉQUISITIONS
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Réquisitions',
      badge: 'Réquisitions',
      image: 'assets/images/pv_requisitions.jpeg',
      route: '/gpx/pv_apj20/requisitions',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/requisitions/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : réquisition à personne',
          route: '/gpx/pv_apj20/requisitions/requisition_personne',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & rapport : réquisition à personne',
          route: '/gpx/pv_apj20/requisitions/rapport_requisition_personne',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // CONFRONTATION
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Confrontation',
      badge: 'Procédure',
      image: 'assets/images/pv_confrontation.jpeg',
      route: '/gpx/pv_apj20/confrontation',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/confrontation/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label: 'Canevas & PV : confrontation victime / gardé à vue',
          route: '/gpx/pv_apj20/confrontation/victime_gav',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV : confrontation victime / suspect libre (crime/délit puni emprisonnement)',
          route:
              '/gpx/pv_apj20/confrontation/victime_suspect_libre_emprisonnement',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // PROCÉDURES SPÉCIALES — ÉTRANGERS
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Procédures spéciales (étrangers)',
      badge: 'Spécial',
      image: 'assets/images/pv_etrangers.jpeg',
      route: '/gpx/pv_apj20/procedures_speciales/etrangers',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/procedures_speciales/etrangers/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV : contrôle d’identité + contrôle du séjour et de la circulation des étrangers',
          route:
              '/gpx/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV : contrôle du séjour et de la circulation des étrangers',
          route:
              '/gpx/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),

    // =========================================================
    // LA CIRCULATION ROUTIÈRE
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — Circulation routière',
      badge: 'Circulation',
      image: 'assets/images/pv_circulation_routiere.jpeg',
      route: '/gpx/pv_apj20/circulation_routiere',
      subcategories: [
        // --- Alcool
        SubCategoryConfig(
          label: 'Alcool — Généralités',
          route: '/gpx/pv_apj20/circulation_routiere/alcool/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label:
              'Alcool — Canevas & PV conduite au poste (dépistage CEEA positif / refus / sans dépistage)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Alcool — Canevas & PV d’interpellation suite conduite en état d’ivresse',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Alcool — Tableau des taux d’alcool (affichés & retenus)',
          route: '/gpx/pv_apj20/circulation_routiere/alcool/tableau_taux',
          image: 'assets/images/pv_tableau_taux_alcool.png',
        ),
        SubCategoryConfig(
          label:
              'Alcool — Canevas & PV vérification + notification des taux (CEEA)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Alcool — Canevas & PV vérification des taux (CEI)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool/verification_taux_cei',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Alcool — Canevas & PV prélèvement sanguin (vérification état alcoolique)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool/prelevement_sanguin',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Alcool — Canevas & rapport réquisition (examen clinique médical + prélèvement sanguin)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Alcool — Fiches A, B, C',
          route: '/gpx/pv_apj20/circulation_routiere/alcool/fiches_abc',
          image: 'assets/images/pv_fiches_abc.png',
        ),

        // --- Stupéfiants
        SubCategoryConfig(
          label: 'Stupéfiants — Généralités',
          route: '/gpx/pv_apj20/circulation_routiere/stupefiants/generalites',
          image: 'assets/images/stupefiants.jpeg',
        ),
        SubCategoryConfig(
          label:
              'Stupéfiants — Canevas & PV conduite au poste (dépistage positif / refus)',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Stupéfiants — Formulaire d’information',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/formulaire_information',
          image: 'assets/images/pv_formulaire_information.png',
        ),
        SubCategoryConfig(
          label:
              'Stupéfiants — Canevas & PV vérifications destinées à établir l’usage',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Stupéfiants — Fiche suivi prélèvements (analyse salivaire)',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire',
          image: 'assets/images/pv_suivi_prelevements.png',
        ),
        SubCategoryConfig(
          label: 'Stupéfiants — Canevas & PV suite à prélèvement sanguin',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Stupéfiants — Canevas & PV prélèvement sanguin (établir usage stupéfiants)',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label: 'Stupéfiants — Fiche suivi prélèvements (analyse sanguine)',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine',
          image: 'assets/images/pv_suivi_prelevements.png',
        ),
        SubCategoryConfig(
          label:
              'Stupéfiants — Canevas & rapport réquisition (examen clinique + prélèvement sanguin) + expertise',
          route:
              '/gpx/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise',
          image: 'assets/images/canevas.png',
        ),

        // --- Alcool + Stups
        SubCategoryConfig(
          label:
              'Alcool + Stups — Conduite au poste (dépistages positifs / refus)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/conduite_poste_depistages_positifs_ou_refus',
          image: 'assets/images/pv_conduite_poste.png',
        ),
        SubCategoryConfig(
          label:
              'Alcool + Stups — Conduite au poste (refus de se soumettre aux vérifications)',
          route:
              '/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/refus_verifications',
          image: 'assets/images/pv_refus_verifications.png',
        ),

        // --- Contravention 5e classe
        SubCategoryConfig(
          label: 'Contravention 5e classe — Grand excès de vitesse (+50 km/h)',
          route:
              '/gpx/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse',
          image: 'assets/images/grand_exces_vitesse.jpeg',
        ),
        SubCategoryConfig(
          label: 'Contravention 5e classe — Tableau des vitesses retenues',
          route:
              '/gpx/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses',
          image: 'assets/images/pv_tableau_vitesses.png',
        ),

        // --- Formulaires utiles
        SubCategoryConfig(
          label: 'Formulaires utiles — Avis de rétention du permis',
          route: '/gpx/intervention/formulaires-utiles/avis-retention-permis',
          image: 'assets/images/retention_permis.jpeg',
        ),
        SubCategoryConfig(
          label: 'Formulaires utiles — Fiche d’immobilisation',
          route: '/gpx/intervention/formulaires-utiles/fiche-immobilisation',
          image: 'assets/images/immobilisation.jpeg',
        ),
        SubCategoryConfig(
          label:
              'Formulaires utiles — Fiche descriptive état véhicule (fourrière)',
          route:
              '/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere',
          image: 'assets/images/mise_en_fourriere.jpeg',
        ),
      ],
    ),

    // =========================================================
    // L’I.V.P.M (Ivresse Publique et Manifeste)
    // =========================================================
    CategoryConfig(
      label: 'Recueil PV — I.V.P.M',
      badge: 'IPM',
      image: 'assets/images/ipm.jpeg',
      route: '/gpx/pv_apj20/ipm',
      subcategories: [
        SubCategoryConfig(
          label: '',
          route: '/gpx/pv_apj20/ipm/generalites',
          image: 'assets/images/généralités.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV contravention d’ivresse publique et manifeste (examen médical)',
          route: '/gpx/pv_apj20/ipm/pv_ipm_examen_medical',
          image: 'assets/images/canevas.png',
        ),
        SubCategoryConfig(
          label:
              'Canevas & PV contravention d’ivresse publique et manifeste (remise à un tiers)',
          route: '/gpx/pv_apj20/ipm/pv_ipm_remise_tiers',
          image: 'assets/images/canevas.png',
        ),
      ],
    ),
  ],

  // =========================================================
  // 6) DIMENSION HUMAINE (d’après le sommaire screen)
  // =========================================================
  GpxSchoolProgram.dimensionHumaine: [
    CategoryConfig(
      label: 'Communication & posture',
      badge: 'Relationnel',
      image: 'assets/images/dh_communication.jpeg',
      route: '/gpx/dimension_humaine/communication',
      subcategories: [
        // Socle initial
        SubCategoryConfig(
          label:
              'DH1 — Le fonctionnement intellectuel et émotionnel dans l’intervention',
          route: '/gpx/dimension_humaine/communication/dh1_fonctionnement',
          image: 'assets/images/dh1_fonctionnement.jpeg',
        ),
        SubCategoryConfig(
          label:
              'DH3 — Les stratégies de communication adaptées avec le public',
          route: '/gpx/dimension_humaine/communication/dh3_strategies_public',
          image: 'assets/images/dh3_strategies_public.jpeg',
        ),
        SubCategoryConfig(
          label: 'DH4 — La coordination au sein des équipes de police',
          route:
              '/gpx/dimension_humaine/communication/dh4_coordination_equipes',
          image: 'assets/images/dh4_coordination.jpeg',
        ),
        SubCategoryConfig(
          label: 'ADH2 — La posture professionnelle adaptée face à une victime',
          route: '/gpx/dimension_humaine/communication/adh2_posture_victime',
          image: 'assets/images/adh2_posture_victime.jpeg',
        ),
        SubCategoryConfig(
          label:
              'S3-2 — L’intervention auprès de victimes de violences intrafamiliales',
          route:
              '/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales',
          image: 'assets/images/s3_2_violences_intrafamiliales.jpeg',
        ),

        // ✅ QUIZ
        SubCategoryConfig(
          label: 'Quiz — Communication & posture',
          route: '/gpx/dimension_humaine/communication/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),

    // =========================================================
    // STRESS & GESTION ÉMOTIONNELLE
    // (stress, ressources, agressivité, suicide…)
    // =========================================================
    CategoryConfig(
      label: 'Stress & gestion émotionnelle',
      badge: 'Bien-être',
      image: 'assets/images/dh_stress.jpeg',
      route: '/gpx/dimension_humaine/stress',
      subcategories: [
        // Socle initial
        SubCategoryConfig(
          label: 'DH2 — Le stress',
          route: '/gpx/dimension_humaine/stress/dh2_stress',
          image: 'assets/images/dh2_stress.jpeg',
        ),
        SubCategoryConfig(
          label: 'DH2 — Le carnet des ressources',
          route: '/gpx/dimension_humaine/stress/dh2_carnet_ressources',
          image: 'assets/images/dh2_carnet_ressources.jpeg',
        ),

        // Socle avancé
        SubCategoryConfig(
          label: 'ADH9 — Faire face à une situation d’agressivité',
          route: '/gpx/dimension_humaine/stress/adh9_agressivite',
          image: 'assets/images/adh9_agressivite.jpeg',
        ),
        SubCategoryConfig(
          label: 'AC6 — Les conduites suicidaires',
          route: '/gpx/dimension_humaine/stress/ac6_conduites_suicidaires',
          image: 'assets/images/ac6_suicide.jpeg',
        ),

        // ✅ QUIZ
        SubCategoryConfig(
          label: 'Quiz — Stress & gestion émotionnelle',
          route: '/gpx/dimension_humaine/stress/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),

    // =========================================================
    // ÉTHIQUE AU QUOTIDIEN
    // (mental, violences sexuelles, confrontation à la mort…)
    // =========================================================
    CategoryConfig(
      label: 'Éthique au quotidien',
      badge: 'Valeurs',
      image: 'assets/images/dignite_discriminations.jpeg',
      route: '/gpx/dimension_humaine/ethique',
      subcategories: [
        // Socle initial
        SubCategoryConfig(
          label:
              'ADH1 — L’intervention auprès de personnes ne jouissant pas de toutes ses facultés mentales',
          route: '/gpx/dimension_humaine/ethique/adh1_facultes_mentales',
          image: 'assets/images/adh1_facultes_mentales.jpeg',
        ),
        SubCategoryConfig(
          label: 'ADH4 — Les violences sexuelles et sexistes',
          route:
              '/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes',
          image: 'assets/images/adh4_violences_sexuelles.jpeg',
        ),
        SubCategoryConfig(
          label:
              'ADH6 — La confrontation à la mort en situation professionnelle',
          route: '/gpx/dimension_humaine/ethique/adh6_confrontation_mort',
          image: 'assets/images/adh6_confrontation_mort.jpeg',
        ),

        // ✅ QUIZ
        SubCategoryConfig(
          label: 'Quiz — Éthique au quotidien',
          route: '/gpx/dimension_humaine/ethique/quiz',
          image: 'assets/images/quiz.jpeg',
        ),
      ],
    ),
  ],
};

const Map<String, String> redirectConfig = {
  // '/gpx/placeholder': '/gpx/ton_vrai_module',
};

// ===============================================================
// ✅ Discovery Tutorial Overlay for HomePageGpxSchool
// (focus + blur + tip bubble + next) — VERSION STABLE (NO FLASH)
// ===============================================================

class HomePageGpxSchoolDiscoveryTutorial extends StatefulWidget {
  const HomePageGpxSchoolDiscoveryTutorial({
    super.key,
    required this.active,
    required this.onFinished,
  });

  final bool active;
  final VoidCallback onFinished;

  @override
  State<HomePageGpxSchoolDiscoveryTutorial> createState() =>
      _HomePageGpxSchoolDiscoveryTutorialState();
}

class _HomePageGpxSchoolDiscoveryTutorialState
    extends State<HomePageGpxSchoolDiscoveryTutorial> {
  final GlobalKey _modeGradeKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _heroDeckKey = GlobalKey();
  final GlobalKey _progressKey = GlobalKey();

  final GlobalKey _bottomNavKey = GlobalKey();
  final GlobalKey _navJournalKey = GlobalKey();
  final GlobalKey _navFavoritesKey = GlobalKey();
  final GlobalKey _navProfileKey = GlobalKey();

  Rect? _hole;
  int _step = 0;
  bool _didRun = false;
  bool _show = false;

  static const double _pad = 8;

  // ✅ rendu uniforme & premium
  static const double _dimOpacity = 0.42; // ✅ uniformisé
  static const double _blurSigma = 18.0; // ✅ stable & fluide (évite gros coûts)

  // ✅ décalage de la bulle (c’est ICI que tu règles)
  static const double _bubbleOffsetY = -24.0; // négatif => remonte

  @override
  void didUpdateWidget(covariant HomePageGpxSchoolDiscoveryTutorial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_didRun) {
      _didRun = true;
      _start();
    }
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
      setState(() => _show = true);
      HapticFeedback.selectionClick();
    });
  }

  GlobalKey _currentKey() {
    switch (_step) {
      case 0:
        return _modeGradeKey;
      case 1:
        return _settingsKey;
      case 2:
        return _heroDeckKey;
      case 3:
        return _progressKey;
      case 4:
        return _bottomNavKey;
      case 5:
        return _navJournalKey;
      case 6:
        return _navFavoritesKey;
      case 7:
        return _navProfileKey;
      default:
        return _modeGradeKey;
    }
  }

  void _measure() {
    final ctx = _currentKey().currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final topLeftGlobal = box.localToGlobal(Offset.zero);
    final size = box.size;

    final overlayBox = context.findRenderObject() as RenderBox;
    final topLeftLocal = overlayBox.globalToLocal(topLeftGlobal);

    final nextHole = Rect.fromLTWH(
      topLeftLocal.dx - _pad,
      topLeftLocal.dy - _pad,
      size.width + _pad * 2,
      size.height + _pad * 2,
    );

    // ✅ IMPORTANT : ne JAMAIS mettre _hole = null => sinon flash
    setState(() => _hole = nextHole);
  }

  void _next() {
    if (_step >= 7) {
      widget.onFinished();
      return;
    }

    setState(() {
      _step += 1;
      // ✅ PAS de _hole = null ici
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });

    HapticFeedback.selectionClick();
  }

  ({String title, String text, String cta}) _copyForStep() {
    switch (_step) {
      case 0:
        return (
          title: "Mode & grade",
          text:
              "Ici tu peux changer ton mode et ton grade à n’importe quel moment.\n"
              "Ex : après le concours, tu passes en scolarité.",
          cta: "Suivant",
        );
      case 1:
        return (
          title: "Paramètres",
          text: "Ici tu peux configurer l’app : thème, préférences, options…",
          cta: "Suivant",
        );
      case 2:
        return (
          title: "Catégories",
          text:
              "Voici les catégories de ta scolarité.\n"
              "Tu peux swiper horizontalement et appuyer sur une carte ou sur “Découvrir”.",
          cta: "Suivant",
        );
      case 3:
        return (
          title: "Progression",
          text:
              "Tu retrouves ici ton avancement.\n"
              "Le bouton “Détails” te donne l’historique de tes quiz.",
          cta: "Suivant",
        );
      case 4:
        return (
          title: "Navigation",
          text:
              "En bas, tu peux accéder aux grandes sections de l’application.",
          cta: "Suivant",
        );
      case 5:
        return (
          title: "Journal",
          text:
              "Ici, tu accèdes au journal : cours & quiz de la scolarité GPX.",
          cta: "Suivant",
        );
      case 6:
        return (
          title: "Favoris",
          text: "Ici, tu retrouves tout ce que tu as mis en favoris.",
          cta: "Suivant",
        );
      case 7:
        return (
          title: "Compte",
          text:
              "Ici, tu gères ton compte.\n"
              "Après inscription, tu viendras compléter ton profil ici.",
          cta: "Terminer",
        );
      default:
        return (title: "COP’IQ", text: "Découverte", cta: "Suivant");
    }
  }

  ({double? top, double? bottom}) _bubblePositionFor(Rect hole) {
    final size = MediaQuery.sizeOf(context);
    final padTop = MediaQuery.of(context).padding.top;
    final padBot = MediaQuery.of(context).padding.bottom;

    const bubbleH = 132.0;
    const margin = 14.0;

    final forceAbove = (_step == 3) || (_step == 4);

    if (forceAbove) {
      final top = (hole.top - bubbleH - 14).clamp(
        padTop + 10,
        size.height - padBot - bubbleH - 10,
      );
      return (top: top, bottom: null);
    }

    final bottomSafe = size.height - padBot - (bubbleH + margin);
    if (hole.bottom > bottomSafe) {
      final top = (hole.top - bubbleH - 12).clamp(
        padTop + 10,
        size.height - padBot - bubbleH - 10,
      );
      return (top: top, bottom: null);
    }

    return (top: null, bottom: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    final hole = _hole;
    final copy = _copyForStep();

    return Stack(
      children: [
        // ✅ Home réelle (toujours en base)
        Positioned.fill(
          child: HomePageGpxSchool(
            tutorialLock: _show,
            modeGradeButtonKey: _modeGradeKey,
            settingsButtonKey: _settingsKey,
            heroDeckKey: _heroDeckKey,
            progressCardKey: _progressKey,
            bottomNavKey: _bottomNavKey,
            navJournalKey: _navJournalKey,
            navFavoritesKey: _navFavoritesKey,
            navProfileKey: _navProfileKey,
          ),
        ),

        if (_show && hole != null) ...[
          // ✅ BLUR + DIM (sans Opacity => pas d'erreur Impeller)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipPath(
                clipper: _HomeTutorialHoleClipper(hole),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurSigma,
                    sigmaY: _blurSigma,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(_dimOpacity),
                  ),
                ),
              ),
            ),
          ),

          // ✅ contour glow
          Positioned.fromRect(
            rect: hole,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF1147D9).withOpacity(0.42),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 22,
                      offset: const Offset(0, 14),
                      color: const Color(0xFF1147D9).withOpacity(0.12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ bulle
          Builder(
            builder: (_) {
              final pos = _bubblePositionFor(hole);
              return Positioned(
                left: 16,
                right: 16,
                top: pos.top != null ? (pos.top! + _bubbleOffsetY) : null,
                bottom: pos.bottom != null
                    ? (pos.bottom! - _bubbleOffsetY)
                    : null,
                child: SafeArea(
                  top: false,
                  child: _HomeTutorialBubbleNoSkip(
                    title: copy.title,
                    text: copy.text,
                    cta: copy.cta,
                    onNext: _next,
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _HomeTutorialHoleClipper extends CustomClipper<Path> {
  _HomeTutorialHoleClipper(this.hole);
  final Rect hole;

  @override
  Path getClip(Size size) {
    final p = Path()..addRect(Offset.zero & size);
    p.addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(22)));
    p.fillType = PathFillType.evenOdd;
    return p;
  }

  @override
  bool shouldReclip(covariant _HomeTutorialHoleClipper old) => old.hole != hole;
}

class _HomeTutorialBubbleNoSkip extends StatelessWidget {
  const _HomeTutorialBubbleNoSkip({
    required this.title,
    required this.text,
    required this.cta,
    required this.onNext,
  });

  final String title;
  final String text;
  final String cta;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 14),
            color: Colors.black.withOpacity(0.22),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.black.withOpacity(0.78),
              fontWeight: FontWeight.w700,
              fontSize: 13.3,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1147D9),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                cta,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
