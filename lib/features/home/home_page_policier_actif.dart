import 'dart:async';
import 'dart:ui';
import 'package:flutter/physics.dart' as physics;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../active/active_access_service.dart';
import '../active/active_dynamic_course_page.dart';
import '../forum/community_models.dart';
import '../forum/community_page.dart';
import 'parametre_home.dart';
import 'profil_page.dart';

class HomePagePolicierActif extends StatefulWidget {
  const HomePagePolicierActif({super.key, this.parentId, this.title});
  final String? parentId;
  final String? title;
  @override
  State<HomePagePolicierActif> createState() => _HomePagePolicierActifState();
}

class _HomePagePolicierActifState extends State<HomePagePolicierActif> {
  final _service = ActiveAccessService();
  final _search = TextEditingController();
  Timer? _timer;
  List<ActiveContentNode> _nodes = const [];
  bool _loading = true, _dialogOpen = false;
  bool _ownerPreviewActive = false;
  String _query = '';
  String? _error;
  int _currentTab = 0;
  String? _firstName;
  final _favoritesKey = GlobalKey<_ActiveFavoritesTabState>();

  @override
  void initState() {
    super.initState();
    _loadFirstName();
    _load();
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _checkAvailability(),
    );
  }

  Future<void> _loadFirstName() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    final metadata = user?.userMetadata;
    var candidate =
        metadata?['first_name'] ??
        metadata?['firstname'] ??
        metadata?['full_name'] ??
        metadata?['name'];
    if ((candidate?.toString().trim().isEmpty ?? true) && user != null) {
      try {
        final profile = await client
            .from('user_profiles')
            .select('first_name')
            .eq('user_id', user.id)
            .maybeSingle();
        candidate = profile?['first_name'];
      } catch (_) {
        // La salutation reste utilisable même si le profil est indisponible.
      }
    }
    final name = candidate?.toString().trim().split(RegExp(r'\s+')).first;
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _firstName = name);
    }
  }

  Future<void> _load() async {
    try {
      final config = await _service.config();
      if (!config.available) {
        await _showDisabled(config);
        return;
      }
      if (!config.ownerPreviewActive) {
        final access = await _service.status();
        if (!mounted) return;
        if (!access.granted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/active-verification', (_) => false);
          return;
        }
      }
      final nodes = await _service.contentTree();
      if (mounted)
        setState(() {
          _nodes = nodes;
          _ownerPreviewActive = config.ownerPreviewActive;
          _loading = false;
          _error = null;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = 'Impossible de charger les contenus pour le moment.';
        });
    }
  }

  Future<void> _checkAvailability() async {
    if (!mounted || _dialogOpen) return;
    try {
      final c = await _service.config();
      if (!c.available && mounted) {
        await _showDisabled(c);
      } else if (mounted && _ownerPreviewActive != c.ownerPreviewActive) {
        setState(() => _ownerPreviewActive = c.ownerPreviewActive);
      }
    } catch (_) {}
  }

  Future<void> _showDisabled(ActiveModeConfig config) async {
    if (_dialogOpen || !mounted) return;
    _dialogOpen = true;
    var seconds = config.countdownSeconds;
    Timer? countdown;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Mise à jour du module actif',
      barrierColor: Colors.black.withValues(alpha: .78),
      transitionDuration: const Duration(milliseconds: 320),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: .94, end: 1).animate(curved),
            child: child,
          ),
        );
      },
      pageBuilder: (dialogContext, animation, secondaryAnimation) =>
          StatefulBuilder(
            builder: (context, refresh) {
              countdown ??= Timer.periodic(const Duration(seconds: 1), (timer) {
                seconds--;
                if (seconds <= 0) {
                  timer.cancel();
                  Navigator.of(dialogContext).pop();
                  _leave();
                } else {
                  refresh(() {});
                }
              });
              return _ActiveModuleUnavailableDialog(
                message: config.disableMessage,
                seconds: seconds,
                totalSeconds: config.countdownSeconds,
                onLeave: () {
                  countdown?.cancel();
                  Navigator.of(dialogContext).pop();
                  _leave();
                },
              );
            },
          ),
    );
    countdown?.cancel();
    _dialogOpen = false;
  }

  Future<void> _leave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_mode');
    await prefs.remove('selected_track');
    if (mounted)
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/mode_picker', (_) => false);
  }

  void _open(ActiveContentNode node) {
    final page = node.isCourse
        ? ActiveDynamicCoursePage(node: node)
        : HomePagePolicierActif(parentId: node.id, title: node.title);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final visible = _nodes
        .where(
          (n) =>
              n.parentId == widget.parentId &&
              '${n.title} ${n.subtitle ?? ''}'.toLowerCase().contains(
                _query.toLowerCase(),
              ),
        )
        .toList();

    if (widget.parentId != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title ?? '',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                _SearchBar(
                  controller: _search,
                  onChanged: (value) => setState(() => _query = value.trim()),
                ),
                const SizedBox(height: 18),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_error != null)
                  _EmptyState(
                    icon: Icons.cloud_off_rounded,
                    text: _error!,
                    action: _load,
                  )
                else if (visible.isEmpty)
                  const _EmptyState(
                    icon: Icons.auto_stories_outlined,
                    text: 'Aucun contenu publié dans cette rubrique.',
                  )
                else
                  ...visible.map(
                    (node) => _ContentCard(
                      node: node,
                      onTap: () => _open(node),
                      dark: dark,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final pages = <Widget>[
      _ActiveHomeTab(
        firstName: _firstName,
        ownerPreviewActive: _ownerPreviewActive,
        nodes: visible,
        loading: _loading,
        error: _error,
        searchController: _search,
        onSearch: (value) => setState(() => _query = value.trim()),
        onOpen: _open,
        onRefresh: _load,
        onMode: _leave,
      ),
      _ActiveProgressTab(
        service: _service,
        nodes: _nodes,
        onStart: () {
          if (visible.isNotEmpty) _open(visible.first);
        },
      ),
      const CommunityPage(
        initialScope: CommunityScope.active,
        lockedToInitialScope: true,
      ),
      _ActiveFavoritesTab(
        key: _favoritesKey,
        service: _service,
        nodes: _nodes,
        onOpen: _open,
      ),
      const ProfilPage(),
    ];

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: IndexedStack(index: _currentTab, children: pages),
      ),
      bottomNavigationBar: _ActiveBottomNav(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() => _currentTab = index);
          if (index == 3) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _favoritesKey.currentState?.refresh(),
            );
          }
        },
      ),
    );
  }
}

class _ActiveHomeTab extends StatelessWidget {
  const _ActiveHomeTab({
    required this.firstName,
    required this.ownerPreviewActive,
    required this.nodes,
    required this.loading,
    required this.error,
    required this.searchController,
    required this.onSearch,
    required this.onOpen,
    required this.onRefresh,
    required this.onMode,
  });
  final String? firstName;
  final bool ownerPreviewActive;
  final List<ActiveContentNode> nodes;
  final bool loading;
  final String? error;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final ValueChanged<ActiveContentNode> onOpen;
  final Future<void> Function() onRefresh;
  final VoidCallback onMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = nodes.isEmpty ? null : nodes.first;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          if (ownerPreviewActive) ...[
            const _OwnerPreviewBanner(),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName == null ? 'Bonjour 👋' : 'Bonjour $firstName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Bienvenue sur COP’IQ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _HeaderButton(
                label: 'Espace actif',
                icon: Icons.arrow_back_rounded,
                onTap: onMode,
              ),
              const SizedBox(width: 8),
              _CircleButton(
                icon: Icons.local_police_rounded,
                tooltip: 'Changer de mode',
                onTap: onMode,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SearchBar(
                  controller: searchController,
                  onChanged: onSearch,
                ),
              ),
              const SizedBox(width: 10),
              _CircleButton(
                icon: Icons.settings_rounded,
                tooltip: 'Paramètres',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ParametreHomePage()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Espace professionnel — Gardien de la Paix',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélection de contenu',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (loading)
            const SizedBox(
              height: 330,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (error != null)
            _EmptyState(
              icon: Icons.cloud_off_rounded,
              text: error!,
              action: onRefresh,
            )
          else if (nodes.isEmpty)
            const _EmptyState(
              icon: Icons.auto_stories_outlined,
              text: 'Aucun contenu publié dans cette rubrique.',
            )
          else
            _ActiveHeroDeck(height: 330, nodes: nodes, onOpen: onOpen),
          if (next != null) ...[
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 19,
                  color: Color(0xFF2D6CDF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ta prochaine étape',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  'Aujourd’hui',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ActiveNextStepCard(node: next, onTap: () => onOpen(next)),
          ],
        ],
      ),
    );
  }
}

class _ActiveModuleUnavailableDialog extends StatelessWidget {
  const _ActiveModuleUnavailableDialog({
    required this.message,
    required this.seconds,
    required this.totalSeconds,
    required this.onLeave,
  });

  final String message;
  final int seconds;
  final int totalSeconds;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final progress = totalSeconds <= 0
        ? 0.0
        : (seconds / totalSeconds).clamp(0.0, 1.0);
    final surface = dark ? const Color(0xFF11161D) : Colors.white;
    final text = dark ? Colors.white : const Color(0xFF111827);
    final muted = dark ? const Color(0xFFAFB8C5) : const Color(0xFF5B6472);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Semantics(
                namesRoute: true,
                label:
                    'Mise à jour du module. Retour automatique dans $seconds secondes.',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 410),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: dark
                            ? Colors.white.withValues(alpha: .1)
                            : const Color(0xFFE5EAF0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .34),
                          blurRadius: 48,
                          offset: const Offset(0, 24),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _ActiveModuleDialogHero(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Le module se met à jour',
                                style: GoogleFonts.poppins(
                                  fontSize: 23,
                                  height: 1.12,
                                  fontWeight: FontWeight.w800,
                                  color: text,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                message,
                                style: GoogleFonts.instrumentSans(
                                  fontSize: 15,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: dark
                                      ? Colors.white.withValues(alpha: .045)
                                      : const Color(0xFFF5F8FC),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: dark
                                        ? Colors.white.withValues(alpha: .07)
                                        : const Color(0xFFE7EDF5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox.square(
                                      dimension: 52,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: progress,
                                            strokeWidth: 4,
                                            strokeCap: StrokeCap.round,
                                            backgroundColor: const Color(
                                              0xFF2D6CDF,
                                            ).withValues(alpha: .13),
                                            valueColor:
                                                const AlwaysStoppedAnimation(
                                                  Color(0xFF2D6CDF),
                                                ),
                                          ),
                                          Text(
                                            '$seconds',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: text,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 13),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Retour automatique',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: text,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Tu seras redirigé vers le choix des modules.',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  height: 1.35,
                                                  color: muted,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.verified_user_outlined,
                                      size: 18,
                                      color: Color(0xFF2D6CDF),
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      'Ta progression, tes favoris et ton historique sont conservés.',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            height: 1.4,
                                            color: muted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: FilledButton(
                                  onPressed: onLeave,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D6CDF),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Choisir un autre module',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 9),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                      ),
                                    ],
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveModuleDialogHero extends StatelessWidget {
  const _ActiveModuleDialogHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF061127), Color(0xFF102D61)],
              ),
            ),
          ),
          Positioned(
            right: -42,
            top: -65,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF24B5E4).withValues(alpha: .16),
              ),
            ),
          ),
          Positioned(
            left: -50,
            bottom: -88,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE63338).withValues(alpha: .12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .12),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    semanticLabel: 'Logo COP’IQ',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .13),
                          ),
                        ),
                        child: Text(
                          'MISE À JOUR SÉCURISÉE',
                          style: GoogleFonts.instrumentSans(
                            color: const Color(0xFF8CDFFF),
                            fontSize: 9,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'COP’IQ évolue',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 19,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Une meilleure expérience se prépare.',
                        style: GoogleFonts.instrumentSans(
                          color: Colors.white.withValues(alpha: .68),
                          fontSize: 12,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerPreviewBanner extends StatelessWidget {
  const _OwnerPreviewBanner();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label:
          'Aperçu propriétaire actif. Ce module reste masqué pour les autres utilisateurs.',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF2B2414) : const Color(0xFFFFF7DF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF3B61F).withValues(alpha: .45),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFF3B61F),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aperçu propriétaire',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Visible uniquement sur ton compte — le public reste bloqué.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.lock_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    height: 50,
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .06),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search_rounded),
        hintText: 'Rechercher un contenu…',
        contentPadding: EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: tooltip,
    child: Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: .12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 48, height: 48, child: Icon(icon)),
      ),
    ),
  );
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: .25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActiveHeroDeck extends StatefulWidget {
  const _ActiveHeroDeck({
    required this.height,
    required this.nodes,
    required this.onOpen,
  });

  final double height;
  final List<ActiveContentNode> nodes;
  final ValueChanged<ActiveContentNode> onOpen;

  @override
  State<_ActiveHeroDeck> createState() => _ActiveHeroDeckState();
}

class _ActiveHeroDeckState extends State<_ActiveHeroDeck>
    with SingleTickerProviderStateMixin {
  static const _storageId = ValueKey('active-hero-deck-index');

  late final AnimationController _controller = AnimationController.unbounded(
    vsync: this,
    value: 0,
  )..addListener(_onTick);

  double get _page => _controller.value;
  set _page(double value) => _controller.value = value;

  bool _restored = false;
  double? _dragStartX;
  double _dragStartPage = 0;

  void _onTick() {
    PageStorage.maybeOf(
      context,
    )?.writeState(context, _page, identifier: _storageId);
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_restored || widget.nodes.isEmpty) return;
    final saved =
        PageStorage.maybeOf(context)?.readState(context, identifier: _storageId)
            as double?;
    _page = (saved ?? 0).clamp(0.0, (widget.nodes.length - 1).toDouble());
    _restored = true;
  }

  @override
  void didUpdateWidget(covariant _ActiveHeroDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nodes.isEmpty) {
      _page = 0;
      return;
    }
    if (oldWidget.nodes.length != widget.nodes.length) {
      _page = _page.clamp(0.0, (widget.nodes.length - 1).toDouble());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
    _dragStartPage = _page;
    _controller.stop();
  }

  void _dragUpdate(DragUpdateDetails details, double cardWidth) {
    if (_dragStartX == null || widget.nodes.isEmpty) return;
    final delta = -(details.globalPosition.dx - _dragStartX!) / cardWidth;
    _page = (_dragStartPage + delta).clamp(
      0.0,
      (widget.nodes.length - 1).toDouble(),
    );
  }

  void _dragEnd(DragEndDetails details, double cardWidth) {
    if (widget.nodes.isEmpty) return;
    final velocity = -details.velocity.pixelsPerSecond.dx / cardWidth;
    final target = (_page + velocity * .20).roundToDouble().clamp(
      0.0,
      (widget.nodes.length - 1).toDouble(),
    );
    const spring = physics.SpringDescription(
      mass: 1,
      stiffness: 420,
      damping: 32,
    );
    _controller.animateWith(
      physics.SpringSimulation(spring, _page, target, velocity),
    );
    _dragStartX = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nodes.isEmpty) return SizedBox(height: widget.height);

    return LayoutBuilder(
      builder: (context, constraints) {
        const viewportFraction = .78;
        final deckWidth = constraints.maxWidth;
        final cardWidth = deckWidth * viewportFraction;
        final sidePeek = (deckWidth - cardWidth) / 2;
        final order = List<int>.generate(widget.nodes.length, (index) => index)
          ..sort((a, b) => (b - _page).abs().compareTo((a - _page).abs()));

        Widget buildCard(int index) {
          final delta = index - _page;
          if (delta.abs() > 1.25) return const SizedBox.shrink();
          final proximity = 1 - delta.abs().clamp(0.0, 1.0);
          final scale = .90 + .10 * proximity;
          return Positioned.fill(
            child: Transform.translate(
              offset: Offset(delta * 52, (1 - proximity) * 18),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: .75 + .25 * proximity,
                  child: _ActiveHeroCard(
                    key: ValueKey(widget.nodes[index].id),
                    node: widget.nodes[index],
                    onTap: () => widget.onOpen(widget.nodes[index]),
                  ),
                ),
              ),
            ),
          );
        }

        return Semantics(
          label: 'Sélection de contenu, balayez horizontalement',
          child: SizedBox(
            height: widget.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePeek),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: _dragStart,
                onHorizontalDragUpdate: (details) =>
                    _dragUpdate(details, cardWidth),
                onHorizontalDragEnd: (details) => _dragEnd(details, cardWidth),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [for (final index in order) buildCard(index)],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActiveHeroCard extends StatefulWidget {
  const _ActiveHeroCard({super.key, required this.node, required this.onTap});
  final ActiveContentNode node;
  final VoidCallback onTap;
  @override
  State<_ActiveHeroCard> createState() => _ActiveHeroCardState();
}

class _ActiveHeroCardState extends State<_ActiveHeroCard> {
  bool _favorite = false;
  @override
  void initState() {
    super.initState();
    ActiveAccessService().favoriteNodeIds().then((ids) {
      if (mounted) setState(() => _favorite = ids.contains(widget.node.id));
    });
  }

  Future<void> _toggleFavorite() async {
    final next = !_favorite;
    setState(() => _favorite = next);
    try {
      await ActiveAccessService().record(
        widget.node.id,
        next ? 'favorite_added' : 'favorite_removed',
      );
    } catch (_) {
      if (mounted) setState(() => _favorite = !next);
    }
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(28),
    child: InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF172033),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .16),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ActiveNodeArtwork(node: widget.node),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE6111723)],
                  ),
                ),
              ),
              Positioned(
                right: 14,
                top: 14,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: _favorite
                        ? 'Retirer des favoris'
                        : 'Ajouter aux favoris',
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _favorite
                          ? const Color(0xFFE5485D)
                          : const Color(0xFF202124),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.node.subtitle?.isNotEmpty == true
                              ? widget.node.subtitle!
                              : 'CONTENU PROFESSIONNEL')
                          .toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.instrumentSans(
                        color: Colors.white.withValues(alpha: .86),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.node.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xCC3D414A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Découvrir',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF202124),
                            ),
                          ),
                        ],
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
}

class _ActiveNextStepCard extends StatelessWidget {
  const _ActiveNextStepCard({required this.node, required this.onTap});
  final ActiveContentNode node;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF111C30),
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 148,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ActiveNodeArtwork(node: node, alignment: Alignment.centerRight),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF101C31),
                      Color(0xE6101C31),
                      Color(0x55101C31),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTENU PROFESSIONNEL',
                      style: GoogleFonts.instrumentSans(
                        color: const Color(0xFF9FC0FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      node.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Text(
                          'Commencer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF202124),
                          ),
                        ),
                      ],
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
}

class _ActiveProgressTab extends StatefulWidget {
  const _ActiveProgressTab({
    required this.service,
    required this.nodes,
    required this.onStart,
  });
  final ActiveAccessService service;
  final List<ActiveContentNode> nodes;
  final VoidCallback onStart;
  @override
  State<_ActiveProgressTab> createState() => _ActiveProgressTabState();
}

class _ActiveProgressTabState extends State<_ActiveProgressTab> {
  late Future<List<Map<String, dynamic>>> _future = widget.service
      .learningEvents();
  Future<void> _refresh() async {
    setState(() => _future = widget.service.learningEvents());
    await _future;
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          final events = snapshot.data ?? const <Map<String, dynamic>>[];
          final opened = events
              .where((event) => event['event_type'] == 'opened')
              .map((event) => event['node_id'])
              .toSet();
          final completed = events
              .where((event) => event['event_type'] == 'completed')
              .map((event) => event['node_id'])
              .toSet();
          final courses = widget.nodes.where((node) => node.isCourse).length;
          final percent = courses == 0
              ? 0
              : ((completed.length / courses) * 100).clamp(0, 100).round();
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
              children: [
                Text(
                  'Mon suivi professionnel',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Retrouve tes cours consultés et ta progression.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$percent %',
                        style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1769E8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percent / 100,
                        minHeight: 9,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ProgressMetric(
                              value: '${opened.length}',
                              label: 'Consultés',
                            ),
                          ),
                          Expanded(
                            child: _ProgressMetric(
                              value: '${completed.length}',
                              label: 'Terminés',
                            ),
                          ),
                          Expanded(
                            child: _ProgressMetric(
                              value: '$courses',
                              label: 'Cours',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                if (events.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Icon(
                          Icons.insights_rounded,
                          size: 42,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Commence un premier contenu pour activer ton suivi.',
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: widget.onStart,
                          child: const Text('Commencer'),
                        ),
                      ],
                    ),
                  )
                else
                  ...events.take(12).map((event) {
                    final node = widget.nodes
                        .where((value) => value.id == event['node_id'])
                        .firstOrNull;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Icon(
                          event['event_type'] == 'completed'
                              ? Icons.check_rounded
                              : Icons.menu_book_rounded,
                        ),
                      ),
                      title: Text(node?.title ?? 'Contenu professionnel'),
                      subtitle: Text(
                        event['event_type'] == 'completed'
                            ? 'Cours terminé'
                            : 'Contenu consulté',
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      );
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900),
      ),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _ActiveFavoritesTab extends StatefulWidget {
  const _ActiveFavoritesTab({
    super.key,
    required this.service,
    required this.nodes,
    required this.onOpen,
  });
  final ActiveAccessService service;
  final List<ActiveContentNode> nodes;
  final ValueChanged<ActiveContentNode> onOpen;
  @override
  State<_ActiveFavoritesTab> createState() => _ActiveFavoritesTabState();
}

class _ActiveFavoritesTabState extends State<_ActiveFavoritesTab> {
  late Future<Set<String>> _future = widget.service.favoriteNodeIds();

  Future<void> refresh() async {
    setState(() => _future = widget.service.favoriteNodeIds());
    await _future;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Set<String>>(
    future: _future,
    builder: (context, snapshot) {
      final ids = snapshot.data ?? const <String>{};
      final nodes = widget.nodes
          .where((node) => ids.contains(node.id))
          .toList();
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
          children: [
            Text(
              'Mes favoris actifs',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Tes contenus professionnels enregistrés.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 70),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (snapshot.hasError)
              _EmptyState(
                icon: Icons.cloud_off_rounded,
                text: 'Impossible de charger les favoris pour le moment.',
                action: refresh,
              )
            else if (nodes.isEmpty)
              const _EmptyState(
                icon: Icons.favorite_border_rounded,
                text: 'Aucun contenu professionnel en favori.',
              )
            else
              ...nodes.map(
                (node) => _ContentCard(
                  node: node,
                  onTap: () => widget.onOpen(node),
                  dark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _ActiveBottomNav extends StatelessWidget {
  const _ActiveBottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;
  static const icons = [
    Icons.home_rounded,
    Icons.insights_rounded,
    Icons.forum_rounded,
    Icons.favorite_rounded,
    Icons.person_rounded,
  ];
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF25262A) : const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .13),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(icons.length, (index) {
              final selected = currentIndex == index;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: const [
                    'Accueil',
                    'Suivi',
                    'Communauté',
                    'Favoris',
                    'Profil',
                  ][index],
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () => onTap(index),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[index],
                          color: selected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.node,
    required this.onTap,
    required this.dark,
  });
  final ActiveContentNode node;
  final VoidCallback onTap;
  final bool dark;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Material(
      color: dark ? const Color(0xFF151A26) : Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: .12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox(
          height: 116,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
                child: SizedBox(
                  width: 116,
                  height: 116,
                  child: _ActiveNodeArtwork(node: node),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        node.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if ((node.subtitle ?? '').isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Text(
                          node.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color
                                ?.withValues(alpha: .65),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ActiveNodeArtwork extends StatelessWidget {
  const _ActiveNodeArtwork({
    required this.node,
    this.alignment = Alignment.center,
  });

  final ActiveContentNode node;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF243651), Color(0xFF111C30)],
        ),
      ),
      child: Center(
        child: Icon(
          node.isCourse ? Icons.menu_book_rounded : Icons.local_police_rounded,
          size: 38,
          color: Colors.white.withValues(alpha: .82),
        ),
      ),
    );
    final url = node.imageUrl;
    if (url == null) return fallback;
    return Image.network(
      url,
      fit: BoxFit.cover,
      alignment: alignment,
      frameBuilder: (context, child, frame, synchronouslyLoaded) =>
          frame == null && !synchronouslyLoaded ? fallback : child,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text, this.action});
  final IconData icon;
  final String text;
  final Future<void> Function()? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 70),
    child: Column(
      children: [
        Icon(icon, size: 40, color: Colors.grey),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
        if (action != null)
          TextButton(onPressed: action, child: const Text('Réessayer')),
      ],
    ),
  );
}
