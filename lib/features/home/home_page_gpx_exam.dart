import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/physics.dart' as phys;
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/features/onboarding/mode_picker.dart';
// ==== Modèles partagés depuis home_page.dart ====
import 'package:copiqpolice/features/home/home_page.dart'
    show CategoryConfig, SubCategoryConfig, Track, UserMode;
import 'package:copiqpolice/features/forum/forum_espace_exam_gpx.dart';
// ==== Pages existantes ====
import 'package:copiqpolice/features/home/journal_pa_exam_page.dart';
import 'package:copiqpolice/features/home/favoris_home.dart';
import 'package:copiqpolice/core/services/favorites.dart';
import 'package:copiqpolice/features/home/profil_page.dart';
import 'package:copiqpolice/features/home/parametre_home.dart';
import 'package:copiqpolice/core/services/subscription_service.dart';
import 'package:copiqpolice/features/home/abonnement_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class HomePageGpxExam extends StatefulWidget {
  const HomePageGpxExam({super.key});

  /// Pont pour charger le username (injecté au boot, même API que GPX).
  static Future<String?> Function()? usernameLoader;

  static const String routeName = '/home-gpx-exam';

  @override
  State<HomePageGpxExam> createState() => _HomePageGpxExamState();
}

class _HomePageGpxExamState extends State<HomePageGpxExam>
    with WidgetsBindingObserver {
  int _currentTab = 0;

  // ✅ Scroll + état enfants
  final PageStorageBucket _bucket = PageStorageBucket();

  // ✅ Recherche
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String _lastAutoRoute = '';
  String _lastAutoQuery = '';

  // ✅ Profil / prénom (user_profiles.first_name)
  String? _firstName;
  bool _isLoadingProfile = true;

  // Contexte : Exam + GPX
  static const _mode = UserMode.exam;
  static const _track = Track.gpx;

  // Source des catégories
  late final List<CategoryConfig> _cats =
      (categoriesConfigGPX[_mode]?[_track] ?? const <CategoryConfig>[]);

  // ===================== 💾 PERSISTENCE HERO DECK =====================

  static const String _kDeckIndexKey = 'gpx_exam_hero_deck_index';
  static const String _kLastFocusRouteKey = 'gpx_exam_last_focus_route';

  int _initialDeckIndex = 0;
  bool _hasLoadedDeckIndex = false;

  int _heroIndex = 0;
  String? _lastFocusRoute;

  int _computeDefaultDeckIndex() {
    final i = _cats.indexWhere(
      (c) => c.label.trim().toLowerCase().contains('structure'),
    );
    return i >= 0 ? i : 0;
  }

  Future<void> _loadSavedDeckIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getInt(_kDeckIndexKey);
      _lastFocusRoute = prefs.getString(_kLastFocusRouteKey);

      if (!mounted) return;

      final computed = (saved != null && saved >= 0 && saved < _cats.length)
          ? saved
          : _computeDefaultDeckIndex();

      setState(() {
        _initialDeckIndex = computed;
        _heroIndex = computed;
        _hasLoadedDeckIndex = true;
      });
    } catch (_) {
      if (!mounted) return;
      final computed = _computeDefaultDeckIndex();
      setState(() {
        _initialDeckIndex = computed;
        _heroIndex = computed;
        _hasLoadedDeckIndex = true;
      });
    }
  }

  Future<void> _persistDeckIndex(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kDeckIndexKey, index);
    } catch (_) {}
  }

  Future<void> _persistLastFocusRoute(String? route) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (route == null || route.trim().isEmpty) {
        await prefs.remove(_kLastFocusRouteKey);
      } else {
        await prefs.setString(_kLastFocusRouteKey, route);
      }
    } catch (_) {}
  }

  void _onHeroIndexChanged(int index) {
    if (!mounted) return;
    if (index == _heroIndex) return;
    setState(() => _heroIndex = index);
    _persistDeckIndex(index);
  }

  int _heroIndexSafe(int len) {
    if (len <= 0) return 0;
    return _heroIndex.clamp(0, len - 1);
  }

  // ===================== 🔐 QUOTA / QUIZ ROUTES =====================

  bool _isQuizLeafRoute(String route) {
    return route.startsWith('/gpx_exam/concours/culture_generale_') ||
        route.startsWith('/gpx_exam/concours/tests_psychotechniques/') ||
        route.startsWith('/gpx_exam/concours/langue_etrangere/exemples_') ||
        route.startsWith('/gpx_exam/concours/cas_pratique/');
  }

  Future<void> _openRouteWithQuota(String route) async {
    // ✅ lock global (toute l'app)
    final ok = await SubscriptionService.instance.guardAppAccess(context);
    if (!ok) return;

    // Non quiz => accès direct
    if (!_isQuizLeafRoute(route)) {
      if (!mounted) return;
      Navigator.of(context).pushNamed(route);
      return;
    }

    // Quiz => consomme côté backend
    final res = await SubscriptionService.instance.consumeFreeRequest();

    if (!res.allowed) {
      if (!mounted) return;

      await SubscriptionService.instance.refresh(force: true, withQuota: true);
      final q = SubscriptionService.instance.state.value.quota;

      final resetsTxt = (q?.resetsAt != null)
          ? '${q!.resetsAt.toLocal().day.toString().padLeft(2, '0')}/${q.resetsAt.toLocal().month.toString().padLeft(2, '0')} à ${q.resetsAt.toLocal().hour.toString().padLeft(2, '0')}:${q.resetsAt.toLocal().minute.toString().padLeft(2, '0')}'
          : 'dans 7 jours';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Limite atteinte'),
          content: Text(
            'Tu as utilisé tes 10 quiz gratuits.\n'
            'Réinitialisation : $resetsTxt.\n\n'
            'Passe en Premium pour accéder en illimité.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Plus tard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/abonnement');
              },
              child: const Text('Voir Premium'),
            ),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushNamed(route);
  }

  // ===================== 👤 PROFIL (first_name depuis user_profiles) =====================

  String? _sanitizeName(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return t;
  }

  Future<void> _loadFirstName() async {
    try {
      // 0) Si tu as encore un loader custom, on le garde en fallback
      // (mais ton besoin principal = user_profiles)
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;
        setState(() {
          _firstName = null;
          _isLoadingProfile = false;
        });
        return;
      }

      // 1) Requête sur user_profiles
      final data = await supabase
          .from('user_profiles')
          .select('first_name')
          .eq('user_id', user.id)
          .maybeSingle();

      final first = _sanitizeName(data?['first_name'] as String?);

      if (!mounted) return;
      setState(() {
        _firstName = first;
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _firstName = null;
        _isLoadingProfile = false;
      });
    }
  }

  // Si l’utilisateur remplit son profil puis revient sur la home,
  // on refresh automatiquement en reprenant le focus de l’app.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_loadFirstName());
    }
  }

  String get _greeting {
    // Exigence: si first_name vide => Bonjour 👋 (même si connecté)
    final fn = _sanitizeName(_firstName);
    if (fn == null) return 'Bonjour 👋';
    return 'Bonjour $fn';
  }

  // ===================== 🔎 RECHERCHE (CLARTÉ + ZÉRO FRICTION) =====================

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

      // 1 résultat => auto-open (UX: zéro friction)
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

      setState(() {}); // bouton clear
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

  // ===================== 🎯 FOCUS ENGINE (AUTORITÉ + CONTRÔLE) =====================

  CategoryConfig? _pickFocus({
    required int heroIndex,
    required List<CategoryConfig> cats,
  }) {
    if (cats.isEmpty) return null;

    final safeHero = heroIndex.clamp(0, cats.length - 1);
    final heroRoute = cats[safeHero].route;

    const priorities = <String>[
      'structure',
      'cas',
      'psychotech',
      'psycho',
      'culture',
      'langue',
    ];

    CategoryConfig? pickByNeedle(String needle) {
      final n = needle.toLowerCase();
      for (final c in cats) {
        if (c.route == heroRoute) continue;
        if (_lastFocusRoute != null && c.route == _lastFocusRoute) continue;
        final label = c.label.toLowerCase();
        final route = c.route.toLowerCase();
        if (label.contains(n) || route.contains(n)) return c;
      }
      return null;
    }

    for (final needle in priorities) {
      final c = pickByNeedle(needle);
      if (c != null) return c;
    }

    for (int step = 1; step <= cats.length; step++) {
      final idx = (safeHero + step) % cats.length;
      final c = cats[idx];
      if (c.route == heroRoute) continue;
      if (_lastFocusRoute != null && c.route == _lastFocusRoute) continue;
      return c;
    }

    for (final c in cats) {
      if (c.route != heroRoute) return c;
    }

    return null;
  }

  // ===================== NAV =====================

  void _openRouteOrDetails({
    required String label,
    required String route,
    List<SubCategoryConfig>? subs,
  }) {
    final redirectRoute = redirectConfigGPX[route];
    final target = redirectRoute ?? route;

    if (subs != null && subs.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _CategoryDetailPage(
            title: label,
            subcategories: subs,
            onOpenRoute: _openRouteWithQuota,
          ),
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

  // ===================== UI UTIL =====================

  Widget _sectionHeader(
    BuildContext context, {
    required String title,
    String? actionText,
    VoidCallback? onAction,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (actionText != null && onAction != null)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  actionText,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: _muted(context, .7),
                    letterSpacing: .1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===================== LIFECYCLE =====================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initialDeckIndex = _computeDefaultDeckIndex();
    _heroIndex = _initialDeckIndex;
    _loadSavedDeckIndex();

    // ✅ Subscription state au boot
    unawaited(
      SubscriptionService.instance.refresh(force: true, withQuota: true),
    );

    // ✅ Prénom depuis user_profiles
    unawaited(_loadFirstName());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ===================== BUILD =====================

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

    final focusCat = _pickFocus(
      heroIndex: _heroIndexSafe(_cats.length),
      cats: _cats,
    );

    // Persist focus route (anti répétition)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = focusCat?.route;
      if (route != null && route != _lastFocusRoute) {
        _lastFocusRoute = route;
        _persistLastFocusRoute(route);
      }
    });

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

            // Header (même rendu, logique greeting améliorée)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoadingProfile ? 'Bonjour 👋' : _greeting,
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
                            fontWeight: FontWeight.w700,
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

            // Search + Settings
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
                                hintText:
                                    'Rechercher (ex: cas, psy, annales...)',
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: _muted(context, .6),
                                  fontWeight: FontWeight.w600,
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

            const SizedBox(height: 18),

            // ⚠️ tu as demandé : ne pas toucher "Sélection de contenu" + deck
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sélection de contenu',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HeroDeck(
                key: const PageStorageKey('gpx-exam-hero-deck'),
                height: 330,
                items: deckItems,
                initialIndex: _initialDeckIndex,
                onIndexChanged: _onHeroIndexChanged,
                onOpen: (item) {
                  _openRouteOrDetails(
                    label: item.label,
                    route: item.route,
                    subs: item.subcategories,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            _sectionHeader(
              context,
              title: 'Focus du jour',
              actionText: 'Explorer',
              onAction: () => _goToTab(1),
            ),
            const SizedBox(height: 10),

            if (focusCat != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _MiniHeroCard(
                  title: focusCat.label,
                  subtitle: focusCat.badge,
                  image: focusCat.image,
                  onTap: () => _openRouteOrDetails(
                    label: focusCat.label,
                    route: focusCat.route,
                    subs: focusCat.subcategories,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Aucun focus disponible pour le moment.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _muted(context, .65),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            const SizedBox(height: 18),
          ],
        ),
      ),

      const JournalGpxExamPage(),
      const ForumEspaceExamGPXPage(),
      const FavorisHomePage(),
      const ProfilPage(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: AnimatedSwitcher(
          duration: _T.med,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: pages[_currentTab],
        ),
      ),
      bottomNavigationBar: _SlidingPillNavBar(
        currentIndex: _currentTab,
        onTap: _goToTab,
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

  // ✅ Persistance par le parent
  final ValueChanged<int>? onIndexChanged;

  // ✅ Ouverture gérée par le parent
  final void Function(_DeckItem item)? onOpen;

  const _HeroDeck({
    Key? key,
    required this.height,
    required this.items,
    required this.initialIndex,
    this.onIndexChanged,
    this.onOpen,
  }) : super(key: key);

  @override
  State<_HeroDeck> createState() => _HeroDeckState();
}

class _HeroDeckState extends State<_HeroDeck>
    with SingleTickerProviderStateMixin {
  static const _kStorageId = ValueKey('gpx-exam-hero-deck-index');

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
    if (_initializedFromStorage) return;

    if (widget.items.isEmpty) {
      _page = 0;
      _lastReportedIndex = 0;
      _initializedFromStorage = true;
      return;
    }

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

    if (widget.items.isEmpty) {
      _page = 0;
      _lastReportedIndex = 0;
      return;
    }

    if (oldWidget.items.length != widget.items.length) {
      final maxPage = (widget.items.length - 1).toDouble();
      _page = _page.clamp(0.0, maxPage);
      _lastReportedIndex = _page.round().clamp(0, widget.items.length - 1);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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

      final VoidCallback? onOpenCb = widget.onOpen == null
          ? null
          : () => widget.onOpen!(item);

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
                  onOpen: onOpenCb, // ✅ parent gère
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

  /// Navigation déléguée au parent (souvent _openRouteOrDetails)
  final VoidCallback? onOpen;

  const HeroCard({
    super.key,
    required this.item,
    required this.isDark,
    this.onOpen,
  });

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
      if (mounted && nowFav != _isFav) {
        setState(() => _isFav = nowFav);
      }
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

  Future<void> _open() async {
    HapticFeedback.selectionClick();

    final ok = await SubscriptionService.instance.guardAppAccess(context);
    if (!ok) return;

    if (widget.onOpen != null) {
      widget.onOpen!.call();
      return;
    }

    final redirectRoute = redirectConfigGPX[widget.item.route];
    final targetRoute = redirectRoute ?? widget.item.route;
    Navigator.of(context).pushNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SubscriptionState>(
      valueListenable: SubscriptionService.instance.state,
      builder: (context, s, _) {
        final locked = s.isLocked;

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
              // IMAGE RESPONSIVE PARFAITE
              Positioned.fill(
                child: Image.asset(
                  widget.item.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFF9E9E9E).withOpacity(.25),
                    );
                  },
                ),
              ),

              // voile haut
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // voile bas
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.00, 0.42, 0.85],
                      colors: [
                        Colors.black.withOpacity(.72),
                        Colors.black.withOpacity(.30),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // zone tap globale
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _open,
                    splashFactory: InkRipple.splashFactory,
                  ),
                ),
              ),

              // Favori
              Positioned(
                top: 12,
                left: 12,
                child: ClipOval(
                  child: Material(
                    color: Colors.black.withOpacity(0.28),
                    child: InkWell(
                      onTap: _toggleFavorite,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.32),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: ScaleTransition(
                            scale: _pop,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 160),
                              transitionBuilder: (child, anim) {
                                return ScaleTransition(
                                  scale: anim,
                                  child: child,
                                );
                              },
                              child: Icon(
                                _isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                key: ValueKey<bool>(_isFav),
                                size: 20,
                                color: _isFav ? Colors.redAccent : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Badge Premium
              if (locked)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _PremiumBadge(
                    onTap: () =>
                        Navigator.of(context).pushNamed('/subscription'),
                  ),
                ),

              // contenu bas
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.instrumentSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          height: 1.06,
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

                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _open,
                          child: Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: anthracite.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.10),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Découvrir',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 10),
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
                      ),
                    ],
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
  final Future<void> Function(String route) onOpenRoute;

  const _CategoryDetailPage({
    required this.title,
    required this.subcategories,
    required this.onOpenRoute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF0E0F12) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

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

          final img = (sub.image != null && sub.image!.trim().isNotEmpty)
              ? sub.image!.trim()
              : _imageFor(sub.label);

          final subtitle = _subtitleFor(sub.label);

          return _ModuleCard(
            tag: sub.route,
            title: sub.label,
            subtitle: subtitle,
            imagePath: img,
            onTap: () => onOpenRoute(sub.route),
          );
        },
      ),
    );
  }

  // ✅ fallback image simple (tu peux enrichir)
  String _imageFor(String label) {
    final l = label.toLowerCase().trim();

    if (l.contains('tableau')) return 'assets/images/concours_pa_epreuves.jpeg';
    if (l.contains('admiss'))
      return 'assets/images/concours_connaissances_generales.jpeg';
    if (l.contains('admission'))
      return 'assets/images/concours_photolangage.jpeg';

    return 'assets/images/concours_pa_epreuves.jpeg';
  }

  // ✅ sous-titres pro (tu peux enrichir)
  String _subtitleFor(String label) {
    final l = label.toLowerCase();

    if (l.contains('tableau')) return 'Vue synthétique et repères clés';
    if (l.contains('admiss')) return 'Épreuves écrites : contenu & attentes';
    if (l.contains('admission'))
      return 'Oral & sport : préparation et critères';

    return 'Module';
  }
}

class _QuickAction {
  final String label;
  final String caption;
  final IconData icon;
  final String route;
  final List<SubCategoryConfig>? subs;

  const _QuickAction({
    required this.label,
    required this.caption,
    required this.icon,
    required this.route,
    this.subs,
  });
}

class _QuickActionsGrid extends StatelessWidget {
  final List<_QuickAction> actions;
  final ValueChanged<_QuickAction> onTap;

  const _QuickActionsGrid({required this.actions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final soft = (isDark ? Colors.white : Colors.black).withOpacity(
      isDark ? .08 : .04,
    );

    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.25,
      ),
      itemBuilder: (_, i) {
        final a = actions[i];

        return Material(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          elevation: 0,
          child: InkWell(
            onTap: () => onTap(a),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 10),
                    color: Color(0x10000000),
                  ),
                ],
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(
                    0.06,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: soft,
                    ),
                    child: Icon(a.icon, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          a.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _muted(context, .68),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: _muted(context, .55),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MiniHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onTap;

  const _MiniHeroCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const double radius = 24;
    const double h = 168;
    const Color ctaBg = Color(0xFF2E3137);

    TextStyle overlineStyle() => GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Colors.white.withOpacity(.82),
      letterSpacing: .2,
    );

    TextStyle titleStyle() => GoogleFonts.instrumentSans(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      height: 1.06,
      color: Colors.white,
    );

    return ValueListenableBuilder<SubscriptionState>(
      valueListenable: SubscriptionService.instance.state,
      builder: (context, s, _) {
        final locked = s.isLocked;

        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            height: h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image + fallback solide
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF9E9E9E).withOpacity(.18),
                  ),
                ),

                // Voile premium : lisible, stable, institutionnel
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.58, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.18),
                        Colors.black.withOpacity(0.46),
                        Colors.black.withOpacity(0.82),
                      ],
                    ),
                  ),
                ),

                // ✅ Un seul badge “dominant” : Premium seulement si lock
                if (locked)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _PremiumBadge(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/abonnement'),
                    ),
                  ),

                // Contenu
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // (On retire le badge "Focus" -> section header suffit)
                      const Spacer(),

                      // Subtitle (badge métier)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: overlineStyle(),
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle(),
                      ),

                      const SizedBox(height: 12),

                      // CTA : aligné avec le deck (même verbe, même langage)
                      Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: ctaBg.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.10),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Découvrir',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tap layer propre : 1 seule hitbox, feedback net
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      splashFactory: InkRipple.splashFactory,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ======================================================================
// Carte “image + gradient + badge + CTA” (comme ton screen 2)
// ======================================================================

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
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
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return tp.size.height;
  }

  Future<void> _guardedOpen(BuildContext context) async {
    final ok = await SubscriptionService.instance.guardAppAccess(context);
    if (!ok) return;
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SubscriptionState>(
      valueListenable: SubscriptionService.instance.state,
      builder: (context, s, _) {
        final locked = s.isLocked;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final Color badgeBg = Colors.white.withOpacity(isDark ? 0.14 : 0.10);
        final Color borderClr = Colors.white.withOpacity(isDark ? 0.18 : 0.14);

        return LayoutBuilder(
          builder: (context, c) {
            const double pad = 16;
            const double badgeHApprox = 28;
            const double gapAfterBadge = 10;
            const double gapTitleSub = 6;

            const double ctaApproxW = 118;
            const double ctaApproxH = 44;
            const double gapBetweenTextAndCta = 12;

            final double textMaxWidth =
                (c.maxWidth - (pad * 2) - ctaApproxW - gapBetweenTextAndCta)
                    .clamp(140.0, c.maxWidth);

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
              onTap: () => _guardedOpen(context),
              child: Semantics(
                button: true,
                label: '$title — découvrir',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: cardHeight,
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

                        Padding(
                          padding: const EdgeInsets.all(pad),
                          child: Stack(
                            children: [
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

                              // ✅ badge Premium en haut à droite (comme ta carte “Je suis en scolarité”)
                              if (locked)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: _PremiumBadge(
                                    onTap: () => Navigator.of(
                                      context,
                                    ).pushNamed('/subscription'),
                                  ),
                                ),

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

                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: _RoundCTA(
                                  onTap: () => _guardedOpen(context),
                                ),
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

class _PremiumBadge extends StatelessWidget {
  final VoidCallback? onTap;
  const _PremiumBadge({this.onTap});

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.36),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.24), width: 1),
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
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: child,
      ),
    );
  }
}

// ======================================================================
//                      CONFIG GPX – MODE CONCOURS
//            (Gardien de la paix – UserMode.exam / Track.gpx)
// ======================================================================

const Map<String, String> redirectConfigGPX = {};

const Map<UserMode, Map<Track, List<CategoryConfig>>> categoriesConfigGPX = {
  UserMode.exam: {
    Track.gpx: [
      // ------------------------------------------------------------------
      // 1. Vue globale du concours GPX
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Structure du concours GPX',
        badge: 'Organisation & déroulement',
        image: 'assets/images/concours_pa_epreuves.jpeg',
        route: '/gpx_exam/concours/epreuves_gpx',
        subcategories: [
          SubCategoryConfig(
            label: 'Tableau récapitulatif des épreuves',
            route: '/gpx_exam/concours/epreuves_gpx/tableau',
          ),
          SubCategoryConfig(
            label: 'Épreuves d’admissibilité — écrit',
            route: '/gpx_exam/concours/epreuves_gpx/admissibilite',
          ),
          SubCategoryConfig(
            label: 'Épreuves d’admission — oral & sport',
            route: '/gpx_exam/concours/epreuves_gpx/admission',
            image: 'assets/images/sport.jpg',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 2. Cas pratique
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Cas pratique',
        badge: 'Méthodologie & raisonnement',
        image: 'assets/images/comprendre.jpg',
        route: '/gpx_exam/concours/cas_pratique/welcome',
      ),

      // ------------------------------------------------------------------
      // 3. QCM de culture générale
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Culture générale',
        badge: 'Institutions & société',
        image: 'assets/images/concours_connaissances_generales.jpeg',
        route: '/gpx_exam/concours/culture_generale',
        subcategories: [
          SubCategoryConfig(
            label: 'Histoire de france & institutions',
            route: '/gpx_exam/concours/culture_generale_histoire_france',
            image: 'assets/images/histoire_de_france.webp',
          ),
          SubCategoryConfig(
            label: 'Institutions européennes',
            route:
                '/gpx_exam/concours/culture_generale_institutions_europeennes',
            image: 'assets/images/ue.jpg',
          ),
          SubCategoryConfig(
            label: 'Actualité & société',
            route: '/gpx_exam/concours/culture_generale_actualite',
            image: 'assets/images/macron.jpg',
          ),
          SubCategoryConfig(
            label: 'Géographie française & mondiale',
            route: '/gpx_exam/concours/culture_generale_geographie',
            image: 'assets/images/geographie.png',
          ),
          SubCategoryConfig(
            label: 'Français & Humanités',
            route: '/gpx_exam/concours/culture_generale_francais',
            image: 'assets/images/francais_cg.jpg',
          ),
          SubCategoryConfig(
            label: 'Sport & culture générale',
            route: '/gpx_exam/concours/culture_generale_sport',
            image: 'assets/images/sport_cg.jpg',
          ),
          SubCategoryConfig(
            label: 'Sciences & environnement',
            route: '/gpx_exam/concours/culture_generale_sciences',
            image: 'assets/images/science.jpg',
          ),
          SubCategoryConfig(
            label: 'Santé & bien-être',
            route: '/gpx_exam/concours/culture_generale_sante',
            image: 'assets/images/sante.png',
          ),
          SubCategoryConfig(
            label: 'Police & sécurité publique',
            route: '/gpx_exam/concours/culture_generale_police_securite',
            image: 'assets/images/police.webp',
          ),
          SubCategoryConfig(
            label: 'Mythologie & culture générale',
            route: '/gpx_exam/concours/culture_generale_mythologie',
            image: 'assets/images/mythologie.webp',
          ),
          SubCategoryConfig(
            label: 'Musique & culture générale',
            route: '/gpx_exam/concours/culture_generale_musique',
            image: 'assets/images/musique.jpg',
          ),
          SubCategoryConfig(
            label: 'Cinéma & culture générale',
            route: '/gpx_exam/concours/culture_generale_cinema',
            image: 'assets/images/cinema.png',
          ),
          SubCategoryConfig(
            label: 'Droit & culture générale',
            route: '/gpx_exam/concours/culture_generale_droit',
            image: 'assets/images/action_justice.jpeg',
          ),
          SubCategoryConfig(
            label: 'Langue & culture générale',
            route: '/gpx_exam/concours/culture_generale_langue',
            image: 'assets/images/langue_francaise.webp',
          ),
          SubCategoryConfig(
            label: 'Sécurité routière & culture générale',
            route: '/gpx_exam/concours/culture_generale_securite_routiere',
            image: 'assets/images/secu.webp',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 4. QCM de langue étrangère
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Langue étrangère',
        badge: 'Anglais • Espagnol • Allemand',
        image: 'assets/images/diffusion_images.jpeg',
        route: '/gpx_exam/concours/langue_etrangere',
        subcategories: [
          SubCategoryConfig(
            label: 'QCM  — Anglais',
            route: '/gpx_exam/concours/langue_etrangere/exemples_anglais',
            image: 'assets/images/anglais.webp',
          ),
          SubCategoryConfig(
            label: 'QCM  — Espagnol',
            route: '/gpx_exam/concours/langue_etrangere/exemples_espagnol',
            image: 'assets/images/espagne.png',
          ),
          SubCategoryConfig(
            label: 'QCM  — Allemand',
            route: '/gpx_exam/concours/langue_etrangere/exemples_allemand',
            image: 'assets/images/allemand.jpg',
          ),
        ],
      ),

      // ------------------------------------------------------------------
      // 5. Tests psychotechniques
      // ------------------------------------------------------------------
      CategoryConfig(
        label: 'Tests psychotechniques',
        badge: 'Logique • Numérique • Verbal • Spatial',
        image: 'assets/images/concours_tests_psy.jpeg',
        route: '/gpx_exam/concours/tests_psychotechniques',
        subcategories: [
          // 📘 INTRO
          SubCategoryConfig(
            label: 'Comprendre l’épreuve',
            route:
                '/gpx_exam/concours/tests_psychotechniques/comprendre_epreuve',
            image: 'assets/images/comprendre_psyco.png',
          ),

          // 🧠 LOGIQUE
          SubCategoryConfig(
            label: 'Attention visuelle',
            route:
                '/gpx_exam/concours/tests_psychotechniques/attention_visuelle',
            image: 'assets/images/attention_visuelle.jpg',
          ),
          SubCategoryConfig(
            label: 'Suites logiques',
            route: '/gpx_exam/concours/tests_psychotechniques/suites_logiques',
            image: 'assets/images/suite_logique.png',
          ),
          SubCategoryConfig(
            label: 'Raisonnement logique',
            route:
                '/gpx_exam/concours/tests_psychotechniques/raisonnement_logique',
            image: 'assets/images/raisonnement.png',
          ),

          // 🔢 NUMÉRIQUE
          SubCategoryConfig(
            label: 'Calcul mental',
            route: '/gpx_exam/concours/tests_psychotechniques/calcul_mental',
            image: 'assets/images/calcul.png',
          ),
          // 🔤 VERBAL
          SubCategoryConfig(
            label: 'Logique verbale',
            route: '/gpx_exam/concours/tests_psychotechniques/logique_verbale',
            image: 'assets/images/verbal.png',
          ),
          // 🧊 SPATIAL
          SubCategoryConfig(
            label: 'Raisonnement spatial',
            route: '/gpx_exam/concours/tests_psychotechniques/spatial',
            image: 'assets/images/spatial.png',
          ),
          SubCategoryConfig(
            label: 'Rotations & symétries',
            route: '/gpx_exam/concours/tests_psychotechniques/rotations',
            image: 'assets/images/rotation.png',
          ),

          // 🏆 MODE CONCOURS (IMPORTANT)
          SubCategoryConfig(
            label: 'Mode concours (chronométré)',
            route: '/gpx_exam/concours/tests_psychotechniques/mode_concours',
            image: 'assets/images/chrono.jpg',
          ),
        ],
      ),
    ],
  },
};
