// journal_gpx_school_courses_page.dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/home/home_page_gpx_school.dart' as school;
import 'package:copiqpolice/services/favorites.dart';

void navTo(BuildContext context, String route) {
  try {
    context.push(route);
    return;
  } catch (_) {}
  Navigator.of(context).pushNamed(route);
}

class JournalGpxSchoolCoursesPage extends StatefulWidget {
  const JournalGpxSchoolCoursesPage({super.key});

  @override
  State<JournalGpxSchoolCoursesPage> createState() =>
      _JournalGpxSchoolCoursesPageState();
}

class _JournalGpxSchoolCoursesPageState
    extends State<JournalGpxSchoolCoursesPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // SAFE READERS (évite 100% des erreurs de null / types)
  // ---------------------------------------------------------------------------

  String _s(dynamic v, [String fallback = '']) {
    if (v == null) return fallback;
    final str = v.toString();
    if (str.trim().isEmpty) return fallback;
    return str;
  }

  List<dynamic> _list(dynamic v) {
    if (v == null) return const [];
    if (v is List) return v;
    return const [];
  }

  // ---------------------------------------------------------------------------
  // QUIZ FILTER
  // ---------------------------------------------------------------------------

  bool _isQuizLabel(String label) {
    final t = label.trim().toLowerCase();
    return t.startsWith('quiz'); // ✅ "Quiz ..." => filtré
  }

  // ---------------------------------------------------------------------------
  // FLATTEN : toutes les catégories / sous-catégories => une liste de modules
  // ---------------------------------------------------------------------------

  List<_DeckItem> _buildAllModules() {
    final raw = school.gpxSchoolCategoriesConfig;

    final q = _searchCtrl.text.trim().toLowerCase();
    final hasSearch = q.isNotEmpty;

    final out = <_DeckItem>[];

    raw.forEach((program, categories) {
      final cats = categories as List<dynamic>;

      for (final cat in cats) {
        final catLabel = _s((cat as dynamic).label, 'Module');
        final catRoute = _s((cat as dynamic).route, '/');
        final catBadge = _s((cat as dynamic).badge, 'Module');
        final catImage = _s(
          (cat as dynamic).image,
          'assets/images/placeholder.jpg',
        );

        // ✅ 1) Filtre catégorie si elle commence par "Quiz"
        if (_isQuizLabel(catLabel)) continue;

        final subs = _list((cat as dynamic).subcategories);

        // ---- CAS 1 : pas de sous-catégories => la catégorie = module ----
        if (subs.isEmpty) {
          final item = _DeckItem(
            label: catLabel,
            route: catRoute,
            badge: catBadge,
            image: catImage,
            rating: 4.9,
            reviews: 120,
          );

          if (!hasSearch ||
              item.label.toLowerCase().contains(q) ||
              item.badge.toLowerCase().contains(q)) {
            out.add(item);
          }
          continue;
        }

        // ---- CAS 2 : sous-catégories => chaque sub = module ----
        for (final s in subs) {
          final sLabel = _s((s as dynamic).label, catLabel);
          final sRoute = _s((s as dynamic).route, catRoute);

          // ✅ 2) Filtre sous-catégorie si elle commence par "Quiz"
          if (_isQuizLabel(sLabel)) continue;

          // sub image fallback cat image
          final subImg = _s((s as dynamic).image, '');
          final img = subImg.trim().isNotEmpty ? subImg : catImage;

          final item = _DeckItem(
            label: sLabel,
            route: sRoute,
            badge: catBadge,
            image: img,
            rating: 4.9,
            reviews: 120,
          );

          if (!hasSearch ||
              item.label.toLowerCase().contains(q) ||
              item.badge.toLowerCase().contains(q)) {
            out.add(item);
          }
        }
      }
    });

    // petit tri stable (optionnel) : alphabétique
    out.sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final items = _buildAllModules();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cours — GPX Scolarité'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: _SearchBar(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),

            if (items.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                  child: _EmptyState(
                    query: _searchCtrl.text.trim(),
                    onReset: () {
                      _searchCtrl.clear();
                      setState(() {});
                    },
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                sliver: SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final it = items[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ModuleCard(
                        tag: it.route,
                        title: it.label,
                        subtitle: it.badge,
                        imagePath: it.image,
                        isDark: isDark,
                        onTap: () => navTo(context, it.route),

                        // favoris
                        route: it.route,
                        favTitle: it.label,
                        favSubtitle: it.badge,
                        favImage: it.image,
                        rating: it.rating,
                        reviews: it.reviews,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// UI — Search
// =============================================================================

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.cardColor,
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.10)
              : Colors.black.withOpacity(.06),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.06),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText: 'Rechercher un module…',
          border: InputBorder.none,
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
        ),
      ),
    );
  }
}

// =============================================================================
// DATA
// =============================================================================

class _DeckItem {
  final String label;
  final String route;
  final String badge;
  final String image;
  final double rating;
  final int reviews;

  const _DeckItem({
    required this.label,
    required this.route,
    required this.badge,
    required this.image,
    required this.rating,
    required this.reviews,
  });
}

// =============================================================================
// MODULE CARD — même style “screenshot” + coeur (FavoritesStore)
// =============================================================================

class ModuleCard extends StatefulWidget {
  const ModuleCard({
    super.key,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isDark,
    required this.onTap,
    // favoris payload
    required this.route,
    required this.favTitle,
    required this.favSubtitle,
    required this.favImage,
    required this.rating,
    required this.reviews,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isDark;
  final VoidCallback onTap;

  final String route;
  final String favTitle;
  final String favSubtitle;
  final String favImage;
  final double rating;
  final int reviews;

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> with TickerProviderStateMixin {
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

    FavoritesStore.I.isFavorite(widget.route).then((v) {
      if (mounted) setState(() => _isFav = v);
    });

    _favListener = () {
      final nowFav = FavoritesStore.I.favorites.value.any(
        (e) => e.route == widget.route,
      );
      if (mounted && nowFav != _isFav) setState(() => _isFav = nowFav);
    };

    FavoritesStore.I.favorites.addListener(_favListener);
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

    final next = !_isFav;
    setState(() => _isFav = next);

    await FavoritesStore.I.toggle(
      FavoriteItem(
        route: widget.route,
        title: widget.favTitle,
        subtitle: widget.favSubtitle,
        image: widget.favImage,
        rating: widget.rating,
        reviews: widget.reviews,
      ),
    );
  }

  // ---- mêmes constants que ton rendu ----
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;

    final Color badgeBg = Colors.white.withOpacity(isDark ? 0.14 : 0.10);
    final Color borderClr = Colors.white.withOpacity(isDark ? 0.18 : 0.14);

    return LayoutBuilder(
      builder: (context, c) {
        const double pad = 16;
        const double badgeHApprox = 28;
        const double gapAfterBadge = 10;
        const double gapTitleSub = 6;

        const double ctaApproxW = 118;
        const double ctaApproxH = 46;
        const double gapBetweenTextAndCta = 12;

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
          text: widget.title,
          style: titleStyle,
          maxWidth: textMaxWidth,
        );

        final double subH = widget.subtitle.trim().isEmpty
            ? 0
            : _measureTextHeight(
                text: widget.subtitle,
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

        Widget img;
        try {
          img = Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          );
        } catch (_) {
          img = Container(color: theme.colorScheme.primary.withOpacity(0.08));
        }

        // CTA bg (ton gris)
        final ctaBg = const ui.Color.fromARGB(255, 71, 75, 83);

        return GestureDetector(
          onTap: widget.onTap,
          child: Semantics(
            button: true,
            label: '${widget.title} — découvrir',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: cardHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(tag: 'hero_${widget.tag}', child: img),

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

                    // coeur (top right)
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
                                      ScaleTransition(
                                        scale: anim,
                                        child: child,
                                      ),
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

                    // contenu
                    Padding(
                      padding: const EdgeInsets.all(pad),
                      child: Stack(
                        children: [
                          // Badge "Module"
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

                          // Texte bas gauche (réserve place CTA)
                          Positioned(
                            left: 0,
                            right: ctaApproxW + gapBetweenTextAndCta,
                            bottom: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: titleStyle,
                                ),
                                if (widget.subtitle.trim().isNotEmpty) ...[
                                  const SizedBox(height: gapTitleSub),
                                  Text(
                                    widget.subtitle,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: subtitleStyle,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // CTA bas droite
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: widget.onTap,
                              child: Container(
                                height: 46,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: ctaBg,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Découvrir',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
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

// =============================================================================
// Empty state
// =============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.onReset});

  final String query;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 42),
          const SizedBox(height: 10),
          Text(
            query.isEmpty ? 'Aucun module' : 'Aucun résultat',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty ? 'La liste est vide.' : 'Essaie un autre mot-clé.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }
}
